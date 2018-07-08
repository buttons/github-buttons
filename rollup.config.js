import coffeescript from 'rollup-plugin-coffee-script'
import resolve from 'rollup-plugin-node-resolve'
import { uglify } from 'rollup-plugin-uglify'

const raw = function ({ name, test, transform = (code) => code }) {
  return {
    name,
    transform (code, id) {
      if (!test(id)) return null

      code = `export default ${JSON.stringify(transform(code))}`

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
  }
}

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
    input: 'src/container.coffee',
    output: {
      format: 'es',
      file: 'dist/buttons.esm.js'
    }
  }, {
    input: 'src/container.coffee',
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
    raw({
      name: 'css',
      test (id) {
        return id.endsWith('css')
      }
    }),
    raw({
      name: 'octicons-data-json',
      test (id) {
        return id.endsWith('/node_modules/octicons/build/data.json')
      },
      transform (code) {
        const data = JSON.parse(code)

        return Object.assign({}, ...[
          'mark-github',
          'eye',
          'star',
          'repo-forked',
          'issue-opened',
          'cloud-download'
        ].map(key => ({
          [key]: {
            width: data[key].width,
            height: data[key].height,
            path: data[key].path
          }
        })))
      }
    }),
    ...(/\.min\.js$/.test(config.output.file) ? [uglify()] : [])
  ]
}, config))
