if window._phantom
  HTMLElement.prototype.click or= ->
    event = document.createEvent 'MouseEvents'
    event.initMouseEvent 'click', true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
    @dispatchEvent event
    return


describe 'Element', ->
  describe '#constructor()', ->
    it 'should use element when element is given', ->
      element = document.createElement "a"
      expect new Element element
        .to.have.property "element", element

    it 'should create new element when tag name is given', ->
      expect new Element "i"
        .to.have.deep.property "element.nodeType", 1

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
      document.body.removeChild input.element

    it 'should call the function on single event type', ->
      spy = sinon.spy()
      input.on "click", spy
      input.element.click()
      expect spy
        .to.have.been.calledOnce
      input.element.click()
      expect spy
        .to.have.been.calledTwice

    it 'should call the function on multiple event types', ->
      spy = sinon.spy()
      input.on "focus", "blur", "click", spy
      input.element.focus()
      expect spy
        .to.have.been.calledOnce
      input.element.blur()
      expect spy
        .to.have.been.calledTwice
      input.element.click()
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

    it 'should call the function with argument element', (done) ->
      b = document.createElement "b"
      new Element b
        .on "click", (element) ->
          expect element
            .to.equal b
          done()
      b.click()

  describe '#once()', ->
    input = null

    beforeEach ->
      input = new Element "input", (element) -> document.body.appendChild element

    afterEach ->
      document.body.removeChild input.element

    it 'should call the function on single event type only once', ->
      spy = sinon.spy()
      input.once "click", spy
      input.element.click()
      expect spy
        .to.have.been.calledOnce
      input.element.click()
      input.element.click()
      expect spy
        .to.have.been.calledOnce

    it 'should call the function on multiple event types only once', ->
      spy = sinon.spy()
      input.once "focus", "blur", spy
      input.element.focus()
      expect spy
        .to.have.been.calledOnce
      input.element.blur()
      input.element.focus()
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

    it 'should call the function with argument element', (done) ->
      b = document.createElement "b"
      new Element b
        .once "click", (element) ->
          expect element
            .to.equal b
          done()
      b.click()

  describe '#addClass()', ->
    it 'should add class to element', ->
      element = document.createElement "a"
      element.className = "hello"
      a = new Element element
      a.addClass "world"
      expect a.element.className
        .to.equal "hello world"
      a.addClass "world"
      expect a.element.className
        .to.equal "hello world"

  describe '#removeClass()', ->
    it 'should remove class from element', ->
      element = document.createElement "a"
      element.className = "hello world"
      a = new Element element
      a.removeClass "hello"
      expect a.element.className
        .to.equal "world"
      a.removeClass "hello"
      expect a.element.className
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
    document.body.removeChild frame.element

  describe '#constructor()', ->
    it 'should callback with the new iframe', ->
      expect frame.element.nodeType
        .to.equal 1
      expect frame.element.tagName
        .to.equal "IFRAME"

  describe '#html()', ->
    it 'should write html when iframe is in same-origin', (done) ->
      frame.on "load", ->
        expect frame.element.contentWindow.document.documentElement.getAttribute "lang"
          .to.equal "ja"
        done()
      frame.html html

  describe '#load()', ->
    it 'should load the src url', ->
      frame.load "../../buttons.html"
      expect frame.element.src
        .to.match /buttons\.html$/

  describe '#size()', ->
    it 'should return the iframe content size', (done) ->
      frame.on "load", ->
        expect frame.size()
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
      expect frame.element.style.width
        .to.equal "20px"
      expect frame.element.style.height
        .to.equal "10px"
      done()

