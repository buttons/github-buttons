module.exports = (config) ->
  config.set
    frameworks: [
      'mocha'
      'chai'
      'sinon'
      'sinon-chai'
    ]
    files: [
      'test/**/*.js', {
        pattern: 'test/api.github.com/**/*'
        included: false
        served: true
      }
    ]
    proxies:
      '/api.github.com/': '/base/test/api.github.com/'
    browsers: ['ChromeHeadless', 'Firefox', 'Safari']
