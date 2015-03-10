fs = require 'fs'
path = require 'path'
{spawn, exec} = require 'child_process'


system = (command, args..., callback) ->
  if callback and "[object Function]" isnt Object::toString.call callback
    args.push callback
    callback = null

  console.log "\u001B[36;1m==>\u001B[0;1m #{command} #{args.map((arg) -> arg.replace /([ \t\n])/g, "\\$1").join " "}\u001B[0m"

  spawn command, args, stdio: ['ignore', 'ignore', process.stderr]
    .on 'exit', (status) ->
      process.exit status unless status is 0
      callback() if callback

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

    console.log "\u001B[36;1m==>\u001B[0;1m cat #{coffeescripts.join " "} | coffee --compile --stdio > #{javascript}\u001B[0;1m"

    cat_proc = spawn "cat", coffeescripts, stdio: ['ignore', 'pipe', process.stderr]
    cat_proc.stdout.on 'data', (data) -> coffee_proc.stdin.write data
    cat_proc.on 'close', -> coffee_proc.stdin.end()
    cat_proc.on 'exit', (status) -> process.exit status unless status is 0
    coffee_proc = spawn "coffee", ["--compile", "--stdio"], stdio: ['pipe', fs.openSync(javascript, 'w'), process.stderr]
    coffee_proc.on 'exit', (status) ->
      process.exit status unless status is 0
      callback() if callback


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
                           "--mangle",
                           "--source-map", "assets/js/main.js.map",
                           "--source-map-root", "../../",
                           "--source-map-url", "main.js.map",
                           "--output", "assets/js/main.js",
                           "lib/main.js"
  system "coffee", "--compile", "--output", "lib/", "src/ie8.coffee", ->
    system "uglifyjs", "--mangle", "--output", "assets/js/ie8.js", "lib/ie8.js"

task 'build:less', 'Build stylesheets', ->
  find("assets/css/", /^(buttons|main)\.less$/i).forEach (file) ->
    system "lessc", "--clean-css=--s1 --compatibility=ie7", "--source-map", file, "#{file.replace /\.less$/i, '.css'}"

task 'build:octicons', 'Build octicons', ->
  system "coffee", "--compile", "src/phantomjs/octicons/octicons.coffee", ->
    system "env", "-i", "sh", "-c", "phantomjs src/phantomjs/octicons/octicons.js assets/css/octicons.less"
  system "coffee", "--compile", "src/phantomjs/octicons/lt-ie8.coffee", ->
    system "phantomjs", "src/phantomjs/octicons/lt-ie8.js", "assets/css/lt-ie8.css"

task 'clean', 'Cleanup everything', ->
  js = /\.js(\.map)?$/
  css = /\.css(\.map)?$|^octicons.less$/
  targets = find "./", js
    .concat find "assets/js/", js
    .concat find "lib/", js
    .concat find "src/phantomjs/octicons/", js
    .concat find "test/browser/lib/", js
    .concat find "assets/css/", css
  system "rm", targets... if targets.length > 0

task 'test', 'Test everything', ->
  system "cake", "clean", ->
    system "cake", "build", ->
      invoke 'test:recess'
      invoke 'test:mocha'
      invoke 'test:mocha-phantomjs'

task 'test:recess', 'Test stylesheets', ->
  targets = find "assets/css/", /\.less$/i
  system "recess", targets... if targets.length > 0

task 'test:mocha', 'Test scripts', ->
  system "mocha", "--compilers", "coffee:coffee-script/register", "test/*.coffee"

task 'test:mocha-phantomjs', 'Test browser scripts', ->
  coffee.compile "src/data.coffee",
                 "src/core.coffee",
                 "test/browser/src/helpers.coffee",
                 "test/browser/src/core.coffee",
                 "test/browser/lib/main.js",
                 -> system "mocha-phantomjs", "test/browser/index.html"
