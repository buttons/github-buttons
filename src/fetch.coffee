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
  window.$ = ->
    window.$ = null
    return

  onceToken = 0
  callback = ->
    if !onceToken and onceToken = 1
      func.apply null, arguments
      $()
    return

  if window.XMLHttpRequest and "withCredentials" of XMLHttpRequest.prototype
    xhr = new XMLHttpRequest()

    onEvent xhr, "abort", callback
    onEvent xhr, "error", callback
    onEvent xhr, "load", ->
      callback xhr.status isnt 200, JSON.parse xhr.responseText
      return

    xhr.open "GET", url
    xhr.send()
  else
    window._ = (json) ->
      window._ = null
      callback json.meta.status isnt 200, json.data
      return

    script = createElement "script"
    script.async = true
    script.src = url + (if /\?/.test url then "&" else "?") + "callback=_"

    onEvent script, "error", callback

    if script.readyState
      ### istanbul ignore next: IE lt 9 ###
      onEvent script, "readystatechange", ->
        if script.readyState is "loaded" and window._?
          callback 1
        return

    head = document.getElementsByTagName("head")[0]
    ### istanbul ignore if: Presto based Opera ###
    if "[object Opera]" is {}.toString.call window.opera
      defer ->
        head.appendChild script
        return
    else
      head.appendChild script
  return

export {
  fetch
}
