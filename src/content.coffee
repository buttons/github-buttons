import {
  document
} from "./alias"
import {
  render as renderButton
} from "./button"
import {
  render as renderSocialCount
} from "./social-count"

render = (root, options) ->
  return unless options
  root.className = "large" if /^large$/i.test options["data-size"]
  button = renderButton root, options
  renderSocialCount button if /^(true|1)$/i.test options["data-show-count"]
  return

export {
  render
}
