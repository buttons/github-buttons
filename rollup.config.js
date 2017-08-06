import coffeescript from 'rollup-plugin-coffee-script'
import resolve from 'rollup-plugin-node-resolve'
import uglify from 'rollup-plugin-uglify'

export default [
  {
    entry: 'src/main.coffee',
    dest: 'dist/buttons.js'
  }, {
    entry: 'src/main.coffee',
    dest: 'dist/buttons.min.js'
  }, {
    entry: 'src/lib.coffee',
    format: 'es',
    dest: 'dist/buttons.esm.js'
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
