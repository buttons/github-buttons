import {
  document
} from "./alias"

buttonClass = "github-button"
uuid = "faa75404-3b97-5585-b449-4bc51338fbd1"

isInFrame = document.title is uuid

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
  isInFrame
  baseURL
  apiBaseURL
  setBaseURL
  setApiBaseURL
}
