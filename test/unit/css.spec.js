import {
  getColorScheme,
  widgetColorSchemes
} from '@/css'

describe('CSS', () => {
  const getCss = (noPreference = 'light', light = 'light', dark = 'dark') => {
    return widgetColorSchemes[noPreference] + '@media(prefers-color-scheme:light){' + widgetColorSchemes[light] + '}@media(prefers-color-scheme:dark){' + widgetColorSchemes[dark] + '}'
  }

  describe('getColorScheme(declarations)', () => {
    it('should return the light when declarations is null', () => {
      expect(getColorScheme())
        .to.equal(widgetColorSchemes.light)
    })

    it('should return the light/light/dark when declarations is empty', () => {
      expect(getColorScheme(''))
        .to.equal(getCss())
    })

    it('should return the dark/light/dark with no-preference: dark', () => {
      expect(getColorScheme('no-preference: dark'))
        .to.equal(getCss('dark'))
    })

    it('should return the dark/dark/dark with no-preference: dark; light: dark', () => {
      expect(getColorScheme('no-preference: dark; light: dark'))
        .to.equal(getCss('dark', 'dark'))
    })

    it('should ignore non-exist system color scheme', () => {
      expect(getColorScheme('blue: light;'))
        .to.equal(getCss())
    })

    it('should ignore non-exist widget color scheme', () => {
      expect(getColorScheme('light: red;'))
        .to.equal(getCss())
    })

    it('should ignore __proto__ as system color scheme', () => {
      expect(getColorScheme('__proto__: light;'))
        .to.equal(getCss())
    })

    it('should ignore __proto__ as widget color scheme', () => {
      expect(getColorScheme('no-preference: __proto__; light: __proto__; dark: __proto__;'))
        .to.equal(getCss())
    })
  })
})
