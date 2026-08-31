# Manage blog authors

Use this reference when adding or updating an author,
or when a post's author ID doesn't resolve.

Authors are defined as individual YAML files in
`src/data/authors/<author-id>.yaml`, and
their local profile images live in `src/content/blog/authors/`.

The filename `<author-id>.yaml` acts as a stable content ID,
matching the author identifier used in blog post frontmatter.

## Add or resolve an author

Before adding a record,
search `src/data/authors/` by ID, display name, or GitHub handle.
Use verified or author-provided details.
Don't invent a name, profile, or image.
For a new ID, choose a recognizable lowercase handle or concise stable slug,
then create `src/data/authors/<author-id>.yaml`.

`name` is required while `image`, `bio`, `twitter`, and `github` are optional:

```yaml
name: "Author Display Name"
username: "author-id"
bio: ""
image: "author-id.webp"
twitter: ""
github:
  handle: "author-id"
  username: "Author Display Name"
  avatar_url: "https://avatars.githubusercontent.com/u/123456?v=4"
```

- `image` names a local image file in `src/content/blog/authors/`.
- If `image` is omitted, the site falls back to `github.avatar_url`.
- `github.handle` or `twitter` is used to link to their profile from the byline.
  Prefer GitHub.

## Author images

Place local author images in `src/content/blog/authors/`.
Name a local image after the exact author ID or image hash and
use its real lowercase `.jpg` or `.webp` extension,
such as `author-id.webp`.
Optimize it for a small square display and a centered circular crop.
Use an author-supplied or appropriately reusable image.

## Update an author

Keep the existing ID when an author's name, handle, link, or image changes.
If the ID must change, update every occurrence in post frontmatter.

When replacing an image with a different filename or extension,
search for references to the old file before removing it.
Don't remove an apparently unused author without checking all posts.

## Configure the authors of a post

In a post's `index.md` frontmatter:

For a single author, use a YAML scalar:

```yaml
author: author-id
```

For multiple authors, use an ordered list:

```yaml
author:
  - first-author
  - second-author
```

List order controls the displayed byline.
