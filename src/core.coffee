class EventTarget
  constructor: (@$) ->

  on: (events..., func) ->
    callback = (event) =>
      func.call @, event || window.event
    addEventListener @$, eventName, callback for eventName in events
    return

  once: (events..., func) ->
    callback = (event) =>
      removeEventListener @$, eventName, callback for eventName in events
      func.call @, event || window.event
    addEventListener @$, eventName, callback for eventName in events
    return

  addEventListener = (element, event, func) ->
    if element.addEventListener
      element.addEventListener "#{event}", func
    else
      element.attachEvent "on#{event}", func
    return

  removeEventListener = (element, event, func) ->
    if element.removeEventListener
      element.removeEventListener "#{event}", func
    else
      element.detachEvent "on#{event}", func
    return


class Element extends EventTarget
  constructor: (element, callback) ->
    @$ = if element and element.nodeType is 1 then element else document.createElement element
    callback.call @, @$ if callback

  addClass: (className) ->
    addClass @$, className unless hasClass @$, className
    return

  removeClass: (className) ->
    removeClass @$, className if hasClass @$, className
    return

  hasClass: (className) ->
    hasClass @$, className

  addClass = (element, className) ->
    element.className += " #{className}"
    return

  removeClass = (element, className) ->
    element.className = " #{element.className} "
      .replace r_whitespace, " "
      .replace " #{className} ", ""
      .replace /^ | $/, ""
    return

  hasClass = (element, className) ->
    " #{element.className} ".replace(r_whitespace, " ").indexOf(" #{className} ") >= 0

  r_whitespace = /[ \t\n\f\r]+/g


class Frame extends Element
  constructor: (callback) ->
    super "iframe", (iframe) ->
      iframe.setAttribute key, value for key, value of {
        allowtransparency: true
        scrolling: "no"
        frameBorder: 0
      }
      iframe.style[key] = value for key, value of {
        border: "none"
        height: "0"
        width: "1px"
      }
      callback.call @, iframe if callback
      return

  html: (html) ->
    try
      contentDocument = @$.contentWindow.document
      contentDocument.open()
      contentDocument.write html
      contentDocument.close()
    return

  load: (src) ->
    @$.src = src
    return

  size: ->
    try
      contentDocument = @$.contentWindow.document
      html = contentDocument.documentElement
      body = contentDocument.body
      width = Math.max html.scrollWidth, body.scrollWidth
      height = Math.max html.scrollHeight, body.scrollHeight
      if body.getBoundingClientRect
        body.style.display = "inline-block"
        boundingClientRect = body.getBoundingClientRect()
        width = Math.max width, roundPixel boundingClientRect.width or boundingClientRect.right - boundingClientRect.left
        height = Math.max height, roundPixel boundingClientRect.height or boundingClientRect.bottom - boundingClientRect.top
        body.style.display = ""

      width: "#{width}px"
      height: "#{height}px"

  resize: ({width, height} = @size() or {}) ->
    @$.style.width = width if width
    @$.style.height = height if height
    return

  devicePixelRatio = window.devicePixelRatio or 1

  roundPixel = (px) ->
    if devicePixelRatio > 1
      Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 or 0
    else
      Math.ceil(px) or 0


class ButtonAnchor
  @parse: (element) ->
    href: element.href
    text: element.getAttribute("data-text") or element.textContent or element.innerText or ""
    data:
      count:
        api: element.getAttribute("data-count-api") or ""
        href: element.getAttribute("data-count-href") or element.href
        aria:
          label: element.getAttribute("data-count-aria-label") or ""
      style: element.getAttribute("data-style") or ""
      icon: element.getAttribute("data-icon") or ""
    aria:
      label: element.getAttribute("aria-label") or ""


class ButtonFrame extends Frame
  constructor: (hash, callback, onload) ->
    super callback

    reload = =>
      size = @size()
      @once "load", ->
        @resize size
        onload.call @, @$ if onload
        return
      @load "#{Config.url}buttons.html#{hash}"
      return

    @once "load", ->
      if callback = @$.contentWindow.callback
        new Element callback.script, (script) ->
          @on "load", "error", reload

          if script.readyState
            @on "readystatechange", ->
              reload() unless /i/.test script.readyState
              return
          return
      else
        reload()
      return

    @html \
      """
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="utf-8">
      <title></title>
      <link rel="stylesheet" href="#{Config.url}assets/css/buttons.css">
      <script>document.location.hash = "#{hash}";</script>
      </head>
      <body>
      <script src="#{Config.script.src}"></script>
      </body>
      </html>
      """


class ButtonFrameContent
  constructor: (options) ->
    if options and options.data
      document.body.className = options.data.style or ""

      new Anchor options.href, null, (a) ->
        a.className = "button"
        a.setAttribute "aria-label", options.aria.label if options.aria.label
        new Element "i", (icon) ->
          icon.className = (options.data.icon or Config.icon) + if Config.iconClass then " #{Config.iconClass}" else ""
          icon.setAttribute "aria-hidden", "true"
          a.appendChild icon
          return

        a.appendChild document.createTextNode " "

        new Element "span", (text) ->
          text.appendChild document.createTextNode options.text if options.text
          a.appendChild text
          return
        document.body.appendChild a
        return

      do (options = options.data.count, baseUrl = options.href) ->
        if options and options.api
          new Anchor options.href, baseUrl, (a) ->
            a.className = "count"
            new Element "b", (b) ->
              a.appendChild b
              return
            new Element "i", (i) ->
              a.appendChild i
              return
            new Element "span", (span) ->
              a.appendChild span

              endpoint = do ->
                url = options.api.replace(/^(?!\/)/, "/").split("#")[0]
                query = QueryString.parse url.split("?")[1..].join("?")
                query.callback = "callback"
                "#{url.split("?")[0]}?#{QueryString.stringify query}"

              new Element "script", (script) ->
                script.async = true
                script.src = "#{Config.api}#{endpoint}"

                window.callback = (json) ->
                  window.callback = null

                  if json.meta.status is 200
                    data = FlatObject.flatten(json.data)[options.api.split("#")[1..].join("#")]
                    if "[object Number]" is Object::toString.call data
                      data = "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
                    span.appendChild document.createTextNode data
                    a.setAttribute "aria-label", options.aria.label.replace "#", data if options.aria.label
                    document.body.appendChild a
                  return
                window.callback.script = script

                @on "error", ->
                  window.callback = null
                  return

                if script.readyState
                  @on "readystatechange", ->
                    window.callback = null if script.readyState is "loaded" and script.children and script.readyState is "loading"
                    return

                head = document.getElementsByTagName("head")[0]
                head.insertBefore script, head.firstChild
                return
              return
            return
        return


  class Anchor extends Element
    constructor: (urlString, baseURLstring, callback) ->
      super "a", (a) ->
        if base
          if (a.href = baseURLstring) and !r_javascript.test a.href
            try
              a.href = new URL(urlString, baseURLstring).href
            catch
              base.href = baseURLstring
              a.href = urlString
              container = document.createElement "div"
              container.innerHTML = a.outerHTML
              a.href = container.firstChild.href
              container = null
              base.href = document.location.href
              base.removeAttribute "href"
          else
            a.href = urlString
          if r_javascript.test a.href
            a.href = "#"
            a.target = "_self"
        callback a
        return

    base = document.getElementsByTagName("base")[0]
    r_javascript = /^javascript:/i
