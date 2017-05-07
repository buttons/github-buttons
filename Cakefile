fs = require 'fs'
path = require 'path'
{spawn, exec} = require 'child_process'


class Indent extends require('stream').Transform
  constructor: ->
    @_indentation = new Buffer "  "
    @_newline = true
    super

  push: (chunk) ->
    super @_indentation if chunk? and @_newline
    super

  _transform: (chunk, encoding, callback) ->
    begin = 0
    for charCode, end in chunk when charCode is 10 or charCode is 13
      @push chunk.slice begin, begin = ++end
      @_newline = true
    if begin < chunk.length
      @push chunk.slice begin
      @_newline = false
    callback()


system = (command, args..., callback) ->
  if callback and "[object Function]" isnt Object::toString.call callback
    args.push callback
    callback = null

  console.log "\u001B[36;1m==>\u001B[0;1m #{command} #{args.map((arg) -> arg.replace /([ \t\n])/g, "\\$1").join " "}\u001B[0m"

  spawn command, args, stdio: ['ignore', 'pipe', process.stderr]
    .on 'exit', (status) ->
      process.exit status unless status is 0
      callback() if callback
    .stdout.pipe(new Indent()).pipe process.stdout

find = (dir, pattern = /.*/) ->
  fs.readdirSync dir
    .filter (file) ->
      file.match pattern
    .map (file) ->
      path.join dir, file

coffee =
  compile: (coffeescripts..., javascript, callback) ->
    if callback and "[object Function]" isnt Object::toString.call callback
      coffeescripts.push javascript
      javascript = callback
      callback = null

    console.log "\u001B[36;1m==>\u001B[0;1m cat #{coffeescripts.join " "} | coffee --compile --stdio > #{javascript}\u001B[0m"

    spawn "cat", coffeescripts, stdio: ['ignore', 'pipe', process.stderr]
      .on 'exit', (status) -> process.exit status unless status is 0
      .on 'close', -> stdin.end()
      .stdout.on 'data', (data) -> stdin.write data

    stdin = spawn "coffee", ["--compile", "--stdio"], stdio: ['pipe', fs.openSync(javascript, 'w'), process.stderr]
      .on 'exit', (status) ->
        process.exit status unless status is 0
        callback() if callback
      .stdin


task 'build', 'Build everything', ->
  system "cake", "build:octicons", ->
    invoke 'build:less'
  invoke 'build:coffee'

task 'build:coffee', 'Build scripts', ->
  system "coffee", "-o", "dist/", "src/buttons.coffee", ->
    system "uglifyjs", "--compress", "--mangle", "--source-map", "buttons.js.map", "--output", "buttons.js", "dist/buttons.js"
  coffee.compile "src/buttons.coffee",
                 "src/app.coffee",
                 "assets/js/app.js",
                 -> system "uglifyjs",
                           "--compress",
                           "--mangle",
                           "--source-map", "assets/js/app.min.js.map",
                           "--source-map-root", "../../",
                           "--source-map-url", "app.min.js.map",
                           "--output", "assets/js/app.min.js",
                           "assets/js/app.js"

task 'build:less', 'Build stylesheets', ->
  find("assets/scss/", /\.scss$/i).forEach (file) ->
    system "node-sass", "--source-map", "true", "--output-style", "compressed", "--output", "assets/css/", file

task 'build:octicons', 'Build octicons', ->
  system "coffee", "src/octicons/sizes.coffee", "assets/css/octicons/sizes.css"
  system "coffee", "src/octicons/lt-ie8.coffee", "assets/css/octicons/lt-ie8.css"

task 'clean', 'Cleanup everything', ->
  js = /\.js(\.map)?$/
  css = /\.css(\.map)?$/
  targets = find "./", js
    .concat find "assets/js", js
    .concat find "dist/", js
    .concat find "test/lib/", js
    .concat find "assets/css/", css
    .concat find "assets/css/octicons/", css
  system "rm", targets... if targets.length > 0

task 'test', 'Test everything', ->
  system "cake", "clean", ->
    system "cake", "build", ->
      invoke 'lint:coffee'
      invoke 'lint:recess'
      invoke 'test:mocha-phantomjs'

task 'lint:coffee', 'Lint coffeescripts', ->
  system "coffeelint", "src", "test"

task 'lint:recess', 'Lint stylesheets', ->
  targets = find "assets/css/", /\.css$/i
  system "recess", targets... if targets.length > 0

task 'test:mocha-phantomjs', 'Test browser scripts', ->
  coffee.compile "src/buttons.coffee",
                 "test/src/polyfill.coffee",
                 "test/src/querystring.coffee",
                 "test/src/event.coffee",
                 "test/src/defer.coffee",
                 "test/src/jsonp.coffee",
                 "test/src/pixel.coffee",
                 "test/src/frame.coffee",
                 "test/src/config.coffee",
                 "test/src/render.coffee",
                 "test/lib/main.js",
                 -> system "mocha-phantomjs", "-p", "./node_modules/.bin/phantomjs", "--file", "/dev/null", "test/index.html"
