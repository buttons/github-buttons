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
