import {
  document
  createElement
} from "./alias"
import {
  baseURL
  htmlPath
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
  get as getSize
  set as setSize
} from "./size"

render = (options, func) ->
  return unless options? and func?

  options = parseOptions options if options.getAttribute

  if (HTMLElement = window.HTMLElement) and HTMLElement::attachShadow and !HTMLElement::attachShadow::
    host = createElement "span"
    host.title = title if title = options.title
    renderContent (host.attachShadow mode: "closed"), options, ->
      func host
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
        iframe.src = baseURL + htmlPath + "#" + stringifyQueryString options
        iframe.title = title if title = options.title
        func iframe
        return
      return
    document.body.appendChild iframe
  return

export {
  render
}
