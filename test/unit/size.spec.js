import { get, set } from '@/size'

describe('Size', () => {
  let el, size

  const getRandomInt = (min = 0, max = 1000) => {
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min)) + min
  }

  beforeEach(() => {
    el = document.body.appendChild(document.createElement('div'))
    el.style.display = 'inline-block'
    el.style.overflow = 'hidden'
    size = [getRandomInt(), getRandomInt()]
  })

  afterEach(() => {
    el.parentNode.removeChild(el)
  })

  describe('get(el)', () => {
    it('should size', () => {
      set(el, size)
      expect(get(el))
        .to.deep.equal(size)
    })

    it('should size without Element::getBoundingClientRect()', () => {
      el.getBoundingClientRect = null
      set(el, size)
      expect(get(el))
        .to.deep.equal(size)
    })

    it('should size with Element::getBoundingClientRect()', () => {
      el.getBoundingClientRect = sinon.stub().returns({
        width: size[0],
        height: size[1]
      })
      set(el, size)
      expect(get(el))
        .to.deep.equal(size)
      expect(el.getBoundingClientRect)
        .to.be.calledOnce
    })

    it('should size with Element::getBoundingClientRect() that lacks of width and height properties', () => {
      el.getBoundingClientRect = sinon.stub().returns({
        top: 0,
        right: size[0],
        bottom: size[1],
        left: 0
      })
      set(el, size)
      expect(get(el))
        .to.deep.equal(size)
      expect(el.getBoundingClientRect)
        .to.be.calledOnce
    })
  })

  describe('set(el, size)', () => {
    it('should set width and height on element', () => {
      set(el, [0, 0])
      expect(el.scrollWidth)
        .to.equal(0)
      expect(el.scrollHeight)
        .to.equal(0)
      set(el, [50, 100])
      expect(el.scrollWidth)
        .to.equal(50)
      expect(el.scrollHeight)
        .to.equal(100)
    })
  })
})
