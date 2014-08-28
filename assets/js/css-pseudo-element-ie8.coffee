head = document.getElementsByTagName("head")[0]
style = document.createElement "style"
style.type = "text/css"
style.styleSheet.cssText = ":before, :after { content: none !important; }"
head.appendChild style
window.attachEvent "onload", ->
  head.removeChild style
  return
