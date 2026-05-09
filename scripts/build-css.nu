#!/usr/bin/env nu

# Epignosis — CSS Build Script
# Compile SCSS → CSS → Minify → Deploy to theme static/

const THEME_DIR = ('.' | path expand)
const SCSS_DIR = ([$THEME_DIR 'scss'] | path join)
const CSS_DIR = ([$THEME_DIR 'static' 'css'] | path join)

export def main [] {
  build
}

export def build [] {
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
