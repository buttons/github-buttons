class QueryString
  @stringify: (obj) ->
    results = []
    for key, value of obj
      value ?= ""
      results.push "#{key}=#{value}"
    results.join "&"

  @parse: (str) ->
    obj = {}
    for pair in str.split "&" when pair isnt ""
      [key, value...] = pair.split "="
      obj[key] = value.join "=" if key isnt ""
    obj



class Hash
  @encode: (data) ->
    "#" + encodeURIComponent QueryString.stringify data

  @decode: (data = document.location.hash) ->
    QueryString.parse decodeURIComponent data.replace /^#/, ""



class Element
  constructor: (tagName, callback) ->
    @element = document.createElement tagName
    callback @element if callback

  on: (event, func) ->
    if @element.addEventListener
      @element.addEventListener "#{event}", func
    else if @element.attachEvent
      @element.attachEvent "on#{event}", func
    @

  once: (event, func) ->
    once = =>
      if @element.removeEventListener
        @element.removeEventListener "#{event}", once
      else if @element.detachEvent
        @element.detachEvent "on#{event}", once
      func()
      return
    @on event, once



class Anchor
  constructor: (@element) ->
    @data =
      countApi: do ->
        if api = element.getAttribute "data-count-api"
          api = "/#{api}" if "/" isnt api.charAt 0
          api
      countHref: do ->
        if (href = element.getAttribute "data-count-href") and (href = filter_js href)
          href
        else
          filter_js element.href
      href: filter_js element.href
      style: do ->
        if style = element.getAttribute "data-style"
          for i in Config.styles
            if i is style
              return style
        Config.styles[0]
      text: element.getAttribute("data-text") or element.textContent or element.innerText
      icon: element.getAttribute("data-icon") or Config.icon

  filter_js = (href) -> href unless /^\s*javascript:/i.test href



class Frame extends Element
  constructor: (@hash, @callback...) ->
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
      callback[0] iframe if callback[0]
      return

    @once "load", =>
      contentDocument = @element.contentWindow.document
      script = contentDocument.getElementsByTagName("script")[0]
      if !script.readyState or /loaded|complete/.test script.readyState
        setTimeout =>
          @reload()
        , 0
      else
        @on.call element: script, "readystatechange", (_, aborted) =>
          if aborted or !script.readyState or /loaded|complete/.test script.readyState
            @reload()
          return
      return

    @element.contentWindow.document.open()
    @element.contentWindow.document.write \
      """
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="utf-8">
      <title></title>
      <base target="_blank"><!--[if lte IE 6]></base><![endif]-->
      <link rel="stylesheet" href="#{Config.url}assets/css/buttons.css">
      <style>html{visibility:hidden;}</style>
      <script>document.location.hash = "#{@hash}";</script>
      </head>
      <body>
      <script src="#{Config.script.src}"></script>
      </body>
      </html>
      """
    @element.contentWindow.document.close()

  reload: ->
    contentDocument = @element.contentWindow.document
    html = contentDocument.documentElement
    body = contentDocument.body
    html.style.overflow = body.style.overflow = "visible"
    style =
      height: "#{body.scrollHeight}px"
      width:  "#{body.scrollWidth}px"
    html.style.overflow = body.style.overflow = ""
    @once "load", =>
      @element.style[key] = value for key, value of style
      @callback[1] @element if @callback[1]
      return
    @element.src = "#{Config.url}buttons.html#{@hash}"
    return



class FrameContent
  constructor: (data) ->
    document.body.className = data.style
    document.getElementsByTagName("base")[0].href = data.href
    new Button data, (buttonElement) ->
      document.body.appendChild buttonElement
      return
    new Count data, (countElement) ->
      document.body.appendChild countElement
      return

  class Button extends Element
    constructor: (data, callback) ->
      super "a", (a) ->
        a.className = "button"
        a.href = data.href if data.href
        new Element "i", (icon) ->
          icon = document.createElement "i"
          icon.className = do ->
            classNames = [data.icon]
            classNames.push Config.iconClass if Config.iconClass?
            classNames.join " "
          a.appendChild icon
          return
        new Element "span", (text) ->
          text.appendChild document.createTextNode " #{data.text} " if data.text
          a.appendChild text
          return
        callback a if callback
        return

  class Count extends Element
    constructor: (data, callback) ->
      if data.countApi
        super "a", (a) ->
          a.className = "count"
          a.href = data.countHref if data.countHref
          new Element "b", (b) ->
            a.appendChild b
            return
          new Element "i", (i) ->
            a.appendChild i
            return
          new Element "span", (text) ->
            a.appendChild text

            window.callback = (json) ->
              window.callback = null

              if json.meta.status is 200
                for i in data.countApi.split("#").slice(1).join("#").split(".")
                  json.data = json.data[i]
                if !(isNaN parseFloat json.data) and (isFinite json.data)
                  json.data = json.data.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","
                text.appendChild document.createTextNode " #{json.data} "
                callback a if callback
              return
            return
          return

        endpoint = do ->
          url = data.countApi.split("#")[0]
          query = QueryString.parse url.split("?").slice(1).join("?")
          query.callback = "callback"
          "#{url.split("?")[0]}?#{QueryString.stringify query}"

        new Element "script", (script) ->
          script.async = true
          script.src = "#{Config.api}#{endpoint}"
          head = document.getElementsByTagName("head")[0]
          head.insertBefore script, head.firstChild
          return



Config =
  api:         "https://api.github.com"
  buttonClass: "github-button"
  iconClass:   "octicon"
  icon:        "octicon-mark-github"
  scriptId:    "github-bjs"
  styles:     ["default", "mega"]

if Config.script = document.getElementById Config.scriptId
  Config.url = Config.script.src.replace /buttons.js$/, ""

  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{Config.buttonClass}"
  else
    anchors =
      anchor for anchor in document.getElementsByTagName "a" when " #{anchor.className} ".replace(/[\t\r\n\f]/g, " ").indexOf " #{Config.buttonClass} " >= 0

  for anchor in anchors
    do (a = anchor) ->
      new Frame Hash.encode(new Anchor(a).data), (iframe) ->
        a.parentNode.insertBefore iframe, a
        return
      , ->
        a.parentNode.removeChild a
        return
      return
else
  new FrameContent Hash.decode()
