import { document } from './globals'

export const forEach = function (obj, func) {
  for (let i = 0, len = obj.length; i < len; i++) {
    func(obj[i])
  }
}

export const createElementInDocument = function (document) {
  return function (tag, props, children) {
    const el = document.createElement(tag)
    if (props != null) {
      for (const prop in props) {
        const val = props[prop]
        if (val != null) {
          if (el[prop] != null) {
            el[prop] = val
          } else {
            el.setAttribute(prop, val)
          }
        }
      }
    }
    if (children != null) {
      forEach(children, function (child) {
        el.appendChild(typeof child === 'string' ? document.createTextNode(child) : child)
      })
    }
    return el
  }
}

export const createElement = createElementInDocument(document)

export const dispatchOnce = function (func) {
  let onceToken
  return function () {
    if (!onceToken) {
      onceToken = 1
      func.apply(this, arguments)
    }
  }
}

export const hasOwnProperty = function (obj, prop) {
  return {}.hasOwnProperty.call(obj, prop)
}

export const toLowerCase = function (obj) {
  return ('' + obj).toLowerCase()
}
