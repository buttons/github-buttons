class FlatObject
  @flatten: (obj) ->
    flatten = (object, flat_key) ->
      switch Object::toString.call object
        when "[object Object]"
          for key, value of object
            flatten value, if flat_key then "#{flat_key}.#{key}" else key
        when "[object Array]"
          for item, index in object
            flatten item, "#{flat_key}[#{index}]"
        else
          result[flat_key] = object
      return
    result = {}
    flatten obj, ""
    result

  @expand: (obj) ->
    namespace = []
    for flat_key, value of obj
      keys = flat_key.match /((?!\[\d+\])[^.])+|\[\d+\]/g
      target = namespace
      key = 0
      while keys.length
        unless target[key]?
          target[key] = if keys[0] is index keys[0] then {} else []
        target = target[key]
        key = index keys.shift()
      target[key] = value
    namespace[0]

  index = (str) ->
    if match = str.match /^\[(\d+)\]$/
      Number match[1]
    else
      str


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
    "#" + QueryString.stringify FlatObject.flatten data

  @decode: (data = document.location.hash) ->
    (FlatObject.expand QueryString.parse data.replace /^#/, "") or {}
