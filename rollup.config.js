import json from 'rollup-plugin-json'
import replace from 'rollup-plugin-replace'
import resolve from 'rollup-plugin-node-resolve'
import { terser } from 'rollup-plugin-terser'
import sass from 'sass'
import sassFunctions from './src/scss/functions'
import path from 'path'
import fs from 'fs'
import packageJSON from './package.json'

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

      code = `export default ${JSON.stringify(transform(code, id))}`

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

const html = function ({ output: { file }, title = '\u200b' } = {}) {
  const bundle = file
  return {
    name: 'html',
    generateBundle ({ file }) {
      return new Promise((resolve, reject) => {
        fs.writeFile(bundle, `<!doctype html><meta charset=utf-8><title>${title}</title><meta name=robots content=noindex><body><script src=${path.relative(path.dirname(bundle), file)}></script>`, (error) => {
          if (error) reject(error)
          resolve()
        })
      })
    }
  }
}

export default [
  {
    input: 'src/container.js',
    output: {
      format: 'cjs',
      file: 'dist/buttons.common.js'
    }
  }, {
    input: 'src/container.js',
    output: {
      format: 'es',
      file: 'dist/buttons.esm.js'
    }
  }, {
    input: 'src/main.js',
    output: {
      format: 'iife',
      file: 'dist/buttons.js'
    },
    plugins: [
      process.env.NODE_ENV !== 'production' && html({
        output: {
          file: 'dist/buttons.html'
        }
      })
    ]
  }, {
    input: 'src/main.js',
    output: {
      format: 'iife',
      file: 'dist/buttons.min.js'
    },
    plugins: [
      process.env.NODE_ENV === 'production' && html({
        output: {
          file: 'dist/buttons.html'
        }
      })
    ]
  }
].map(config => ({
  input: config.input,
  output: Object.assign(config.output, {
    banner,
    preferConst: false
  }),
  plugins: [
    ...(config.plugins || []),
    resolve(),
    json({
      exclude: ['node_modules/**']
    }),
    raw({
      name: 'octicons-data-json',
      filter (id) {
        return id.endsWith('node_modules/@primer/octicons/build/data.json')
      },
      transform (code) {
        const data = JSON.parse(code)

        return Object.assign({}, ...[
          'mark-github',
          'heart',
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
      transform (_, id) {
        return sass.renderSync({
          file: id,
          functions: sassFunctions,
          outputStyle: process.env.DEBUG ? 'expanded' : 'compressed'
        }).css.toString()
      }
    }),
    replace({
      const: 'var',
      let: 'var',
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
