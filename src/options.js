import {
  forEach
} from './util'

export const parseOptions = function (anchor) {
  const options = {
    href: anchor.href,
    title: anchor.title,
    'aria-label': anchor.getAttribute('aria-label')
  }

  forEach(['icon', 'color-scheme', 'text', 'size', 'show-count'], function (option) {
    const attribute = 'data-' + option
    options[attribute] = anchor.getAttribute(attribute)
  })

  if (options['data-text'] == null) {
    options['data-text'] = anchor.textContent || anchor.innerText
  }

  return options
}
