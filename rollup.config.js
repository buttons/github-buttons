import coffeescript from 'rollup-plugin-coffee-script'
import resolve from 'rollup-plugin-node-resolve'
import uglify from 'rollup-plugin-uglify'

export default [
  {
    entry: 'src/buttons.coffee',
    dest: 'dist/buttons.js'
  }, {
    entry: 'src/buttons.coffee',
    dest: 'dist/buttons.min.js'
  }, {
    entry: 'src/app.coffee',
    dest: 'assets/js/app.js'
  }, {
    entry: 'src/app.coffee',
    dest: 'assets/js/app.min.js'
  }
].map(config => Object.assign({
  format: 'iife',
  plugins: [
    resolve({
      extensions: ['.coffee', '.js', '.json']
    }),
    coffeescript(),
    ...(/\.min\.js$/.test(config.dest) ? [uglify()] : [])
  ]
}, config))
