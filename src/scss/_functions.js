import sass from 'sass'
import primitives from '@primer/primitives/dist/js'

// https://tools.ietf.org/html/rfc3986#section-2.2
const reservedCharacters = ":/?#[]@!$&'()*+,;=".split('')

const unreserved = reservedCharacters
  .filter(char => '#[]'.indexOf(char) === -1)
  .concat([' '])
  .map(char => encodeURIComponent(char))

const parseValue = function (source) {
  let value
  sass.renderSync({
    data: `a {b: foo((${source}))}`,
    functions: {
      'foo($value)': function (_value) {
        value = _value
        return sass.types.Null.NULL
      }
    }
  })
  return value
}

export default {
  'encodeURIData($data)': function (data) {
    return new sass.types.String(encodeURIComponent(data.getValue()).replace(/%[0-9A-Z]{2}/g, function (match) {
      if (unreserved.includes(match)) {
        return decodeURIComponent(match)
      }
      return match.toLowerCase()
    }))
  },
  'primitive($keys...)': function (keys) {
    let primitive = primitives
    for (let i = 0, len = keys.getLength(); i < len; i++) {
      primitive = primitive[keys.getValue(i)]
    }
    return parseValue(primitive)
  }
}
