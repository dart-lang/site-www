import {
  activeNavEntryIndexArray,
  arrayToSentenceString, breadcrumbsForPage, generateToc,
  regexReplace,
  toISOString,
  underscoreBreaker
} from './src/_11ty/filters.js';

import yaml from 'js-yaml';

import {markdown} from './src/_11ty/plugins/markdown.js';

import {configureHighlighting} from './src/_11ty/plugins/highlight.js';

import minifier from 'html-minifier-terser';
import * as path from 'node:path';
import * as sass from 'sass';

/**
 * @typedef {import('11ty/eleventy/UserConfig')} EleventyConfig
 * @param {EleventyConfig} eleventyConfig
 */
export default function (eleventyConfig) {
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

  // eleventyConfig.addPlugin(eleventySass, {
  //   sass: {
  //     style: _isProduction() ? 'compressed' : 'expanded',
  //     sourceMap: !_isProduction(),
  //     quietDeps: true
  //   },
  //   compileOptions: {
  //     cache: !_isProduction(),
  //   },
  // });

  eleventyConfig.addExtension('scss', {
    read: false,
    getData: async function (inputPath) {
      const data = {
        eleventyExcludeFromCollections: true
      };

      if (path.basename(inputPath).startsWith('_')) {
        return data;
      }
      const { css } = sass.compile(inputPath, {
        style: _isProduction() ? 'compressed' : 'expanded',
        sourceMap: !_isProduction(),
        quietDeps: true,
      });
      data._content = css;
      return data;
    },
    compileOptions: {
      cache: !_isProduction(),
      permalink: function (permalink, inputPath) {
        if (path.basename(inputPath).startsWith('_')) {
          return false;
        }

        return data => `${data.page.filePathStem}.css`;
      }
    },
    compile: () => data => data._content
  });

  eleventyConfig.addPassthroughCopy('src/assets/dash');
  eleventyConfig.addPassthroughCopy('src/assets/js');
  eleventyConfig.addPassthroughCopy('src/assets/img', {expand: true});
  eleventyConfig.addPassthroughCopy('src/assets/shared', {expand: true, filter: /^(?!_).+/});
  eleventyConfig.addPassthroughCopy('src/f', {expand: true, filter: /^(?!_).+/});
  eleventyConfig.addPassthroughCopy('src/guides/language/specifications');

  if (_isProduction()) {
    // If building for production, minify/optimize the HTML output.
    // Doing so during serving isn't worth the extra build time.
    eleventyConfig.addTransform('minify-html', async function (content) {
      if (this.page.outputPath && this.page.outputPath.endsWith('.html')) {
        // Minify the page's content if it's an HTML file.
        // Other options can be enabled, but each should be tested.
        return await minifier.minify(content, {
          useShortDoctype: true,
          removeComments: true,
          collapseWhitespace: true,
          minifyJS: true,
        });
      }

      return content;
    });
  }
  
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
