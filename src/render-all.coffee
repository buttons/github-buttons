import {
  document
} from "./alias"
import {
  buttonClass
} from "./config"
import {
  render
} from "./render"

### istanbul ignore next ###
renderAll = ->
  anchors = []
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{buttonClass}"
  else
    for anchor in document.getElementsByTagName "a"
      if ~" #{anchor.className} ".replace(/[ \t\n\f\r]+/g, " ").indexOf(" #{buttonClass} ")
        anchors.push anchor
  render anchor for anchor in anchors
  return

export {
  renderAll
}
