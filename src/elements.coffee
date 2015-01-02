class Element
  constructor: (element, callback) ->
    @$ = if element and element.nodeType is 1 then element else document.createElement element
    callback.apply @, [@$] if callback

  get: -> @$

  on: (events..., func) ->
    callback = (event) =>
      func.apply @, [event || window.event]
    addEventListener @$, eventName, callback for eventName in events
    return

  once: (events..., func) ->
    callback = (event) =>
      removeEventListener @$, eventName, callback for eventName in events
      func.apply @, [event || window.event]
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
  r_leading_and_trailing_whitespace = /^[ \t\n\f\r]+|[ \t\n\f\r]+$/g

  addClass = (element, className) ->
    element.className += " #{className}"
    return

  removeClass = (element, className) ->
    element.className = " #{element.className} "
      .replace r_whitespace, " "
      .replace " #{className} ", ""
      .replace r_leading_and_trailing_whitespace, ""
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
      callback.apply @, [iframe] if callback
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

  size: ->
    try
      contentDocument = @$.contentWindow.document
      html = contentDocument.documentElement
      body = contentDocument.body
      html.style.overflow = body.style.overflow = if window.opera then "scroll" else "visible"
      size =
        width:  "#{body.scrollWidth}px"
        height: "#{body.scrollHeight}px"
      html.style.overflow = body.style.overflow = ""
      size
    catch
      {}

  resize: ({width, height} = @size()) ->
    @$.style.width = width if width
    @$.style.height = height if height


class ButtonAnchor
  @parse: (element) ->
    href: filter_js element.href
    text: element.getAttribute("data-text") or element.textContent or element.innerText
    data:
      count:
        api: do ->
          if api = element.getAttribute "data-count-api"
            api = "/#{api}" if "/" isnt api.charAt 0
            api
        href: do ->
          if (href = element.getAttribute "data-count-href") and (href = filter_js href)
            href
          else
            filter_js element.href
      style: do ->
        if style = element.getAttribute "data-style"
          for i in Config.styles
            if i is style
              return style
        Config.styles[0]
      icon: do ->
        if icon = element.getAttribute "data-icon"
          icon

  filter_js = (href) -> href unless /^\s*javascript:/i.test href


class ButtonFrame extends Frame
  constructor: (hash, callbacks...) ->
    super callbacks.shift()

    reload = =>
      size = @size()
      @once "load", ->
        @resize size
        callbacks.shift() @$ if callbacks[0]
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
      <style>html{visibility:hidden;}</style>
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
      document.body.className = options.data.style
      document.getElementsByTagName("base")[0].href = options.href
      new Button options, (buttonElement) ->
        document.body.appendChild buttonElement
        return
      new Count options, (countElement) ->
        document.body.appendChild countElement
        return

  class Button extends Element
    constructor: (options, callback) ->
      super "a", (a) ->
        a.className = "button"
        a.href = options.href if options.href
        new Element "i", (icon) ->
          icon = document.createElement "i"
          icon.className = do ->
            classNames = [options.data.icon or Config.icon]
            classNames.push Config.iconClass if Config.iconClass
            classNames.join " "
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
      if options.data.count.api
        super "a", (a) ->
          a.className = "count"
          a.href = options.data.count.href if options.data.count.href
          new Element "b", (b) ->
            a.appendChild b
            return
          new Element "i", (i) ->
            a.appendChild i
            return
          new Element "span", (text) ->
            a.appendChild text

            endpoint = do ->
              url = options.data.count.api.split("#")[0]
              query = QueryString.parse url.split("?").slice(1).join("?")
              query.callback = "callback"
              "#{url.split("?")[0]}?#{QueryString.stringify query}"

            new Element "script", (script) ->
              script.async = true
              script.src = "#{Config.api}#{endpoint}"

              window.callback = (json) ->
                window.callback = null

                if json.meta.status is 200
                  data = FlatObject.flatten(json.data)[options.data.count.api.split("#").slice(1).join("#")]
                  if Object.prototype.toString.call(data) is "[object Number]"
                    data = data.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","
                  text.appendChild document.createTextNode " #{data} "
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
