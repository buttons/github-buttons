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

const raw = function ({ name, filter, transform = (code) => code }) {
  return {
    name,
    transform (code, id) {
      if (!filter(id)) return null

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
    input: 'src/main.js',
    output: {
      format: 'iife',
      file: 'dist/buttons.js'
    }
  }, {
    input: 'src/main.js',
    output: {
      format: 'iife',
      file: 'dist/buttons.min.js'
    }
  }, {
    input: 'src/container.js',
    output: {
      format: 'es',
      file: 'dist/buttons.esm.js'
    }
  }, {
    input: 'src/container.js',
    output: {
      format: 'cjs',
      file: 'dist/buttons.common.js'
    }
  }
].map(config => ({
  input: config.input,
  output: Object.assign(config.output, {
    banner,
    preferConst: false
  }),
  plugins: [
    resolve(),
    json({
      exclude: ['node_modules/**']
    }),
    raw({
      name: 'octicons-data-json',
      filter (id) {
        return id.endsWith('node_modules/octicons/build/data.json')
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
    raw({
      name: 'sass',
      filter (id) {
        return id.endsWith('sass') || id.endsWith('scss')
      },
      transform (code) {
        return sass.renderSync({
          data: code,
          outputStyle: 'compressed'
        }).css.toString()
      }
    }),
    replace({
      'const': 'var',
      'let': 'var',
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
      'process.env.DEBUG': process.env.DEBUG || false
    }),
    ...(/\.min\.js$/.test(config.output.file) ? [terser({
      output: {
        comments: /@preserve|@license|@cc_on/i
      }
    })] : [])
  ]
}))
