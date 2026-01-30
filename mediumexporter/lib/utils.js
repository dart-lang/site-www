const r2 = require('r2')
const fs = require('fs')
const sanitize = require('sanitize-filename')

const MEDIUM_IMG_CDN = 'https://cdn-images-1.medium.com/max/'
let mentionedUsers = []

async function downloadImages(images, options = {}) {
  const articleImages = []

  for (const image of images) {
    let file = sanitize(image.split('/')[image.split('/').length - 1])

    if (options.featuredImage && options.featuredImage === file) {
      let type = file.split('.')[file.split('.').length - 1]
      file = `featuredImage.${type}`
    }

    console.log('image', image, file)
    const response = await (await r2.get(image).response).buffer()
    fs.writeFileSync(`${options.imageFolder}/${file}`, response, 'base64')
    articleImages.push(file)
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
    json = require(process.cwd() + '/' + mediumURL)
    return json
  }
}

function processSection(s, slug, images, options = {}) {
  let section = ''
  if (s.backgroundImage) {
    const imgwidth = parseInt(s.backgroundImage.originalWidth, 10)
    const imgsrc =
      MEDIUM_IMG_CDN + Math.max(imgwidth * 2, 2000) + '/' + s.backgroundImage.id
    images.push(imgsrc)
    section = '\n![](' + s.backgroundImage.id + ')'
    if (!!options.jekyll) {
      section = `\n![](/assets/images/${options.imageFolder +
        s.backgroundImage.id})`
    }
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

async function getGitHubEmbed(iframesrc, options = {}) {
  let response
  let json
  try {
    console.log('github', iframesrc)
    response = await r2.get(iframesrc + '?format=json').text
    json = JSON.parse(response.substr(response.indexOf('{')))
  } catch (err) {
    return err
  }

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
}

async function processParagraph(p, slug, images, options = {}) {
  const markups_array = createMarkupsArray(p.markups)

  if (markups_array.length > 0) {
    let previousIndex = 0
    let j = 0
    const text = p.text
    const tokens = []
    for (j = 0; j < markups_array.length; j++) {
      if (markups_array[j]) {
        token = text.substring(previousIndex, j)
        previousIndex = j
        tokens.push(token)
        tokens.push(markups_array[j])
      }
    }
    tokens.push(text.substring(j - 1))
    p.text = tokens.join('')
  }

  if (p.type !== 8 && p.type !== 10) {
    p.text = p.text.replace(/>/g, '&gt;').replace(/</g, '&lt;')
  }

  let markup = ''
  switch (p.type) {
    case 1:
      markup = '\n'
      break
    case 2:
      p.text = '\n# ' + p.text.replace(/\n/g, '\n# ')
      break
    case 3:
      p.text = '\n## ' + p.text.replace(/\n/g, '\n## ')
      break
    case 4: // image & caption
      const imgwidth = parseInt(p.metadata.originalWidth, 10)
      const imgsrc =
        MEDIUM_IMG_CDN + Math.max(imgwidth * 2, 2000) + '/' + p.metadata.id
      images.push(imgsrc)
      let text = '\n![' + p.text + '](' + p.metadata.id + ')'
      if (!!options.jekyll) {
        text = `\n![${p.text}](/assets/images/${slug}/${p.metadata.id})`
      }
      if (p.text) {
        text += '*' + p.text + '*'
      }
      p.text = text
      break
    case 6:
      markup = '> '
      break
    case 7: // quote
      p.text = '> # ' + p.text.replace(/\n/g, '\n> # ')
      break
    case 8:
      p.text = '\n```\n' + p.text + '\n```\n'
      break
    case 9:
      markup = '\n* '
      break
    case 10:
      markup = '\n1. '
      break
    case 11:
      return await getGitHubEmbed(
        'https://medium.com/media/' + p.iframe.mediaResourceId,
        options
      )
    case 13:
      markup = '\n### '
      break
    case 15: // caption for section image
      p.text = '*' + p.text + '*'
      break
  }

  p.text = markup + p.text

  if (p.alignment == 2 && p.type != 6 && p.type != 7)
    p.text = '<center>' + p.text + '</center>'

  return p.text
}

function addMarkup(markups_array, open, close, start, end) {
  if (markups_array[start]) markups_array[start] += open
  else markups_array[start] = open

  if (markups_array[end]) markups_array[end] += close
  else markups_array[end] = close

  return markups_array
}

function createMarkupsArray(markups) {
  if (!markups || markups.length == 0) return []
  const markups_array = []
  for (let j = 0; j < markups.length; j++) {
    const m = markups[j]
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
  processSection
}
