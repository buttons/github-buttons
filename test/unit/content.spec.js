import {
  render
} from '@/content'

import {
  setApiBaseURL
} from '@/config'

setApiBaseURL('/base/test/fixtures/xhr/api.github.com')

describe('Content', () => {
  let root

  beforeEach(() => {
    root = document.body.appendChild(document.createElement('div'))
  })

  afterEach(() => {
    root.parentNode.removeChild(root)
    root = null
  })

  describe('render(root, config, callback)', () => {
    it('should work', (done) => {
      render(root, {}, () => done())
    })

    it('should render stylesheet', (done) => {
      render(root, {}, () => {
        expect(root.querySelector('style'))
          .to.be.an.instanceof(HTMLElement)
        done()
      })
    })

    it('should create a widget with className widget', (done) => {
      render(root, {}, () => {
        expect(root.querySelector('.widget'))
          .to.be.an.instanceof(HTMLElement)
        expect(root.querySelector('.widget.widget-lg'))
          .to.be.null
        done()
      })
    })

    it('should add widget-lg to widget.className when data-size is large', (done) => {
      render(root, {
        'data-size': 'large'
      }, () => {
        expect(root.querySelector('.widget.widget-lg'))
          .to.be.an.instanceof(HTMLElement)
        done()
      })
    })

    it('should append the button to widget when the necessary config is given', (done) => {
      render(root, {}, () => {
        expect(root.querySelector('.btn'))
          .to.be.an.instanceof(HTMLElement)
        done()
      })
    })

    it('should callback with widget', (done) => {
      render(root, {}, (widget) => {
        expect(widget)
          .to.be.an.instanceof(HTMLElement)
        done()
      })
    })

    it('should append the button with given href', (done) => {
      const config = {
        href: 'https://ntkme.github.com/'
      }
      render(root, config, () => {
        expect(root.querySelector('.btn').getAttribute('href'))
          .to.equal(config.href)
        done()
      })
    })

    it('should append the button with given href if hostname is FQDN', (done) => {
      const config = {
        href: 'https://github.com./ntkme'
      }
      render(root, config, () => {
        expect(root.querySelector('.btn').getAttribute('href'))
          .to.equal(config.href)
        done()
      })
    })

    it('should create an anchor with href # if hostname is not under github.com', (done) => {
      render(root, {
        href: 'https://twitter.com/ntkme'
      }, () => {
        expect(root.querySelector('.btn').href)
          .to.equal(document.location.href + '#')
        expect(root.querySelector('.btn').target)
          .to.equal('_self')
        done()
      })
    })

    it('should create an anchor with href # if url contains javascript', (done) => {
      Promise.all([
        'javascript:',
        'JAVASCRIPT:',
        'JavaScript:',
        ' javascript:',
        '   javascript:',
        '\tjavascript:',
        '\njavascript:',
        '\rjavascript:',
        '\fjavascript:'
      ].map(href => new Promise(resolve => {
        render(root, {
          href
        }, (widget) => {
          expect(widget.querySelector('.btn').href)
            .to.equal(document.location.href + '#')
          expect(widget.querySelector('.btn').target)
            .to.equal('_self')
          resolve()
        })
      })))
        .then(() => done())
    })

    it('should create an anchor with target _top if url is a download link', (done) => {
      Promise.all([
        'https://github.com/ntkme/github-buttons/archive/master.zip',
        'https://codeload.github.com/ntkme/github-buttons/zip/master',
        'https://github.com/octocat/Hello-World/releases/download/v1.0.0/example.zip'
      ].map(href => new Promise(resolve => {
        render(root, {
          href
        }, (widget) => {
          expect(widget.querySelector('.btn').href)
            .to.equal(href)
          expect(widget.querySelector('.btn').target)
            .to.equal('_top')
          resolve()
        })
      })))
        .then(() => done())
    })

    it('should append the button with the default icon', (done) => {
      render(root, {}, () => {
        expect(root.querySelector('.btn').querySelector('.octicon.octicon-mark-github'))
          .to.be.an.instanceof(SVGElement)
        done()
      })
    })

    it('should append the button with given icon', (done) => {
      render(root, {
        'data-icon': 'octicon-star'
      }, () => {
        expect(root.querySelector('.btn').querySelector('.octicon.octicon-star'))
          .to.be.an.instanceof(SVGElement)
        done()
      })
    })

    it('should append the button with the default if given icon is invalid', (done) => {
      render(root, {
        'data-icon': 'null'
      }, () => {
        expect(root.querySelector('.btn').querySelector('.octicon.octicon-mark-github'))
          .to.be.an.instanceof(SVGElement)
        done()
      })
    })

    it('should append the button with given text', (done) => {
      const config = {
        'data-text': 'Follow'
      }
      render(root, config, () => {
        expect(root.querySelector('.btn').lastChild.textContent)
          .to.equal(config['data-text'])
        done()
      })
    })

    it('should append the button with given aria label', (done) => {
      const config = {
        'aria-label': 'GitHub'
      }
      render(root, config, () => {
        expect(root.querySelector('.btn').getAttribute('aria-label'))
          .to.equal(config['aria-label'])
        done()
      })
    })

    it('should append the count when a known button type is given', (done) => {
      const config = {
        href: 'https://github.com/ntkme',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        expect(widget.querySelector('.social-count'))
          .to.be.an.instanceof(HTMLElement)
        done()
      })
    })

    it('should append the count for follow button', (done) => {
      const config = {
        href: 'https://github.com/ntkme',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        expect(count.textContent)
          .to.equal('78')
        expect(count.getAttribute('aria-label'))
          .to.equal('78 followers on GitHub')
        done()
      })
    })

    it('should append the count for watch button', (done) => {
      const config = {
        href: 'https://github.com/ntkme/github-buttons/subscription',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/github-buttons/watchers')
        expect(count.textContent)
          .to.equal('36')
        expect(count.getAttribute('aria-label'))
          .to.equal('36 subscribers on GitHub')
        done()
      })
    })

    it('should append the count for star button', (done) => {
      const config = {
        href: 'https://github.com/ntkme/github-buttons',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/github-buttons/stargazers')
        expect(count.textContent)
          .to.equal('546')
        expect(count.getAttribute('aria-label'))
          .to.equal('546 stargazers on GitHub')
        done()
      })
    })

    it('should append the count for fork button', (done) => {
      const config = {
        href: 'https://github.com/ntkme/github-buttons/fork',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/github-buttons/network/members')
        expect(count.textContent)
          .to.equal('94')
        expect(count.getAttribute('aria-label'))
          .to.equal('94 forks on GitHub')
        done()
      })
    })

    it('should append the count for issue button', (done) => {
      const config = {
        href: 'https://github.com/ntkme/github-buttons/issues',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/github-buttons/issues')
        expect(count.textContent)
          .to.equal('1')
        expect(count.getAttribute('aria-label'))
          .to.equal('1 open issue on GitHub')
        done()
      })
    })

    it('should append the count for issue button when it links to new issue', (done) => {
      const config = {
        href: 'https://github.com/ntkme/github-buttons/issues/new',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/github-buttons/issues')
        expect(count.textContent)
          .to.equal('1')
        expect(count.getAttribute('aria-label'))
          .to.equal('1 open issue on GitHub')
        done()
      })
    })

    it('should append the count for button whose link has a tailing slash', (done) => {
      const config = {
        href: 'https://github.com/ntkme/',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        done()
      })
    })

    it('should append the count for button whose link has a query', (done) => {
      const config = {
        href: 'https://github.com/ntkme?tab=repositories',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        done()
      })
    })

    it('should append the count for button whose link has a hash', (done) => {
      const config = {
        href: 'https://github.com/ntkme#github-buttons',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        done()
      })
    })

    it('should append the count for button whose link has both a tailing slash and a query', (done) => {
      const config = {
        href: 'https://github.com/ntkme/?tab=repositories',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        done()
      })
    })

    it('should append the count for button whose link has both a tailing slash and a hash', (done) => {
      const config = {
        href: 'https://github.com/ntkme/#github-buttons',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        done()
      })
    })

    it('should append the count for button whose link has a tailing slash, a query, and a hash', (done) => {
      const config = {
        href: 'https://github.com/ntkme/?tab=repositories#github-buttons',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const count = widget.querySelector('.social-count')
        expect(count.href)
          .to.equal('https://github.com/ntkme/followers')
        done()
      })
    })

    it('should not append the count for unknown button type', (done) => {
      const config = {
        href: 'https://github.com/',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        expect(widget.querySelector('.social-count'))
          .to.be.null
        done()
      })
    })

    it('should append button without count when count has error', (done) => {
      const config = {
        href: 'https://github.com/404',
        'data-show-count': 'true'
      }
      render(root, config, (widget) => {
        const btn = widget.querySelector('.btn')
        expect(btn.href)
          .to.equal(config.href)
        expect(widget.querySelector('.social-count'))
          .to.be.null
        done()
      })
    })
  })
})
