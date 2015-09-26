class Element
  constructor: (element, callback) ->
    @$ = if element and element.nodeType is 1 then element else document.createElement element
    callback.call @, @$ if callback

  get: -> @$

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

  addClass: (className) ->
    addClass @$, className unless hasClass @$, className
    return

  removeClass: (className) ->
    removeClass @$, className if hasClass @$, className
    return

  hasClass: (className) ->
    hasClass @$, className

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

  r_whitespace = /[ \t\n\f\r]+/g

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
      html.style.overflow = body.style.overflow = if window.opera then "scroll" else "visible"
      width = body.scrollWidth
      height = body.scrollHeight
      if body.getBoundingClientRect
        body.style.display = "inline-block"
        boundingClientRect = body.getBoundingClientRect()
        width = Math.max width, roundPixel boundingClientRect.width
        height = Math.max height, roundPixel boundingClientRect.height
        body.style.display = ""
      html.style.overflow = body.style.overflow = ""

      width: "#{width}px"
      height: "#{height}px"
    catch
      {}

  resize: ({width, height} = @size()) ->
    @$.style.width = width if width
    @$.style.height = height if height

  devicePixelRatio = window.devicePixelRatio or 1

  roundPixel = (px) ->
    if devicePixelRatio > 1
      Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 or 0
    else
      Math.ceil px


class ButtonAnchor
  @parse: (element) ->
    href: filter_js element.href
    text: element.getAttribute("data-text") or element.textContent or element.innerText or ""
    data:
      count:
        api:
          if (api = element.getAttribute "data-count-api") and (~api.indexOf "#")
            api.replace /^(?!\/)/, "/"
        href:
          (filter_js element.getAttribute "data-count-href") or (filter_js element.href)
        aria:
          label:
            label if label = element.getAttribute "data-count-aria-label"
      style:
        style if style = element.getAttribute "data-style"
      icon:
        icon if icon = element.getAttribute "data-icon"
    aria:
      label:
        label if label = element.getAttribute "aria-label"


  filter_js = (href) ->
    if /^\s*javascript:/i.test href
      ""
    else
      href


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
        script = callback.script
        if script.readyState
          new Element script
            .on "readystatechange", ->
              reload() if /loaded|complete/.test script.readyState
              return
        else
          new Element script
            .on "load", "error", ->
              reload()
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
      <base target="_blank"><!--[if lte IE 6]></base><![endif]-->
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
      document.body.className = (do -> return style for style in Config.styles when style is options.data.style) or Config.styles[0]
      document.getElementsByTagName("base")[0].href = options.href if options.href
      new Button options, (buttonElement) ->
        document.body.appendChild buttonElement
        return
      new Count options.data.count, (countElement) ->
        document.body.appendChild countElement
        return

  class Button extends Element
    constructor: (options, callback) ->
      super "a", (a) ->
        a.className = "button"
        a.href = options.href if options.href
        a.setAttribute "aria-label", options.aria.label if options.aria.label
        new Element "i", (icon) ->
          icon = document.createElement "i"
          icon.className = (options.data.icon or Config.icon) + if Config.iconClass then " #{Config.iconClass}" else ""
          icon.setAttribute "aria-hidden", "true"
          a.appendChild icon
          return
        new Element "span", (text) ->
          text.appendChild document.createTextNode " "
          a.appendChild text
          return
        new Element "span", (text) ->
          text.appendChild document.createTextNode options.text if options.text
          a.appendChild text
          return
        callback a if callback
        return

  class Count extends Element
    constructor: (options, callback) ->
      if options and options.api
        super "a", (a) ->
          a.className = "count"
          a.href = options.href if options.href
          new Element "b", (b) ->
            a.appendChild b
            return
          new Element "i", (i) ->
            a.appendChild i
            return
          new Element "span", (span) ->
            a.appendChild span

            endpoint = do ->
              url = options.api.split("#")[0]
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
                  span.appendChild document.createTextNode " #{data} "
                  a.setAttribute "aria-label", options.aria.label.replace "#", data if options.aria.label
                  callback a if callback
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
