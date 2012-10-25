xhr = new XMLHttpRequest
xhr.addEventListener "load", ->
  css = @responseText
  sizeTesterContainer = document.createElement "div"
  sizeTesterContainer.className = "octicon"
  sizeTesterContainer.style.visibility = "hidden"
  for style in css.match /^\.octicon-.*{\s+.*\s+}$/mg
    sizeTester = document.createElement "span"
    className = style.match(/^\.(octicon-.*):before/)[1]
    sizeTester.className = className
    sizeTesterContainer.appendChild sizeTester
  document.body.appendChild sizeTesterContainer

  WebFont.load
    custom:
      families: ["octicons"]
      urls: ["../octicons.css"]
      testStrings: {
        octicons: "\uf092"
      }
    active: ->
      for s in [{fontSize: "14px"}, {prefix: "mega", fontSize: "20px"}]
        sizeTesterContainer.style.fontSize = s.fontSize
        code = document.getElementsByTagName("code")[0]
        code.innerText += (
          for i in sizeTesterContainer.children
            """
            #{if s.prefix then ".#{s.prefix} " else ""}.#{i.className} {
              width: #{i.offsetWidth}px;
            }
            """
        ).join "\n\n"
      document.body.removeChild sizeTesterContainer
      return
  return
xhr.open "GET", "/assets/css/octicons.css", true
xhr.send()
