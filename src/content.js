import { createElementInDocument } from './util'
import {
  buttons as buttonsCssText,
  getColorScheme as getColorSchemeCssText
} from './css'
import { apiBaseURL } from './config'
import { octicon } from './octicons'
import { fetch } from './fetch'

export const render = function (root, options, func) {
  const createElement = createElementInDocument(root.ownerDocument)

  const style = root.appendChild(createElement('style', {
    type: 'text/css'
  }))

  const cssText = buttonsCssText + getColorSchemeCssText(options['data-color-scheme'])

  /* istanbul ignore if: IE lt 9 */
  if (style.styleSheet) {
    style.styleSheet.cssText = cssText
  } else {
    style.appendChild(root.ownerDocument.createTextNode(cssText))
  }

  const btn = createElement('a', {
    className: 'btn',
    href: options.href,
    target: '_blank',
    rel: 'noopener',
    innerHTML: octicon(options['data-icon'], /^large$/i.test(options['data-size']) ? 16 : 14),
    'aria-label': options['aria-label'] || undefined
  }, [
    ' ',
    createElement('span', {}, [options['data-text'] || ''])
  ])

  const widget = root.appendChild(createElement('div', {
    className: 'widget' + (/^large$/i.test(options['data-size']) ? ' widget-lg' : '')
  }, [
    btn
  ]))

  const domain = btn.hostname.split('.').reverse()
  if (domain[0] === '') {
    domain.shift()
  }
  if (domain[0] !== 'com' || domain[1] !== 'github') {
    btn.href = '#'
    btn.target = '_self'
    func(widget)
    return
  }

  const len = domain.length
  const path = (' /' + btn.pathname).split(/\/+/)
  if (((len === 2 || (len === 3 && domain[2] === 'gist')) && path[3] === 'archive') ||
    (len === 2 && path[3] === 'releases' && path[4] === 'download') ||
    (len === 3 && domain[2] === 'codeload')) {
    btn.target = '_top'
  }

  if (!/^true$/i.test(options['data-show-count']) || len !== 2) {
    func(widget)
    return
  }

  let href, property
  if (!path[2] && path[1]) {
    href = property = 'followers'
  } else if (!path[3] && path[2]) {
    property = 'stargazers_count'
    href = 'stargazers'
  } else if (!path[4] && path[3] === 'subscription') {
    property = 'subscribers_count'
    href = 'watchers'
  } else if (!path[4] && path[3] === 'fork') {
    property = 'forks_count'
    href = 'network/members'
  } else if (path[3] === 'issues') {
    property = 'open_issues_count'
    href = 'issues'
  } else {
    func(widget)
    return
  }

  const api = path[2] ? '/repos/' + path[1] + '/' + path[2] : '/users/' + path[1]
  fetch.call(this, apiBaseURL + api, function (error, json) {
    if (!error) {
      const data = json[property]
      widget.appendChild(createElement('a', {
        className: 'social-count',
        href: json.html_url + '/' + href,
        target: '_blank',
        rel: 'noopener',
        'aria-label': data + ' ' + property.replace(/_count$/, '').replace('_', ' ').slice(0, data < 2 ? -1 : undefined) + ' on GitHub'
      }, [
        ('' + data).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      ]))
    }
    func(widget)
  })
}
