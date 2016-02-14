fs    = require 'fs'
css   = require 'css'
jsdom = require 'jsdom'


class OcticonsLess
  constructor: (octicons, callback) ->
    svgs = {}
    for svg in fs.readdirSync "#{octicons}/svg" when svg.match /\.svg$/i
      svgs[".octicon-#{svg.replace /\.svg$/i, ""}"] = fs.readFileSync("#{octicons}/svg/#{svg}").toString()

    stylesheet = css.parse fs.readFileSync("#{octicons}/octicons/octicons.css").toString()
      .stylesheet.rules.filter (rule) ->
        rule.type is "rule" and rule.selectors[0].match /:before$/i
      .map (rule) ->
        selectors = rule.selectors.map (selector) -> selector.replace /::?before$/i, ""

        for selector in selectors when selector of svgs
          window = jsdom.jsdom(svgs[selector], parsingMode: "xml").defaultView
          height = round window.document.documentElement.getAttribute "height"
          width = round window.document.documentElement.getAttribute "width"
          window.close()
          break

        "#{selectors.join ", "} { width: unit(( #{width} / #{height} ), em); }"
      .join "\n"

    css.parse stylesheet
    callback stylesheet

  round = (length) ->
    if Math.abs(length - Math.round length) < 0.01
      Math.round length
    else
      length


new OcticonsLess "components/octicons", (stylesheet) ->
  if process.argv.length > 2
    fs.writeFileSync process.argv[2], stylesheet
  else
    console.log stylesheet
