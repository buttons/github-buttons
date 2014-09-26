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
    else if element.attachEvent
      element.attachEvent "on#{event}", func
    return

  removeEventListener = (element, event, func) ->
    if element.removeEventListener
      element.removeEventListener "#{event}", func
    else if element.detachEvent
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
            classNames.push Config.iconClass if Config.iconClass
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



###
Main
###



class UIElement extends Element
  constructor: (@element) ->



class Form extends Element
  constructor: (@element, callback) ->
    if callback
      onchange = =>
        callback @serialize()
        return
      for element in @element.elements
        @on.call element: element, "change", onchange
        @on.call element: element, "input", onchange if element.type is "text"

  serialize: ->
    data = {}
    for node in @element.elements when node.name
      switch node.type
        when "radio", "checkbox"
          data[node.name] = node.value if node.checked
        else
          data[node.name] = node.value
    data

  parse: ->
    Form.parse @serialize()

  @parse: (options)->
    {type, user, repo} = options
    config =
      className: "github-button"
      href:
        switch type
          when "follow"
            "https://github.com/#{user}"
          when "watch", "star", "fork"
            "https://github.com/#{user}/#{repo}"
          when "issue"
            "https://github.com/#{user}/#{repo}/issues"
          when "download"
            "https://github.com/#{user}/#{repo}/archive/master.zip"
          else
            "https://github.com/"
      text:
        switch type
          when "follow"
            "Follow @#{user}"
          else
            type.charAt(0).toUpperCase() + type.slice(1).toLowerCase()
      data:
        icon:
          switch type
            when "watch"
              "octicon-eye"
            when "star"
              "octicon-star"
            when "fork"
              "octicon-git-branch"
            when "issue"
              "octicon-issue-opened"
            when "download"
              "octicon-cloud-download"
            else
              "octicon-mark-github"

    if options["large-button"]?
      config.data.style = "mega"

    if options["show-count"]?
      switch type
        when "follow"
          config.data["count-href"] = "/#{user}/followers"
          config.data["count-api"] = "/users/#{user}#followers"
        when "watch"
          config.data["count-href"] = "/#{user}/#{repo}/watchers"
          config.data["count-api"] = "/repos/#{user}/#{repo}#subscribers_count"
        when "star"
          config.data["count-href"] = "/#{user}/#{repo}/stargazers"
          config.data["count-api"] = "/repos/#{user}/#{repo}#stargazers_count"
        when "fork"
          config.data["count-href"] = "/#{user}/#{repo}/network"
          config.data["count-api"] = "/repos/#{user}/#{repo}#forks_count"
        when "issue"
          config.data["count-api"] = "/repos/#{user}/#{repo}#open_issues_count"

    if options["standard-icon"]? or config.data.icon is "octicon-mark-github"
      delete config.data.icon

    config



class Frame extends Element
  constructor: (@element) ->
    @on "load", =>
      for a in @element.contentWindow.document.getElementsByTagName "a"
        @on.call element: a, "click", (event) ->
          event.preventDefault()
          false
      @on.call element: @element.contentWindow.document.body, "click", =>
        @element.parentNode.click()
        return
      return



class PreviewAnchor extends Element
  constructor: ({href, text, data}, callback) ->
    super "a", (a) ->
      a.className = Config.anchorClass
      a.href = href
      a.appendChild document.createTextNode "#{text}"
      a.setAttribute "data-#{name}", value for name, value of data
      callback a if callback
      return



class PreviewFrame extends Element
  constructor: (@element) ->
    @on "load", =>
      contentDocument = @element.contentWindow.document
      html = contentDocument.documentElement
      body = contentDocument.body
      html.style.overflow = body.style.overflow = "visible"
      style =
        height: "#{body.scrollHeight}px"
        width:  "#{body.scrollWidth}px"
      html.style.overflow = body.style.overflow = ""
      @element.style[key] = value for key, value of style
      return

  load: (config) ->
    @element.parentNode.style.height = "#{(if config.data.style is "mega" then 28 else 20) + 2}px"
    style =
      height: "0"
      width: "1px"
    @element.style[key] = value for key, value of style
    @element.src = "buttons.html#{Hash.encode config}"
    @element.contentWindow.document.location.reload()
    return



class PreviewButton extends Element
  constructor: (@element, @ui) ->
    @on "click", =>
      event.preventDefault()
      @preview()
      false

  preview: (config = @ui.form.parse(), no_count = false) ->
    new PreviewAnchor config, (a) =>
      @ui.code.element.value = \
        """
        <!-- Place this tag where you want the button to render. -->
        #{a.outerHTML}
        """
      a.removeAttribute("data-count-api") if no_count
      @ui.preview_frame.load Anchor.parse a
      a = null
      return
    return



class Code extends Element
  constructor: (@element) ->
    @on "focus", =>
      @element.select()
      return
    @on "click", =>
      @element.select()
      return
    @on "mouseup", ->
      event.preventDefault()
      false



class Snippet extends Code
  constructor: ->
    super
    @element.value = \
      """
      <!-- Place this tag right after the last button or just before your close body tag. -->
      <script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
      """



class UI
  constructor: ->
    for iframe in document.getElementsByTagName "iframe"
      if iframe.parentNode.id is "preview"
        @preview_frame = new PreviewFrame iframe
      else
        new Frame iframe
    @content = new UIElement document.getElementById "content"
    @form = new Form document.getElementById("button-config"), (options) =>
      if options.type
        for name in ["repo", "standard-icon"]
          @form.element.elements[name].disabled = options.type is "follow"

        for name in ["show-count"]
          @form.element.elements[name].disabled = options.type is "download"

        if options["show-count"]? and options.type isnt "download"
          @preview_button.removeClass "hidden"
        else
          @preview_button.addClass "hidden"

        unless (!options.user or /^[a-z0-9][a-z0-9-]*$/i.test options.user) and (options.type is "follow" or !options.repo or (/^[\w.-]+$/.test(options.repo) and not /^\.\.?$/.test(options.repo)))
          @user_repo.addClass "has-error"
        else
          @user_repo.removeClass "has-error"
          if options.user is "" or (options.type isnt "follow" and options.repo is "")
            @user_repo.addClass "has-warning"
          else
            @user_repo.removeClass "has-warning"

        if (@user_repo.hasClass "has-error") or (@user_repo.hasClass "has-warning")
          options.user = "ntkme"
          options.repo = "github-buttons"
          @preview_button.addClass "hidden"
          @preview_button.preview Form.parse(options)
        else
          @preview_button.preview Form.parse(options), true

        @content.removeClass "hidden"
      return
    @user_repo = new UIElement document.getElementById "user-repo"
    @preview_button = new PreviewButton document.getElementById("preview-button"), @
    @code = new Code document.getElementById "code"
    @snippet = new Snippet document.getElementById "snippet"

new UI()



@onbeforeunload = ->
