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
    window._ = null
    func json
    return
  window._.$ = script

  onEvent script, "error", ->
    window._ = null
    return

  if script.readyState
    ### istanbul ignore next: IE lt 9 ###
    onEvent script, "readystatechange", ->
      window._ = null if script.readyState is "loaded" and script.children and script.readyState is "loading"
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
