class GitHubAPIStatus
  @low_rate_limit = false

  window.callback = (json) ->
    GitHubAPIStatus.rate_limit = json.data
    GitHubAPIStatus.low_rate_limit = GitHubAPIStatus.rate_limit.resources.core.remaining < 16
    return

  @update: ->
    unless window.callback.script
      new Element "script", (script) ->
        script.async = true
        script.src = "https://api.github.com/rate_limit?callback=callback"
        window.callback.script = script
        @on "readystatechange", "load", "error", ->
          if !script.readyState or /loaded|complete/.test script.readyState
            script.parentNode.removeChild script
            window.callback.script = null
          return
        head = document.getElementsByTagName("head")[0]
        head.insertBefore script, head.firstChild
        return
    return

  @update()


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


class Form extends Element
  on: (events..., func) ->
    if events.indexOf("change") >= 0
      callback = (event) =>
        func.call @, event || window.event
      for element in @$.elements
        new Element element
          .on "change", "input", callback
    super

  serialize: ->
    data = {}
    for node in @$.elements when node.name
      switch node.type
        when "radio", "checkbox"
          data[node.name] = node.value if node.checked
        else
          data[node.name] = node.value
    data


class PreviewAnchor extends Element
  constructor: ({href, text, data, aria}, callback) ->
    super "a", (a) ->
      a.className = CONFIG_ANCHOR_CLASS
      a.href = href
      a.appendChild document.createTextNode "#{text}"
      a.setAttribute "data-#{name}", value for name, value of data
      a.setAttribute "aria-#{name}", value for name, value of aria
      callback a if callback
      return


class PreviewFrame extends Frame
  constructor: (preview) ->
    super (iframe) ->
      preview.appendChild iframe
      iframe.src = "buttons.html"
      return
    @on "load", ->
      if callback = @$.contentWindow.callback
        script = callback.script
        if script.readyState
          new Element script
            .on "readystatechange", ->
              @resize() if /loaded|complete/.test script.readyState
              return
        else
          new Element script
            .on "load", "error", ->
              @resize()
              return
      else
        @resize()
      return

  load: (config) ->
    parentNode = @$.parentNode
    parentNode.removeChild @$
    parentNode.style.height = "#{(if config["data-style"] is "mega" then 28 else 20) + 2}px"

    @$.style.width = "1px"
    @$.style.height = "0"
    @$.src = "buttons.html#{Hash.encode config}"

    parentNode.appendChild @$
    return


class Code extends Element
  constructor: ->
    super
    @on "focus", ->
      @$.select()
      return
    @on "click", ->
      @$.select()
      return
    @on "mouseup", (event) ->
      event.preventDefault()
      false


class ButtonForm extends Form
  constructor: (@$, {content, preview: {button, frame, code, warning}, snippet, user_repo}) ->
    @$.setAttribute key, value for key, value of {
      autocapitalize: "none"
      autocomplete: "off"
      autocorrect: "off"
      spellcheck: "false"
    }

    snippet.$.value = \
      """
      <!-- Place this tag in your head or just before your close body tag. -->
      <script async defer src="https://buttons.github.io/buttons.js"></script>
      """

    callback = ({force}) =>
      options = @serialize()

      if options.type
        content.removeClass "hidden"

        for name in ["repo", "standard-icon"]
          @$.elements[name].disabled = options.type is "follow"
        for name in ["show-count"]
          @$.elements[name].disabled = options.type is "download"

        unless (!options.user or validate_user options.user) and (options.type is "follow" or !options.repo or validate_repo options.repo)
          user_repo.addClass "has-error"
        else
          user_repo.removeClass "has-error"
          if options.user is "" or (options.type isnt "follow" and options.repo is "")
            user_repo.addClass "has-warning"
          else
            user_repo.removeClass "has-warning"

        if (user_repo.hasClass "has-error") or (user_repo.hasClass "has-warning")
          options.user = "ntkme"
          options.repo = "github-buttons"

        if @cache isnt (cache = Hash.encode options) or force
          @cache = cache
          new PreviewAnchor @parse(options), (a) =>
            code.$.value = \
              """
              <!-- Place this tag where you want the button to render. -->
              #{a.outerHTML}
              """

            button.addClass "hidden"
            if options["show-count"]? and options.type isnt "download"
              GitHubAPIStatus.update()
              if GitHubAPIStatus.low_rate_limit
                button.removeClass "hidden"
                reset = new Date GitHubAPIStatus.rate_limit.resources.core.reset * 1000
                if !@reset or reset > @reset
                  @reset = reset
                  warning.removeClass "hidden"
                if force
                  warning.addClass "hidden"
                else
                  a.removeAttribute "data-count-api"

            frame.load ButtonAnchor.parse a
            a = null
            return
      return

    button.on "click", (event) ->
      event.preventDefault()
      callback force: true
      false
    @on "change", callback

  parse: (options = @serialize()) ->
    {type, user, repo} = options
    config =
      className: "github-button"
      href:
        switch type
          when "follow"
            "https://github.com/#{user}"
          when "watch"
            "https://github.com/#{user}/#{repo}/subscription"
          when "star"
            "https://github.com/#{user}/#{repo}"
          when "fork"
            "https://github.com/#{user}/#{repo}/fork"
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
            type.charAt(0).toUpperCase() + type[1..].toLowerCase()
      data:
        icon:
          switch type
            when "watch"
              "octicon-eye"
            when "star"
              "octicon-star"
            when "fork"
              "octicon-repo-forked"
            when "issue"
              "octicon-issue-opened"
            when "download"
              "octicon-cloud-download"
            else
              "octicon-mark-github"
      aria:
        label:
          switch type
            when "follow"
              "Follow @#{user} on GitHub"
            when "watch", "star", "fork", "issue", "download"
              "#{type.charAt(0).toUpperCase() + type[1..].toLowerCase()} #{user}/#{repo} on GitHub"
            else
              "GitHub"
    if options["large-button"]?
      config.data.style = "mega"
    if options["show-count"]?
      switch type
        when "follow", "watch", "star", "fork", "issue"
          config.data["show-count"] = "true"
    if options["standard-icon"]? or config.data.icon is "octicon-mark-github"
      delete config.data.icon
    config

  validate_user = (user) ->
    0 < user.length < 40 and not /[^A-Za-z0-9-]|^-|-$|--/i.test user

  validate_repo = (repo) ->
    0 < repo.length < 101 and not /[^\w-.]|\.git$|^\.\.?$/i.test repo


new Deferred ->
  new ButtonForm document.getElementById("button-config"),
    content: new Element document.getElementById "content"
    user_repo: new Element document.getElementById "user-repo"
    preview:
      button: new Element document.getElementById "preview-button"
      frame: new PreviewFrame document.getElementById "preview"
      code: new Code document.getElementById "code"
      warning: new Element document.getElementById "preview-warning"
    snippet: new Code document.getElementById "snippet"
  return

@onbeforeunload = ->
