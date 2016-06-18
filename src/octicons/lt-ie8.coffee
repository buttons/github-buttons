fs  = require 'fs'
css = require 'css'


class OcticonsLtIE8
  constructor: (octicons, callback) ->
    stylesheet = css.parse fs.readFileSync("#{octicons}/build/font/octicons.css").toString()
      .stylesheet.rules.filter (rule) ->
        rule.type is "rule" and rule.selectors[0].match /:before$/i
      .map (rule) ->
        selectors = rule.selectors.map (selector) -> selector.replace /::?before$/i, ""

        for declaration in rule.declarations when declaration.property is "content"
          charCode = parseInt declaration.value.replace(/\W/g, ""), 16
          break

        "#{selectors.join ", "} { zoom: expression( this.innerHTML = '&#x#{charCode.toString 16};' ); } /* #{String.fromCharCode charCode} */"
      .join "\n"

    css.parse stylesheet
    callback stylesheet


new OcticonsLtIE8 "components/octicons", (stylesheet) ->
  if process.argv.length > 2
    fs.writeFileSync process.argv[2], stylesheet
  else
    console.log stylesheet
