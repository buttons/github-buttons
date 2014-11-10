#!/usr/bin/env phantomjs

args = require('system').args
fs   = require('fs')
page = require('webpage').create()

if args.length > 1
  puts = (content) -> fs.write args[1], content, 'w'
else
  puts = (content) -> console.log content

page.onLoadFinished = ->
  puts page.evaluate (option) ->
    octicon = document.body.appendChild document.createElement "span"
    octicon.style.fontSize = "32px"

    styleSheets = Array.prototype.filter.call document.styleSheets, (styleSheet) ->
      styleSheet.href?.match /\/octicons\.css$/
    Array.prototype.filter.call styleSheets[0].cssRules, (cssRule) ->
      cssRule.selectorText?.match /^\.octicon-[\w-]+?::before(?:\s*,\s*\.octicon-[\w-]+?::before)*$/
    .map (cssRule) ->
      selector = cssRule.selectorText.match(/^\.(octicon-[\w-]+?)::before/)[1]
      octicon.className = "octicon #{selector}"

      selectorText = cssRule.selectorText.replace /::before/g, ""

      "#{selectorText} { width: unit((#{octicon.offsetWidth}/32), em); }"
    .join "\n"
  phantom.exit()

page.open "buttons.html#href%3D%26text%3D%26data.count.api%3D%26data.count.href%3D%26data.style%3D%26data.icon%3D"
