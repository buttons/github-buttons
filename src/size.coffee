import {
  Math
} from "./alias"
import {
  ceilPixel
} from "./pixel"

get = (el) ->
  width = el.scrollWidth
  height = el.scrollHeight
  if el.getBoundingClientRect
    boundingClientRect = el.getBoundingClientRect()
    width = Math.max width, ceilPixel boundingClientRect.width or boundingClientRect.right - boundingClientRect.left
    height = Math.max height, ceilPixel boundingClientRect.height or boundingClientRect.bottom - boundingClientRect.top
  [width, height]

set = (el, size) ->
  el.style.width = "#{size[0]}px"
  el.style.height = "#{size[1]}px"
  return

export {
  get
  set
}
