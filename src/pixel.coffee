import {
  Math
} from "./alias"

export ceilPixel = (px) ->
  devicePixelRatio = window.devicePixelRatio or 1
  (if devicePixelRatio > 1 then Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 else Math.ceil(px)) or 0
