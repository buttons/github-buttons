if not {}.hasOwnProperty.call(document, 'currentScript') and delete document.currentScript and document.currentScript
  BASEURL = document.currentScript.src.replace /[^/]*([?#].*)?$/, ''
                                      .replace /[^/]*\/[^/]*\/$/, ''

@onbeforeunload = ->

defer ->
  Vue.component 'github-button-preview',
    template: '#github-button-preview-template'
    props: ['config']
    data: ->
      timeoutId: null
    computed:
      rateLimitWait: ->
        if @config['data-show-count'] then 300 else 0
    mounted: ->
      iframe = @$el.firstChild
      onload = ->
        setFrameSize iframe, getFrameContentSize iframe
        return
      onEvent iframe, 'load', ->
        if callback = iframe.contentWindow._
          onceScriptLoad callback.$, onload
        else
          onload()
        return
      @update()
      return
    updated: ->
      @update()
      return
    methods:
      update: ->
        iframe = @$el.firstChild
        setFrameSize iframe, [1, 0]

        clearTimeout @timeoutId
        @timeoutId = setTimeout ((_this) -> ->
          iframe = _this.$el.removeChild iframe
          iframe.src = 'buttons.html#' + stringifyQueryString _this.config
          _this.$el.appendChild iframe
          return
        )(@), @rateLimitWait
        return

  Vue.component 'github-button-code',
    template: '#github-button-code-template'
    props: ['text']

  new Vue
    el: '#app'
    template: '#app-template'
    mounted: ->
      setTimeout renderAll
      return
    updated: ->
      if @focus
        @focus.focus()
        @focus = null
      return
    data: ->
      script: '<!-- Place this tag in your head or just before your close body tag. -->\n<script async defer src="https://buttons.github.io/buttons.js"></script>'
      focus: null
      options:
        type: null
        user: ''
        repo: ''
        largeButton: false
        showCount: false
        standardIcon: false
    watch:
      'options.type': ->
        if document.activeElement isnt @$refs.user and document.activeElement isnt @$refs.repo
          if @options.type is 'follow' or not @successes.user or
              (@successes.user and @successes.repo)
            @focus = @$refs.user
          else
            @focus = @$refs.repo
        return
    computed:
      code: ->
        a = createElement 'a'
        a.className = 'github-button'
        a.href = @config.href
        a.textContent = @config['data-text']
        for name, value of @config
          if name isnt 'href' and name isnt 'data-text' and value?
            a.setAttribute name, value
        '<!-- Place this tag where you want the button to render. -->\n' + a.outerHTML
      successes: ->
        user: do (user = @options.user) ->
          0 < user.length && user.length < 40 && !/[^A-Za-z0-9-]|^-|-$|--/i.test(user)
        repo: do (repo = @options.repo) ->
          0 < repo.length && repo.length < 101 && !/[^\w-.]|\.git$|^\.\.?$/i.test(repo)
      hasSuccess: ->
        if @options.type is 'follow'
          @successes.user
        else
          @successes.user and @successes.repo
      dangers: ->
        user: @options.user isnt '' and not @successes.user
        repo: @options.type isnt 'follow' and @options.repo isnt '' and not @successes.repo
      hasDanger: ->
        @dangers.user or @dangers.repo
      config: ->
        return unless @options.type?
        options =
          type: @options.type
          user: if @hasSuccess then @options.user else 'ntkme'
          repo: if @hasSuccess then @options.repo else 'github-buttons'
          largeButton: @options.largeButton
          showCount: @options.showCount
          standardIcon: @options.standardIcon

        href: do ->
          base = 'https://github.com'
          user = '/' + options.user
          repo = user + '/' + options.repo
          switch (options.type)
            when 'follow'
              return base + user
            when 'watch'
              return base + repo + '/subscription'
            when 'star'
              return base + repo
            when 'fork'
              return base + repo + '/fork'
            when 'issue'
              return base + repo + '/issues'
            when 'download'
              return base + repo + '/archive/master.zip'
            else
              return base
        'data-text': do ->
          switch (options.type)
            when 'follow'
              return 'Follow @' + options.user
            else
              return options.type.charAt(0).toUpperCase() + options.type.slice(1).toLowerCase()
        'data-icon': do ->
          if (options.standardIcon)
            return
          switch options.type
            when 'watch'
              return 'octicon-eye'
            when 'star'
              return 'octicon-star'
            when 'fork'
              return 'octicon-repo-forked'
            when 'issue'
              return 'octicon-issue-opened'
            when 'download'
              return 'octicon-cloud-download'
            else
              return
        'data-size': do ->
          return if options.largeButton then 'large' else null
        'data-show-count': do ->
          if options.showCount
            switch options.type
              when 'download'
                return null
              else
                return true
          return null
        'aria-label': do ->
          switch options.type
            when 'follow'
              return 'Follow @' + options.user + ' on GitHub'
            when 'watch', 'star', 'fork', 'issue', 'download'
              return (options.type.charAt(0).toUpperCase() + options.type.slice(1).toLowerCase()) + ' ' + options.user + '/' + options.repo + ' on GitHub'
            else
              return 'GitHub'
  return
