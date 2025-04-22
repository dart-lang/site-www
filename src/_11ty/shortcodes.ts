import {UserConfig} from '@11ty/eleventy';

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
  eleventyConfig.addShortcode('ytEmbed', function (id: string, title: string, type = 'video', fullWidth = false) {
    let embedTypePath = '';
    if (type === 'playlist') {
      embedTypePath = 'playlist?list=';
    } else if (type === 'series') {
      embedTypePath = 'videoseries?list=';
    }

    return `<iframe ${fullWidth ? 'class="full-width"' : 'width="560" height="315"'} 
        src="https://www.youtube.com/embed/${embedTypePath}${id}" title="${title}" frameborder="0" 
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" 
        allowfullscreen loading="lazy"></iframe><br>
        <p><a href="https://www.youtube.com/watch/${id}" target="_blank" rel="noopener" title="Open '${title}' video in new tab">${title}</a></p>`;
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
