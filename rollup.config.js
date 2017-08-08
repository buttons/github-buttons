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
    {
      name: 'octicons-data-json',
      transform (json, id) {
        if (!id.endsWith('/node_modules/octicons/build/data.json')) return null

        const data = JSON.parse(json)
        Object.keys(data).forEach(key => { delete data[key].keywords })
        json = JSON.stringify(data)

        const code = `export default ${json}`

        const ast = {
          type: 'Program',
          sourceType: 'module',
          start: 0,
          end: code.length,
          body: [{
            type: 'ExportDefaultDeclaration',
            start: 0,
            end: code.length,
            declaration: {
              type: 'Literal',
              start: 15,
              end: code.length,
              value: null,
              raw: 'null'
            }
          }]
        }

        return { ast, code, map: { mappings: '' } }
      }
    },
    ...(/\.min\.js$/.test(config.dest) ? [uglify()] : [])
  ]
}, config))
