import {
  document
  createElement
} from "./alias"
import {
  onEvent
  onceScriptError
} from "./event"
import {
  defer
} from "./defer"

jsonp = (url, func) ->
  script = createElement "script"
  script.async = true
  script.src = url + (if /\?/.test url then "&" else "?") + "callback=_"

  window._ = (json) ->
    window._._ null, json
    return

  onceScriptError script, (error) ->
    window._._ error
    return

  window._._ = ->
    func.apply (window._ = null), arguments
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
