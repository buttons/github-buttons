import {
  encodeURIComponent
  decodeURIComponent
} from "./alias"

export stringify = (obj) ->
  params = []
  for name, value of obj
    params.push "#{encodeURIComponent name}=#{encodeURIComponent value}" if value?
  params.join "&"

export parse = (str) ->
  params = {}
  for pair in str.split "&" when pair isnt ""
    ref = pair.split "="
    params[decodeURIComponent ref[0]] = (decodeURIComponent ref.slice(1).join "=" if ref[1]?)
  params
