import data from '@primer/octicons-v2/build/data'

import { hasOwnProperty } from './util'

export const octicon = function (icon, height) {
  icon = ('' + icon).toLowerCase().replace(/^octicon-/, '')
  if (!hasOwnProperty(data, icon)) {
    icon = 'mark-github'
  }

  const defaultHeight = height < 24 ? 16 : /* istanbul ignore next */ 24

  const svg = data[icon].heights[defaultHeight]

  return '<svg viewBox="0 0 ' + svg.width + ' ' + defaultHeight + '" width="' + (height * svg.width / defaultHeight) + '" height="' + height + '" class="octicon octicon-' + icon + '" aria-hidden="true">' + svg.path + '</svg>'
}
