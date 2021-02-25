import alias from '@rollup/plugin-alias'
import html from '@rollup/plugin-html'
import json from '@rollup/plugin-json'
import replace from '@rollup/plugin-replace'
import resolve from '@rollup/plugin-node-resolve'
import { createFilter } from '@rollup/pluginutils'
import { terser } from 'rollup-plugin-terser'
import sassImplementation from 'sass'
import sassFunctions from './src/scss/_functions'
import path from 'path'
import packageJSON from './package.json'

const banner =
`/*!
 * ${packageJSON.name} v${packageJSON.version}
 * (c) ${new Date().getFullYear()} ${packageJSON.author.name}
 * @license ${packageJSON.license}
 */`

const octicons = ({ include, exclude, heights = [16, 24] } = {}) => {
  const filter = createFilter(include, exclude, false)

  return {
    name: 'octicons-data-json',
    transform (code, id) {
      if (!id.split(path.sep).join(path.posix.sep).endsWith('node_modules/@primer/octicons/build/data.json')) return

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
}

const sass = ({ include, exclude, extensions = ['.sass', '.scss'] } = {}) => {
  const filter = createFilter(include, exclude)

  return {
    name: 'sass',
    load (id) {
      if (!extensions.includes(path.extname(id)) || !filter(id)) return

      return {
        code: 'export default ' + JSON.stringify(sassImplementation.renderSync({
          file: id,
          functions: sassFunctions,
          outputStyle: process.env.DEBUG ? 'expanded' : 'compressed'
        }).css.toString()),
        map: { mappings: '' }
      }
    }
  }
}

const template = ({ files }) => `<!doctype html><meta charset=utf-8><title>\u200b</title><meta name=robots content=noindex><body>${files.js.map(({ fileName }) => `<script src=${fileName}></script>`).join('')}`

const plugins = [
  alias({
    entries: [
      { find: '@', replacement: path.resolve(__dirname, 'src') }
    ]
  }),
  resolve(),
  octicons({
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
  sass(),
  replace({
    preventAssignment: true,
    values: {
      const: 'var',
      let: 'var',
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
      'process.env.DEBUG': process.env.DEBUG || false
    }
  })
]

export { plugins }

export default [
  {
    input: 'src/container.js',
    plugins: plugins,
    output: [
      {
        format: 'cjs',
        file: 'dist/buttons.common.js',
        banner: banner
      },
      {
        format: 'es',
        file: 'dist/buttons.esm.js',
        banner: banner
      }
    ]
  }, {
    input: 'src/main.js',
    plugins: plugins,
    output: [
      {
        format: 'iife',
        file: 'dist/buttons.js',
        banner: banner,
        plugins: [
          process.env.NODE_ENV !== 'production' &&
          html({
            fileName: 'buttons.html',
            template: template
          })
        ]
      },
      {
        format: 'iife',
        file: 'dist/buttons.min.js',
        banner: banner,
        plugins: [
          terser({
            output: {
              comments: /@preserve|@license|@cc_on/i
            }
          }),
          process.env.NODE_ENV === 'production' &&
          html({
            fileName: 'buttons.html',
            template: template
          })
        ]
      }
    ]
  }
]
