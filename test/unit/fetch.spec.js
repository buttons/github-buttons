import { setUseXHR } from '@/config'
import { fetch } from '@/fetch'

describe('Fetch', () => {
  const head = document.getElementsByTagName('head')[0]

  beforeEach(() => {
    sinon.spy(JSON, 'parse')
  })

  afterEach(() => {
    JSON.parse.restore()
  })

  describe('fetch(url, func)', () => {
    it('should fetch url as json via xhr', (done) => {
      fetch('/base/test/fixtures/xhr/api.github.com/repos/ntkme/github-buttons', (error, data) => {
        expect(error)
          .to.not.be.ok
        done()
        expect(data.owner.login)
          .to.equal('ntkme')
        done()
      })
    })

    it('should handle error via xhr', (done) => {
      fetch('/404', (error, data) => {
        expect(error)
          .to.be.ok
        done()
      })
    })

    it('should handle http 200 with corrupted json via xhr', (done) => {
      fetch('/base/test/fixtures/jsonp/api.github.com/users/ntkme', (error, data) => {
        expect(error)
          .to.be.ok
        done()
      })
    })

    it('should combine identical pending requests via xhr', (done) => {
      Promise.all([
        new Promise((resolve, reject) => {
          fetch('/base/test/fixtures/xhr/api.github.com/users/ntkme', (error, data) => {
            expect(data.login)
              .to.equal('ntkme')
            resolve()
          })
        }),
        new Promise((resolve, reject) => {
          fetch('/base/test/fixtures/xhr/api.github.com/users/ntkme', (error, data) => {
            expect(data.login)
              .to.equal('ntkme')
            resolve()
          })
        })
      ]).then(() => {
        expect(JSON.parse).to.be.calledOnce
        done()
      })
    })
  })

  describe('fetch(url, func)', () => {
    beforeEach(() => {
      setUseXHR(false)
      sinon.spy(head, 'appendChild')
    })

    afterEach(() => {
      setUseXHR(true)
      head.appendChild.restore()
    })

    it('should fetch url as json via json-p', (done) => {
      fetch('/base/test/fixtures/jsonp/api.github.com/repos/ntkme/github-buttons', (error, data) => {
        expect(error)
          .to.not.be.ok
        done()
        expect(data.owner.login)
          .to.equal('ntkme')
        done()
      })
    })

    it('should handle error via json-p', (done) => {
      fetch('/404', (error, data) => {
        expect(error)
          .to.be.ok
        done()
      })
    })

    it('should combine identical pending requests via json-p', (done) => {
      Promise.all([
        new Promise((resolve, reject) => {
          fetch('/base/test/fixtures/jsonp/api.github.com/users/ntkme', (error, data) => {
            expect(data.login)
              .to.equal('ntkme')
            resolve()
          })
        }),
        new Promise((resolve, reject) => {
          fetch('/base/test/fixtures/jsonp/api.github.com/users/ntkme', (error, data) => {
            expect(data.login)
              .to.equal('ntkme')
            resolve()
          })
        })
      ]).then(() => {
        expect(head.appendChild)
          .to.be.calledOnce
        done()
      })
    })
  })

  describe('fetch(url, func)', () => {
    beforeEach(() => {
      setUseXHR(false)
      sinon.stub(head, 'appendChild')
    })

    afterEach(() => {
      setUseXHR(true)
      head.appendChild.restore()
    })

    it('should set up the callback function for json-p', () => {
      fetch('hello', () => {})
      expect(window._)
        .to.be.a('function')
    })

    it('should setup the script and add callback query to request url for json-p', () => {
      const url = '/random/url/' + new Date().getTime()
      fetch(url)
      expect(head.appendChild)
        .to.have.been.calledOnce
      expect(head.appendChild.args[0][0])
        .to.have.property('tagName').to.equal('SCRIPT')
      expect(head.appendChild.args[0][0].getAttribute('src'))
        .to.equal(url + '?callback=_')
    })

    it('should append callback query to request url with existing query for json-p', () => {
      const url = '/random/url?query=' + new Date().getTime()
      fetch(url)
      expect(head.appendChild.args[0][0].getAttribute('src'))
        .to.equal(url + '&callback=_')
    })

    it('should clean up and run callback when request is fulfilled for json-p', (done) => {
      const response = {
        meta: {
          status: 200
        },
        data: {
          test: 'test'
        }
      }
      fetch('world', (error, json) => {
        expect(window._)
          .to.be.null
        expect(error)
          .to.not.be.ok
        expect(json)
          .to.deep.equal(response.data)
        done()
      })
      window._(response)
    })

    it('should clean up when request is failed for json-p', (done) => {
      fetch('fail2', (error, json) => {
        expect(error)
          .to.be.ok
        expect(json)
          .to.be.undefined
        done()
      })
      head.appendChild.args[0][0].dispatchEvent(new CustomEvent('error'))
    })

    it('should clean up when request is failed with non 200 status for json-p', (done) => {
      const response = {
        meta: {
          status: 500
        }
      }
      fetch('fail', (error, json) => {
        expect(error)
          .to.be.ok
        expect(json)
          .to.be.undefined
        done()
      })
      window._(response)
    })
  })
})
