import {
  document
} from "./alias"
import {
  render as renderStyle
} from "./style"
import {
  render as renderButton
} from "./button"
import {
  render as renderSocialCount
} from "./social-count"

render = (root, options, callback) ->
  return unless options

  renderStyle root

  container = root.appendChild document.createElement "div"
  container.className = "widget" + (if /^large$/i.test options["data-size"] then " large" else "")
  button = renderButton container, options
  if /^(true|1)$/i.test options["data-show-count"]
    renderSocialCount.call @, button, ->
      callback container if callback
      return
  else
    callback container if callback
  return

export {
  render
}
