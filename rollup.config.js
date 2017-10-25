import coffeescript from 'rollup-plugin-coffee-script'
import resolve from 'rollup-plugin-node-resolve'
import uglify from 'rollup-plugin-uglify'

export default [
  {
    input: 'src/main.coffee',
    output: {
      format: 'iife',
      file: 'dist/buttons.js'
    }
  }, {
    input: 'src/main.coffee',
    output: {
      format: 'iife',
      file: 'dist/buttons.min.js'
    }
  }, {
    input: 'src/render.coffee',
    output: {
      format: 'es',
      file: 'dist/buttons.esm.js'
    }
  }, {
    input: 'src/render.coffee',
    output: {
      format: 'cjs',
      file: 'dist/buttons.common.js'
    }
  }, {
    input: 'src/app.coffee',
    output: {
      format: 'iife',
      file: 'assets/js/app.js'
    }
  }, {
    input: 'src/app.coffee',
    output: {
      format: 'iife',
      file: 'assets/js/app.min.js'
    }
  }
].map(config => Object.assign({
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
    ...(/\.min\.js$/.test(config.output.file) ? [uglify()] : [])
  ]
}, config))
