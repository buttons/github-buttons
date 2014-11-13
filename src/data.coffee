class FlatObject
  @flatten: (obj) ->
    flatten = (object, super_key) ->
      switch __toString.call(object)
        when "[object Object]"
          for key, value of object
            flatten value, if super_key then "#{super_key}.#{key}" else key
        when "[object Array]"
          for item, index in object
            flatten item, if super_key then "#{super_key}[#{index}]" else "[#{index}]"
        else
          result[super_key] = object
      return
    result = {}
    flatten obj
    result

  @expand: (obj) ->
    namespace = []
    for flat_key, value of obj
      keys = []
      for key in flat_key.split "."
        match = key.match /^(.*?)((?:\[[0-9]+\])*)$/
        keys.push match[1] if match[1]
        keys.push Number sub_key for sub_key in match[2].replace(/^\[|\]$/g, "").split("][") if match[2]
      target = namespace
      key = 0
      while keys.length
        unless target[key]?
          switch __toString.call(keys[0])
            when "[object String]"
              target[key] = {}
            when "[object Number]"
              target[key] = []
        target = target[key]
        key = keys.shift()
      target[key] = value
    namespace[0]

  __toString = Object.prototype.toString


class QueryString
  @stringify: (obj) ->
    results = []
    for key, value of obj
      value ?= ""
      results.push "#{key}=#{value}"
    results.join "&"

  @parse: (str) ->
    obj = {}
    for pair in str.split "&" when pair isnt ""
      [key, value...] = pair.split "="
      obj[key] = value.join "=" if key isnt ""
    obj


class Hash
  @encode: (data) ->
    "#" + encodeURIComponent QueryString.stringify FlatObject.flatten data

  @decode: (data = document.location.hash) ->
    (FlatObject.expand QueryString.parse decodeURIComponent data.replace /^#/, "") or {}
