#!/usr/bin/env phantomjs

args = require('system').args
fs   = require('fs')
page = require('webpage').create()

if args.length > 1
  puts = (content) -> fs.write args[1], content, 'w'
else
  puts = (content) -> console.log content

page.onCallback = ->
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

page.open "https://octicons.github.com/", ->
  page.includeJs "//ajax.googleapis.com/ajax/libs/webfont/1/webfont.js", ->
    page.evaluate ->
      WebFont.load
        custom:
          families: ["octicons"]
          testStrings:
            octicons: "\uf092"
        active: ->
          window.callPhantom()
