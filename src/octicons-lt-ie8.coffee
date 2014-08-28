#!/usr/bin/env phantomjs

args = require('system').args
fs   = require('fs')
page = require('webpage').create()

if args.length > 1
  puts = (content) -> fs.write args[1], content, 'w'
else
  puts = (content) -> console.log content

page.open "https://octicons.github.com/", ->
  puts page.evaluate ->
    styleSheets = Array.prototype.filter.call document.styleSheets, (styleSheet) ->
      styleSheet.href?.match /\/octicons\.css$/
    Array.prototype.filter.call styleSheets[0].cssRules, (cssRule) ->
      cssRule.selectorText?.match /^\.octicon-[\w-]+?::before(?:\s*,\s*\.octicon-[\w-]+?::before)*$/
    .map (cssRule) ->
      selectorText = cssRule.selectorText.replace /::before/g, ""
      char = cssRule.style.content
      charCode = char.charCodeAt(0).toString(16)

      "#{selectorText} { zoom: expression( this.innerHTML = '&#x#{charCode};' ); } /* #{char} */"
    .join "\n"
  phantom.exit()
