onEvent = (target, eventName, func) ->
  ### istanbul ignore else: IE lt 9 ###
  if target.addEventListener
    target.addEventListener "#{eventName}", func
  else
    target.attachEvent "on#{eventName}", func
  return

onceEvent = (target, eventName, func) ->
  callback = (event) ->
    ### istanbul ignore else: IE lt 9 ###
    if target.removeEventListener
      target.removeEventListener "#{eventName}", callback
    else
      target.detachEvent "on#{eventName}", callback
    func event
  onEvent target, eventName, callback
  return

onceScriptError = (script, func) ->
  token = 0
  callback = ->
    if !token and token = 1
      func token
    return

  onEvent script, "error", callback

  if script.readyState
    ### istanbul ignore next: IE lt 9 ###
    onEvent script, "readystatechange", ->
      callback() if script.readyState is "loaded" and script.children and script.readyState is "loading"
      return
  return

export {
  onEvent
  onceEvent
  onceScriptError
}
