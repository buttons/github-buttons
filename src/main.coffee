import {
  document
} from "./alias"
import {
  uuid
  setBaseURL
  currentScriptURL
} from "./config"
import {
  parseQueryString
} from "./querystring"
import {
  defer
} from "./defer"
import {
  renderFrameContent
} from "./frame-content"
import {
  render
} from "./render"
import {
  renderAll
} from "./render-all"

if typeof define is "function" and define.amd
  define [], { render: render }
else if typeof exports is "object" and typeof exports.nodeName isnt "string"
  exports.render = render
else
  setBaseURL currentScriptURL.replace /[^/]*([?#].*)?$/, "" if currentScriptURL

  if document.title is uuid
    renderFrameContent parseQueryString document.location.hash.replace /^#/, ""
  else
    defer renderAll
