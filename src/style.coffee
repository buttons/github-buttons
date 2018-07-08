import css from "../assets/css/buttons.css"
import {
  document
} from "./alias"

render = (root) ->
  style = document.createElement "style"
  style.type = "text/css"
  root.appendChild style

  ### istanbul ignore if ###
  if style.styleSheet
    style.styleSheet.cssText = css
  else
    style.appendChild document.createTextNode css

  return

export {
  render
}
