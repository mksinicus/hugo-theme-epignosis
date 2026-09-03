# Epignosis

A Hugo theme for building **personal knowledge bases** — flat entry structure, Wikipedia-style Pagefind search, a three-tier taxonomy (`nous` · `physis` · `techne`), automatic backlinks, and CJK-aware typography.

**Epignosis** (ἐπίγνωσις) — Ancient Greek for "true knowledge" / "intimate understanding."

Live demo: <https://mksinicus.github.io/hugo-theme-epignosis/>

## Features

- 🧠 **Knowledge base, not a blog** — flat entries with dates as metadata, no reverse-chronological bias
- 🔍 **Search everywhere** — [Pagefind](https://pagefind.app/) search box in the nav bar on every page plus a Wikipedia-style hero search on the homepage
- 🏛️ **Three-category taxonomy** — `physis` (natural world), `techne` (skills), `nous` (mind); color-coded category chips and dedicated term pages
- 🏷️ **Tag cloud** — frequency-weighted chips on the tags page, with per-tag term listings
- 🔗 **Bidirectional links** — `{{< bilink >}}` shortcode (validated at build time, `errorf` on a missing target) plus an automatic **Backlinks** section on every entry; only explicit bilinks count, `relref` links do not
- 📑 **Sticky TOC sidebar** — auto-generated from headings; sticky on wide screens, stacks above the article on mobile
- 🧩 **Markdown render hooks** — local links/images resolve through global assets or page resources (with permalinks); remote URLs pass through untouched
- 📦 **Shortcode library** — note/alert/warning/example callouts, spoiler (`<details>`), two-column layout, flex rows, margin notes, heimu redaction, small caps, attribution, centered text
- 🎨 **Solarized Light code highlighting** — via Hugo's built-in Chroma (`style = "solarized-light"` in site config)
- 🇨🇳 **CJK typography** — Chinese/Japanese-aware font stacks (applied through `[lang^="zh"]` / `[lang^="ja"]` so `zh-cn` works), emphasis dots (`span.cem`), single-line `del` instead of strikethrough, underline positioning
- 📐 **SCSS toolchain** — Dart Sass + CleanCSS with Nushell build scripts; no Node/npm needed to build the theme
- 📡 **RSS autodiscovery** — feed link in the nav bar and `<head>`

## Requirements

- [Hugo](https://gohugo.io/) ≥ 0.146.0 (extended edition not required)
- [Dart Sass](https://sass-lang.com/dart-sass) (`sass`)
- [CleanCSS](https://github.com/clean-css/clean-css) (`cleancss`)
- [Pagefind](https://pagefind.app/) ≥ 1.5 (the extended binary is recommended for CJK content)
- [Nushell](https://www.nushell.sh/) for the build scripts

## Quick Start

Add the theme as a git submodule:

```bash
cd your-hugo-site
git submodule add https://github.com/mksinicus/hugo-theme-epignosis.git themes/hugo-theme-epignosis
```

Minimal site configuration (`hugo.toml`):

```toml
baseURL = "https://example.org"
languageCode = "zh-cn"
title = "My Knowledge Base"
theme = "hugo-theme-epignosis"

[taxonomies]
  tag = "tags"
  category = "category"

[params]
  description = "知识库 — nous (心灵) · physis (自然) · techne (技艺)"

[markup]
  [markup.highlight]
    style = "solarized-light"
```

Or scaffold from the bundled example site (the submodule already lives at `themes/hugo-theme-epignosis`, so default theme resolution works):

```bash
cp themes/hugo-theme-epignosis/exampleSite/hugo.toml .
cp -r themes/hugo-theme-epignosis/exampleSite/content .
hugo server
```

### Assumed site structure

The nav bar links to the three categories, the tag cloud, an Archive page, and an About page, so the theme expects this layout:

```
content/
├── _index.md            # homepage hero (title + description)
├── about.md             # About page
├── pages/
│   └── _index.md        # Archive — lists every regular page
└── *.md                 # your entries (flat, no folders needed)
```

## Content authoring

### Frontmatter

```yaml
---
title: "Entry Title"
date: 2026-05-08
author: "Author Name"            # or authors: ["A", "B"] for multiple
category: ["techne"]             # physis / techne / nous — single or array
tags: ["tag1", "tag2"]
description: "Optional summary shown under the title"
---
```

- `category` must be one of `physis`, `techne`, `nous` to get its color chip; `date` shows in the entry meta; `author`/`authors` render between the title and meta.

### Internal links & backlinks

Two kinds of internal links, with different semantics:

```md
<!-- Standard Hugo link: no backlink is created -->
See [the other entry]({{< relref "other-entry.md" >}}).

<!-- Bilink: validated at build, auto-titled, creates a backlink -->
See {{< bilink "other-entry.md" >}}.
See {{< bilink "other-entry.md" "Custom label" >}}.
```

- `bilink` fails the build (`errorf`) if the target doesn't exist — same safety as `relref`.
- A **Backlinks** section is appended to an entry when other pages bilink to it. Only explicit bilinks count, so backlinks stay intentional.

### Shortcodes

| Shortcode | Purpose |
|-----------|---------|
| `{{< bilink "slug.md" >}}` / `{{< bilink "slug.md" "label" >}}` | Validated bidirectional internal link |
| `{{< note >}}…{{< /note >}}` | Blue info callout (optional title: `{{< note "Title" >}}`) |
| `{{< alert "Title" >}}…{{< /alert >}}` | Yellow alert callout |
| `{{< warning "Title" >}}…{{< /warning >}}` | Red warning callout |
| `{{< example "Title" >}}…{{< /example >}}` | Example box |
| `{{< spoiler "Title" >}}…{{< /spoiler >}}` | `<details>` disclosure; title defaults to `展开` |
| `{{< redacted >}}…{{< /redacted >}}` | Heimu — black bar, reveals on hover |
| `{{< attribution >}}…{{< /attribution >}}` | Attribution/citation block |
| `{{< centered >}}…{{< /centered >}}` | Centered text |
| `{{< columns >}}…{{< column >}}…{{< /column >}}{{< /columns >}}` | Two-column flex layout |
| `{{< flexrow >}}…{{< /flexrow >}}` | Plain flex row |
| `{{< flexcent >}}…{{< /flexcent >}}` | Centered flex row |
| `{{< margin-note >}}…{{< /margin-note >}}` | Floated margin note (wide screens) |
| `{{< sc >}}…{{< /sc >}}` | Small caps |

All callouts render their inner content through Markdown.

## Build

The theme ships Nushell scripts; run them from the theme directory:

```bash
nu scripts/build-css.nu      # SCSS → static/css/main.css (sass + cleancss)
nu scripts/build.nu          # full site: CSS → Hugo → Pagefind
nu scripts/build-example.nu  # rebuild exampleSite & publish it into docs/ (GitHub Pages)
```

`build.nu` compiles the CSS, runs Hugo against the site **two levels up** (`../..`), then indexes `public/` with Pagefind. If you are developing a site that vendors this theme, run it from the theme folder or replicate the steps (CSS → `hugo` → `pagefind --site public --output-subdir pagefind`).

## Deployment on GitHub Pages

The repository publishes the example site from the `docs/` folder:

```bash
nu scripts/build-example.nu   # rebuilds exampleSite and replaces docs/
git add docs/ && git commit -m "rebuild example site"
git push
```

The build passes `--baseURL https://mksinicus.github.io/hugo-theme-epignosis/` so Pagefind is configured for the subpath deployment.

## Structure

```
hugo-theme-epignosis/
├── archetypes/       # Content templates (hugo new)
├── exampleSite/      # Runnable demo site (content/hugo.toml)
├── layouts/
│   ├── _default/     # baseof, home, list, single
│   ├── _default/_markup/  # link & image render hooks
│   ├── pages/        # Archive (all-pages) listing
│   ├── partials/     # nav, head, footer, backlinks
│   ├── shortcodes/   # 15 shortcodes
│   └── tags/         # tag cloud + term listing
├── scss/             # SCSS source (_colors, _fonts, _shared, _layout, _home, _pagefind)
├── scripts/          # Nushell build scripts
├── static/           # Compiled CSS + favicon
└── docs/             # Built example site (GitHub Pages output)
```

## Styling & theming

- Single-file compiled CSS: `static/css/main.css`. Edit the SCSS sources under `scss/`, then run `nu scripts/build-css.nu`.
- Colors are CSS custom properties in `:root` (`scss/_colors.scss`) — accent, surfaces, callout colors, max widths and the rest are all overridable there.
- CJK rules live in `scss/_fonts.scss`: font stacks are scoped with `[lang^="zh"]` / `[lang^="ja"]` attribute selectors so they fire for `zh-cn`/`ja-JP` documents without touching code/math fonts; `span.cem` renders the dot-under emphasis mark (print falls back to `text-emphasis`); `del` in Chinese/Japanese text draws a single rule instead of strikethrough.

## License

Public domain under [The Unlicense](https://unlicense.org) (see `UNLICENSE`). Fonts/styles adapted in part from [my-rmd-stylesheets](https://github.com/mksinicus/my-rmd-stylesheets). Proudly made with OpenClaw @ DeepSeek-V4-Pro.
