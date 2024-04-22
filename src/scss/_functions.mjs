import * as sass from 'sass'
import { require } from './_require.js'

// https://tools.ietf.org/html/rfc3986#section-2.2
const reservedCharacters = ":/?#[]@!$&'()*+,;=".split('')

const unreserved = reservedCharacters
  .filter(char => '#[]'.indexOf(char) === -1)
  .concat([' '])
  .map(char => encodeURIComponent(char))

const parseValue = function (source) {
  let value
  sass.compileString(`$_: yield((${source}));`, {
    functions: {
      'yield($value)': function (args) {
        value = args[0]
        return sass.sassNull
      }
    }
  })
  return value
}

export default {
  'encodeURIData($data)': function (args) {
    return new sass.SassString(encodeURIComponent(args[0].text).replace(/%[0-9A-Z]{2}/g, function (match) {
      if (unreserved.includes(match)) {
        return decodeURIComponent(match)
      }
      return match.toLowerCase()
    }))
  },
  'json($path, $keys...)': function (args) {
    const path = args[0].assertString('path').text
    let value = require(path)
    args[1].asList.forEach(key => { value = value[key.assertString().text] })
    return parseValue(value)
  }
}
