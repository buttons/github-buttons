fs = require 'fs'
path = require 'path'
vm = require 'vm'
CoffeeScript = require 'coffee-script'


module.exports =
  require: (id) ->
    filename = require.resolve path.relative(path.relative(module.parent.filename, __filename), id)
    code = fs.readFileSync filename, encoding: "utf8"
    sandbox = (vm.createContext or vm.Script.createContext)()
    if CoffeeScript.helpers.isCoffee filename
      CoffeeScript.eval code, {sandbox, filename}
    else
      vm.runInContext code, sandbox, filename
    sandbox
