CSS = "../../../components/octicons/octicons/octicons.css"

xhr = new XMLHttpRequest
xhr.addEventListener "load", ->
  css = @responseText
  sizeTesterContainer = document.createElement "div"
  sizeTesterContainer.className = "octicon"
  sizeTesterContainer.style.visibility = "hidden"
  for style in css.match /(\.octicon-.*:before,\s*)*\.octicon-.*:before\s*{\s*.*\s*}/mg
    for classNameBefore in style.match /\.octicon-.*:before/g
      console.log classNameBefore
      sizeTester = document.createElement "span"
      className = classNameBefore.match(/^\.(octicon-.*):before/)[1]
      sizeTester.className = className
      sizeTesterWrapper = document.createElement "div"
      sizeTesterWrapper.appendChild sizeTester
      sizeTesterContainer.appendChild sizeTesterWrapper
  document.body.appendChild sizeTesterContainer

  WebFont.load
    custom:
      families: ["octicons"]
      urls: [CSS]
      testStrings: {
        octicons: "\uf092"
      }
    active: ->
      for s in [{fontSize: "14px"}, {prefix: "mega", fontSize: "20px"}]
        sizeTesterContainer.style.fontSize = s.fontSize
        code = document.getElementsByTagName("code")[0]
        code.innerText += (
          for sizeTesterWrapper in sizeTesterContainer.children
            sizeTester = sizeTesterWrapper.children[0]
            """#{if s.prefix then ".#{s.prefix} " else ""}.#{sizeTester.className} { width: #{sizeTester.offsetWidth}px; }"""
        ).join "\n"
        code.innerText += "\n"
      document.body.removeChild sizeTesterContainer
      return
  return
xhr.open "GET", CSS, true
xhr.send()
