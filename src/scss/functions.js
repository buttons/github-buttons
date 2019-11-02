import sass from 'sass'

// https://tools.ietf.org/html/rfc3986#section-2.2
const reservedCharacters = ":/?#[]@!$&'()*+,;=".split('')

const unreserved = reservedCharacters
  .filter(char => '#[]'.indexOf(char) === -1)
  .concat([' '])
  .map(char => encodeURIComponent(char))

export default {
  'encodeURIData($data)': function (data) {
    return new sass.types.String(encodeURIComponent(data.getValue()).replace(/%[0-9A-Z]{2}/g, function (match) {
      if (unreserved.includes(match)) {
        return decodeURIComponent(match)
      }
      return match.toLowerCase()
    }))
  }
}
