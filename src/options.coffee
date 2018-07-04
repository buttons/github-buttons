export parseOptions = (anchor) ->
  options =
    "href": anchor.href
    "title": anchor.title
    "aria-label": anchor.getAttribute "aria-label"
  for attribute in [
    "icon"
    "text"
    "size"
    "show-count"
  ]
    attribute = "data-" + attribute
    options[attribute] = anchor.getAttribute attribute
  if !options["data-text"]?
    options["data-text"] = anchor.textContent or anchor.innerText
  options
