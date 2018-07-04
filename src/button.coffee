import {
  document
  createElement
  createTextNode
} from "./alias"
import {
  octicon
} from "./octicons"

render = (root, options) ->
  a = createElement "a"
  a.href = options.href
  a.target = "_blank"

  if not /\.github\.com$/.test ".#{a.hostname}"
    a.href = "#"
    a.target = "_self"
  else if ///
    ^https?://(
      (gist\.)?github\.com/[^/?#]+/[^/?#]+/archive/ |
      github\.com/[^/?#]+/[^/?#]+/releases/download/ |
      codeload\.github\.com/
    )
  ///.test a.href
    a.target = "_top"

  a.className = "btn"
  a.setAttribute "aria-label", ariaLabel if ariaLabel = options["aria-label"]
  a.innerHTML = octicon options["data-icon"], if /^large$/i.test options["data-size"] then 16 else 14
  a.appendChild createTextNode " "
  span = a.appendChild createElement "span"
  span.appendChild createTextNode options["data-text"] or ""
  root.appendChild a

export {
  render
}
