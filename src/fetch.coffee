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

queues = {}

fetch = (url, func) ->
  return if 1 < (queue = (queues[url] ||= [])).push func

  onceToken = 0
  callback = ->
    if !onceToken and onceToken = 1
      delete queues[url]
      func.apply null, arguments while func = queue.shift()
    return

  if (XMLHttpRequest = window.XMLHttpRequest) and "withCredentials" of XMLHttpRequest::
    xhr = new XMLHttpRequest()

    onEvent xhr, "abort", callback
    onEvent xhr, "error", callback
    onEvent xhr, "load", ->
      callback xhr.status isnt 200, try JSON.parse xhr.responseText
      return

    xhr.open "GET", url
    xhr.send()
  else
    contentWindow = @ or window

    contentWindow._ = (json) ->
      contentWindow._ = null
      callback json.meta.status isnt 200, json.data
      return

    script = contentWindow.document.createElement "script"
    script.async = true
    script.src = url + (if /\?/.test url then "&" else "?") + "callback=_"

    onloadend = ->
      contentWindow._ meta: {} if contentWindow._
      return

    onEvent script, "error", onloadend

    if script.readyState
      ### istanbul ignore next: IE lt 9 ###
      onEvent script, "readystatechange", ->
        onloadend() if script.readyState is "loaded"
        return

    contentWindow.document.getElementsByTagName("head")[0].appendChild script
  return

export {
  fetch
}
