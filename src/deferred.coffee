class Deferred
  constructor: (func) ->
    if /m/.test(document.readyState) or (!/g/.test(document.readyState) and !document.documentElement.doScroll)
      window.setTimeout func
    else
      if document.addEventListener
        new EventTarget document
          .once "DOMContentLoaded", func
      else
        callback = ->
          if /m/.test document.readyState
            document.detachEvent "onreadystatechange", callback
            func() if func
          return
        document.attachEvent "onreadystatechange", callback
