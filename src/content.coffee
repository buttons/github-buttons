import css from "./buttons.scss"
import {
  octicon
} from "./octicons"
import {
  apiBaseURL
} from "./config"
import {
  fetch
} from "./fetch"

render = (root, options, func) ->
  return unless options

  contentWindow = @
  document = root.ownerDocument
  createElement = (tag) -> document.createElement tag
  createTextNode = (text) -> document.createTextNode text

  style = createElement "style"
  style.type = "text/css"
  root.appendChild style
  ### istanbul ignore if ###
  if style.styleSheet
    style.styleSheet.cssText = css
  else
    style.appendChild createTextNode css

  widget = root.appendChild createElement "div"
  widget.className = "widget" + (if /^large$/i.test options["data-size"] then " large" else "")

  callback = ->
    func widget if func
    return

  button = do ->
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
    widget.appendChild a

  do ->
    return callback() unless /^(true|1)$/i.test(options["data-show-count"]) and button.hostname is "github.com"

    match = button.pathname.replace(/^(?!\/)/, "/").match ///
      ^/([^/?#]+)
      (?:
        /([^/?#]+)
        (?:
          /(?:(subscription)|(fork)|(issues)|([^/?#]+))
        )?
      )?
      (?:[/?#]|$)
    ///

    return callback() unless match and not match[6]

    if match[2]
      api = "/repos/#{match[1]}/#{match[2]}"
      if match[3]
        property = "subscribers_count"
        href = "watchers"
      else if match[4]
        property = "forks_count"
        href = "network"
      else if match[5]
        property = "open_issues_count"
        href = "issues"
      else
        property = "stargazers_count"
        href = "stargazers"
    else
      api = "/users/#{match[1]}"
      href = property = "followers"

    fetch.call contentWindow, apiBaseURL + api, (error, json) ->
      if !error
        data = json[property]

        a = createElement "a"
        a.href = json.html_url + "/" + href
        a.target = "_blank"
        a.className = "social-count"
        a.setAttribute "aria-label", "#{data} #{property.replace(/_count$/, "").replace("_", " ").slice(0, if data < 2 then -1)} on GitHub"
        a.appendChild createElement "b"
        a.appendChild createElement "i"
        span = a.appendChild createElement "span"
        span.appendChild document.createTextNode "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
        button.parentNode.insertBefore a, button.nextSibling
      callback()
      return
    return
  return

export {
  render
}
