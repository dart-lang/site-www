const utils = require('./utils')
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
    console.error(err)
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
  story.author = s.displayAuthor
  story.date = new Date(s.createdAt).toJSON()
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
    Object.keys(json.payload.references.User).forEach(k => {
      let u = json.payload.references.User[k]
      authors.push({
        name: u.name,
        username: u.username,
        userId: u.userId
      })
    })
    story.authors = authors

    if (!story.author) {
      story.author = authors[0].name
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
    outputText += `date: ${story.date.slice(0, 10)}\n`
    outputText += `author: "${story.author}"\n`
    outputText += `layout: docs\n`
    outputText += `sidenav: ""\n`

    if (story.featuredImage) {
      const featImgFile = imageMap[story.featuredImage] || utils.normalizeId(story.featuredImage)
      if (featImgFile) {
        outputText += `image: images/${featImgFile}\n`
      }
    }

    const tags = story.tags || []
    if (tags.length > 0) {
      // Use first tag as category
      outputText += `category: ${tags[0]}\n`
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
