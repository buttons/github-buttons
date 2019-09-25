export const stringify = function (obj, sep, eq, encodeURIComponent) {
  if (sep == null) {
    sep = '&'
  }
  if (eq == null) {
    eq = '='
  }
  if (encodeURIComponent == null) {
    encodeURIComponent = window.encodeURIComponent
  }
  const params = []
  for (const name in obj) {
    const value = obj[name]
    if (value != null) {
      params.push(encodeURIComponent(name) + eq + encodeURIComponent(value))
    }
  }
  return params.join(sep)
}

export const parse = function (str, sep, eq, decodeURIComponent) {
  if (sep == null) {
    sep = '&'
  }
  if (eq == null) {
    eq = '='
  }
  if (decodeURIComponent == null) {
    decodeURIComponent = window.decodeURIComponent
  }
  const obj = {}
  const params = str.split(sep)
  for (let i = 0, len = params.length; i < len; ++i) {
    const entry = params[i]
    if (entry !== '') {
      const ref = entry.split(eq)
      obj[decodeURIComponent(ref[0])] = (ref[1] != null ? decodeURIComponent(ref.slice(1).join(eq)) : undefined)
    }
  }
  return obj
}
