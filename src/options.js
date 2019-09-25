export const parseOptions = function (anchor) {
  const options = {
    href: anchor.href,
    title: anchor.title,
    'aria-label': anchor.getAttribute('aria-label')
  }
  const ref = ['icon', 'color-scheme', 'text', 'size', 'show-count']
  for (let i = 0, len = ref.length; i < len; i++) {
    const attribute = 'data-' + ref[i]
    options[attribute] = anchor.getAttribute(attribute)
  }
  if (options['data-text'] == null) {
    options['data-text'] = anchor.textContent || anchor.innerText
  }
  return options
}
