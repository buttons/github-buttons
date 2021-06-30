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
  forEach
} from './util'
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
    const anchors = document.querySelectorAll
      ? document.querySelectorAll('a.' + buttonClass)
      : (function () {
          const results = []
          forEach(document.getElementsByTagName('a'), function (a) {
            if ((' ' + a.className + ' ').replace(/[ \t\n\f\r]+/g, ' ').indexOf(' ' + buttonClass + ' ') !== -1) {
              results.push(a)
            }
          })
          return results
        })()
    forEach(anchors, function (anchor) {
      renderContainer(anchor, function (el) {
        anchor.parentNode.replaceChild(el, anchor)
      })
    })
  })
}
