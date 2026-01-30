const rssParser = require('rss-parser')
const parser = new rssParser()
const fs = require('fs')
const path = require('path')
const getPost = require('./get-post')

module.exports = async function(feedURL, program = {}) {
  const promises = []
  const data = await parser.parseURL(feedURL)

  data.items.forEach(entry => {
    promises.push(getPost(entry.link, program))
  })

  return Promise.all(promises)
    .then(results => {
      console.log(results)
      return
    })
    .catch(err => {
      console.log(err)
    })
}
