import {
  encodeURIComponent
  decodeURIComponent
} from "./alias"

export stringifyQueryString = (obj) ->
  params = []
  for name, value of obj
    params.push "#{encodeURIComponent name}=#{encodeURIComponent value}" if value?
  params.join "&"

export parseQueryString = (str) ->
  params = {}
  for pair in str.split "&" when pair isnt ""
    ref = pair.split "="
    params[decodeURIComponent ref[0]] = decodeURIComponent ref.slice(1).join "=" if ref[0] isnt ""
  params
