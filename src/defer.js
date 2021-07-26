import { onceEvent, onceReadyStateChange } from './event'
import { document } from './globals'
import { dispatchOnce } from './util'

export const defer = /* istanbul ignore next */ function (func) {
  if (document.readyState === 'complete' || (document.readyState !== 'loading' && !document.documentElement.doScroll)) {
    setTimeout(func)
  } else {
    if (document.addEventListener) {
      const callback = dispatchOnce(func)
      onceEvent(document, 'DOMContentLoaded', callback)
      onceEvent(window, 'load', callback)
    } else {
      onceReadyStateChange(document, /m/, func)
    }
  }
}
