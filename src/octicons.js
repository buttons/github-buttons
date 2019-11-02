import data from '@primer/octicons/build/data'
import { hasOwnProperty } from './util'

export const octicon = function (icon, height) {
  icon = ('' + icon).toLowerCase().replace(/^octicon-/, '')
  if (!hasOwnProperty(data, icon)) {
    icon = 'mark-github'
  }
  return '<svg viewBox="0 0 ' + data[icon].width + ' ' + data[icon].height + '" class="octicon octicon-' + icon + '" style="width: ' + (height * data[icon].width / data[icon].height) + 'px; height: ' + height + 'px;" aria-hidden="true">' + data[icon].path + '</svg>'
}
