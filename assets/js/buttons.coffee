class FlatObject
  @flatten: (obj) ->
    flatten = (object, super_key) ->
      switch __toString.call(object)
        when "[object Object]"
          for key, value of object
            flatten value, if super_key then "#{super_key}.#{key}" else key
        when "[object Array]"
          for item, index in object
            flatten item, if super_key then "#{super_key}[#{index}]" else "[#{index}]"
        else
          result[super_key] = object
      return
    result = {}
    flatten obj
    result

  @expand: (obj) ->
    namespace = {}
    for flat_key, value of obj
      keys = []
      for key in flat_key.split "."
        match = key.match /^(.*?)((?:\[[0-9]+\])*)$/
        keys.push match[1] if match[1]
        keys.push Number sub_key for sub_key in match[2].replace(/^\[|\]$/g, "").split("][") if match[2]
      target = namespace
      key = "result"
      while keys.length
        unless target[key]?
          switch __toString.call(keys[0])
            when "[object String]"
              target[key] = {}
            when "[object Number]"
              target[key] = []
        target = target[key]
        key = keys.shift()
      target[key] = value
    namespace.result

  __toString = Object.prototype.toString



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
    "#" + encodeURIComponent QueryString.stringify FlatObject.flatten data

  @decode: (data = document.location.hash) ->
    FlatObject.expand QueryString.parse decodeURIComponent data.replace /^#/, ""



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



class Anchor extends Element
  constructor: ({href, text, data}, callback) ->
    super "a", (a) ->
      a.className = Config.anchorClass
      a.href = href
      a.appendChild document.createTextNode "#{text}"
      a.setAttribute "data-#{name}", value for name, value of data
      callback a if callback
      return

  parse: ->
    Anchor.parse @element

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
          return
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
  constructor: (options) ->
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
            classNames.push Config.iconClass if Config.iconClass?
            classNames.join " "
          a.appendChild icon
          return
        new Element "span", (text) ->
          text.appendChild document.createTextNode " #{options.text} " if options.text
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

            window.callback = (json) ->
              window.callback = null

              if json.meta.status is 200
                data = FlatObject.flatten(json.data)[options.data.count.api.split("#").slice(1).join("#")]
                if Object.prototype.toString.call(data) is "[object Number]"
                  data = data.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","
                text.appendChild document.createTextNode " #{data} "
                callback a if callback
              return
            return
          return

        endpoint = do ->
          url = options.data.count.api.split("#")[0]
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
  anchorClass: "github-button"
  iconClass:   "octicon"
  icon:        "octicon-mark-github"
  scriptId:    "github-bjs"
  styles:     ["default", "mega"]

if Config.script = document.getElementById Config.scriptId
  Config.url = Config.script.src.replace /buttons.js$/, ""

  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{Config.anchorClass}"
  else
    anchors =
      anchor for anchor in document.getElementsByTagName "a" when " #{anchor.className} ".replace(/[\t\r\n\f]/g, " ").indexOf " #{Config.anchorClass} " >= 0

  for anchor in anchors
    do (a = anchor) ->
      new Frame Hash.encode(Anchor.parse a), (iframe) ->
        a.parentNode.insertBefore iframe, a
        return
      , ->
        a.parentNode.removeChild a
        return
      return
else
  new FrameContent Hash.decode()
