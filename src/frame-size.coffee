import {
  Math
} from "./alias"
import {
  ceilPixel
} from "./pixel"

getFrameContentSize = (iframe) ->
  contentDocument = iframe.contentWindow.document
  html = contentDocument.documentElement
  body = contentDocument.body
  width = html.scrollWidth
  height = html.scrollHeight
  if body.getBoundingClientRect
    body.style.display = "inline-block"
    boundingClientRect = body.getBoundingClientRect()
    width = Math.max width, ceilPixel boundingClientRect.width or boundingClientRect.right - boundingClientRect.left
    height = Math.max height, ceilPixel boundingClientRect.height or boundingClientRect.bottom - boundingClientRect.top
    body.style.display = ""
  [width, height]

setFrameSize = (iframe, size) ->
  iframe.style.width = "#{size[0]}px"
  iframe.style.height = "#{size[1]}px"
  return

export {
  getFrameContentSize
  setFrameSize
}
