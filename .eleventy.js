const {
  regexReplace,
  toISOString,
  activeNavEntryIndexArray,
  arrayToSentenceString,
  underscoreBreaker,
  generateToc,
  breadcrumbsForPage,
} = require('./src/_11ty/filters');
const markdown = require('./src/_11ty/plugins/markdown');
const {configureHighlighting} = require('./src/_11ty/plugins/highlight');

const yaml = require('js-yaml');
const eleventySass = require('eleventy-sass');
const directoryOutputPlugin = require("@11ty/eleventy-plugin-directory-output");

module.exports = function (eleventyConfig) {
  eleventyConfig.on('eleventy.before', async () => {
    await configureHighlighting(markdown);
  });
  
  eleventyConfig.addGlobalData('isProduction', _isProduction());

  eleventyConfig.setLibrary('md', markdown);

  eleventyConfig.addDataExtension('yml,yaml',
      contents => yaml.load(contents));

  eleventyConfig.setLiquidOptions({
    cache: true,
    strictFilters: true,
    // strictVariables: true, TODO(parlough): Enable
    lenientIf: true
  });

  eleventyConfig.addTemplateFormats('scss');

  eleventyConfig.addFilter('regex_replace', regexReplace);
  eleventyConfig.addFilter('toISOString', toISOString);
  eleventyConfig.addFilter('active_nav_entry_index_array', activeNavEntryIndexArray);
  eleventyConfig.addFilter('array_to_sentence_string', arrayToSentenceString);
  eleventyConfig.addFilter('underscore_breaker', underscoreBreaker);
  eleventyConfig.addFilter('throw_error', function (error) { throw new Error(error); });
  eleventyConfig.addAsyncFilter('generate_toc', generateToc);
  eleventyConfig.addFilter('breadcrumbsForPage', breadcrumbsForPage);

  eleventyConfig.addPlugin(eleventySass, {
    sass: {
      style: _isProduction() ? 'compressed' : 'expanded',
      sourceMap: !_isProduction(),
      quietDeps: true
    },
    compileOptions: {
      cache: !_isProduction(),
    },
  });

  eleventyConfig.addPassthroughCopy('src/assets/dash');
  eleventyConfig.addPassthroughCopy('src/assets/js');
  eleventyConfig.addPassthroughCopy('src/assets/img', {expand: true});
  eleventyConfig.addPassthroughCopy('src/assets/shared', {expand: true, filter: /^(?!_).+/});
  eleventyConfig.addPassthroughCopy('src/f', {expand: true, filter: /^(?!_).+/});
  eleventyConfig.addPassthroughCopy('src/guides/language/specifications');

  eleventyConfig.setQuietMode(true);
  
  eleventyConfig.setServerOptions({
    port: 4000,
  });
  
  return {
    htmlTemplateEngine: 'liquid',
    dir: {
      input: 'src',
      output: '_site',
      layouts: '_layouts'
    }
  }
};

function _isProduction() {
  return process.env.PRODUCTION === 'true'
}
