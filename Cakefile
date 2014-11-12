fs = require 'fs'
{spawn, exec} = require 'child_process'

system = (command, args..., callback) ->
  app = spawn command, args
  app.stdout.pipe process.stdout
  app.stderr.pipe process.stderr
  app.on 'exit', (status) ->
    if status is 0
      callback() if callback
    else
      process.exit(status)

task 'build', 'Build project', ->
  system "cake", "build:octicons", ->
    invoke 'build:less'
  invoke 'build:coffee'

task 'build:coffee', 'Build scripts', ->
  system "coffee", "--compile", "assets/js/", ->
    system "uglifyjs", "--mangle", "--output", "buttons.js", "assets/js/buttons.js", ->

task 'build:less', 'Build stylesheets', ->
  for file in fs.readdirSync 'assets/css/' when file.match /\.less$/
    system "lessc", "assets/css/#{file}", "assets/css/#{file.replace /\.less$/, '.css'}", ->

task 'build:octicons', 'Build octicons', ->
  system "phantomjs", "src/octicons/base.coffee", "assets/css/octicons/base.less", ->
  system "phantomjs", "src/octicons/lt-ie8.coffee", "assets/css/octicons/lt-ie8.css", ->

task 'clean', 'Cleanup', ->
  exec "rm assets/css/octicons/* assets/css/*.css assets/js/*.js buttons.js"

task 'test', 'Run all tests', ->
  system "cake", "clean", ->
    invoke 'build'
