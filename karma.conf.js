import { configure } from './rollup.config'
import istanbul from 'rollup-plugin-istanbul'

export default config => config.set({
  browsers: ['ChromeHeadless', 'FirefoxHeadless'].concat(process.platform === 'darwin' ? ['Safari'] : []),
  frameworks: ['mocha', 'chai', 'sinon', 'sinon-chai'],
  reporters: ['mocha', 'coverage'],
  preprocessors: {
    'test/**/*.spec.js': ['rollup']
  },
  files: [
    {
      pattern: 'test/**/*.spec.js',
      watched: false
    },
    {
      pattern: 'test/fixtures/**/*',
      included: false,
      served: true
    }
  ],
  rollupPreprocessor: configure({
    plugins: [
      istanbul({
        include: ['src/**/*.js']
      })
    ],
    output: {
      format: 'iife',
      sourcemap: 'inline'
    }
  }),
  coverageReporter: {
    reporters: [
      { type: process.env.CI ? 'lcovonly' : 'html' },
      { type: 'text-summary' }
    ]
  }
})
