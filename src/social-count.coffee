import {
  apiBaseURL
} from "./config"
import {
  createElement
  createTextNode
} from "./alias"
import {
  fetch
} from "./fetch"

renderSocialCount = (button) ->
  return unless button.hostname is "github.com"

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

  return unless match and not match[6]

  if match[2]
    href = "/#{match[1]}/#{match[2]}"
    api = "repos#{href}"
    if match[3]
      property = "subscribers_count"
      href += "/watchers"
    else if match[4]
      property = "forks_count"
      href += "/network"
    else if match[5]
      property = "open_issues_count"
      href += "/issues"
    else
      property = "stargazers_count"
      href += "/stargazers"
  else
    api = "users/#{match[1]}"
    property = "followers"
    href = "/#{match[1]}/#{property}"

  fetch "#{apiBaseURL}#{api}", (error, json) ->
    if !error
      data = json[property]

      a = createElement "a"
      a.href = "https://github.com" + href
      a.className = "social-count"
      a.setAttribute "aria-label", "#{data} #{property.replace(/_count$/, "").replace("_", " ")} on GitHub"
      a.appendChild createElement "b"
      a.appendChild createElement "i"
      span = a.appendChild createElement "span"
      span.appendChild createTextNode "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
      button.parentNode.insertBefore a, button.nextSibling
    return
  return

export {
  renderSocialCount
}
