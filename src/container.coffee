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
  render as renderContent
} from "./content"
import {
  getFrameContentSize
  setFrameSize
} from "./frame"
import {
  render as batchRender
} from "./batch"

### istanbul ignore next ###
render = (targetNode, options) ->
  return batchRender() unless targetNode?
  options = parseOptions targetNode unless options?

  if HTMLElement::attachShadow
    host = createElement "span"
    host.title = title if title = options.title
    root = host.attachShadow mode: "closed"
    link = createElement "link"
    link.rel = "stylesheet"
    link.href = "#{baseURL}assets/css/buttons.css"
    root.appendChild link
    renderContent root.appendChild(createElement "span"), options
    targetNode.parentNode.replaceChild host, targetNode
  else
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
    iframe.title = title if title = options.title

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
      contentWindow = iframe.contentWindow
      if contentWindow.$
        contentWindow.$ = onload
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
