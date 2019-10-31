import { document } from './globals'
import { createElement } from './util'
import { iframeURL, useShadowDOM } from './config'
import { onEvent, offEvent, onceEvent } from './event'
import { parseOptions } from './options'
import { render as renderContent } from './content'
import { stringify as stringifyQueryString } from './querystring'
import { get as getSize, set as setSize } from './size'

export const render = function (options, func) {
  if (options == null || func == null) {
    return
  }
  if (options.getAttribute) {
    options = parseOptions(options)
  }
  if (useShadowDOM) {
    const host = createElement('span', {
      title: options.title || undefined
    })
    renderContent(host.attachShadow({ mode: process.env.DEBUG ? 'open' : 'closed' }), options, function () {
      func(host)
    })
  } else {
    const iframe = createElement('iframe', {
      src: 'javascript:0',
      title: options.title || undefined,
      allowtransparency: true,
      scrolling: 'no',
      frameBorder: 0
    })
    setSize(iframe, [0, 0])
    iframe.style.border = 'none'
    const callback = function () {
      const contentWindow = iframe.contentWindow
      let body
      try {
        body = contentWindow.document.body
      } catch (_) /* istanbul ignore next: IE 11 */ {
        document.body.appendChild(iframe.parentNode.removeChild(iframe))
        return
      }
      offEvent(iframe, 'load', callback)
      renderContent.call(contentWindow, body, options, function (widget) {
        const size = getSize(widget)
        iframe.parentNode.removeChild(iframe)
        onceEvent(iframe, 'load', function () {
          setSize(iframe, size)
        })
        iframe.src = iframeURL + '#' + (iframe.name = stringifyQueryString(options))
        func(iframe)
      })
    }
    onEvent(iframe, 'load', callback)
    document.body.appendChild(iframe)
  }
}
