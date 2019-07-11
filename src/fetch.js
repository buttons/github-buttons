import { XMLHttpRequest } from './globals'
import { useXHR } from './config'
import {
  onEvent,
  onceReadyStateChange
} from './event'
import {
  createElementInDocument,
  dispatchOnce
} from './util'

const queues = {}

export const fetch = function (url, func) {
  const queue = queues[url] || (queues[url] = [])
  if (queue.push(func) > 1) {
    return
  }

  const callback = dispatchOnce(function () {
    delete queues[url]
    while ((func = queue.shift())) {
      func.apply(null, arguments)
    }
  })

  if (useXHR) {
    const xhr = new XMLHttpRequest()
    onEvent(xhr, 'abort', callback)
    onEvent(xhr, 'error', callback)
    onEvent(xhr, 'load', function () {
      let data
      try {
        data = JSON.parse(xhr.responseText)
      } catch (error) {
        callback(error)
        return
      }
      callback(xhr.status !== 200, data)
    })
    xhr.open('GET', url)
    xhr.send()
  } else {
    const contentWindow = this || window
    contentWindow._ = function (json) {
      contentWindow._ = null
      callback(json.meta.status !== 200, json.data)
    }
    const script = createElementInDocument(contentWindow.document)('script', {
      async: true,
      src: url + (/\?/.test(url) ? '&' : '?') + 'callback=_'
    })
    const onloadend = /* istanbul ignore next: IE lt 9 */ function () {
      if (contentWindow._) {
        contentWindow._({
          meta: {}
        })
      }
    }
    onEvent(script, 'load', onloadend)
    onEvent(script, 'error', onloadend)
    /* istanbul ignore if: IE lt 9 */
    if (script.readyState) {
      onceReadyStateChange(script, /de|m/, onloadend)
    }
    contentWindow.document.getElementsByTagName('head')[0].appendChild(script)
  }
}
