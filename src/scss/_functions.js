import sass from 'sass'
import primitives from '@primer/primitives'

// https://tools.ietf.org/html/rfc3986#section-2.2
const reservedCharacters = ":/?#[]@!$&'()*+,;=".split('')

const unreserved = reservedCharacters
  .filter(char => '#[]'.indexOf(char) === -1)
  .concat([' '])
  .map(char => encodeURIComponent(char))

const parseValue = function (source) {
  let value
  sass.compileString(`a {b: foo((${source}))}`, {
    functions: {
      'foo($value)': function (args) {
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
  'primitive($keys...)': function (args) {
    let primitive = primitives
    args[0].asList.forEach(value => {
      primitive = primitive[value.text]
    })
    return parseValue(primitive)
  }
}
