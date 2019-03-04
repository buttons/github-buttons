import { Math } from './globals'

let devicePixelRatio = window.devicePixelRatio || /* istanbul ignore next */ 1

export const setDevicePixelRatio = function (ratio) {
  devicePixelRatio = ratio
}

export const ceilPixel = function (px) {
  return (devicePixelRatio > 1 ? Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 : Math.ceil(px)) || 0
}
