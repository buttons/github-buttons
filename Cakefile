fs = require 'fs'
path = require 'path'
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

find = (dir, pattern = /.*/) ->
  fs.readdirSync dir
    .filter (file) ->
      file.match pattern
    .map (file) ->
      path.join dir, file



task 'build', 'Build everything', ->
  system "cake", "build:octicons", ->
    invoke 'build:less'
  invoke 'build:coffee'

task 'build:coffee', 'Build scripts', ->
  system "coffee", "--compile", "assets/js/", ->
    system "uglifyjs", "--mangle", "--output", "buttons.js", "assets/js/buttons.js", ->

task 'build:less', 'Build stylesheets', ->
  find("assets/css/", /\.less$/i).forEach (file) ->
    system "lessc", file, "#{file.replace /\.less$/i, '.css'}", ->

task 'build:octicons', 'Build octicons', ->
  system "phantomjs", "src/octicons/base.coffee", "assets/css/octicons/base.less", ->
  system "phantomjs", "src/octicons/lt-ie8.coffee", "assets/css/octicons/lt-ie8.css", ->

task 'clean', 'Cleanup everything', ->
  exec "rm assets/css/octicons/* assets/css/*.css assets/js/*.js buttons.js"

task 'test', 'Test everything', ->
  system "cake", "clean", ->
    system "cake", "build", ->
      invoke 'test:recess'

task 'test:recess', 'Test stylesheets', ->
  system.apply @, ["recess"].concat(find "assets/css/", /\.css$/i).concat ->
