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
  coffee.compile "src/global.coffee",
                 "src/config.coffee",
                 "src/data.coffee",
                 "src/core.coffee",
                 "src/buttons.coffee",
                 "lib/buttons.js",
                 -> system "uglifyjs",
                           "--compress",
                           "--mangle",
                           "--source-map", "buttons.js.map",
                           "--output", "buttons.js",
                           "lib/buttons.js"
  coffee.compile "src/global.coffee",
                 "src/config.coffee",
                 "src/data.coffee",
                 "src/core.coffee",
                 "src/main.coffee",
                 "lib/main.js",
                 -> system "uglifyjs",
                           "--compress",
                           "--mangle",
                           "--source-map", "assets/js/main.js.map",
                           "--source-map-root", "../../",
                           "--source-map-url", "main.js.map",
                           "--output", "assets/js/main.js",
                           "lib/main.js"

task 'build:less', 'Build stylesheets', ->
  find("assets/css/", /^(buttons|main)\.less$/i).forEach (file) ->
    system "lessc", "--clean-css=--s1 --advanced --compatibility=ie7", "--source-map", file, "#{file.replace /\.less$/i, '.css'}"

task 'build:octicons', 'Build octicons', ->
  system "coffee", "src/octicons/sizes.coffee", "assets/css/octicons/sizes.css"
  system "coffee", "src/octicons/lt-ie8.coffee", "assets/css/octicons/lt-ie8.css"

task 'clean', 'Cleanup everything', ->
  js = /\.js(\.map)?$/
  css = /\.css(\.map)?$/
  targets = find "./", js
    .concat find "assets/js/", js
    .concat find "lib/", js
    .concat find "test/browser/lib/", js
    .concat find "assets/css/", css
    .concat find "assets/css/octicons/", css
  system "rm", targets... if targets.length > 0

task 'test', 'Test everything', ->
  system "cake", "clean", ->
    system "cake", "build", ->
      invoke 'test:recess'
      invoke 'test:mocha'
      invoke 'test:mocha-phantomjs'

task 'test:recess', 'Test stylesheets', ->
  targets = find "assets/css/", /\.css$/i
  system "recess", targets... if targets.length > 0

task 'test:mocha', 'Test scripts', ->
  system "mocha", "--compilers", "coffee:coffee-script/register", "test/*.coffee"

task 'test:mocha-phantomjs', 'Test browser scripts', ->
  coffee.compile "test/browser/src/helpers.coffee",
                 "src/data.coffee",
                 "src/core.coffee",
                 "test/browser/src/core.coffee",
                 "test/browser/lib/main.js",
                 -> system "mocha-phantomjs", "--file", "/dev/null", "test/browser/index.html"
