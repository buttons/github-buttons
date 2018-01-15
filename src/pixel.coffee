import {
  Math
} from "./alias"

### istanbul ignore next ###
devicePixelRatio = window.devicePixelRatio or 1

setDevicePixelRatio = (ratio) ->
  devicePixelRatio = ratio

ceilPixel = (px) ->
  (if devicePixelRatio > 1 then Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 else Math.ceil(px)) or 0

export {
  setDevicePixelRatio
  ceilPixel
}
