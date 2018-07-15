import {
  document
} from "./alias"

buttonClass = "github-button"

### istanbul ignore next ###
baseURL = "#{if /^http:/.test document.location then "http" else "https"}://buttons.github.io/"

apiBaseURL = "https://api.github.com/"

setBaseURL = (url) ->
  baseURL = url
  return

setApiBaseURL = (url) ->
  apiBaseURL = url
  return

export {
  buttonClass
  baseURL
  apiBaseURL
  setBaseURL
  setApiBaseURL
}
