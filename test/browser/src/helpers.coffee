if window._phantom
  HTMLElement.prototype.click or= ->
    event = document.createEvent 'MouseEvents'
    event.initMouseEvent 'click', true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
    @dispatchEvent event
    return


Config =
  url: "../../"
  script: src: "../../buttons.js"
