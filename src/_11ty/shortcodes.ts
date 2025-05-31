import {UserConfig} from '@11ty/eleventy';
import {escapeHtml} from 'markdown-it/lib/common/utils.mjs';

export function registerShortcodes(eleventyConfig: UserConfig): void {
  _setupCards(eleventyConfig);
  _setupMedia(eleventyConfig);
}

function _setupCards(eleventyConfig: UserConfig): void {
  eleventyConfig.addPairedShortcode('card', function (content: string, title: string, link?: string | null) {
    let cardBuilder = link ? `<a class="card filled-card" href="${link}">` : '<div class="card">';

    cardBuilder += `<div class="card-header"><header class="card-title">${title}</header></div>`;
    cardBuilder += `<div class="card-content">

${content}

</div>
`;

    cardBuilder += link ? '</a>' : '</div>';

    return cardBuilder;
  });
}

function _setupMedia(eleventyConfig: UserConfig): void {
  eleventyConfig.addShortcode('ytEmbed', function (id: string, title: string, playlistId: string | null = null) {
    const escapedTitle = title && title.length > 0 ? escapeHtml(title) : '';

    let startTime = 0;
    if (id.includes('?')) {
      id = id.split('?')[0];

      const idAndStartTime = id.split('start=');
      if (idAndStartTime.length > 1) {
        const startTimeString = idAndStartTime[1];
        startTime = Number.parseInt(startTimeString);
      }
    }

    return `
<lite-youtube videoid="${id}" videotitle="${escapedTitle}" videoStartAt="${startTime}" ${playlistId ? `playlistid="${playlistId}"` : ''}>
  <p><a class="lite-youtube-fallback" href="https://www.youtube.com/watch/${id}" target="_blank" rel="noopener">Watch on YouTube in a new tab: "${title}"</a></p>
</lite-youtube>`;
  });

  eleventyConfig.addPairedShortcode('videoWrapper', function (content: string, intro = '') {
    let wrapperMarkup = '<div class="video-wrapper">';
    if (intro && intro !== '') {
      wrapperMarkup += `<span class="video-intro">${intro}</span>`;
    }

    wrapperMarkup += content;
    wrapperMarkup += '</div>';
    return wrapperMarkup;
  });
}
