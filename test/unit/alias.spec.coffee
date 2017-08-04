import {
  document
  encodeURIComponent
  decodeURIComponent
  Math
  createElement
  createTextNode
} from "@/alias"

describe "Alias", ->
  it "should export an alias for window.document", ->
    expect document
      .to.equal window.document

  it "should export an alias for window.encodeURIComponent", ->
    expect encodeURIComponent
      .to.equal window.encodeURIComponent

  it "should export an alias for window.decodeURIComponent", ->
    expect decodeURIComponent
      .to.equal window.decodeURIComponent

  it "should export an alias for window.Math", ->
    expect Math
      .to.equal window.Math

  it "should create an alias for document.createElement()", ->
    element = createElement 'div'
    expect element.nodeType
      .to.equal element.ELEMENT_NODE

  it "should create an alias for document.createTextNode()", ->
    text = createTextNode 'hello world'
    expect text.nodeType
      .to.equal text.TEXT_NODE
