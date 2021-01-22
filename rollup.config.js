import alias from '@rollup/plugin-alias'
import html from '@rollup/plugin-html'
import json from '@rollup/plugin-json'
import replace from '@rollup/plugin-replace'
import resolve from '@rollup/plugin-node-resolve'
import { createFilter } from '@rollup/pluginutils'
import { terser } from 'rollup-plugin-terser'
import sass from 'sass'
import sassFunctions from './src/scss/_functions'
import path from 'path'
import packageJSON from './package.json'

const banner =
`/*!
 * ${packageJSON.name} v${packageJSON.version}
 * (c) ${new Date().getFullYear()} ${packageJSON.author.name}
 * @license ${packageJSON.license}
 */`

const plugins = {
  octicons ({ include, exclude, heights = [16, 24] } = {}) {
    const filter = createFilter(include, exclude, false)

    return {
      name: 'octicons-data-json',
      transform (code, id) {
        if (!id.endsWith('node_modules/@primer/octicons/build/data.json')) return

        const data = JSON.parse(code)

        return {
          code: JSON.stringify(Object.assign({}, ...Object.keys(data).filter(key => filter(key)).map(key => ({
            [key]: {
              heights: Object.assign({}, ...heights.filter(height => ({}).hasOwnProperty.call(data[key].heights, height)).map(height => ({
                [height]: {
                  width: data[key].heights[height].width,
                  path: data[key].heights[height].path
                }
              })))
            }
          })))),
          map: { mappings: '' }
        }
      }
    }
  },
  sass ({ include, exclude } = {}) {
    const filter = createFilter(include, exclude)

    return {
      name: 'sass',
      load (id) {
        if ((!id.endsWith('.sass') && !id.endsWith('.scss')) || !filter(id)) return

        return {
          code: 'export default ' + JSON.stringify(sass.renderSync({
            file: id,
            functions: sassFunctions,
            outputStyle: process.env.DEBUG ? 'expanded' : 'compressed'
          }).css.toString()),
          map: { mappings: '' }
        }
      }
    }
  }
}

const template = ({ files }) => `<!doctype html><meta charset=utf-8><title>\u200b</title><meta name=robots content=noindex><body>${files.js.map(({ fileName }) => `<script src=${fileName}></script>`).join('')}`

const configure = config => Object.assign(config, {
  input: config.input,
  output: Object.assign(config.output, {
    banner,
    preferConst: false
  }),
  plugins: [
    alias({
      entries: [
        { find: '@', replacement: path.resolve(__dirname, 'src') }
      ]
    }),
    resolve(),
    plugins.octicons({
      include: [
        'download',
        'eye',
        'heart',
        'issue-opened',
        'mark-github',
        'repo-forked',
        'repo-template',
        'star'
      ],
      heights: [16]
    }),
    json({
      compact: true,
      preferConst: true
    }),
    plugins.sass(),
    replace({
      const: 'var',
      let: 'var',
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
      'process.env.DEBUG': process.env.DEBUG || false
    }),
    /\.min\.js$/.test(config.output.file) &&
    terser({
      output: {
        comments: /@preserve|@license|@cc_on/i
      }
    })
  ].concat(config.plugins || [])
})

export { configure }

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
        fileName: 'buttons.html',
        template: template
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
        fileName: 'buttons.html',
        template: template
      })
    ]
  }
].map(config => configure(config))
