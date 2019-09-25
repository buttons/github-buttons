import {
  createElementInDocument,
  createElement,
  dispatchOnce,
  hasOwnProperty
} from '@/util'

describe('Util', () => {
  describe('createElement(tag, props, children)', () => {
    it('should create an element with tag', () => {
      const element = createElement('div')
      expect(element.nodeType)
        .to.equal(element.ELEMENT_NODE)
      expect(element.tagName.toLowerCase())
        .to.equal('div')
    })

    it('should create an element with tag and props', () => {
      const props = {
        href: 'https://github.com/',
        'aria-label': 'accessibility'
      }
      const element = createElement('a', props)
      expect(element.href)
        .to.equal(props.href)
      expect(element.getAttribute('aria-label'))
        .to.equal(props['aria-label'])
    })

    it('should create an element with tag and an element child', () => {
      const element = createElement('a', null, [createElement('span')])
      expect(element.children.length)
        .to.equal(1)
      expect(element.children[0].tagName.toLowerCase())
        .to.equal('span')
    })

    it('should create an element with tag and a text child', () => {
      const element = createElement('a', null, ['text child'])
      expect(element.childNodes.length)
        .to.equal(1)
      expect(element.childNodes[0].nodeType)
        .to.equal(element.TEXT_NODE)
      expect(element.innerHTML)
        .to.equal('text child')
    })

    it('should create an element with tag and children', () => {
      const element = createElement('a', null, [
        'text child 1',
        createElement('span', null, [
          'child'
        ]),
        'text child 2'
      ])
      expect(element.childNodes.length)
        .to.equal(3)
      expect(element.children.length)
        .to.equal(1)
      expect(element.childNodes[0].nodeType)
        .to.equal(element.TEXT_NODE)
      expect(element.childNodes[1].nodeType)
        .to.equal(element.ELEMENT_NODE)
      expect(element.childNodes[2].nodeType)
        .to.equal(element.TEXT_NODE)
      expect(element.innerHTML)
        .to.equal('text child 1<span>child</span>text child 2')
    })
  })

  describe('createElementInDocument(document)', () => {
    it('should a createElement function for given document', () => {
      const iframe = document.body.appendChild(document.createElement('iframe'))
      const element = createElementInDocument(iframe.contentWindow.document)('div')
      expect(element.ownerDocument)
        .to.equal(iframe.contentWindow.document)
      document.body.removeChild(iframe)
    })
  })

  describe('dispatchOnce(func)', () => {
    it('should dispatch func only once', () => {
      const spy = sinon.spy()
      const once = dispatchOnce(spy)
      once()
      expect(spy)
        .to.have.been.calledOnce
      once()
      expect(spy)
        .to.have.been.calledOnce
      once()
      expect(spy)
        .to.have.been.calledOnce
    })

    it('should dispatch func with arguments', () => {
      const spy = sinon.spy()
      const once = dispatchOnce(spy)
      once('a', 'b')
      once()
      once('c', 'd')
      expect(spy)
        .to.have.been.calledOnce
      expect(spy)
        .to.have.been.calledWith('a', 'b')
    })

    it('should discard func return', () => {
      expect(dispatchOnce(() => true)())
        .to.be.undefined
    })
  })

  describe('hasOwnProperty(obj, prop)', () => {
    it('should work', () => {
      const obj = { hello: 'world' }
      expect(hasOwnProperty(obj, 'hello'))
        .to.be.true
      expect(hasOwnProperty(obj, 'world'))
        .to.be.false
      expect(hasOwnProperty(obj, 'constructor'))
        .to.be.false
      expect(hasOwnProperty(obj, '__proto__'))
        .to.be.false
    })
  })
})
