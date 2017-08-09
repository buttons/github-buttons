import {
  document
} from "./alias"
import {
  renderButton
} from "./button"
import {
  renderSocialCount
} from "./social-count"

renderFrameContent = (options) ->
  return unless options
  document.body.className = "large" if /^large$/i.test options["data-size"]
  button = renderButton options
  renderSocialCount button if /^(true|1)$/i.test options["data-show-count"]
  return

export {
  renderFrameContent
}
