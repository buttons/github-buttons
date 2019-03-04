import {
  document
  location
  encodeURIComponent
  decodeURIComponent
  Math
} from "@/globals"

describe "Globals", ->
  it "should export an alias for window.document", ->
    expect document
      .to.equal window.document

  it "should export an alias for window.document", ->
    expect location
      .to.equal document.location

  it "should export an alias for window.encodeURIComponent", ->
    expect encodeURIComponent
      .to.equal window.encodeURIComponent

  it "should export an alias for window.decodeURIComponent", ->
    expect decodeURIComponent
      .to.equal window.decodeURIComponent

  it "should export an alias for window.Math", ->
    expect Math
      .to.equal window.Math
