import {
  document
  location
} from "./alias"
import {
  baseURL
  htmlPath
  setBaseURL
} from "./config"
import {
  currentScriptURL
} from "./current-script"
import {
  parse as parseQueryString
} from "./querystring"
import {
  defer
} from "./defer"
import {
  render as renderContainer
} from "./container"
import {
  render as renderContent
} from "./content"
import {
  render as batchRender
} from "./batch"

if typeof define is "function" and define.amd
  define [], { render: renderContainer }
else if typeof exports is "object" and typeof exports.nodeName isnt "string"
  exports.render = renderContainer
else
  if process.env.NODE_ENV isnt "production"
    setBaseURL currentScriptURL.replace /\/[^/]*([?#].*)?$/, "" if currentScriptURL

  if location.protocol + "//" + location.host + location.pathname is baseURL + htmlPath
    renderContent document.body, parseQueryString location.hash.replace /^#/, ""
  else
    defer batchRender
