fs = require 'fs'
path = require 'path'
{spawn, exec} = require 'child_process'


system = (command, args..., callback) ->
  if callback and "[object Function]" isnt Object.prototype.toString.call callback
    args.push callback
    callback = null
  esc = String.fromCharCode 27
  console.log "#{esc}[36;1m==>#{esc}[0;1m #{command} #{args.map((arg) -> arg.replace /([ \t\n])/g, "\\$1").join " "}#{esc}[0m"
  proc = spawn command, args
  proc.stdout.pipe process.stdout
  proc.stderr.pipe process.stderr
  proc.on 'exit', (status) ->
    if status is 0
      callback() if callback
    else
      process.exit status

find = (dirs..., pattern = /.*/) ->
  result = []
  for dir in dirs
    fs.readdirSync dir
      .filter (file) ->
        file.match pattern
      .forEach (file) ->
        result.push path.join dir, file
  return result

coffee =
  compile: (coffeescripts..., javascript, callback) ->
    if callback and "[object Function]" isnt Object.prototype.toString.call callback
      coffeescripts.push javascript
      javascript = callback
      callback = null
    esc = String.fromCharCode 27
    console.log "#{esc}[32;1m==>#{esc}[0;1m Compiling:#{esc}[0m #{coffeescripts.join " "} #{esc}[1m-->#{esc}[0m #{javascript}"
    stdout = fs.createWriteStream javascript
    cat_proc = spawn "cat", coffeescripts
    cat_proc.stdout.on 'data', (data) -> coffee_proc.stdin.write data
    cat_proc.stderr.on 'data', (data) -> console.error data.toString "utf8"
    cat_proc.on 'close', (status) ->
      if status is 0
        coffee_proc.stdin.end()
      else
        process.exit status
    coffee_proc = spawn "coffee", ["--compile", "--stdio"]
    coffee_proc.stdout.on 'data', (data) -> stdout.write data
    coffee_proc.stderr.on 'data', (data) -> console.error data.toString "utf8"
    coffee_proc.on 'close', (status) ->
      if status is 0
        stdout.end()
        callback() if callback
      else
        process.exit status


task 'build', 'Build everything', ->
  system "cake", "build:octicons", ->
    invoke 'build:less'
  invoke 'build:coffee'

task 'build:coffee', 'Build scripts', ->
  coffee.compile "src/config.coffee",
                 "src/data.coffee",
                 "src/elements.coffee",
                 "src/buttons.coffee",
                 "lib/buttons.js",
                 -> system "uglifyjs",
                           "--mangle",
                           "--source-map", "buttons.js.map",
                           "--output", "buttons.js",
                           "lib/buttons.js"
  coffee.compile "src/config.coffee",
                 "src/data.coffee",
                 "src/elements.coffee",
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
    system "env", "-i", "sh", "-c", "phantomjs src/phantomjs/octicons/lt-ie8.js assets/css/lt-ie8.css"

task 'clean', 'Cleanup everything', ->
  targets = find "./", "assets/js/", "lib/", "test/browser/lib/", "src/phantomjs/octicons/", /\.js(\.map)?$/
    .concat find "assets/css/", /\.css(\.map)?$|^octicons.less$/
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
  coffee.compile "src/elements.coffee",
                 "test/browser/src/elements.coffee",
                 "test/browser/lib/elements.js",
                 -> system "mocha-phantomjs", "test/browser/index.html"
