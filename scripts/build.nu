#!/usr/bin/env nu

# Epignosis — Full Site Build Script
# Usage: nu scripts/build.nu

const PROJ_ROOT = ('../..' | path expand)
const THEME_DIR = ('.' | path expand)
const SCSS_DIR = ([$THEME_DIR 'scss'] | path join)
const CSS_DIR = ([$THEME_DIR 'static' 'css'] | path join)

export def main [] {
  build
}

export def build [] {
  build-css
  build-site
  build-search
}

export def 'build-css' [] {
  print "🔨 Epignosis CSS..."
  mkdir $CSS_DIR

  let main_src = ([$SCSS_DIR 'main.scss'] | path join)
  let main_out = ([$CSS_DIR 'main.css'] | path join)

  let css = (^sass --no-source-map $main_src)
  let minified = ($css | ^cleancss -O2 --format beautify)
  $minified | save -f $main_out

  let len = ($minified | str length)
  print ("  Done: main.css " + ($len | into string) + " bytes")
}

export def 'build-site' [] {
  print "🏗️  Hugo..."
  let result = (do {
    cd $PROJ_ROOT
    ^hugo --cleanDestinationDir
  } | complete)

  if $result.exit_code != 0 {
    print ("  Hugo error: " + $result.stderr)
  } else {
    print "  Hugo: ok"
  }
}

export def 'build-search' [] {
  print "🔍 Pagefind..."
  let result = (do {
    cd $PROJ_ROOT
    ^pagefind --site public --output-subdir pagefind
  } | complete)

  if $result.exit_code != 0 {
    print ("  Pagefind error: " + $result.stderr)
  } else {
    print "  Pagefind: ok"
  }
}
