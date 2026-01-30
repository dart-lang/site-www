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

    console.log('image', image, file)

    // Better cache check: find any file in cache starting with sourceId (ignoring extension for now if we don't know it)
    const existingCacheFile = fs.readdirSync(CACHE_DIR).find(f => f.startsWith(file))
    if (existingCacheFile) {
      console.log('Using cached image:', existingCacheFile)
      response = fs.readFileSync(path.join(CACHE_DIR, existingCacheFile))
      file = existingCacheFile
    } else {
      for (let attempt = 0; attempt < maxRetries; attempt++) {
        try {
          if (options.puppeteerPage) {
            const page = options.puppeteerPage
            await page.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

            // Use puppeteer to fetch the image buffer
            const viewSource = await page.goto(image, { waitUntil: 'networkidle2', timeout: 30000 })
            response = await viewSource.buffer()
          } else {
            const res = await r2.get(image).response
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
          console.error(`Attempt ${attempt + 1} to download image ${file} failed: ${err.message}`)
          if (attempt === maxRetries - 1) {
            console.error(`Failed to download image ${file} after ${maxRetries} attempts.`)
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

    fs.writeFileSync(`${options.imageFolder}/${file}`, response)
    articleImages[sourceId] = file
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
    const fileName = (options.imageMap && options.imageMap[s.backgroundImage.id]) || normalizeId(s.backgroundImage.id)
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
    console.log('Using cached media JSON:', resourceId)
    response = fs.readFileSync(cacheFile, 'utf8')
  } else {
    for (let attempt = 0; attempt < maxRetries; attempt++) {
      try {
        console.log(`media ${iframesrc} (attempt ${attempt + 1})`)
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
        console.error(`Attempt ${attempt + 1} failed: ${err.message}`)
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
    console.log('gistsrc', scriptsrc)
    let gistJson = await r2.get(scriptsrc).json
    let mdSoureCode = ''
    for (const key in gistJson.files) {
      if (gistJson.files.hasOwnProperty(key)) {
        const file = gistJson.files[key]
        const language = file.language.toLowerCase()
        console.log('gistCode', file.raw_url)
        let gistCode = await r2.get(file.raw_url).text

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
      const fileName = (options.imageMap && options.imageMap[p.metadata.id]) || normalizeId(p.metadata.id)
      let imgText = '\n![' + processedText + '](images/' + fileName + ')'
      if (processedText) {
        imgText += '*' + processedText + '*'
      }
      processedText = imgText
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

module.exports = exports = {
  downloadImages,
  loadMediumPost,
  processParagraph,
  processSection,
  normalizeId
}
