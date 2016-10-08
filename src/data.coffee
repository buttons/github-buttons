class ObjectHelper
  @deepProperty: (obj, path) ->
    return obj unless path?
    key_path = path.split /[.]|(?=\[\d+\])/
    while key_path.length and obj?
      key = key_path.shift()
      key = Number match[1] if match = key.match /^\[(\d+)\]$/
      obj = obj[key]
    obj


class NumberHelper
  @numberWithDelimiter: (number) ->
    "#{number}".replace /\B(?=(\d{3})+(?!\d))/g, ","


class QueryString
  @stringify: (obj) ->
    results = []
    for key, value of obj
      results.push "#{encodeURIComponent key}=#{if value? then encodeURIComponent value else ""}"
    results.join "&"

  @parse: (str) ->
    obj = {}
    for pair in str.split "&" when pair isnt ""
      [key, value...] = pair.split "="
      obj[decodeURIComponent key] = decodeURIComponent value.join "=" if key isnt ""
    obj


class Hash
  @encode: (data) ->
    "#" + QueryString.stringify data

  @decode: (data = document.location.hash) ->
    (QueryString.parse data.replace /^#/, "") or {}
