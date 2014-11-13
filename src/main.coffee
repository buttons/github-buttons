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
      if @element.contentWindow.callback
        script = @element.contentWindow.document.getElementsByTagName("script")[0]
        if script.readyState
          @on.call element: script, "readystatechange", =>
            @resize() if /loaded|complete/.test script.readyState
            return
        else
          for event in ["load", "error"]
            @on.call element: script, event, =>
              @resize()
              return
      else
        @resize()
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

  resize: ->
    contentDocument = @element.contentWindow.document
    html = contentDocument.documentElement
    body = contentDocument.body
    html.style.overflow = body.style.overflow = if window.opera then "scroll" else "visible"
    style =
      height: "#{body.scrollHeight}px"
      width:  "#{body.scrollWidth}px"
    html.style.overflow = body.style.overflow = ""
    @element.style[key] = value for key, value of style
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
