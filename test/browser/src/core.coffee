describe 'Element', ->
  describe '#constructor()', ->
    it 'should use element when element is given', ->
      element = document.createElement "a"
      expect new Element(element).get()
        .to.equal element

    it 'should create new element when tag name is given', ->
      expect new Element("i").get().nodeType
        .to.equal 1

    it 'should callback with this', ->
      _this = null
      _ = new Element "em", (element) -> _this = @
      expect _this
        .to.equal _

    it 'should callback with argument element', (done) ->
      b = document.createElement "b"
      new Element b, (element) ->
        expect element
          .to.equal b
        done()

  describe '#on()', ->
    input = null

    beforeEach ->
      input = new Element "input", (element) -> document.body.appendChild element

    afterEach ->
      document.body.removeChild input.get()

    it 'should call the function on single event type', ->
      spy = sinon.spy()
      input.on "click", spy
      input.get().click()
      expect spy
        .to.have.been.calledOnce
      input.get().click()
      expect spy
        .to.have.been.calledTwice

    it 'should call the function on multiple event types', ->
      spy = sinon.spy()
      input.on "focus", "blur", "click", spy
      input.get().focus()
      expect spy
        .to.have.been.calledOnce
      input.get().blur()
      expect spy
        .to.have.been.calledTwice
      input.get().click()
      expect spy
        .to.have.been.calledThrice

    it 'should call the function with this', (done) ->
      a = document.createElement "a"
      _this = new Element a
      _this.on "click", ->
        expect @
          .to.equal _this
        done()
      a.click()

    it 'should call the function with event', (done) ->
      b = document.createElement "b"
      new Element b
        .on "click", (event) ->
          expect event.type
            .to.equal "click"
          done()
      b.click()

  describe '#once()', ->
    input = null

    beforeEach ->
      input = new Element "input", (element) -> document.body.appendChild element

    afterEach ->
      document.body.removeChild input.get()

    it 'should call the function on single event type only once', ->
      spy = sinon.spy()
      input.once "click", spy
      input.get().click()
      expect spy
        .to.have.been.calledOnce
      input.get().click()
      input.get().click()
      expect spy
        .to.have.been.calledOnce

    it 'should call the function on multiple event types only once', ->
      spy = sinon.spy()
      input.once "focus", "blur", spy
      input.get().focus()
      expect spy
        .to.have.been.calledOnce
      input.get().blur()
      input.get().focus()
      expect spy
        .to.have.been.calledOnce

    it 'should call the function with this', (done) ->
      a = document.createElement "a"
      _this = new Element a
      _this.once "click", ->
        expect @
          .to.equal _this
        done()
      a.click()

    it 'should call the function with event', (done) ->
      b = document.createElement "b"
      new Element b
        .once "click", (event) ->
          expect event.type
            .to.equal "click"
          done()
      b.click()

  describe '#addClass()', ->
    it 'should add class to element', ->
      element = document.createElement "a"
      element.className = "hello"
      a = new Element element
      a.addClass "world"
      expect a.get().className
        .to.equal "hello world"
      a.addClass "world"
      expect a.get().className
        .to.equal "hello world"

  describe '#removeClass()', ->
    it 'should remove class from element', ->
      element = document.createElement "a"
      element.className = "hello world"
      a = new Element element
      a.removeClass "hello"
      expect a.get().className
        .to.equal "world"
      a.removeClass "hello"
      expect a.get().className
        .to.equal "world"

  describe '#hasClass()', ->
    it 'should return whether element has class', ->
      element = document.createElement "a"
      element.className = "world"
      a = new Element element
      expect a.hasClass "hello"
        .to.be.false
      expect a.hasClass "world"
        .to.be.true


describe 'Frame', ->
  frame = null
  html = \
    """
    <!DOCTYPE html>
    <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title></title>
    </head>
    <body style="margin: 0;">
      <div style="width: 200.5px; height: 100px;"></div>
    </body>
    </html>
    """

  beforeEach ->
    frame = new Frame (iframe) -> document.body.appendChild iframe

  afterEach ->
    document.body.removeChild frame.get()

  describe '#constructor()', ->
    it 'should callback with the new iframe', ->
      expect frame.get().nodeType
        .to.equal 1
      expect frame.get().tagName
        .to.equal "IFRAME"

  describe '#html()', ->
    it 'should write html when iframe is in same-origin', (done) ->
      frame.on "load", ->
        expect frame.get().contentWindow.document.documentElement.getAttribute "lang"
          .to.equal "ja"
        done()
      frame.html html

  describe '#load()', ->
    it 'should load the src url', ->
      frame.load "../../buttons.html"
      expect frame.get().src
        .to.match /buttons\.html$/

  describe '#size()', ->
    it 'should return the iframe content size', (done) ->
      frame.on "load", ->
        switch window.devicePixelRatio
          when 2
            expect @size()
              .to.deep.equal
                width: "200.5px"
                height: "100px"
          when 3
            expect @size()
              .to.deep.equal
                width: "201px"
                height: "100px"
        done()
      frame.html html

  describe '#resize()', ->
    it 'should resize the iframe', (done) ->
      frame.resize
        width: "20px"
        height: "10px"
      expect frame.get().style.width
        .to.equal "20px"
      expect frame.get().style.height
        .to.equal "10px"
      done()


describe 'ButtonAnchor', ->
  a = null

  beforeEach ->
    a = document.createElement "a"

  describe '.parse()', ->
    it 'should parse the anchor without attribute', ->
      expect ButtonAnchor.parse a
        .to.deep.equal
          href: ""
          text: ""
          data:
            count:
              api: undefined
              href: ""
              aria:
                label: undefined
            style: undefined
            icon: undefined
          aria:
            label: undefined

    it 'should parse the attribute href', ->
      a.href = "https://buttons.github.io/"
      expect ButtonAnchor.parse a
        .to.have.property "href"
        .and.equal a.href

    it 'should parse the attribute data-text', ->
      text = "test"
      a.setAttribute "data-text", text
      expect ButtonAnchor.parse a
        .to.have.property "text"
        .and.equal text

    it 'should parse the text content', ->
      text = "something"
      a.appendChild document.createTextNode text
      expect ButtonAnchor.parse a
        .to.have.property "text"
        .and.equal text

    it 'should ignore the text content when the attribute data-text is given', ->
      text = "something"
      a.setAttribute "data-text", text
      a.appendChild document.createTextNode "something else"
      expect ButtonAnchor.parse a
        .to.have.property "text"
        .and.equal text

    it 'should parse the attribute data-count-api', ->
      api = "/repos/:user/:repo#item"
      a.setAttribute "data-count-api", api
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.count.api"
        .and.equal api

    it 'should prepend / when the attribute data-count-api does not start with /', ->
      api = "repos/:user/:repo#item"
      a.setAttribute "data-count-api", api
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.count.api"
        .and.equal "/#{api}"

    it 'should ignore the attribute data-count-api when missing #', ->
      api = "/repos/:user/:repo"
      a.setAttribute "data-count-api", api
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.count.api"
        .and.be.undefined

    it 'should parse the attribute data-count-href', ->
      href = "https://github.com/"
      a.setAttribute "data-count-href", href
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.count.href"
        .and.equal href

    it 'should fallback data.cout.href to the attribute href when the attribute data-count-href is not given', ->
      a.href = "https://github.com/"
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.count.href"
        .and.equal a.href

    it 'should parse the attribute data-style', ->
      style = "mega"
      a.setAttribute "data-style", style
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.style"
        .and.equal style

    it 'should parse the attribute data-icon', ->
      icon = "octicon"
      a.setAttribute "data-icon", icon
      expect ButtonAnchor.parse a
        .to.have.deep.property "data.icon"
        .and.equal icon


describe 'ButtonFrame', ->
  describe '#constructor()', ->
    hash = Hash.encode ButtonAnchor.parse document.createElement "a"

    it 'should callback with this twice', (done) ->
      _this = null
      _ = new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        _this = @
      , (iframe) ->
        expect _this
          .to.equal _
        expect @
          .to.equal _
        iframe.parentNode.removeChild iframe
        done()

    it 'should callback with the iframe as argument twice', (done) ->
      frame = null
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        frame = iframe
        expect iframe.tagName
          .to.equal "IFRAME"
      , (iframe) ->
        expect iframe
          .to.equal frame
        iframe.parentNode.removeChild iframe
        done()

    it 'should load the iframe twice after insert it into DOM', (done) ->
      spy = sinon.spy()
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        @on "load", -> spy()
      , (iframe) ->
        expect spy
          .to.have.been.calledTwice
        iframe.parentNode.removeChild iframe
        done()

    it 'should load the iframe the first time by writing html', (done) ->
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        sinon.spy @, "html"
      , (iframe) ->
        expect @html
          .to.have.been.calledOnce
        @html.restore()
        iframe.parentNode.removeChild iframe
        done()

    it 'should set document.location.hash when load the first time by writing html', (done) ->
      _hash = null
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        @once "load", ->
          _hash = iframe.contentWindow.document.location.hash
      , (iframe) ->
        expect _hash
          .to.equal hash
        iframe.parentNode.removeChild iframe
        done()

    it 'should load the iframe the second time by setting the src attribute', (done) ->
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        sinon.spy @, "html"
        sinon.spy @, "load"
      , (iframe) ->
        expect @load
          .to.have.been.calledOnce
        expect @load
          .to.have.been.calledAfter @html
        @html.restore()
        @load.restore()
        iframe.parentNode.removeChild iframe
        done()

    it 'should set document.location.href when load the second time by setting the src attribute', (done) ->
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
      , (iframe) ->
        expect iframe.contentWindow.document.location.hash
          .to.equal hash
        iframe.parentNode.removeChild iframe
        done()

    it 'should resize the iframe after the second load', (done) ->
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        sinon.spy @, "html"
        sinon.spy @, "load"
        sinon.spy @, "size"
        sinon.spy @, "resize"
      , (iframe) ->
        expect @size
          .to.have.been.calledOnce
        expect @size
          .to.have.been.calledAfter @html
        expect @resize
          .to.have.been.calledOnce
        expect @resize
          .to.have.been.calledAfter @load
        expect @resize.args[0][0]
          .to.deep.equal @size.returnValues[0]
        expect iframe.style.width
          .to.equal @size.returnValues[0].width
        expect iframe.style.height
          .to.equal @size.returnValues[0].height
        @html.restore()
        @load.restore()
        @size.restore()
        @resize.restore()
        iframe.parentNode.removeChild iframe
        done()


describe 'ButtonFrameContent', ->
  head = document.getElementsByTagName("head")[0]
  base = null
  bodyClassName = null
  data =
    "meta":
      "X-RateLimit-Limit": "60",
      "X-RateLimit-Remaining": "59",
      "X-RateLimit-Reset": "1423391706",
      "Cache-Control": "public, max-age=60, s-maxage=60",
      "Last-Modified": "Sun, 08 Feb 2015 07:39:11 GMT",
      "Vary": "Accept",
      "X-GitHub-Media-Type": "github.v3",
      "status": 200
    "data":
      "login": "ntkme",
      "id": 899645,
      "avatar_url": "https://avatars.githubusercontent.com/u/899645?v=3",
      "gravatar_id": "",
      "url": "https://api.github.com/users/ntkme",
      "html_url": "https://github.com/ntkme",
      "followers_url": "https://api.github.com/users/ntkme/followers",
      "following_url": "https://api.github.com/users/ntkme/following{/other_user}",
      "gists_url": "https://api.github.com/users/ntkme/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/ntkme/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/ntkme/subscriptions",
      "organizations_url": "https://api.github.com/users/ntkme/orgs",
      "repos_url": "https://api.github.com/users/ntkme/repos",
      "events_url": "https://api.github.com/users/ntkme/events{/privacy}",
      "received_events_url": "https://api.github.com/users/ntkme/received_events",
      "type": "User",
      "site_admin": false,
      "name": "なつき",
      "company": "",
      "blog": "https://ntk.me",
      "location": "California",
      "email": "i@ntk.me",
      "hireable": true,
      "bio": null,
      "public_repos": 10,
      "public_gists": 0,
      "followers": 26,
      "following": 0,
      "created_at": "2011-07-07T03:26:58Z",
      "updated_at": "2015-02-08T07:39:11Z"

  javascript_protocals = [
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

  beforeEach ->
    bodyClassName= document.body.getAttribute "class"
    base = head.insertBefore document.createElement("base"), head.firstChild
    sinon.stub document.body, "appendChild"

  afterEach ->
    if bodyClassName
      document.body.className = bodyClassName
    else
      document.body.removeAttribute "class"
    base.parentNode.removeChild base
    document.body.appendChild.restore()

  describe '#constructor()', ->
    it 'should do nothing when options are missing', ->
      new ButtonFrameContent()
      expect base.getAttribute "href"
        .to.be.null
      expect document.body.appendChild
        .to.have.not.been.called

    it 'should not set base.href', ->
      options =
        href: "https://github.com/"
        data: {}
        aria: {}
      new ButtonFrameContent options
      expect base.getAttribute "href"
        .to.be.null

    it 'should set document.body.className when a style is given', ->
      options =
        data: style: "mega"
        aria: {}
      new ButtonFrameContent options
      expect document.body.className
        .to.equal options.data.style

    it 'should append the button to document.body when the necessary options are given', ->
      options =
        data: {}
        aria: {}
      new ButtonFrameContent options
      expect document.body.appendChild
        .to.be.calledOnce
      button = document.body.appendChild.args[0][0]
      expect button
        .to.have.property "className"
        .and.equal "button"

    it 'should append the button with given href', ->
      options =
        href: "https://twitter.com/"
        data: {}
        aria: {}
      new ButtonFrameContent options
      button = document.body.appendChild.args[0][0]
      expect button.getAttribute "href"
        .to.equal options.href

    it 'should filter javascript in the href', ->
      for href, i in javascript_protocals
        options =
          href: href
          data: count: href: href
          aria: {}
        new ButtonFrameContent options
        button = document.body.appendChild.args[i][0]
        expect button.getAttribute "href"
          .to.not.match /javascript:/i

    it 'should append the button with the default icon', ->
      options =
        data: {}
        aria: {}
      new ButtonFrameContent options
      button = document.body.appendChild.args[0][0]
      expect " #{button.firstChild.className} ".indexOf " #{Config.icon} "
        .to.be.at.least 0

    it 'should append the button with given icon', ->
      options =
        data: icon: "octicon-star"
        aria: {}
      new ButtonFrameContent options
      button = document.body.appendChild.args[0][0]
      expect " #{button.firstChild.className} ".indexOf " #{options.data.icon} "
        .to.be.at.least 0

    it 'should append the button with given text', ->
      options =
        text: "Follow"
        data: {}
        aria: {}
      new ButtonFrameContent options
      button = document.body.appendChild.args[0][0]
      expect button.lastChild.innerHTML
        .to.equal options.text

    it 'should append the button with given aria label', ->
      options =
        data: {}
        aria: label: "GitHub"
      new ButtonFrameContent options
      button = document.body.appendChild.args[0][0]
      expect button.getAttribute "aria-label"
        .to.equal options.aria.label

    it 'should append the count to document.body when the necessary options are given', ->
      sinon.stub head, "insertBefore", -> window.callback data
      options =
        data: count:
          api: "/dummy/api#followers"
          aria: {}
        aria: {}
      new ButtonFrameContent options
      expect document.body.appendChild
        .to.be.calledTwice
      count = document.body.appendChild.args[1][0]
      expect count
        .to.have.property "className"
        .and.equal "count"
      head.insertBefore.restore()

    it 'should append the count with given data.count.href', ->
      sinon.stub head, "insertBefore", -> window.callback data
      options =
        data: count:
          api: "/dummy/api#followers"
          href: "https://twitter.com/"
          aria: {}
        aria: {}
      new ButtonFrameContent options
      count = document.body.appendChild.args[1][0]
      expect count.getAttribute "href"
        .to.equal options.data.count.href
      head.insertBefore.restore()

    it 'should append the count with #entry from api response', ->
      sinon.stub head, "insertBefore", -> window.callback data
      options =
        data: count:
          api: "/dummy/api#followers"
          aria: {}
        aria: {}
      new ButtonFrameContent options
      count = document.body.appendChild.args[1][0]
      expect count.lastChild.innerHTML
        .to.equal " 26 "
      head.insertBefore.restore()

    it 'should append the count with large number split by comma', ->
      sinon.stub head, "insertBefore", -> window.callback data
      options =
        data: count:
          api: "/dummy/api#id"
          aria: {}
        aria: {}
      new ButtonFrameContent options
      count = document.body.appendChild.args[1][0]
      expect count.lastChild.innerHTML
        .to.equal " 899,645 "
      head.insertBefore.restore()

    it 'should append the count with given aria label', ->
      sinon.stub head, "insertBefore", -> window.callback data
      options =
        data: count:
          api: "/dummy/api#followers"
          aria: label: "# followers on GitHub"
        aria: {}
      new ButtonFrameContent options
      count = document.body.appendChild.args[1][0]
      expect count.getAttribute "aria-label"
        .to.equal "26 followers on GitHub"
      head.insertBefore.restore()

    it 'should append the count with text undefined when api #entry does not exist', ->
      sinon.stub head, "insertBefore", -> window.callback data
      options =
        data: count:
          api: "/dummy/api#fail"
          aria: {}
        aria: {}
      new ButtonFrameContent options
      count = document.body.appendChild.args[1][0]
      expect count.lastChild.innerHTML
        .to.equal " undefined "
      head.insertBefore.restore()

    it 'should not append the count when it fails to pull api data', ->
      sinon.stub head, "insertBefore", -> window.callback meta: status: 404
      options =
        data: count:
          api: "/dummy/api#followers"
          aria: {}
        aria: {}
      new ButtonFrameContent options
      expect document.body.appendChild
        .to.be.calledOnce
      button = document.body.appendChild.args[0][0]
      expect button
        .to.have.property "className"
        .and.equal "button"
      head.insertBefore.restore()
