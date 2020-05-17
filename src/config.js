import {
  name,
  version
} from '../package'
import {
  HTMLElement,
  XMLHttpRequest
} from './globals'

export const buttonClass = 'github-button'

export let iframeURL = 'https://' + (/* istanbul ignore next */ process.env.NODE_ENV === 'production' ? 'unpkg.com/' + name + '@' + version + '/dist' : 'buttons.github.io') + '/buttons.html'

export const setIframeURL = /* istanbul ignore next */ function (url) {
  iframeURL = url
}

export let apiBaseURL = 'https://api.github.com'

export const setApiBaseURL = /* istanbul ignore next */ function (url) {
  apiBaseURL = url
}

export let useXHR = XMLHttpRequest && XMLHttpRequest.prototype && 'withCredentials' in XMLHttpRequest.prototype

export const setUseXHR = /* istanbul ignore next */ function (boolean) {
  useXHR = boolean && XMLHttpRequest && XMLHttpRequest.prototype && 'withCredentials' in XMLHttpRequest.prototype
}

export let useShadowDOM = useXHR && HTMLElement && HTMLElement.prototype.attachShadow && !HTMLElement.prototype.attachShadow.prototype

export const setUseShadowDOM = /* istanbul ignore next */ function (boolean) {
  useShadowDOM = boolean && HTMLElement && HTMLElement.prototype.attachShadow && !HTMLElement.prototype.attachShadow.prototype
}
