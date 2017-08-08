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
      name: 'json',
      transform (json, id) {
        if (id.slice(-5) !== '.json') return null;

        const data = JSON.parse(json);
        let code = '';

        const ast = {
          type: 'Program',
          sourceType: 'module',
          start: 0,
          end: null,
          body: []
        };

        code = `export default ${json};`;

        ast.body.push({
          type: 'ExportDefaultDeclaration',
          start: 0,
          end: code.length,
          declaration: {
            type: 'Literal',
            start: 15,
            end: code.length - 1,
            value: null,
            raw: 'null'
          }
        });

        ast.end = code.length;

        return { ast, code, map: { mappings: '' } };
      }
    },
    ...(/\.min\.js$/.test(config.dest) ? [uglify()] : [])
  ]
}, config))
