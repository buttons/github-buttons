import {
  document
  createElement
} from "./alias"
import {
  baseURL
} from "./config"
import {
  parseOptions
} from "./options"
import {
  stringify as stringifyQueryString
} from "./querystring"
import {
  onceEvent
} from "./event"
import {
  render as renderContent
} from "./content"
import {
  render as batchRender
} from "./batch"
import {
  get as getSize
  set as setSize
} from "./size"

### istanbul ignore next ###
render = (targetNode, options) ->
  return batchRender() unless targetNode?
  options = parseOptions targetNode unless options?

  if (HTMLElement = window.HTMLElement) and HTMLElement::attachShadow and !HTMLElement::attachShadow::
    host = createElement "span"
    host.title = title if title = options.title
    renderContent (host.attachShadow mode: "closed"), options, ->
      targetNode.parentNode.replaceChild host, targetNode
      return
  else
    iframe = createElement "iframe"
    iframe.setAttribute name, value for name, value of {
      allowtransparency: true
      scrolling: "no"
      frameBorder: 0
    }
    setSize iframe, [1, 0]
    iframe.style.border = "none"
    iframe.src = "javascript:0"
    onceEvent iframe, "load", ->
      contentWindow = iframe.contentWindow
      renderContent.call contentWindow, contentWindow.document.body, options, (widget) ->
        size = getSize widget
        iframe.parentNode.removeChild iframe
        onceEvent iframe, "load", ->
          setSize iframe, size
          return
        iframe.src = "#{baseURL}buttons.html##{stringifyQueryString options}"
        iframe.title = title if title = options.title
        targetNode.parentNode.replaceChild iframe, targetNode
        return
      return
    document.body.appendChild iframe
  return

export {
  render
}
