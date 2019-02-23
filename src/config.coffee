import {
  name,
  version
} from "../package"
import {
  document
  location
} from "./alias"

buttonClass = "github-button"

### istanbul ignore next ###
iframeURL = "#{if /^http:/.test location then "http" else "https"}://#{if process.env.NODE_ENV is "production" then "unpkg.com/" + name + "@" + version + "/dist" else "buttons.github.io"}/buttons.html"

apiBaseURL = "https://api.github.com"

setApiBaseURL = (url) ->
  apiBaseURL = url
  return

export {
  buttonClass
  iframeURL
  apiBaseURL
  setApiBaseURL
}
