[![Build Status](https://travis-ci.org/xdamman/mediumexporter.svg?branch=master)](https://travis-ci.org/xdamman/mediumexporter)
[![Coverage Status](https://coveralls.io/repos/github/xdamman/mediumexporter/badge.svg?branch=master)](https://coveralls.io/github/xdamman/mediumexporter?branch=master)

# Medium Exporter

Export your stories published on medium.com to markdown.

## Usage

    ./index.js {url}
        -O, --output - write to specified output directory
        -I, --info – Show information about the medium post
        --hugo - enable gohugo.io shortcodes
        --frontmatter - enable frontmatter
        --jekyll - format content and images for us in Jekyll blogs

## CLI example

If not output directory is specified, images and content will be downloaded into `/content`

    ./index.js https://medium.com/@PatrickHeneise/malaysia-16be98ab673e

## programmatic example

### get individual posts

    async function example() {
      mediumexporter.getPost(link, {
        output: "content/posts",
        hugo: true,
        frontmatter: true
      })
    }

### get feeds (default page size is 10)

    const exporter = require('./index')
    exporter.getFeed('https://medium.com/feed/@xdamman', { output: 'content' })
