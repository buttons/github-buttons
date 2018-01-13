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
  if window.XMLHttpRequest
    xhr = new XMLHttpRequest()
    ### istanbul ignore if ###
    xhr = null unless "withCredentials" of xhr

  window._ = (json) ->
    if xhr
      _._ null, json
    else if json.meta.status is 200
      _._ null, json.data
    else
      onceError()
    return

  _._ = ->
    func.apply (window._ = null), arguments
    return

  onceToken = 0
  onceError = ->
    if !onceToken and onceToken = 1
      _._ onceToken
    return

  if xhr
    onEvent xhr, "error", onceError

    onEvent xhr, "load", ->
      window._ JSON.parse xhr.responseText if xhr.readyState is xhr.DONE and xhr.status is 200
      return

    xhr.open "GET", url
    xhr.send()
  else
    script = createElement "script"
    script.async = true
    script.src = url + (if /\?/.test url then "&" else "?") + "callback=_"

    onEvent script, "error", onceError

    if script.readyState
      ### istanbul ignore next: IE lt 9 ###
      onEvent script, "readystatechange", ->
        if script.readyState is "loaded" and window._?
          onceError()
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
