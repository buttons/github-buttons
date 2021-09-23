import { plugins } from './rollup.config'
import istanbul from 'rollup-plugin-istanbul'

export default config => config.set({
  client: {
    mocha: {
      timeout: process.env.CI ? 15000 : 3000
    }
  },
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
  rollupPreprocessor: {
    plugins: [
      ...plugins,
      istanbul({
        include: ['**/*.js'],
        exclude: ['node_modules/**', 'test/**']
      })
    ],
    output: {
      format: 'iife',
      sourcemap: 'inline'
    }
  },
  coverageReporter: {
    reporters: [
      process.env.CI
        ? { type: 'lcovonly', subdir: '.' }
        : { type: 'html' },
      { type: 'text-summary' }
    ]
  }
})
