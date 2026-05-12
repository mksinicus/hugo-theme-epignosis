#!/usr/bin/env nu

# Epignosis — Build Example Site & Deploy to docs/
# Usage: nu scripts/build-example.nu
# Builds the exampleSite with Hugo + Pagefind, then replaces docs/ with the output.
# The docs/ directory is served by GitHub Pages.

export def main [] {
  build
}

export def build [] {
  # Resolve paths relative to the script directory ($env.FILE_PWD is set when running a .nu file)
  let scripts_dir = ($env.FILE_PWD? | default (pwd))
  let repo_root = ($scripts_dir | path dirname)
  let example_dir = ([$repo_root 'exampleSite'] | path join)
  let public_dir = ([$example_dir 'public'] | path join)
  let docs_dir = ([$repo_root 'docs'] | path join)
  let scss_dir = ([$repo_root 'scss'] | path join)
  let css_dir = ([$repo_root 'static' 'css'] | path join)
  build-css $scss_dir $css_dir
  build-site $example_dir $repo_root
  build-search $example_dir $public_dir
  deploy-docs $public_dir $docs_dir
}

# ── CSS ──────────────────────────────────────────────

def 'build-css' [scss_dir: string, css_dir: string] {
  print "🔨 Compiling CSS..."
  mkdir $css_dir

  let main_src = ([$scss_dir 'main.scss'] | path join)
  let main_out = ([$css_dir 'main.css'] | path join)

  let css = (^sass --no-source-map $main_src)
  let minified = ($css | ^cleancss -O2 --format beautify)
  $minified | save -f $main_out

  let len = ($minified | str length)
  print $"  main.css: ($len) bytes"
}

# ── Hugo ─────────────────────────────────────────────

def 'build-site' [example_dir: string, repo_root: string] {
  print "🏗️  Building exampleSite with Hugo..."
  let baseURL = "http://mksinicus.github.io/hugo-theme-epignosis"
  # themesDir is the parent of the repo, so Hugo finds repo_root as hugo-theme-epignosis
  let themes_dir = ($repo_root | path dirname)

  let result = (do {
    cd $example_dir
    ^hugo --cleanDestinationDir --baseURL $baseURL --themesDir $themes_dir
  } | complete)

  if $result.exit_code != 0 {
    print $"  Hugo error: ($result.stderr)"
    exit 1
  }
  print "  Hugo: ok"
}

# ── Pagefind ─────────────────────────────────────────

def 'build-search' [example_dir: string, public_dir: string] {
  print "🔍 Indexing with Pagefind..."

  if not ($public_dir | path exists) {
    print "  Skipped: public/ not found"
    return
  }

  let result = (do {
    cd $example_dir
    ^pagefind --site public --output-subdir pagefind
  } | complete)

  if $result.exit_code != 0 {
    print $"  Pagefind error: ($result.stderr)"
    # Non-fatal — site still works without search
  } else {
    print "  Pagefind: ok"
  }
}

# ── Deploy to docs/ ──────────────────────────────────

def 'deploy-docs' [public_dir: string, docs_dir: string] {
  print "📦 Deploying to docs/..."

  if ($docs_dir | path exists) {
    print "  Removing old docs/..."
    rm -rf $docs_dir
  }

  cp -r $public_dir $docs_dir
  print "  Done: exampleSite/public/ → docs/"
}
