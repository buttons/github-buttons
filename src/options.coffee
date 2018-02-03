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

  deprecate = (oldAttribute, newAttribute, newValue) ->
    if anchor.getAttribute oldAttribute
      options[newAttribute] = newValue
      window.console and console.warn "GitHub Buttons deprecated `#{oldAttribute}`: use `#{newAttribute}=\"#{newValue}\"` instead. Please refer to https://github.com/ntkme/github-buttons#readme for more info."
    return
  deprecate "data-count-api", "data-show-count", "true"
  deprecate "data-style", "data-size", "large"

  options
