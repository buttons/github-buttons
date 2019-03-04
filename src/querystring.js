import {
  encodeURIComponent,
  decodeURIComponent
} from './globals'

export const stringify = function (obj) {
  const params = []
  for (let name in obj) {
    const value = obj[name]
    if (value != null) {
      params.push(encodeURIComponent(name) + '=' + encodeURIComponent(value))
    }
  }
  return params.join('&')
}

export const parse = function (str) {
  const obj = {}
  const params = str.split('&')
  for (let i = 0, len = params.length; i < len; i++) {
    const entry = params[i]
    if (entry !== '') {
      const ref = entry.split('=')
      obj[decodeURIComponent(ref[0])] = (ref[1] != null ? decodeURIComponent(ref.slice(1).join('=')) : void 0)
    }
  }
  return obj
}
