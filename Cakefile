fs     = require 'fs'
{exec} = require 'child_process'

callback = (callback) ->
  (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
    callback() if callback

task 'build', 'Build project', ->
  exec "cake build:octicons", callback ->
    exec "cake build:less", callback ->
  exec "cake build:coffee", callback ->

task 'build:coffee', 'Build scripts', ->
  exec "coffee --compile assets/js/", callback ->
    exec "uglifyjs --output buttons.js assets/js/buttons.js", callback ->

task 'build:less', 'Build stylesheets', ->
  for file in fs.readdirSync 'assets/css/' when file.match /\.less$/
    exec "lessc assets/css/#{file} assets/css/#{file.replace /\.less$/, '.css'}", callback ->

task 'build:octicons', 'Build octicons', ->
  exec "phantomjs src/octicons.coffee assets/css/octicons.css", callback ->
  exec "phantomjs src/octicons-lt-ie8.coffee assets/css/octicons-lt-ie8.css", callback ->
