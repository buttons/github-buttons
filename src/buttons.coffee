if Config.script
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{Config.anchorClass}"
  else
    anchors =
      anchor for anchor in document.getElementsByTagName "a" when Element.prototype.hasClass.call element: anchor, Config.anchorClass

  for anchor in anchors
    do (a = anchor) ->
      new Frame Hash.encode(Anchor.parse a), (iframe) ->
        a.parentNode.insertBefore iframe, a
        return
      , ->
        a.parentNode.removeChild a
        return
      return
else
  new FrameContent Hash.decode()
