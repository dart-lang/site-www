#! /usr/bin/env node

if (require.main !== module) {
  module.exports = {
    getFeed: require('./lib/get-feed'),
    getPost: require('./lib/get-post')
  }
} else {
  const program = require('commander')
  const package = require('./package.json')

  program
    .version(package.version)
    .description(package.description)
    .usage('[options] <medium post or feed url>')
    .option('-I, --info', 'Show information about the medium post')
    .option(
      '-O, --output <destination>',
      'File (if URL is a post) or directory (if URL is a feed) to output to'
    )
    .option('--hugo', 'use gohugo.io specific shortcodes')
    .option(
      '--jekyll',
      'prefix the files with date, place images in an assets/'
    )
    .option('--frontmatter', 'enable markdown frontmatter')
    .option('-L, --limit <n>', 'Limit the number of posts to process')
    .option('-d, --debug', 'Show debugging info')
    .on('--help', function () {
      console.log('  Examples:')
      console.log('')
      console.log('    $ mediumexporter -O content mediumurl')
      console.log('    $ mediumexporter --hugo mediumurl')
      console.log('    $ mediumexporter --limit 3')
      console.log('')
    })

  program.parse(process.argv)

  const fs = require('fs')
  const path = require('path')
  const puppeteer = require('puppeteer')
  const postsDir = path.join(__dirname, 'artifacts', 'posts')

  if (!fs.existsSync(postsDir)) {
    console.error(`Directory not found: ${postsDir}`)
    process.exit(1)
  }

  const files = fs.readdirSync(postsDir).filter(f => f.endsWith('.json'))

  if (files.length === 0) {
    console.log('No JSON files found in artifacts/posts')
    process.exit(0)
  }

  const getPost = require('./lib/get-post')

  async function run() {
    // Load and sort all posts by firstPublishedAt
    console.log('Sorting posts by publication date...')
    const postData = files.map(file => {
      const filePath = path.join(postsDir, file)
      const content = JSON.parse(fs.readFileSync(filePath, 'utf8'))
      return {
        file,
        firstPublishedAt: content.payload.value.firstPublishedAt || 0
      }
    })

    postData.sort((a, b) => b.firstPublishedAt - a.firstPublishedAt)
    let filesToProcess = postData.map(p => p.file)

    if (program.limit) {
      const limit = parseInt(program.limit, 10)
      if (!isNaN(limit)) {
        filesToProcess = filesToProcess.slice(0, limit)
        console.log(`Limiting to newest ${limit} posts.`)
      }
    }

    const browser = await puppeteer.launch({ headless: 'new' })
    const page = await browser.newPage()
    // Navigate to a valid page context to ensure fetch works (avoiding about:blank CORS issues)
    await page.goto('https://medium.com', { waitUntil: 'domcontentloaded' })

    const { logHeader, logItem, logSuccess, logError, BLUE, BOLD } = require('./lib/utils')

    let i = 0
    const total = filesToProcess.length
    for (const file of filesToProcess) {
      i++
      const filePath = path.join(postsDir, file)
      logHeader(`(${i}/${total}) Processing ${file}...`)
      try {
        await getPost(filePath, {
          ...program,
          frontmatter: true,
          puppeteerPage: page
        })
      } catch (err) {
        logError(`Error processing ${file}: ${err}`)
      }
    }

    logItem(`Processed ${i} posts.`)

    await browser.close()
  }

  run()
}
