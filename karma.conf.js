const path = require('path')
const webpack = require('webpack')

module.exports = function (config) {
  return config.set({
    frameworks: ['mocha', 'chai', 'sinon', 'sinon-chai'],
    reporters: ['mocha', 'coverage-istanbul'],
    preprocessors: {
      '**/*.coffee': ['webpack', 'sourcemap']
    },
    webpack: {
      mode: 'none',
      devtool: 'inline-source-map',
      resolve: {
        alias: {
          '@': path.resolve(__dirname, 'src')
        },
        extensions: ['.coffee', '.js', '.json']
      },
      module: {
        rules: [
          {
            test: /\.css$/,
            use: {
              loader: 'raw-loader'
            }
          },
          {
            test: /\.coffee$/,
            use: {
              loader: 'coffee-loader',
              options: {
                sourceMap: true
              }
            }
          },
          {
            test: /src\/.+\.coffee$/,
            exclude: /node_modules/,
            loader: 'istanbul-instrumenter-loader',
            enforce: 'post',
            options: {
              esModules: true
            }
          }
        ]
      },
      plugins: [
        new webpack.SourceMapDevToolPlugin({
          filename: null,
          test: /\.(coffee|js)($|\?)/i
        })
      ]
    },
    webpackMiddleware: {
      noInfo: true
    },
    files: [
      'test/unit/**/*.coffee',
      {
        pattern: 'test/fixtures/**/*',
        included: false,
        served: true
      }
    ],
    browsers: ['ChromeHeadless', 'Firefox', 'Safari']
  })
}
