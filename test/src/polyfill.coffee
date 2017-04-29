if !String.prototype.endsWith
  String.prototype.endsWith = (searchString, position) ->
    subjectString = this.toString()
    if typeof position isnt "number" or !isFinite(position) or Math.floor(position) isnt position or position > subjectString.length
      position = subjectString.length
    position -= searchString.length
    lastIndex = subjectString.lastIndexOf(searchString, position)
    return lastIndex isnt -1 and lastIndex is position
