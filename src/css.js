import main from './scss/main.scss'
import light from './scss/light.scss'
import lightHighContrast from './scss/light_high_contrast.scss'
import dark from './scss/dark.scss'
import darkDimmed from './scss/dark_dimmed.scss'
import darkHighContrast from './scss/dark_high_contrast.scss'

import { parse } from './querystring'
import { hasOwnProperty } from './util'

const widgetColorSchemes = {
  light: light,
  light_high_contrast: lightHighContrast,
  dark: dark,
  dark_dimmed: darkDimmed,
  dark_high_contrast: darkHighContrast
}

const getColorSchemeMediaQuery = function (systemColorScheme, widgetColorScheme) {
  return '@media(prefers-color-scheme:' + systemColorScheme + '){' + widgetColorSchemes[hasOwnProperty(widgetColorSchemes, widgetColorScheme) ? widgetColorScheme : systemColorScheme] + '}'
}

const getColorScheme = function (declarations) {
  if (declarations == null) {
    return widgetColorSchemes.light
  }

  if (hasOwnProperty(widgetColorSchemes, declarations)) {
    return widgetColorSchemes[declarations]
  }

  const colorSchemes = parse(declarations, ';', ':', function (str) {
    return str.replace(/^[ \t\n\f\r]+|[ \t\n\f\r]+$/g, '')
  })

  return widgetColorSchemes[hasOwnProperty(widgetColorSchemes, colorSchemes['no-preference']) ? colorSchemes['no-preference'] : 'light'] +
    getColorSchemeMediaQuery('light', colorSchemes.light) +
    getColorSchemeMediaQuery('dark', colorSchemes.dark)
}

export {
  main,
  getColorScheme,
  widgetColorSchemes
}
