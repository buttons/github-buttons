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
      <div style="width: 200px; height: 100px;"></div>
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
        expect @size()
          .to.deep.equal
            width: "200px"
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
            style: undefined
            icon: undefined

    it 'should parse the attribute href', ->
      a.href = "https://buttons.github.io/"
      expect ButtonAnchor.parse a
        .to.have.property "href"
        .and.equal a.href

    it 'should filter javascript in the attribute href', ->
      for href in javascript_protocals
        a.href = href
        expect ButtonAnchor.parse a
          .to.have.property "href"
          .to.equal ""

    it 'should parse the attribute data-text', ->
      text = "test"
      a.setAttribute "data-text", text
      expect ButtonAnchor.parse(a).text
        .to.equal text

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
        .to.not.have.deep.property "data.count.api"

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

    it 'should filter javascript in the attribute data-count-href', ->
      for href in javascript_protocals
        a.setAttribute "data-count-href", href
        expect ButtonAnchor.parse a
          .to.have.deep.property "data.count.href"
          .and.equal ""

    it 'should fallback data.cout.href to the attribute href when the attribute data-count-href is filtered', ->
      a.href = "https://github.com/"
      for href in javascript_protocals
        expect ButtonAnchor.parse a
          .to.have.deep.property "data.count.href"
          .and.equal a.href

    it 'should filter javascript in the attribute href when the attribute data-count-href fallbacks to its value', ->
      for href in javascript_protocals
        a.href = href
        expect ButtonAnchor.parse a
          .to.have.deep.property "data.count.href"
          .and.equal ""

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
      spy = null
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        spy = sinon.spy @, "html"
      , (iframe) ->
        expect spy
          .to.have.been.calledOnce
        spy.restore()
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
      spy = null
      new ButtonFrame hash, (iframe) ->
        document.body.appendChild iframe
        @once "load", ->
          spy = sinon.spy @, "load"
      , (iframe) ->
        expect spy
          .to.have.been.calledOnce
        spy.restore()
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
