import {
  apiBaseURL
} from "./config"
import {
  document
  createElement
  createTextNode
} from "./alias"
import {
  fetch
} from "./fetch"

render = (button, func) ->
  callback = ->
    func() if func
    return

  return callback() unless button.hostname is "github.com"

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
    api = "repos/#{match[1]}/#{match[2]}"
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
    api = "users/#{match[1]}"
    href = property = "followers"

  fetch.call @, apiBaseURL + api, (error, json) ->
    if !error
      data = json[property]

      a = createElement "a"
      a.href = json.html_url + "/" + href
      a.target = "_blank"
      a.className = "social-count"
      a.setAttribute "aria-label", "#{data} #{property.replace(/_count$/, "").replace("_", " ")} on GitHub"
      a.appendChild createElement "b"
      a.appendChild createElement "i"
      span = a.appendChild createElement "span"
      span.appendChild createTextNode "#{data}".replace /\B(?=(\d{3})+(?!\d))/g, ","
      button.parentNode.insertBefore a, button.nextSibling
    callback()
    return
  return

export {
  render
}
