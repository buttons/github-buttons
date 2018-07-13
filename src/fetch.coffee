import {
  document
  createElement
} from "./alias"
import {
  onEvent
} from "./event"
import {
  defer
} from "./defer"

fetch = (url, func) ->
  global = @ or window

  onceToken = 0
  callback = ->
    if !onceToken and onceToken = 1
      func.apply null, arguments
    return

  if (XMLHttpRequest = window.XMLHttpRequest) and "withCredentials" of XMLHttpRequest::
    xhr = new XMLHttpRequest()

    onEvent xhr, "abort", callback
    onEvent xhr, "error", callback
    onEvent xhr, "load", ->
      callback xhr.status isnt 200, JSON.parse xhr.responseText
      return

    xhr.open "GET", url
    xhr.send()
  else
    global._ = (json) ->
      global._ = null
      callback json.meta.status isnt 200, json.data
      return

    script = createElement "script"
    script.async = true
    script.src = url + (if /\?/.test url then "&" else "?") + "callback=_"

    onloadend = ->
      global._ meta: {} if global._
      return

    onEvent script, "error", onloadend

    if script.readyState
      ### istanbul ignore next: IE lt 9 ###
      onEvent script, "readystatechange", ->
        onloadend() if script.readyState is "loaded"
        return

    global.document.getElementsByTagName("head")[0].appendChild script
  return

export {
  fetch
}
