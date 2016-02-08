if window._phantom
  HTMLElement::click or= ->
    event = document.createEvent 'MouseEvents'
    event.initMouseEvent 'click', true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
    @dispatchEvent event
    return

Config =
  api:         "https://api.github.com"
  anchorClass: "github-button"
  iconClass:   "octicon"
  icon:        "octicon-mark-github"
  scriptId:    "github-bjs"
  script: src: "../../buttons.js"
  url:         "../../"

document.head.appendChild document.createElement "base"
