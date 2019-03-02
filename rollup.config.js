import coffeescript from 'rollup-plugin-coffee-script'
import json from 'rollup-plugin-json'
import replace from 'rollup-plugin-replace'
import resolve from 'rollup-plugin-node-resolve'
import { terser } from 'rollup-plugin-terser'
import sass from 'node-sass'

const packageJSON = require('./package.json')
const banner =
`/*!
 * ${packageJSON.name} v${packageJSON.version}
 * (c) ${new Date().getFullYear()} ${packageJSON.author.name}
 * @license ${packageJSON.license}
 */`

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
  }
].map(config => ({
  input: config.input,
  output: Object.assign(config.output, {
    banner
  }),
  plugins: [
    resolve({
      extensions: ['.coffee', '.js', '.json']
    }),
    json({
      exclude: ['node_modules/octicons/**']
    }),
    coffeescript(),
    replace({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
      'process.env.DEBUG': process.env.DEBUG || false
    }),
    raw({
      name: 'sass',
      test (id) {
        return id.endsWith('sass') || id.endsWith('scss')
      },
      transform (code) {
        return sass.renderSync({
          data: code,
          outputStyle: 'compressed'
        }).css.toString()
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
    ...(/\.min\.js$/.test(config.output.file) ? [terser({
      output: {
        comments: /@preserve|@license|@cc_on/i
      }
    })] : [])
  ]
}))
