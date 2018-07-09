import css from "../assets/css/buttons.css"
import {
  createElement
  createTextNode
} from "./alias"

render = (root) ->
  style = createElement "style"
  style.type = "text/css"
  root.appendChild style

  ### istanbul ignore if ###
  if style.styleSheet
    style.styleSheet.cssText = css
  else
    style.appendChild createTextNode css

  return

export {
  render
}
