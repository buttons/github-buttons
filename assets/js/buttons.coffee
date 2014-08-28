Config =
  api:         "https://api.github.com"
  buttonClass: "github-button"
  iconClass:   "octicon"
  icon:        "octicon-mark-github"
  scriptId:    "github-bjs"
  styles:     ["default", "mega"]
if (Config.script = document.getElementById Config.scriptId)
  Config.url = Config.script.src.replace /buttons.js$/, ""

class QueryString
  @stringify: (obj) ->
    results = []
    for key, value of obj
      value ?= ""
      results.push "#{encodeURIComponent key}=#{encodeURIComponent value}"
    results.join "&"
  @parse: (str) ->
    obj = {}
    for pair in str.split "&"
      [key, value...] = pair.split "="
      obj[decodeURIComponent key] = decodeURIComponent value.join "="
    obj

class Iframe
  on: (event, func) ->
    if @iframe.addEventListener
      @iframe.addEventListener "#{event}", func
    else if @iframe.attachEvent
      @iframe.attachEvent "on#{event}", func
    @

  once: (event, func) ->
    once = =>
      if @iframe.removeEventListener
        @iframe.removeEventListener "#{event}", once
      else if @iframe.detachEvent
        @iframe.detachEvent "on#{event}", once
      func()
      return
    @on event, once

  constructor: (callback) ->
    @iframe = document.createElement "iframe"
    @iframe.setAttribute key, value for key, value of {
      allowtransparency: true
      scrolling: "no"
      frameBorder: 0
    }
    @iframe.style[key] = value for key, value of {
      border: "none"
      height: "0"
      width: "1px"
    }
    callback @iframe if callback

class Button

  parseAnchor: (a) ->
    protocolPattern = /^([a-z0-9.+-]+:)/i
    filter_js = (href) ->
      protocol = protocolPattern.exec href
      if protocol and protocol[0].toLowerCase() is "javascript:"
        ""
      else
        href

    countApi: do ->
      api = a.getAttribute "data-count-api"
      if api
        api = "/#{api}" if "/" isnt api.charAt 0
        api
      else
        null
    countHref: do ->
      href = a.getAttribute "data-count-href"
      if href and (href = filter_js href)
        href
      else
        filter_js a.href
    href: do ->
      filter_js a.href
    style: do ->
      if (style = a.getAttribute "data-style")
        for i in Config.styles
          if i is style
            return style
      Config.styles[0]
    text: a.getAttribute("data-text") or a.textContent or a.innerText
    icon: a.getAttribute("data-icon") or Config.icon

  hash: (data) ->
    "#" + encodeURIComponent QueryString.stringify data

  parseHash: ->
    QueryString.parse decodeURIComponent document.location.hash.replace /^#/, ""

  html: ->
    """
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="utf-8">
    <title></title>
    <base target="_blank"><!--[if lte IE 6]></base><![endif]-->
    <link rel="stylesheet" href="#{Config.url}assets/css/buttons.css">
    <style>html{visibility:hidden;}</style>
    <script>document.location.hash = "#{@hash @data}";</script>
    </head>
    <body>
    <script src="#{Config.script.src}"></script>
    </body>
    </html>
    """

  constructor: (a) ->
    if a
      @data = @parseAnchor a
      @iframe = new Iframe (iframe) ->
        a.parentNode.insertBefore iframe, a
        return
      @iframe.once "load", =>
        iframe = @iframe.iframe
        html = iframe.contentWindow.document.documentElement
        body = iframe.contentWindow.document.body
        html.style.overflow = body.style.overflow = "visible"
        style =
          height: "#{body.scrollHeight}px"
          width:  "#{body.scrollWidth}px"
        html.style.overflow = body.style.overflow = ""
        @iframe.once "load", ->
          a.parentNode.removeChild a
          a = null
          iframe.style[key] = value for key, value of style
          return
        iframe.src = "#{Config.url}buttons.html#{@hash @data}"
        return
      @iframe.iframe.contentWindow.document.open()
      @iframe.iframe.contentWindow.document.write @html()
      @iframe.iframe.contentWindow.document.close()
    else
      @data = @parseHash()
      document.body.className = @data.style
      document.getElementsByTagName("base")[0].href = @data.href
      new ButtonElement @data, (buttonElement) ->
        document.body.appendChild buttonElement
        return
      new CountElement @data, (countElement) ->
        document.body.appendChild countElement
        return

class ButtonElement
  constructor: (@data, callback) ->
    icon = document.createElement "i"
    icon.className = do ->
      classNames = [data.icon]
      classNames.push Config.iconClass if Config.iconClass?
      classNames.join " "
    text = document.createElement "span"
    text.appendChild document.createTextNode " #{data.text} " if data.text

    @a = document.createElement "a"
    @a.className = "button"
    @a.href = data.href if data.href
    @a.appendChild icon
    @a.appendChild text

    callback @a if callback

class CountElement
  json: (json) ->
    window.callback = null
    @script.parentNode.removeChild @script
    @script = null

    if json.meta.status is 200
      for i in @data.countApi.split("#").slice(1).join("#").split(".")
        json.data = json.data[i]
      if !(isNaN parseFloat json.data) and (isFinite json.data)
        json.data = json.data.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","
      text = document.createElement "span"
      text.appendChild document.createTextNode " #{json.data} "
      @a.appendChild text
      @callback @a if @callback
    return

  constructor: (@data, @callback) ->
    if data.countApi
      @a = document.createElement("a")
      @a.className = "count"
      @a.href = data.countHref if data.countHref
      @a.appendChild document.createElement "b"
      @a.appendChild document.createElement "i"

      window.callback = (json) =>
        @json json

      api = do ->
        url = data.countApi.split("#")[0]
        query = QueryString.parse url.split("?").slice(1).join("?")
        query.callback = "callback"
        "#{url.split("?")[0]}?#{QueryString.stringify query}"

      @script = document.createElement "script"
      @script.async = true
      @script.src = "#{Config.api}#{api}"
      s = document.getElementsByTagName("script")[0]
      s.parentNode.insertBefore @script, s
    return

if Config.script
  if document.querySelectorAll
    links = document.querySelectorAll "a.#{Config.buttonClass}"
  else
    links = do ->
      links = []
      for link in document.getElementsByTagName "a"
        links.push link if ~(" #{link.className} ").replace(/[\t\r\n\f]/g, " ").indexOf " #{Config.buttonClass} "
      links
  for link in links
    new Button link
else
  new Button
