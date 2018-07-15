import {
  document
} from "./alias"
import {
  baseURL
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
  setBaseURL currentScriptURL.replace /[^/]*([?#].*)?$/, "" if currentScriptURL

  if baseURL + "buttons.html" is document.location.href.replace /[?#].*$/, ""
    renderContent document.body, parseQueryString document.location.hash.replace /^#/, ""
  else
    defer batchRender
