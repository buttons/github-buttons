if window._phantom
  HTMLElement::click or= ->
    event = document.createEvent 'MouseEvents'
    event.initMouseEvent 'click', true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
    @dispatchEvent event
    return

CONFIG_SCRIPT = src: "../../buttons.js"
CONFIG_URL    = CONFIG_SCRIPT.src.replace /[^/]*([?#].*)?$/, "" if CONFIG_SCRIPT

document.head.appendChild document.createElement "base"
