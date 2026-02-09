const utils = require('./utils')
const { logItem, logError, logSuccess, DIM, YELLOW } = utils
const path = require('path')
const fs = require('fs')
const r2 = require('r2')
const slugify = require('underscore.string/slugify')
let options = {}

function createFolder(path) {
  try {
    if (!fs.existsSync(path)) {
      fs.mkdirSync(path, { recursive: true })
    }
  } catch (err) {
    // may exist already, ignore
    logError(err, 1)
  }
  return
}

module.exports = async function (mediumURL, params = {}) {
  options = params

  let output = params.output || path.join(__dirname, '..', '..', 'src', 'content', 'blog')

  const json = await utils.loadMediumPost(mediumURL, options)
  const s = json.payload.value
  const story = {}
  const images = []

  story.title = s.title
  story.subtitle = s.virtuals.subtitle ? s.virtuals.subtitle.trim() : ''
  story.publishDate = new Date(s.firstPublishedAt).toJSON()
  story.slug = s.slug
  story.url = s.canonicalUrl
  story.images = []
  story.language = s.detectedLanguage
  if (s.virtuals.tags) {
    story.tags = s.virtuals.tags.map(t => t.slug)
  }
  if (s.license && s.license !== 0) {
    story.license = s.license
  }

  // If the author's not available, get it from somewhere else
  let authors = []
  if (json.payload.references && json.payload.references.User) {
    for (const k of Object.keys(json.payload.references.User)) {
      let u = json.payload.references.User[k]
      const author = await utils.fetchAuthor(u, options)

      authors.push({
        name: author.name,
        username: author.username,
        userId: author.userId,
        github: author.github
      })

      // Download Author Image
      let localImage = ''
      if (author.imageId) {
        const authorsImgDir = path.join(__dirname, '..', '..', 'src', 'content', 'blog', 'authors')
        const MEDIUM_IMG_CDN = 'https://cdn-images-1.medium.com/max/'
        const imgUrl = `${MEDIUM_IMG_CDN}400/${author.imageId}`
        const imageMap = await utils.downloadImages([imgUrl], {
          imageFolder: authorsImgDir,
          puppeteerPage: options.puppeteerPage
        })
        const imageId = utils.normalizeId(author.imageId)
        if (imageMap[imageId]) {
          localImage = imageMap[imageId]
        }
      }

      const cleanUsername = author.username.replace(/_\d+$/, '')

      // Generate Author YAML
      const authorData = {
        name: author.name,
        username: cleanUsername,
        bio: author.bio || '',
        image: localImage,
        twitter: author.twitterScreenName || ''
      }

      if (author.github) {
        authorData.github = {
          handle: author.github.handle,
          username: author.github.username,
          avatar_url: author.github.avatar_url
        }
      }

      const authorYaml =
        `name: "${authorData.name.replace(/"/g, '\\"')}"
username: "${authorData.username}"
bio: "${authorData.bio.replace(/"/g, '\\"').replace(/\n/g, ' ')}"
image: "${authorData.image}"
twitter: "${authorData.twitter}"
github: ${authorData.github ? `\n  handle: "${authorData.github.handle}"\n  username: "${authorData.github.username.replace(/"/g, '\\"')}"\n  avatar_url: "${authorData.github.avatar_url}"` : 'null'}
`
      const authorsDir = path.join(__dirname, '..', '..', 'src', 'data', 'authors')
      try {
        if (!fs.existsSync(authorsDir)) {
          fs.mkdirSync(authorsDir, { recursive: true })
        }

        // Use github handle as filename if available, otherwise fallback to medium username
        const filename = authorData.github ? authorData.github.handle : cleanUsername
        fs.writeFileSync(path.join(authorsDir, `${filename}.yaml`), authorYaml)
      } catch (err) {
        logError(`Failed to write author yaml for ${author.username}: ${err}`, 1)
      }
    }

    story.authors = authors

    // Use github handle (or username) as the reference key
    if (authors.length > 0) {
      const primary = authors[0]
      story.author = primary.github ? primary.github.handle : primary.username.replace(/_\d+$/, '')
    }
  }

  if (s.virtuals.previewImage) {
    story.featuredImage = s.virtuals.previewImage.imageId.replace(/\*/g, '')
  }

  if (params && params.info) {
    process.exit(0)
  }

  story.sections = s.content.bodyModel.sections
  story.paragraphs = s.content.bodyModel.paragraphs

  // Add featured image to images collection if it exists
  const MEDIUM_IMG_CDN = 'https://cdn-images-1.medium.com/max/'
  if (s.virtuals.previewImage) {
    const imgwidth = parseInt(s.virtuals.previewImage.originalWidth, 10)
    const imgsrc = MEDIUM_IMG_CDN + (imgwidth || 2000) + '/' + s.virtuals.previewImage.imageId
    images.push(imgsrc)
  }

  // First pass: collect images
  for (let i = 0; i < story.sections.length; i++) {
    utils.processSection(story.sections[i], story.slug, images, options)
  }
  for (let i = 0; i < story.paragraphs.length; i++) {
    await utils.processParagraph(story.paragraphs[i], story.slug, images, options)
  }

  const postFolder = path.join(output, story.slug)
  const imagesFolder = path.join(postFolder, 'images')
  createFolder(imagesFolder)

  let imageMap = {}
  if (!!images.length) {
    imageMap = await utils.downloadImages(images, {
      featuredImage: story.featuredImage,
      imageFolder: imagesFolder,
      puppeteerPage: options.puppeteerPage
    })
  }

  if (!story.subtitle && story.paragraphs.length > 1) {
    story.subtitle = story.paragraphs[1].text
  }

  story.markdown = []
  if (!options.frontmatter) {
    story.markdown.push('\n# ' + story.title.replace(/\n/g, '\n# '))
    if (undefined != story.subtitle) {
      story.markdown.push('\n## ' + story.subtitle.replace(/#+/, ''))
    }
  }

  let lastParagraph = null
  story.paragraphs = story.paragraphs.filter((p, idx) => {
    // Filter out title and subtitle if they appear at the start
    if (idx === 0 && p.text === story.title) return false
    if (idx < 2 && story.subtitle && p.text === story.subtitle) return false

    if (p.type === 8 && lastParagraph && lastParagraph.type === 8) {
      lastParagraph.text += '\n\n' + p.text
      return false
    }
    lastParagraph = p
    return true
  })

  // Second pass: generate markdown with imageMap
  const sections = []
  for (let i = 0; i < story.sections.length; i++) {
    const s = story.sections[i]
    sections[s.startIndex] = utils.processSection(s, story.slug, [], { ...options, imageMap })
  }

  const results = []
  for (let i = 0; i < story.paragraphs.length; i++) {
    if (sections[i]) story.markdown.push(sections[i])
    const p = story.paragraphs[i]
    const text = await utils.processParagraph(p, story.slug, [], { ...options, imageMap })
    results.push(text)
  }

  for (let text of results) {
    story.markdown.push(text)
  }

  // frontmatter
  let outputText = ''
  if (options.frontmatter) {
    outputText = '---\n'
    outputText += `title: "${story.title.replace(/"/g, '\\"')}"\n`
    outputText += `description: "${story.subtitle.replace(/"/g, '\\"')}"\n`
    outputText += `publishDate: ${story.publishDate.slice(0, 10)}\n`
    outputText += `author: "${story.author}"\n`

    if (story.featuredImage) {
      const featImgFile = imageMap[story.featuredImage] || utils.normalizeId(story.featuredImage)
      if (featImgFile) {
        outputText += `image: images/${featImgFile}\n`
      }
    }

    const tags = story.tags || []
    if (tags.length > 0) {
      const category = tags.includes('announcements') ? 'announcements' : 'other'
      outputText += `category: ${category}\n`
      outputText += 'tags:\n'
      for (const tag of tags) {
        outputText += `  - ${tag}\n`
      }
    }
    outputText += '---\n\n'
  }
  outputText += story.markdown.join('\n')

  let outputPath = path.join(postFolder, 'index.md')
  fs.writeFileSync(outputPath, outputText)
  return options.returnObject ? story : undefined
}
