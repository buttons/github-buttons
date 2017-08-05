import {
  document
  createElement
  createTextNode
} from "./alias"
import {
  baseURL
  buttonClass
  iconBaseClass
  iconClass
  uuid
} from './config'
import {
  parseOptions
} from "./options"
import {
  jsonp
} from "./jsonp"
import {
  stringifyQueryString
} from "./querystring"
import {
  onceEvent
  onceScriptLoad
} from "./event"
import {
  getFrameContentSize
  setFrameSize
} from "./frame"

renderButton = (options) ->
  a = createElement "a"
  a.href = options.href

  if not /\.github\.com$/.test ".#{a.hostname}"
    a.href = "#"
    a.target = "_self"
  else if ///
    ^https?://(
      (gist\.)?github\.com/[^/?#]+/[^/?#]+/archive/ |
      github\.com/[^/?#]+/[^/?#]+/releases/download/ |
      codeload\.github\.com/
    )
  ///.test a.href
    a.target = "_top"

  a.className = "btn"
  a.setAttribute "aria-label", ariaLabel if ariaLabel = options["aria-label"]
  i = a.appendChild createElement "i"
  i.className = "#{iconBaseClass} #{options["data-icon"] or iconClass}"
  i.setAttribute "aria-hidden", "true"
  a.appendChild createTextNode " "
  span = a.appendChild createElement "span"
  span.appendChild createTextNode options["data-text"] or ""
  document.body.appendChild a

renderCount = (button) ->
  return unless button.hostname is "github.com"

  match = button.pathname.replace(/^(?!\/)/, "/").match ///
    ^/([^/?#]+)
    (?:
      /([^/?#]+)
      (?:
        /(?:(subscription)|(fork)|(issues)|([^/?#]+))
      )?
    )?
    (?:[/?#]|$)
  ///

  return unless match and not match[6]

  if match[2]
    href = "/#{match[1]}/#{match[2]}"
    api = "/repos#{href}"
    if match[3]
      property = "subscribers_count"
      href += "/watchers"
    else if match[4]
      property = "forks_count"
      href += "/network"
    else if match[5]
      property = "open_issues_count"
      href += "/issues"
    else
      property = "stargazers_count"
      href += "/stargazers"
  else
    api = "/users/#{match[1]}"
    property = "followers"
    href = "/#{match[1]}/#{property}"

  jsonp "https://api.github.com#{api}", (json) ->
    if json.meta.status is 200
      data = json.data[property]

      a = createElement "a"
      a.href = "https://github.com" + href
      a.className = "social-count"
      a.setAttribute "aria-label", "#{data} #{property.replace(/_count$/, "").replace("_", " ")} on GitHub"
      a.appendChild createElement "b"
      a.appendChild createElement "i"
      span = a.appendChild createElement "span"
      span.appendChild createTextNode "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
      button.parentNode.insertBefore a, button.nextSibling
    return
  return

renderFrameContent = (options) ->
  return unless options
  document.body.className = "large" if /^large$/i.test options["data-size"]
  button = renderButton options
  renderCount button if /^(true|1)$/i.test options["data-show-count"]
  return

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
      onceScriptLoad callback.$, onload
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

### istanbul ignore next ###
renderAll = ->
  anchors = []
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{buttonClass}"
  else
    for anchor in document.getElementsByTagName "a"
      if ~" #{anchor.className} ".replace(/[ \t\n\f\r]+/g, " ").indexOf(" #{buttonClass} ")
        anchors.push anchor
  render anchor for anchor in anchors
  return

export {
  renderButton
  renderCount
  renderFrameContent
  render
  renderAll
}
