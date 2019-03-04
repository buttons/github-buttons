import { onceEvent, onceReadyStateChange } from './event'
import { document } from './globals'
import { dispatchOnce } from './util'

export const defer = function (func) {
  /* istanbul ignore else */
  if (/m/.test(document.readyState) || /* istanbul ignore next */ (!/g/.test(document.readyState) && !document.documentElement.doScroll)) {
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
