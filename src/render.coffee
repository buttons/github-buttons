import {
  document
  createElement
} from "./alias"
import {
  baseURL
  uuid
} from "./config"
import {
  parseOptions
} from "./options"
import {
  stringifyQueryString
} from "./querystring"
import {
  onceEvent
} from "./event"
import {
  getFrameContentSize
  setFrameSize
} from "./frame-size"
import {
  renderAll
} from "./render-all"

### istanbul ignore next ###
render = (targetNode, options) ->
  return renderAll() unless targetNode?
  options = parseOptions targetNode unless options?

  hash = "#" + stringifyQueryString options

  iframe = createElement "iframe"
  iframe.setAttribute name, value for name, value of {
    allowtransparency: true
    scrolling: "no"
    frameBorder: 0
  }
  setFrameSize iframe, [1, 0]
  iframe.style.border = "none"
  iframe.src = "javascript:0"

  document.body.appendChild iframe

  onload = ->
    size = getFrameContentSize iframe
    iframe.parentNode.removeChild iframe
    onceEvent iframe, "load", ->
      setFrameSize iframe, size
      return
    iframe.src = "#{baseURL}buttons.html#{hash}"
    targetNode.parentNode.replaceChild iframe, targetNode
    return

  onceEvent iframe, "load", ->
    if callback = iframe.contentWindow._
      _ = callback._
      callback._ = ->
        _.apply null, arguments
        onload()
        return
    else
      onload()
    return

  contentDocument = iframe.contentWindow.document
  contentDocument.open().write \
    """
    <!DOCTYPE html><html><head><meta charset="utf-8"><title>#{uuid}</title><link rel="stylesheet" href="#{baseURL}assets/css/buttons.css"><script>document.location.hash = "#{hash}";</script></head><body><script src="#{baseURL}buttons.js"></script></body></html>
    """
  contentDocument.close()
  return

export {
  render
}
