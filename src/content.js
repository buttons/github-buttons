import {
  createElementInDocument,
  toLowerCase
} from './util'
import {
  main as buttonsCssText,
  getColorScheme as getColorSchemeCssText
} from './css'
import {
  domain,
  apiBaseURL
} from './config'
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

  const isLarge = toLowerCase(options['data-size']) === 'large'

  const btn = createElement('a', {
    className: 'btn',
    href: options.href,
    rel: 'noopener',
    target: '_blank',
    title: options.title || undefined,
    'aria-label': options['aria-label'] || undefined,
    innerHTML: octicon(options['data-icon'], isLarge ? 16 : 14) + '&nbsp;'
  }, [
    createElement('span', {}, [options['data-text'] || ''])
  ])

  const widget = root.appendChild(createElement('div', {
    className: 'widget' + (isLarge ? ' widget-lg' : '')
  }, [
    btn
  ]))

  const hostname = btn.hostname.replace(/\.$/, '')
  if (('.' + hostname).substring(hostname.length - domain.length) !== ('.' + domain)) {
    btn.removeAttribute('href')
    func(widget)
    return
  }

  const path = (' /' + btn.pathname).split(/\/+/)
  if (((hostname === domain || hostname === 'gist.' + domain) && path[3] === 'archive') ||
    (hostname === domain && path[3] === 'releases' && (path[4] === 'download' || (path[4] === 'latest' && path[5] === 'download'))) ||
    (hostname === 'codeload.' + domain)) {
    btn.target = '_top'
  }

  if (toLowerCase(options['data-show-count']) !== 'true' ||
    hostname !== domain ||
    path[1] === 'marketplace' ||
    path[1] === 'sponsors' ||
    path[1] === 'orgs' ||
    path[1] === 'users' ||
    path[1] === '-') {
    func(widget)
    return
  }

  let href, property
  if (!path[2] && path[1]) {
    property = 'followers'
    href = '?tab=followers'
  } else if (!path[3] && path[2]) {
    property = 'stargazers_count'
    href = '/stargazers'
  } else if (!path[4] && path[3] === 'subscription') {
    property = 'subscribers_count'
    href = '/watchers'
  } else if (!path[4] && path[3] === 'fork') {
    property = 'forks_count'
    href = '/forks'
  } else if (path[3] === 'issues') {
    property = 'open_issues_count'
    href = '/issues'
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
        href: json.html_url + href,
        rel: 'noopener',
        target: '_blank',
        'aria-label': data + ' ' + property.replace(/_count$/, '').replace('_', ' ').slice(0, data < 2 ? -1 : undefined) + ' on GitHub'
      }, [
        ('' + data).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      ]))
    }
    func(widget)
  })
}
