import {
  document
  location
} from "./alias"

buttonClass = "github-button"

### istanbul ignore next ###
baseURL = "#{if /^http:/.test location then "http" else "https"}://buttons.github.io"

htmlPath = "/buttons.html"

apiBaseURL = "https://api.github.com"

setBaseURL = (url) ->
  baseURL = url
  return

setApiBaseURL = (url) ->
  apiBaseURL = url
  return

export {
  buttonClass
  baseURL
  htmlPath
  apiBaseURL
  setBaseURL
  setApiBaseURL
}
