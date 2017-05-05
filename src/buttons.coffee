return if typeof window is "undefined"

document = window.document
encodeURIComponent = window.encodeURIComponent
decodeURIComponent = window.decodeURIComponent
createElement = (tag) -> document.createElement tag
createTextNode = (text) -> document.createTextNode text
Math = window.Math

BASEURL = "#{if /^http:/.test document.location then "http" else "https"}://buttons.github.io/"
BUTTON_CLASS = "github-button"
GITHUB_API_BASEURL = "https://api.github.com"
ICON_CLASS = "octicon"
ICON_CLASS_DEFAULT = "#{ICON_CLASS}-mark-github"
UUID = "faa75404-3b97-5585-b449-4bc51338fbd1"

stringifyQueryString = (obj) ->
  params = []
  for name, value of obj
    params.push "#{encodeURIComponent name}=#{encodeURIComponent value}" if value?
  params.join "&"

parseQueryString = (str) ->
  params = {}
  for pair in str.split "&" when pair isnt ""
    ref = pair.split "="
    params[decodeURIComponent ref[0]] = decodeURIComponent ref.slice(1).join "=" if ref[0] isnt ""
  params

onEvent = (target, eventName, func) ->
  if target.addEventListener
    target.addEventListener "#{eventName}", func
  else
    target.attachEvent "on#{eventName}", func
  return

onceEvent = (target, eventName, func) ->
  callback = (event) ->
    if target.removeEventListener
      target.removeEventListener "#{eventName}", callback
    else
      target.detachEvent "on#{eventName}", callback
    func event || window.event
  onEvent target, eventName, callback
  return

onceScriptLoad = (script, func) ->
  token = 0
  callback = ->
    func() if !token and token = 1
    return
  onEvent script, "load", callback
  onEvent script, "error", callback
  onEvent script, "readystatechange", ->
    callback() if not /i/.test script.readyState
    return
  return

defer = (func) ->
  if /m/.test(document.readyState) or (!/g/.test(document.readyState) and !document.documentElement.doScroll)
    window.setTimeout func
  else
    if document.addEventListener
      onceEvent document, "DOMContentLoaded", func
    else
      callback = ->
        if /m/.test document.readyState
          document.detachEvent "onreadystatechange", callback
          func()
        return
      document.attachEvent "onreadystatechange", callback
  return

jsonp = (url, func) ->
  script = createElement "script"
  script.async = true
  ref = url.split "?"
  query = parseQueryString ref.slice(1).join "?"
  query.callback = "_"
  script.src = ref[0] + "?" + stringifyQueryString query

  window._ = (json) ->
    delete window._
    func json
    return
  window._.$ = script

  onEvent script, "error", ->
    delete window._
    return

  if script.readyState
    onEvent script, "readystatechange", ->
      delete window._ if script.readyState is "loaded" and script.children and script.readyState is "loading"
      return

  head = document.getElementsByTagName("head")[0]
  if "[object Opera]" is {}.toString.call window.opera
    onEvent document, "DOMContentLoaded", ->
      head.appendChild script
      return
  else
    head.appendChild script
  return

ceilPixel = (px) ->
  devicePixelRatio = window.devicePixelRatio or 1
  (if devicePixelRatio > 1 then Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 else Math.ceil(px)) or 0

getFrameContentSize = (iframe) ->
  contentDocument = iframe.contentWindow.document
  html = contentDocument.documentElement
  body = contentDocument.body
  width = html.scrollWidth
  height = html.scrollHeight
  if body.getBoundingClientRect
    body.style.display = "inline-block"
    boundingClientRect = body.getBoundingClientRect()
    width = Math.max width, ceilPixel boundingClientRect.width or boundingClientRect.right - boundingClientRect.left
    height = Math.max height, ceilPixel boundingClientRect.height or boundingClientRect.bottom - boundingClientRect.top
    body.style.display = ""
  [width, height]

setFrameSize = (iframe, size) ->
  iframe.style.width = "#{size[0]}px"
  iframe.style.height = "#{size[1]}px"
  return

parseConfig = (anchor) ->
  config =
    "href": anchor.href
    "aria-label": anchor.getAttribute "aria-label"
  for attribute in [
    "icon"
    "text"
    "size"
    "show-count"
  ]
    attribute = "data-" + attribute
    config[attribute] = anchor.getAttribute attribute
  if !config["data-text"]?
    config["data-text"] = anchor.textContent or anchor.innerText

  deprecate = (oldAttribute, newAttribute, newValue) ->
    if anchor.getAttribute oldAttribute
      config[newAttribute] = newValue
      console and console.warn "GitHub Buttons deprecated `#{oldAttribute}`: use `#{newAttribute}=\"#{newValue}\"` instead. Please refer to https://github.com/ntkme/github-buttons#readme for more info."
    return
  deprecate "data-count-api", "data-show-count", "true"
  deprecate "data-style", "data-size", "large"

  config

createAnchor = (url, baseUrl) ->
  anchor = createElement "a"

  javascript = "javascript:"
  if (anchor.href = baseUrl) and anchor.protocol isnt javascript
    try
      href = new URL(url, baseUrl).href
      throw href unless href?
      anchor.href = href
    catch
      base = document.getElementsByTagName("base")[0]
      base.href = baseUrl
      anchor.href = url
      div = createElement "div"
      div.innerHTML = anchor.outerHTML
      anchor.href = div.lastChild.href
      div = null
      base.href = document.location.href
      base.removeAttribute "href"
  else
    anchor.href = url

  if anchor.protocol is javascript or not /\.github\.com$/.test ".#{anchor.hostname}"
    anchor.href = "#"
    anchor.target = "_self"

  if ///
    ^https?://(
      (gist\.)?github\.com/[^/?#]+/[^/?#]+/archive/ |
      github\.com/[^/?#]+/[^/?#]+/releases/download/ |
      codeload\.github\.com/
    )
  ///.test anchor.href
    anchor.target = "_top"

  anchor

renderButton = (config) ->
  a = createAnchor config.href, null
  a.className = "button"
  a.setAttribute "aria-label", ariaLabel if ariaLabel = config["aria-label"]
  i = a.appendChild createElement "i"
  i.className = "#{ICON_CLASS} #{config["data-icon"] or ICON_CLASS_DEFAULT}"
  i.setAttribute "aria-hidden", "true"
  a.appendChild createTextNode " "
  span = a.appendChild createElement "span"
  span.appendChild createTextNode config["data-text"] or ""
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

  jsonp GITHUB_API_BASEURL + api, (json) ->
    if json.meta.status is 200
      data = json.data[property]

      a = createAnchor href, button.href
      a.className = "count"
      a.setAttribute "aria-label", "#{data} #{property.replace(/_count$/, "").replace("_", " ")} on GitHub"
      a.appendChild createElement "b"
      a.appendChild createElement "i"
      span = a.appendChild createElement "span"
      span.appendChild createTextNode "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
      button.parentNode.insertBefore a, button.nextSibling
    return
  return

renderFrameContent = (config) ->
  return unless config
  document.body.className = "large" if /^large$/i.test config["data-size"]
  button = renderButton config
  renderCount button if /^(true|1)$/i.test config["data-show-count"]
  return



render = (targetNode, config) ->
  return renderAll() unless targetNode?
  config = parseConfig targetNode unless config?

  hash = "#" + stringifyQueryString config

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
    iframe.src = "#{BASEURL}buttons.html#{hash}"
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
    <!DOCTYPE html><html><head><meta charset="utf-8"><title>#{UUID}</title><base><!--[if lte IE 6]></base><![endif]--><link rel="stylesheet" href="#{BASEURL}assets/css/buttons.css"><script>document.location.hash = "#{hash}";</script></head><body><script src="#{BASEURL}buttons.js"></script></body></html>
    """
  contentDocument.close()
  return

renderAll = ->
  anchors = []
  if document.querySelectorAll
    anchors = anchors.slice.call document.querySelectorAll "a.#{BUTTON_CLASS}"
  else
    for anchor in document.getElementsByTagName "a"
      if ~" #{anchor.className} ".replace(/[ \t\n\f\r]+/g, " ").indexOf(" #{BUTTON_CLASS} ")
        anchors.push anchor
  render anchor for anchor in anchors
  return



if typeof define is "function" and define.amd
  define [], { render: render }
else if typeof exports is "object" and typeof exports.nodeName isnt "string"
  exports.render = render
else
  if not {}.hasOwnProperty.call(document, "currentScript") and delete document.currentScript and document.currentScript
    BASEURL = document.currentScript.src.replace /[^/]*([?#].*)?$/, ""
  if document.title is UUID
    renderFrameContent parseQueryString document.location.hash.replace /^#/, ""
  else
    defer render
