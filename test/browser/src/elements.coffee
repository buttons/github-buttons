if window._phantom
  HTMLElement.prototype.click or= ->
    ev = document.createEvent 'MouseEvent'
    ev.initMouseEvent 'click', true, true, window, null, 0, 0, 0, 0, false, false, false, false, 0, null
    @dispatchEvent ev
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

    it 'should callback with the element', (done) ->
      b = document.createElement "b"
      new Element b, (element) ->
        expect element
          .to.equal b
        done()

  describe '#on()', ->
    it 'should call the function on event', ->
      spy = sinon.spy()
      a = new Element "a"
      a.on "click", spy
      a.element.click()
      expect spy
        .to.have.been.calledOnce
      a.element.click()
      expect spy
        .to.have.been.calledTwice

  describe '#once()', ->
    it 'should call the function on event only once', ->
      spy = sinon.spy()
      a = new Element "a"
      a.once "click", spy
      a.element.click()
      expect spy
        .to.have.been.calledOnce
      a.element.click()
      a.element.click()
      expect spy
        .to.have.been.calledOnce

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

