args = require('system').args
fs   = require('fs')
page = require('webpage').create()

if args.length > 1
  puts = (content) -> fs.write args[1], content, 'w'
else
  puts = (content) -> console.log content

page.open "src/phantomjs/octicons/index.html", ->
  puts page.evaluate ->
    octicon = document.body.appendChild document.createElement "span"

    styleSheets = Array.prototype.filter.call document.styleSheets, (styleSheet) ->
      styleSheet.href?.match /\/octicons\.css$/
    Array.prototype.filter.call styleSheets[0].cssRules, (cssRule) ->
      cssRule.selectorText?.match /^\.octicon-[\w-]+?::before(?:\s*,\s*\.octicon-[\w-]+?::before)*$/
    .map (cssRule) ->
      selector = cssRule.selectorText.match(/^\.(octicon-[\w-]+?)::before/)[1]
      octicon.className = "mega-octicon #{selector}"

      selectorText = cssRule.selectorText.replace /::before/g, ""

      "#{selectorText} { width: unit((#{octicon.offsetWidth}/32), em); }"
    .join "\n"
  phantom.exit()

