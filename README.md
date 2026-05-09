# Epignosis Theme

A Hugo theme for personal knowledge bases. Wikipedia-style search, three-category taxonomy, responsive TOC sidebar.

**Epignosis** (ἐπίγνωσις) — Ancient Greek for "true knowledge" / "intimate understanding."

## Features

- 📚 **Knowledge base, not a blog** — flat content structure, no chronological bias
- 🔍 **Search-first homepage** — [Pagefind](https://pagefind.app/) powered, Wikipedia-style
- 🏛️ **Three-category taxonomy** — `physis` (objective), `techne` (skills), `nous` (subjective)
- 📑 **Sticky TOC sidebar** — auto-generated, collapsible on mobile
- 🎨 **Solarized Light** code highlighting
- 🏷️ **Tag cloud** — frequency-weighted, modular design
- 📦 **Spoiler shortcode** — `<details>` with styled summary
- 🔧 **SCSS toolchain** — sass + cleancss, Nushell build scripts
- 🇨🇳 **CJK typography** — proper font stacks, emphasis marks, line-through

## Quick Start

### Prerequisites

- [Hugo](https://gohugo.io/) ≥ 0.146.0 (extended not required)
- [Dart Sass](https://sass-lang.com/dart-sass)
- [CleanCSS](https://github.com/clean-css/clean-css)
- [Pagefind](https://pagefind.app/) ≥ 1.5 (extended binary recommended for CJK)

### Install

```bash
cd your-hugo-site
git submodule add https://github.com/marcuskzhong/epignosis-theme themes/epignosis-theme
cp themes/epignosis-theme/exampleSite/hugo.toml .
```

### Build

```bash
cd themes/epignosis-theme
nu scripts/build.nu
```

Or step by step:

```bash
# CSS only
nu scripts/build-css.nu

# Hugo + Pagefind
hugo
pagefind --site public
```

## Content

### Frontmatter

```yaml
---
title: "Entry Title"
date: 2026-05-08
category: ["physis"]      # physis / techne / nous (or multiple)
tags: ["tag1", "tag2"]
description: "Optional summary"
---
```

### Spoiler Shortcode

```
{{< spoiler "Title" >}}
Hidden content rendered as markdown...
{{< /spoiler >}}
```

### Homepage

Edit `content/_index.md` to customize the homepage title and description.

## Structure

```
epignosis-theme/
├── scss/          # SCSS source
├── layouts/       # Hugo templates
├── static/        # Compiled CSS
├── scripts/       # Nushell build scripts
├── exampleSite/   # Demo content
└── archetypes/    # Content templates
```

## License

MIT. Based in part on [my-rmd-stylesheets](https://github.com/mksinicus/my-rmd-stylesheets). Proudly made with OpenClaw@DeepSeek-V4-Pro.
