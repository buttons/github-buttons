import { Math } from './globals'
import { ceilPixel } from './pixel'

export const get = function (el) {
  let width = el.scrollWidth
  let height = el.scrollHeight
  if (el.getBoundingClientRect) {
    let boundingClientRect = el.getBoundingClientRect()
    width = Math.max(width, ceilPixel(boundingClientRect.width || boundingClientRect.right - boundingClientRect.left))
    height = Math.max(height, ceilPixel(boundingClientRect.height || boundingClientRect.bottom - boundingClientRect.top))
  }
  return [width, height]
}

export const set = function (el, size) {
  el.style.width = size[0] + 'px'
  el.style.height = size[1] + 'px'
}
