if CONFIG_SCRIPT
  if document.querySelectorAll
    anchors = document.querySelectorAll "a.#{CONFIG_ANCHOR_CLASS}"
  else
    anchors =
      anchor for anchor in document.getElementsByTagName "a" when new Element(anchor).hasClass CONFIG_ANCHOR_CLASS

  for anchor in anchors
    do (a = anchor) ->
      new ButtonFrame Hash.encode(ButtonAnchor.parse a), (iframe) ->
        document.body.appendChild iframe
        return
      , (iframe) ->
        a.parentNode.replaceChild iframe, a
        return
      return
else
  new ButtonFrameContent Hash.decode()
