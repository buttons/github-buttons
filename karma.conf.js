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
        include: ['**/*.js'],
        exclude: ['node_modules/**', 'test/**']
      })
    ],
    output: {
      format: 'iife',
      sourcemap: 'inline'
    }
  }),
  coverageReporter: {
    reporters: [
      process.env.CI
        ? { type: 'lcovonly', subdir: '.' }
        : { type: 'html' },
      { type: 'text-summary' }
    ]
  }
})
