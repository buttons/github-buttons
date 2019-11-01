import {
  document,
  location
} from './globals'
import {
  buttonClass,
  iframeURL
} from './config'
import {
  parse as parseQueryString
} from './querystring'
import {
  defer
} from './defer'
import {
  render as renderContent
} from './content'
import {
  render as renderContainer
} from './container'

if (location.protocol + '//' + location.host + location.pathname === iframeURL) {
  renderContent(document.body, parseQueryString(window.name || location.hash.replace(/^#/, '')), function () {})
} else {
  defer(function () {
    const ref = document.querySelectorAll
      ? document.querySelectorAll('a.' + buttonClass)
      : (function () {
        const results = []
        const ref = document.getElementsByTagName('a')
        for (let i = 0, len = ref.length; i < len; i++) {
          if (~(' ' + ref[i].className + ' ').replace(/[ \t\n\f\r]+/g, ' ').indexOf(' ' + buttonClass + ' ')) {
            results.push(ref[i])
          }
        }
        return results
      })()
    for (let i = 0, len = ref.length; i < len; i++) {
      (function (anchor) {
        renderContainer(anchor, function (el) {
          anchor.parentNode.replaceChild(el, anchor)
        })
      })(ref[i])
    }
  })
}
