import data from '@primer/octicons/build/data'

import {
  hasOwnProperty,
  toLowerCase
} from './util'

export const octicon = function (icon, height) {
  icon = toLowerCase(icon).replace(/^octicon-/, '')
  if (!hasOwnProperty(data, icon)) {
    icon = 'mark-github'
  }

  const defaultHeight = height >= 24 && /* istanbul ignore next */ 24 in data[icon].heights ? /* istanbul ignore next */ 24 : 16

  const svg = data[icon].heights[defaultHeight]

  return '<svg viewBox="0 0 ' + svg.width + ' ' + defaultHeight + '" width="' + (height * svg.width / defaultHeight) + '" height="' + height + '" class="octicon octicon-' + icon + '" aria-hidden="true">' + svg.path + '</svg>'
}
