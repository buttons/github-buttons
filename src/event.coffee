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

export {
  onEvent
  onceEvent
}
