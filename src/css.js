import buttons from './scss/buttons.scss'
import light from './scss/light.scss'
import dark from './scss/dark.scss'

import { parse } from './querystring'
import { hasOwnProperty } from './util'

const widgetColorSchemes = {
  light: light,
  dark: dark
}

const getColorSchemeMediaQuery = function (systemColorScheme, widgetColorScheme) {
  return '@media(prefers-color-scheme:' + systemColorScheme + '){' + widgetColorSchemes[hasOwnProperty(widgetColorSchemes, widgetColorScheme) ? widgetColorScheme : systemColorScheme] + '}'
}

const getColorScheme = function (declarations) {
  if (declarations == null) {
    return widgetColorSchemes.light
  }

  const colorSchemes = parse(declarations, ';', ':', function (str) {
    return str.replace(/^[ \t\n\f\r]+|[ \t\n\f\r]+$/g, '')
  })

  return widgetColorSchemes[hasOwnProperty(widgetColorSchemes, colorSchemes['no-preference']) ? colorSchemes['no-preference'] : 'light'] +
    getColorSchemeMediaQuery('light', colorSchemes.light) +
    getColorSchemeMediaQuery('dark', colorSchemes.dark)
}

export {
  buttons,
  getColorScheme,
  widgetColorSchemes
}
