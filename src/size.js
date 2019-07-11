import { Math } from './globals'
import { ceilPixel } from './pixel'

export const get = function (el) {
  let width = el.offsetWidth
  let height = el.offsetHeight
  if (el.getBoundingClientRect) {
    const boundingClientRect = el.getBoundingClientRect()
    width = Math.max(width, ceilPixel(boundingClientRect.width))
    height = Math.max(height, ceilPixel(boundingClientRect.height))
  }
  return [width, height]
}

export const set = function (el, size) {
  el.style.width = size[0] + 'px'
  el.style.height = size[1] + 'px'
}
