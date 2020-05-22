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

export let domain = 'github.com'

export const setDomain = /* istanbul ignore next */ function (hostname) {
  domain = hostname
}

export let apiBaseURL = 'https://api.' + domain

export const setApiBaseURL = /* istanbul ignore next */ function (url) {
  apiBaseURL = url
}

export let useXHR = XMLHttpRequest && 'prototype' in XMLHttpRequest && 'withCredentials' in XMLHttpRequest.prototype

export const setUseXHR = /* istanbul ignore next */ function (boolean) {
  useXHR = boolean && XMLHttpRequest && 'prototype' in XMLHttpRequest && 'withCredentials' in XMLHttpRequest.prototype
}

export let useShadowDOM = useXHR && HTMLElement && 'attachShadow' in HTMLElement.prototype && !('prototype' in HTMLElement.prototype.attachShadow)

export const setUseShadowDOM = /* istanbul ignore next */ function (boolean) {
  useShadowDOM = boolean && HTMLElement && 'attachShadow' in HTMLElement.prototype && !('prototype' in HTMLElement.prototype.attachShadow)
}
