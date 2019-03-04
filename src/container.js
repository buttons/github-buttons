import { document } from './globals'
import { createElement } from './util'
import { iframeURL, useShadowDOM } from './config'
import { onceEvent } from './event'
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
      title: options.title || void 0
    })
    renderContent(host.attachShadow({ mode: 'closed' }), options, function () {
      func(host)
    })
  } else {
    const iframe = createElement('iframe', {
      src: 'javascript:0',
      title: options.title || void 0,
      allowtransparency: true,
      scrolling: 'no',
      frameBorder: 0
    })
    setSize(iframe, [1, 0])
    iframe.style.border = 'none'
    onceEvent(iframe, 'load', function () {
      const contentWindow = iframe.contentWindow
      renderContent.call(contentWindow, contentWindow.document.body, options, function (widget) {
        const size = getSize(widget)
        iframe.parentNode.removeChild(iframe)
        onceEvent(iframe, 'load', function () {
          setSize(iframe, size)
        })
        iframe.src = iframeURL + '#' + stringifyQueryString(options)
        func(iframe)
      })
    })
    document.body.appendChild(iframe)
  }
}
