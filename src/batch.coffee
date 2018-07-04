import {
  document
} from "./alias"
import {
  buttonClass
} from "./config"
import {
  render as renderContainer
} from "./container"

### istanbul ignore next ###
render = ->
  anchors = []
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{buttonClass}"
  else
    for anchor in document.getElementsByTagName "a"
      if ~" #{anchor.className} ".replace(/[ \t\n\f\r]+/g, " ").indexOf(" #{buttonClass} ")
        anchors.push anchor
  renderContainer anchor for anchor in anchors
  return

export {
  render
}
