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

jsonp = (url, func) ->
  script = createElement "script"
  script.async = true
  script.src = url + (if /\?/.test url then "&" else "?") + "callback=_"

  window._ = (json) ->
    _._ null, json
    return

  _._ = ->
    func.apply (window._ = null), arguments
    return

  onceToken = 0
  onceError = ->
    if !onceToken and onceToken = 1
      _._ onceToken
    return

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
  jsonp
}
