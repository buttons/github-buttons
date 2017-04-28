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


class Frame extends Element
  constructor: (callback) ->
    super "iframe", (iframe) ->
      iframe.setAttribute key, value for key, value of {
        allowtransparency: true
        scrolling: "no"
        frameBorder: 0
      }
      iframe.style.cssText = "width: 1px; height: 0; border: none"
      iframe.src = "javascript:0"
      callback.call @, iframe if callback
      return

  html: (html) ->
    try
      contentDocument = @$.contentWindow.document
      contentDocument.open().write html
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
      width = html.scrollWidth
      height = html.scrollHeight
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
    (if devicePixelRatio > 1 then Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 else Math.ceil(px)) or 0


class ButtonAnchor
  @parse: (element) ->
    options =
      "href": element.href
      "text": element.getAttribute("data-text") or element.textContent or element.innerText or ""
    options[attribute] = element.getAttribute(attribute) or "" for attribute in [
      "data-show-count"
      "data-style"
      "data-icon"
      "aria-label"
    ]
    if element.getAttribute "data-count-api"
      console and console.warn "GitHub Buttons deprecated `data-count-api`: use `data-show-count` instead. Please refer to https://github.com/ntkme/github-buttons for more info."
      options["data-show-count"] = 1
    options


class ButtonFrame extends Frame
  constructor: (hash, beforeload, callback) ->
    super beforeload

    reload = =>
      reload = null
      size = @size()

      @$.parentNode.removeChild @$
      @once "load", ->
        @resize size
        return

      @load "#{CONFIG_URL}buttons.html#{hash}"
      callback.call @, @$ if callback
      return

    @once "load", ->
      if jsonp_callback = @$.contentWindow.callback
        new Element jsonp_callback.script, (script) ->
          @on "load", "error", ->
            reload() if reload
            return

          if script.readyState
            @on "readystatechange", ->
              reload() if not /i/.test(script.readyState) and reload
              return
          return
      else
        reload()
      return

    @html \
      """
      <!DOCTYPE html><html><head><meta charset="utf-8"><title>#{CONFIG_UUID}</title><base><!--[if lte IE 6]></base><![endif]--><link rel="stylesheet" href="#{CONFIG_URL}assets/css/buttons.css"><script>document.location.hash = "#{hash}";</script></head><body><script src="#{CONFIG_URL}buttons.js"></script></body></html>
      """


class ButtonFrameContent
  constructor: (options) ->
    if options
      document.body.className = options["data-style"] or ""

      new Anchor options.href, null, (a) ->
        a.className = "button"
        a.setAttribute "aria-label", aria_label if aria_label = options["aria-label"]

        new Element "i", (i) ->
          i.className = "#{CONFIG_ICON_CLASS} #{options["data-icon"] or CONFIG_ICON_DEFAULT}"
          i.setAttribute "aria-hidden", "true"
          a.appendChild i
          return

        a.appendChild document.createTextNode " "

        new Element "span", (span) ->
          span.appendChild document.createTextNode options.text if options.text
          a.appendChild span
          return

        document.body.appendChild a

        return unless a.hostname is "github.com" and /^true|1$/i.test options["data-show-count"]

        do ->
          match = a.pathname.replace(/^(?!\/)/, "/").match ///
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
            api = "/repos/#{match[1]}/#{match[2]}"
            href = "/#{match[1]}/#{match[2]}/"
            if match[3]
              property = "subscribers_count"
              href += "watchers"
            else if match[4]
              property = "forks_count"
              href += "network"
            else if match[5]
              property = "open_issues_count"
              href += "issues"
            else
              property = "stargazers_count"
              href += "stargazers"
          else
            api = "/users/#{match[1]}"
            property = "followers"
            href = "/#{match[1]}/#{property}"

          new Anchor href, a.href, (a) ->
            a.className = "count"

            new Element "b", (b) ->
              a.appendChild b
              return

            new Element "i", (i) ->
              a.appendChild i
              return

            new Element "span", (span) ->
              new Element "script", (script) ->
                script.async = true
                script.src = CONFIG_API + do ->
                  query = QueryString.parse api.split("?")[1..].join("?")
                  query.callback = "callback"
                  "#{api.split("?")[0]}?#{QueryString.stringify query}"

                window.callback = (json) ->
                  window.callback = null

                  if json.meta.status is 200
                    data = json.data[property]
                    span.appendChild document.createTextNode "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
                    a.appendChild span
                    a.setAttribute "aria-label", "#{data} #{property.replace(/_count$/, "").replace("_", " ")} on GitHub"
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

                if "[object Opera]" is {}.toString.call window.opera
                  new EventTarget document
                    .on "DOMContentLoaded", ->
                      head.appendChild script
                      return
                else
                  head.appendChild script

                return
              return
            return
          return
        return


  class Anchor extends Element
    constructor: (urlString, baseURLstring, callback) ->
      super "a", (a) ->
        if (a.href = baseURLstring) and a.protocol isnt javascript
          try
            a.href = new URL(urlString, baseURLstring).href
          catch
            base.href = baseURLstring
            a.href = urlString
            new Element "div", (div) ->
              div.innerHTML = a.outerHTML
              a.href = div.lastChild.href
              div = null
              return
            base.href = document.location.href
            base.removeAttribute "href"
        else
          a.href = urlString

        if r_archive.test a.href
          a.target = "_top"
        if a.protocol is javascript or not r_hostname.test ".#{a.hostname}"
          a.href = "#"
          a.target = "_self"

        callback a
        return

    base = document.getElementsByTagName("base")[0]
    javascript = "javascript:"
    r_hostname = /\.github\.com$/
    r_archive = ///
      ^https?://(
        (gist\.)?github\.com/[^/?#]+/[^/?#]+/archive/ |
        github\.com/[^/?#]+/[^/?#]+/releases/download/ |
        codeload\.github\.com/
      )
    ///
