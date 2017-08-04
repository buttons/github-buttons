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

onceScriptLoad = (script, func) ->
  token = 0
  callback = ->
    func() if !token and token = 1
    return
  onEvent script, "load", callback
  onEvent script, "error", callback
  ### istanbul ignore next: IE lt 9 ###
  onEvent script, "readystatechange", ->
    unless /i/.test script.readyState
      callback()
    return
  return

export {
  onEvent
  onceEvent
  onceScriptLoad
}
