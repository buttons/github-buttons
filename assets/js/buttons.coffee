Config =
  api:         "https://api.github.com"
  anchorClass: "github-button"
  iconClass:   "octicon"
  icon:        "octicon-mark-github"
  scriptId:    "github-bjs"
  styles:     ["default", "mega"]

if Config.script = document.getElementById Config.scriptId
  Config.url = Config.script.src.replace /buttons.js$/, ""



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
    namespace = []
    for flat_key, value of obj
      keys = []
      for key in flat_key.split "."
        match = key.match /^(.*?)((?:\[[0-9]+\])*)$/
        keys.push match[1] if match[1]
        keys.push Number sub_key for sub_key in match[2].replace(/^\[|\]$/g, "").split("][") if match[2]
      target = namespace
      key = 0
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
    namespace[0]

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
    addEventListener @element, event, func
    return

  once: (event, func) ->
    once = =>
      removeEventListener @element, event, once
      func()
      return
    addEventListener @element, event, once
    return

  addClass: (className) ->
    addClass @element, className unless hasClass @element, className
    return

  removeClass: (className) ->
    removeClass @element, className if hasClass @element, className
    return

  hasClass: (className) ->
    hasClass @element, className

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



class Anchor
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
      if @element.contentWindow.callback
        script = @element.contentWindow.document.getElementsByTagName("script")[0]
        if script.readyState
          @on.call element: script, "readystatechange", =>
            @reload() if /loaded|complete/.test script.readyState
            return
        else
          for event in ["load", "error"]
            @on.call element: script, event, =>
              @reload()
              return
      else
        @reload()
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

              Element.prototype.on.call element: script, "error", ->
                window.callback = null
                return

              if script.readyState
                Element.prototype.on.call element: script, "readystatechange", ->
                  window.callback = null if script.readyState is "loaded" and script.children and script.readyState is "loading"
                  return

              head = document.getElementsByTagName("head")[0]
              head.insertBefore script, head.firstChild
              return
            return
          return



if Config.script
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{Config.anchorClass}"
  else
    anchors =
      anchor for anchor in document.getElementsByTagName "a" when Element.prototype.hasClass.call element: anchor, Config.anchorClass

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
