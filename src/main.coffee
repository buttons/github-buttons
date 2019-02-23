import {
  document
  location
} from "./alias"
import {
  baseURL
  htmlPath
} from "./config"
import {
  parse as parseQueryString
} from "./querystring"
import {
  defer
} from "./defer"
import {
  render as renderContent
} from "./content"
import {
  render as batchRender
} from "./batch"

if location.protocol + "//" + location.host + location.pathname is baseURL + htmlPath
  renderContent document.body, parseQueryString location.hash.replace /^#/, ""
else
  defer batchRender
