describe "Render", ->
  describe "renderButton(config)", ->
    beforeEach ->
      sinon.stub document.body, "appendChild"

    afterEach ->
      document.body.appendChild.restore()

    it "should append the button to document.body when the necessary config is given", ->
      renderButton {}
      expect document.body.appendChild
        .to.have.been.calledOnce
      button = document.body.appendChild.args[0][0]
      expect button
        .to.have.property "className"
        .and.equal "btn"

    it "should append the button with given href", ->
      config = "href": "https://ntkme.github.com/"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect button.getAttribute "href"
        .to.equal config.href

    it "should create a button with href # if domain is not github", ->
      renderButton "href": "https://twitter/ntkme"
      button = document.body.appendChild.args[0][0]
      expect button
        .to.have.property "href"
        .to.equal document.location.href + "#"
      expect button
        .to.have.property "target"
        .to.equal "_self"

    it "should create an anchor with href # if url contains javascript", ->
      for i, protocol of [
        "javascript:"
        "JAVASCRIPT:"
        "JavaScript:"
        " javascript:"
        "   javascript:"
        "\tjavascript:"
        "\njavascript:"
        "\rjavascript:"
        "\fjavascript:"
      ]
        renderButton "href": protocol
        button = document.body.appendChild.args[i][0]
        expect button
          .to.have.property "href"
          .to.equal document.location.href + "#"
        expect button
          .to.have.property "target"
          .to.equal "_self"

    it "should create an anchor with target _top if url is a download link", ->
      for i, url of [
        "https://github.com/ntkme/github-buttons/archive/master.zip"
        "https://codeload.github.com/ntkme/github-buttons/zip/master"
        "https://github.com/octocat/Hello-World/releases/download/v1.0.0/example.zip"
      ]
        renderButton "href": url
        button = document.body.appendChild.args[i][0]
        expect button
          .to.have.property "target"
          .to.equal "_top"

    it "should append the button with the default icon", ->
      renderButton {}
      button = document.body.appendChild.args[0][0]
      expect " #{button.firstChild.className} ".indexOf " #{ICON_CLASS_DEFAULT} "
        .to.be.at.least 0

    it "should append the button with given icon", ->
      config = "data-icon": "octicon-star"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect " #{button.firstChild.className} ".indexOf " #{config["data-icon"]} "
        .to.be.at.least 0

    it "should append the button with given text", ->
      config = "data-text": "Follow"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect button.lastChild.innerHTML
        .to.equal config["data-text"]

    it "should append the button with given aria label", ->
      config = "aria-label": "GitHub"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect button.getAttribute "aria-label"
        .to.equal config["aria-label"]

  describe "rednerCount(button)", ->
    button = null
    head = document.getElementsByTagName("head")[0]
    REAL_GITHUB_API_BASEURL = GITHUB_API_BASEURL
    real_jsonp = jsonp

    beforeEach ->
      GITHUB_API_BASEURL = "./api.github.com"
      button = document.body.appendChild createElement "a"
      sinon.stub document.body, "insertBefore"
      jsonp = sinon.spy jsonp

    afterEach ->
      GITHUB_API_BASEURL = REAL_GITHUB_API_BASEURL
      button.parentNode.removeChild button
      document.body.insertBefore.restore()
      jsonp = real_jsonp

    testRenderCount = (url, func) ->
      sinon.stub head, "appendChild"
        .callsFake ->
          sinon.stub window, "_"
            .callsFake ->
              args = window._.args[0]
              window._.restore()
              window._.apply null, args
              func()
          script = head.appendChild.args[0][0]
          head.appendChild.restore()
          head.appendChild script
      button.href = url
      renderCount button

    it "should append the count when a known button type is given", (done) ->
      testRenderCount "https://github.com/ntkme", ->
        expect jsonp
          .to.have.been.calledOnce
        expect document.body.insertBefore
          .to.have.been.calledOnce
        count = document.body.insertBefore.args[0][0]
        expect count
          .to.have.property "className"
          .and.equal "social-count"
        done()

    it "should append the count for follow button", (done) ->
      testRenderCount "https://github.com/ntkme", ->
        count = document.body.insertBefore.args[0][0]
        expect jsonp.args[0][0]
          .to.equal GITHUB_API_BASEURL + "/users/ntkme"
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        expect count.lastChild.innerHTML
          .to.equal "53"
        expect count.getAttribute "aria-label"
          .to.equal "53 followers on GitHub"
        done()

    it "should append the count for watch button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/subscription", ->
        count = document.body.insertBefore.args[0][0]
        expect jsonp.args[0][0]
          .to.equal GITHUB_API_BASEURL + "/repos/ntkme/github-buttons"
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/watchers"
        expect count.lastChild.innerHTML
          .to.equal "14"
        expect count.getAttribute "aria-label"
          .to.equal "14 subscribers on GitHub"
        done()

    it "should append the count for star button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect jsonp.args[0][0]
          .to.equal GITHUB_API_BASEURL + "/repos/ntkme/github-buttons"
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/stargazers"
        expect count.lastChild.innerHTML
          .to.equal "302"
        expect count.getAttribute "aria-label"
          .to.equal "302 stargazers on GitHub"
        done()

    it "should append the count for fork button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/fork", ->
        count = document.body.insertBefore.args[0][0]
        expect jsonp.args[0][0]
          .to.equal GITHUB_API_BASEURL + "/repos/ntkme/github-buttons"
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/network"
        expect count.lastChild.innerHTML
          .to.equal "42"
        expect count.getAttribute "aria-label"
          .to.equal "42 forks on GitHub"
        done()

    it "should append the count for issue button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/issues", ->
        count = document.body.insertBefore.args[0][0]
        expect jsonp.args[0][0]
          .to.equal GITHUB_API_BASEURL + "/repos/ntkme/github-buttons"
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issues on GitHub"
        done()

    it "should append the count for issue button when it links to new issue", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/issues/new", ->
        count = document.body.insertBefore.args[0][0]
        expect jsonp.args[0][0]
          .to.equal GITHUB_API_BASEURL + "/repos/ntkme/github-buttons"
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issues on GitHub"
        done()

    it "should append the count for button whose link has a tailing slash", (done) ->
      testRenderCount "https://github.com/ntkme/", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a query", (done) ->
      testRenderCount "https://github.com/ntkme?tab=repositories", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a hash", (done) ->
      testRenderCount "https://github.com/ntkme#github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a query", (done) ->
      testRenderCount "https://github.com/ntkme/?tab=repositories", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a hash", (done) ->
      testRenderCount "https://github.com/ntkme/#github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a tailing slash, a query, and a hash", (done) ->
      testRenderCount "https://github.com/ntkme/?tab=repositories#github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should not append the count for unknown button type", ->
      button.href = "https://github.com/"
      renderCount button
      button.href = "https://github.com/ntkme/github-buttons/test"
      renderCount button
      expect jsonp
        .to.have.not.been.called
      expect document.body.insertBefore
        .to.have.not.been.called


    it "should not append the count when it fails to pull api data", ->
      sinon.stub head, "appendChild"
        .callsFake ->
          head.appendChild.restore()
          window._ meta: status: 404
          expect document.body.insertBefore
            .to.have.not.been.called
      button.href = "https://github.com/ntkme"
      renderCount button

  describe "renderFrameContent(config)", ->
    className = document.body.className
    _renderButton = renderButton
    _renderCount = renderCount

    before ->
      sinon.stub document.body, "appendChild"

    after ->
      document.body.className = className
      document.body.appendChild.restore()

    beforeEach ->
      renderButton = sinon.stub().returns createElement "a"
      renderCount = sinon.stub()

    afterEach ->
      renderButton = _renderButton
      renderCount = _renderCount

    it "should do nothing when config is missing", ->
      renderFrameContent()
      expect document.body.appendChild
        .to.have.not.been.called

    it "should set document.body.className when data-size is large", ->
      config = "data-size": "large"
      renderFrameContent config
      expect document.body.className
        .to.equal "large"

    it "should call renderButton(config)", ->
      renderFrameContent {}
      expect renderButton
        .to.have.been.calledOnce
      expect renderCount
        .to.have.not.been.called

    it "should call renderCount(config) when data-show-count is true", ->
      renderFrameContent "data-show-count": true
      expect renderButton
        .to.have.been.calledOnce
      expect renderCount
        .to.have.been.calledOnce
