const r2 = require('r2')
const fs = require('fs')
const sanitize = require('sanitize-filename')
const path = require('path')

const MEDIUM_IMG_CDN = 'https://cdn-images-1.medium.com/max/'
const CACHE_DIR = path.join(__dirname, '..', 'artifacts', 'cache')
const FAILURE_LOG = path.join(__dirname, '..', 'artifacts', 'failed_downloads.txt')
let mentionedUsers = []

function logFailure(url) {
  fs.appendFileSync(FAILURE_LOG, url + '\n')
}

function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true })
  }
}

function normalizeId(id) {
  return id ? id.replace(/\*/g, '') : id
}

async function downloadImages(images, options = {}) {
  const articleImages = {}
  ensureDir(CACHE_DIR)

  for (const image of images) {
    let sourceId = image.split('/')[image.split('/').length - 1]
    let file = sanitize(normalizeId(sourceId))
    const maxRetries = 3
    let response
    let fetched = false

    // Better cache check: find any file in cache starting with sourceId (ignoring extension for now if we don't know it)
    const existingCacheFile = fs.readdirSync(CACHE_DIR).find(f => f.startsWith(file))
    if (existingCacheFile) {
      logItem(`Using cached image: ${existingCacheFile}`, 2, DIM)
      response = fs.readFileSync(path.join(CACHE_DIR, existingCacheFile))
      file = existingCacheFile
    } else {
      fetched = true
      for (let attempt = 0; attempt < maxRetries; attempt++) {
        try {
          if (options.puppeteerPage) {
            const page = options.puppeteerPage
            await page.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

            // Use puppeteer to fetch the image buffer via fetch API (avoids download prompt)
            const base64 = await page.evaluate(async (url) => {
              const response = await fetch(url)
              if (!response.ok) throw new Error(`HTTP ${response.status}`)
              const blob = await response.blob()
              return new Promise((resolve, reject) => {
                const reader = new FileReader()
                reader.onloadend = () => resolve(reader.result)
                reader.onerror = reject
                reader.readAsDataURL(blob)
              })
            }, image)

            // Parse base64
            const matches = base64.match(/^data:(.+?);base64,(.+)$/)
            if (!matches) {
              throw new Error('Invalid base64 response from fetch')
            }
            response = Buffer.from(matches[2], 'base64')
          } else {
            // Download image with 10s timeout
            const timeoutPromise = new Promise((_, reject) =>
              setTimeout(() => reject(new Error('Request timed out')), 10000)
            )
            const responsePromise = r2.get(image).response

            const res = await Promise.race([responsePromise, timeoutPromise])
            response = await res.buffer()
          }

          // Check if the response is actually an HTML error page (Cloudflare)
          const isHtml = response.slice(0, 10).toString().toLowerCase().includes('<html') ||
            response.slice(0, 50).toString().toLowerCase().includes('<!doctype html')

          if (isHtml) {
            throw new Error('Received HTML instead of image (likely Cloudflare block)')
          }

          // Detect extension if missing
          if (!file.includes('.')) {
            const header = response.toString('hex', 0, 4)
            if (header.startsWith('ffd8ff')) file += '.jpg'
            else if (header.startsWith('89504e47')) file += '.png'
            else if (header.startsWith('47494638')) file += '.gif'
            else if (response.toString('utf8', 0, 4) === 'RIFF') file += '.webp'
          }

          // Save to cache
          fs.writeFileSync(path.join(CACHE_DIR, file), response)
          break // Success
        } catch (err) {
          logError(`Attempt ${attempt + 1} to download image ${file} failed: ${err.message}`, 2)
          if (attempt === maxRetries - 1) {
            logError(`Failed to download image ${file} after ${maxRetries} attempts.`, 2)
            logFailure(image)
            response = null
          } else {
            // Wait before next attempt
            await new Promise(resolve => setTimeout(resolve, 2000 * (attempt + 1)))
          }
        }
      }
    }

    if (!response) continue

    if (options.imageFolder && !fs.existsSync(options.imageFolder)) {
      fs.mkdirSync(options.imageFolder, { recursive: true })
    }
    fs.writeFileSync(`${options.imageFolder}/${file}`, response)
    articleImages[normalizeId(sourceId)] = file

    // Add a small delay between images to be nice to the server and avoid easy blocking
    if (fetched) {
      await new Promise(resolve => setTimeout(resolve, 1000))
    }
  }
  return articleImages
}

async function loadMediumPost(mediumURL, options = {}) {
  if (mediumURL.indexOf('?source') > -1) {
    mediumURL = mediumURL.split('?')[0]
  }
  if (mediumURL.match(/^http/i)) {
    mediumURL = mediumURL.replace(/#.*$/, '')
    mediumURL = `${mediumURL}?format=json`
    const response = await r2.get(mediumURL).text
    const json = JSON.parse(response.substr(response.indexOf('{')))
    mentionedUsers = json.payload.mentionedUsers
    return json
  } else {
    const response = fs.readFileSync(mediumURL, 'utf8')
    const json = JSON.parse(response)
    if (json.payload && json.payload.mentionedUsers) {
      mentionedUsers = json.payload.mentionedUsers
    }
    return json
  }
}

function processSection(s, slug, images, options = {}) {
  let section = ''
  if (s.backgroundImage) {
    const imgwidth = parseInt(s.backgroundImage.originalWidth, 10)
    const imgsrc = MEDIUM_IMG_CDN + (imgwidth || 2000) + '/' + s.backgroundImage.id
    images.push(imgsrc)
    const fileName = (options.imageMap && options.imageMap[normalizeId(s.backgroundImage.id)]) || normalizeId(s.backgroundImage.id)
    section = '\n![](images/' + fileName + ')'
  }
  return section
}

// TODO: why is this not used?
async function getYouTubeEmbed(iframesrc) {
  const body = await r2.get(iframesrc).text
  const tokens = body.match(/youtube.com%2Fembed%2F([^%]+)%3F/)
  if (tokens && tokens.length > 1) {
    const videoId = tokens[1]
    return `<center><iframe width="560" height="315" src="https://www.youtube.com/embed/${videoId}" frameborder="0" allowfullscreen></iframe></center>`
  }
  return `<iframe src="${iframesrc}" frameborder=0></iframe>`
}

async function getMediaEmbed(iframesrc, iframeMetadata, options = {}) {
  let response
  let json
  const maxRetries = 3
  const resourceId = iframesrc.split('/').pop()
  const cacheFile = path.join(CACHE_DIR, `${resourceId}.json`)
  ensureDir(CACHE_DIR)

  // Check cache first
  if (fs.existsSync(cacheFile)) {
    logItem(`Using cached media JSON: ${resourceId}`, 2, DIM)
    response = fs.readFileSync(cacheFile, 'utf8')
  } else {
    for (let attempt = 0; attempt < maxRetries; attempt++) {
      try {
        logItem(`media ${iframesrc} (attempt ${attempt + 1})`, 2, YELLOW)
        const url = iframesrc + '?format=json'
        if (options.puppeteerPage) {
          const page = options.puppeteerPage
          await page.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

          // Add random delay to seem more human
          await new Promise(resolve => setTimeout(resolve, Math.random() * 2000 + 1000))

          await page.goto(url, { waitUntil: 'networkidle2', timeout: 30000 })
          response = await page.evaluate(() => document.body.innerText)
        } else {
          response = await r2.get(url).text
        }

        const jsonStart = response.indexOf('{')
        if (jsonStart !== -1) {
          // Success! Save cleaned JSON to cache
          const cleanJson = response.substr(jsonStart)
          fs.writeFileSync(cacheFile, cleanJson)
          response = cleanJson
          break
        } else if (attempt === maxRetries - 1) {
          throw new Error('No JSON found in response after multiple attempts')
        }
      } catch (err) {
        logError(`Attempt ${attempt + 1} failed: ${err.message}`, 2)
        if (attempt === maxRetries - 1) {
          logFailure(iframesrc)
          return `[Embed error after ${maxRetries} attempts: ${err.message}]`
        }
        // Wait before next attempt
        await new Promise(resolve => setTimeout(resolve, 2000 * (attempt + 1)))
      }
    }
  }

  const jsonStart = response.indexOf('{')
  json = JSON.parse(response.substr(jsonStart))

  if (json.payload.value.gist) {
    const gist = json.payload.value.gist

    if (options.hugo) {
      return `\n{{< gist ${gist.githubUsername} ${gist.gistId} >}}`
    }

    const scriptsrc = `https://api.github.com/gists/${gist.gistId}`
    logItem(`Gist source: ${scriptsrc}`, 2, DIM)

    const GISTS_CACHE_DIR = path.join(__dirname, '..', 'artifacts', 'cache', 'gists')
    ensureDir(GISTS_CACHE_DIR)

    // Cache the gist metadata (file list)
    const gistMetaCache = path.join(GISTS_CACHE_DIR, `${gist.gistId}.json`)
    let gistJson

    if (fs.existsSync(gistMetaCache)) {
      logItem(`Using cached gist metadata: ${gist.gistId}`, 2, DIM)
      gistJson = JSON.parse(fs.readFileSync(gistMetaCache, 'utf8'))
    } else {
      try {
        gistJson = await r2.get(scriptsrc).json
        fs.writeFileSync(gistMetaCache, JSON.stringify(gistJson, null, 2))
      } catch (err) {
        logError(`Failed to fetch gist metadata ${gist.gistId}: ${err}`, 2)
        return `[Gist error: ${err.message}]`
      }
    }

    let mdSoureCode = ''

    for (const key in gistJson.files) {
      if (gistJson.files.hasOwnProperty(key)) {
        const file = gistJson.files[key]
        const language = (file.language || 'text').toLowerCase()
        logItem(`Gist file: ${file.filename}`, 3, DIM)

        // Cache per gist
        const gistDir = path.join(GISTS_CACHE_DIR, gist.gistId)
        ensureDir(gistDir)
        const cacheFile = path.join(gistDir, file.filename)

        let gistCode
        if (fs.existsSync(cacheFile)) {
          logItem(`Using cached gist: ${gist.gistId}/${file.filename}`, 3, DIM)
          gistCode = fs.readFileSync(cacheFile, 'utf8')
        } else {
          try {
            // Fetch with simple retry/timeout if needed, but r2 default might suffice for now
            // or replicate the image download pattern if robust fetch is needed.
            // For now, simple fetch + save.
            gistCode = await r2.get(file.raw_url).text
            fs.writeFileSync(cacheFile, gistCode)
          } catch (err) {
            logError(`Failed to download gist ${file.filename}: ${err}`, 3)
            continue
          }
        }

        mdSoureCode += '\n```' + language + '\n'
        mdSoureCode += gistCode.replace(/\t/g, '  ')
        mdSoureCode += '\n```\n'
      }
    }
    if (mdSoureCode.length > 0) {
      // remove last newline
      mdSoureCode = mdSoureCode.substr(0, mdSoureCode.length - 1)
    }

    return mdSoureCode
  }

  // Fallback for other external links (CodePen, etc.)
  if (json.payload.value.href) {
    let href = json.payload.value.href
    // CodePen specific: change /pen/ to /embed/
    if (href.includes('codepen.io') && href.includes('/pen/')) {
      href = href.replace('/pen/', '/embed/')
    }

    const width = iframeMetadata.iframeWidth || 800
    const height = iframeMetadata.iframeHeight || 600
    return `\n<iframe src="${href}" width="${width}" height="${height}" frameborder="0" allowfullscreen></iframe>\n`
  }

  return `\n<iframe src="https://medium.com/media/${json.payload.value.mediaResourceId}" width="${iframeMetadata.iframeWidth || 800}" height="${iframeMetadata.iframeHeight || 600}" frameborder="0" allowfullscreen></iframe>\n`
}

async function processParagraph(p, slug, images, options = {}) {
  const markups_array = createMarkupsArray(p.markups)
  let processedText = p.text || ''

  if (markups_array.length > 0) {
    let previousIndex = 0
    let j = 0
    const tokens = []
    for (j = 0; j < markups_array.length; j++) {
      if (markups_array[j]) {
        tokens.push(processedText.substring(previousIndex, j))
        previousIndex = j
        tokens.push(markups_array[j])
      }
    }
    tokens.push(processedText.substring(previousIndex))
    processedText = tokens.join('')
  }

  if (p.type !== 8 && p.type !== 10) {
    processedText = processedText.replace(/>/g, '&gt;').replace(/</g, '&lt;')
  }

  let markup = ''
  switch (p.type) {
    case 1:
      markup = '\n'
      break
    case 2:
      processedText = '\n# ' + processedText.replace(/\n/g, '\n# ')
      break
    case 3:
      processedText = '\n## ' + processedText.replace(/\n/g, '\n## ')
      break
    case 4: // image & caption
      const imgwidth = parseInt(p.metadata.originalWidth, 10)
      const imgsrc = MEDIUM_IMG_CDN + (imgwidth || 2000) + '/' + p.metadata.id
      images.push(imgsrc)
      const fileName = (options.imageMap && options.imageMap[normalizeId(p.metadata.id)]) || normalizeId(p.metadata.id)

      let dashImageTag = '\n<DashImage src="images/' + fileName + '"' // Open tag
      if (processedText && processedText.trim().length > 0) {
        const caption = processedText.replace(/"/g, '&quot;')
        dashImageTag += ' alt="' + caption + '" caption="' + caption + '"'
      }
      dashImageTag += ' />\n' // Close tag
      processedText = dashImageTag
      break
    case 6:
      markup = '> '
      break
    case 7: // quote
      processedText = '> # ' + processedText.replace(/\n/g, '\n> # ')
      break
    case 8:
      const lang = (p.codeBlockMetadata && p.codeBlockMetadata.lang) || ''
      processedText = '\n```' + lang + '\n' + processedText + '\n```\n'
      break
    case 9:
      markup = '\n* '
      break
    case 10:
      markup = '\n1. '
      break
    case 11:
      return await getMediaEmbed(
        'https://medium.com/media/' + p.iframe.mediaResourceId,
        p.iframe,
        options
      )
    case 13:
      markup = '\n### '
      break
    case 15: // caption for section image
      processedText = '*' + processedText + '*'
      break
  }

  processedText = markup + processedText

  if (p.alignment == 2 && p.type != 6 && p.type != 7)
    processedText = '<center>' + processedText + '</center>'

  return processedText
}

function addMarkup(markups_array, open, close, start, end) {
  if (markups_array[start]) markups_array[start] += open
  else markups_array[start] = open

  if (markups_array[end]) markups_array[end] = close + markups_array[end]
  else markups_array[end] = close

  return markups_array
}

function createMarkupsArray(markups) {
  if (!markups || markups.length == 0) return []

  // Sort markups: outermost (larger span) first.
  // If spans are equal, use priority: Link (3) > Bold (1) > Italic (2) > Code (10)
  const priority = { 3: 1, 1: 2, 2: 3, 10: 4 }
  const sortedMarkups = [...markups].sort((a, b) => {
    const spanA = a.end - a.start
    const spanB = b.end - b.start
    if (spanA !== spanB) return spanB - spanA // Larger span first

    // Equal span: priority
    const pA = priority[a.type] || 99
    const pB = priority[b.type] || 99
    return pA - pB
  })

  const markups_array = []
  for (let j = 0; j < sortedMarkups.length; j++) {
    const m = sortedMarkups[j]
    switch (m.type) {
      case 1: // bold
        addMarkup(markups_array, '**', '**', m.start, m.end)
        break
      case 2: // italic
        addMarkup(markups_array, '*', '*', m.start, m.end)
        break
      case 3: // anchor tag
        if (m.userId) {
          const user = mentionedUsers.find(u => u.userId === m.userId)
          if (user.twitterScreenName) {
            addMarkup(
              markups_array,
              `[`,
              `](https://twitter.com/${user.twitterScreenName})`,
              m.start,
              m.end
            )
          } else {
            addMarkup(
              markups_array,
              `[`,
              `](https://medium.com/@${user.username})`,
              m.start,
              m.end
            )
          }
        } else {
          addMarkup(markups_array, '[', '](' + m.href + ')', m.start, m.end)
        }
        break
      case 10: // code
        addMarkup(markups_array, '`', '`', m.start, m.end)
        break
      default:
        console.error('Unknown markup type ' + m.type, m)
        break
    }
  }
  return markups_array
}

// Logging Helpers
const RESET = '\x1b[0m'
const RED = '\x1b[31m'
const GREEN = '\x1b[32m'
const YELLOW = '\x1b[33m'
const BLUE = '\x1b[34m'
const DIM = '\x1b[2m'
const BOLD = '\x1b[1m'

function log(msg, indent = 0, color = null) {
  const prefix = ' '.repeat(indent)
  const coloredMsg = color ? `${color}${msg}${RESET}` : msg
  console.log(`${prefix}${coloredMsg}`)
}

function logHeader(msg) {
  log(msg, 0, BOLD + BLUE)
}

function logItem(msg, indent = 1, color = null) {
  log(msg, indent * 2, color)
}

function logSuccess(msg, indent = 1) {
  log(`✓ ${msg}`, indent * 2, GREEN)
}

function logError(msg, indent = 1) {
  console.error(`${' '.repeat(indent * 2)}${RED}✗ ${msg}${RESET}`)
}

const AUTHORS_CACHE_DIR = path.join(__dirname, '..', 'artifacts', 'cache', 'authors')
const GITHUB_MAPPING_FILE = path.join(__dirname, '..', 'artifacts', 'username-to-github.json')

function getGithubMapping() {
  if (fs.existsSync(GITHUB_MAPPING_FILE)) {
    return JSON.parse(fs.readFileSync(GITHUB_MAPPING_FILE, 'utf8'))
  }
  return {}
}

function saveGithubMapping(mapping) {
  ensureDir(path.dirname(GITHUB_MAPPING_FILE))
  fs.writeFileSync(GITHUB_MAPPING_FILE, JSON.stringify(mapping, null, 2))
}

async function fetchAuthor(mediumUser, options = {}) {
  ensureDir(AUTHORS_CACHE_DIR)

  const mapping = getGithubMapping()
  let githubHandle = mapping[mediumUser.username]

  // Step 2: Check Cache / Fetch Github for handle if not mapped
  if (githubHandle === undefined) {
    const searchCacheFile = path.join(AUTHORS_CACHE_DIR, `${mediumUser.username}_search.json`)
    let searchResults

    if (fs.existsSync(searchCacheFile)) {
      logItem(`Using cached github search for ${mediumUser.username}`, 2, DIM)
      searchResults = JSON.parse(fs.readFileSync(searchCacheFile, 'utf8'))
    } else {
      logItem(`Searching Github for ${mediumUser.username}...`, 2, YELLOW)
      try {
        // Try username first, then name
        const queries = [mediumUser.username, mediumUser.name]
        for (const q of queries) {
          if (!q) continue
          const url = `https://api.github.com/search/users?q=${encodeURIComponent(q)}&per_page=1`
          // Basic headers, ideally add auth token if rate limits hit
          const headers = { 'User-Agent': 'MediumExporter/1.0' }

          if (options.puppeteerPage) {
            // Use puppeteer if available to avoid some rate limits or network issues?
            // Actually search api is public. Let's use r2 for simplicity unless blocked.
            // But valid User-Agent is important.
          }

          const res = await r2.get(url, { headers }).json
          if (res.items && res.items.length > 0) {
            searchResults = res
            break
          }
          // Wait a bit between queries to be nice
          await new Promise(resolve => setTimeout(resolve, 1000))
        }

        if (!searchResults) {
          searchResults = { items: [] } // No results found
        }

        fs.writeFileSync(searchCacheFile, JSON.stringify(searchResults, null, 2))

      } catch (err) {
        logError(`Failed to search github for ${mediumUser.username}: ${err.message}`, 2)
        searchResults = { items: [] }
      }
    }

    if (searchResults && searchResults.items && searchResults.items.length > 0) {
      githubHandle = searchResults.items[0].login
      logSuccess(`Found github handle: ${githubHandle}`, 2)
    } else {
      githubHandle = "" // Mark as not found
      logItem(`No github handle found for ${mediumUser.username}`, 2, DIM)
    }

    mapping[mediumUser.username] = githubHandle
    saveGithubMapping(mapping)
  }

  let githubData = null
  if (githubHandle) {
    const githubCacheFile = path.join(AUTHORS_CACHE_DIR, `${githubHandle}_github.json`)
    if (fs.existsSync(githubCacheFile)) {
      logItem(`Using cached github user data for ${githubHandle}`, 2, DIM)
      githubData = JSON.parse(fs.readFileSync(githubCacheFile, 'utf8'))
    } else {
      logItem(`Fetching Github user data for ${githubHandle}...`, 2, YELLOW)
      try {
        const url = `https://api.github.com/users/${githubHandle}`
        const headers = { 'User-Agent': 'MediumExporter/1.0' }
        const res = await r2.get(url, { headers }).json
        githubData = res
        fs.writeFileSync(githubCacheFile, JSON.stringify(githubData, null, 2))
      } catch (err) {
        logError(`Failed to fetch github user ${githubHandle}: ${err.message}`, 2)
      }
    }
  }

  return {
    ...mediumUser,
    github: githubData ? {
      handle: githubData.login,
      username: githubData.name || githubData.login,
      avatar_url: githubData.avatar_url
    } : null
  }
}

module.exports = exports = {
  downloadImages,
  loadMediumPost,
  processParagraph,
  processSection,
  normalizeId,
  fetchAuthor,
  // Export Logger
  log, logHeader, logItem, logSuccess, logError,
  RESET, RED, GREEN, YELLOW, BLUE, DIM, BOLD
}
