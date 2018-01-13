import {
  document
} from "./alias"

buttonClass = "github-button"
uuid = "faa75404-3b97-5585-b449-4bc51338fbd1"

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
  uuid
  baseURL
  apiBaseURL
  setBaseURL
  setApiBaseURL
}
