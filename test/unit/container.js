import { render } from '@/container'
import {
  iframeURL,
  setApiBaseURL,
  setUseShadowDOM
} from '@/config'
import { onceEvent } from '@/event'

setApiBaseURL('/base/test/fixtures/api.github.com')

describe('Container', () => {
  describe('render(options, callback)', () => {
    it('should do nothing when no argument given', () => {
      render()
    })

    it('should do nothing when no callback given', () => {
      render({})
    })

    it('should render with options', (done) => {
      render({}, (el) => {
        expect(el)
          .to.be.an.instanceof(HTMLElement)
        expect(el.tagName)
          .to.match(/^SPAN$|^IFRAME$/)
        done()
      })
    })

    it('should set title attribute if given', (done) => {
      const options = {
        title: 'test1234'
      }
      render(options, (el) => {
        expect(el.title)
          .to.equal(options.title)
        done()
      })
    })
  })

  describe('render(el, callback)', () => {
    let a

    beforeEach(() => {
      a = document.createElement('a')
    })

    it('should do nothing when no argument given', () => {
      render()
    })

    it('should do nothing when no callback given', () => {
      render(a)
    })

    it('should render an anchor', (done) => {
      render(a, (el) => {
        expect(el)
          .to.be.an.instanceof(HTMLElement)
        expect(el.tagName)
          .to.match(/^SPAN$|^IFRAME$/)
        done()
      })
    })

    it('should set title attribute if given', (done) => {
      a.title = 'test1234'
      render(a, (el) => {
        expect(el.title)
          .to.equal(a.title)
        done()
      })
    })
  })

  describe('render(el, callback)', () => {
    let a

    beforeEach(() => {
      a = document.createElement('a')
      setUseShadowDOM(false)
    })

    afterEach(() => {
      setUseShadowDOM(true)
    })

    it('should render an anchor with iframe and set src', (done) => {
      render(a, (el) => {
        expect(el)
          .to.be.an.instanceof(HTMLElement)
        expect(el.tagName)
          .to.equal('IFRAME')
        onceEvent(el, 'load', () => {
          expect(el.src.split('#')[0])
            .to.equal(iframeURL)
          done()
        })
        el.dispatchEvent(new Event('load'))
      })
    })

    it('should render an anchor with iframe and set iframe size on load', (done) => {
      render(a, (el) => {
        expect(el)
          .to.be.an.instanceof(HTMLElement)
        expect(el.tagName)
          .to.equal('IFRAME')
        onceEvent(el, 'load', () => {
          expect(el.style.height)
            .to.equal('20px')
          expect(parseInt(el.style.width))
            .to.be.above(20)
          done()
        })
        el.dispatchEvent(new Event('load'))
      })
    })

    it('should set title attribute on iframe if given', (done) => {
      a.title = 'test1234'
      render(a, (el) => {
        expect(el.title)
          .to.equal(a.title)
        done()
      })
    })
  })
})
