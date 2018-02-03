import {
  parseOptions
} from "@/options"

describe "Options", ->
  a = null

  beforeEach ->
    a = document.createElement "a"

  describe "parseOptions(anchor)", ->
    it "should parse the anchor without attribute", ->
      expect parseOptions a
        .to.deep.equal
          "href": ""
          "title": ""
          "data-text": ""
          "aria-label": null
          "data-icon": null
          "data-size": null
          "data-show-count": null

    it "should parse the attribute href", ->
      a.href = "https://buttons.github.io/"
      expect parseOptions a
        .to.have.property "href"
        .and.equal a.href

    it "should parse the attribute href", ->
      a.title = "button"
      expect parseOptions a
        .to.have.property "title"
        .and.equal a.title

    it "should parse the attribute data-text", ->
      text = "test"
      a.setAttribute "data-text", text
      expect parseOptions a
        .to.have.property "data-text"
        .and.equal text

    it "should parse the text content", ->
      text = "something"
      a.appendChild document.createTextNode text
      expect parseOptions a
        .to.have.property "data-text"
        .and.equal text

    it "should ignore the text content when the attribute data-text is given", ->
      text = "something"
      a.setAttribute "data-text", text
      a.appendChild document.createTextNode "something else"
      expect parseOptions a
        .to.have.property "data-text"
        .and.equal text

    it "should parse the attribute data-icon", ->
      icon = "octicon"
      a.setAttribute "data-icon", icon
      expect parseOptions a
        .to.have.property "data-icon"
        .and.equal icon

    it "should parse the attribute data-size", ->
      size = "large"
      a.setAttribute "data-size", size
      expect parseOptions a
        .to.have.property "data-size"
        .and.equal size

    it "should parse the attribute data-style for backward compatibility", ->
      a.setAttribute "data-style", "mega"
      expect parseOptions a
        .to.have.property "data-size"
        .and.equal "large"

    it "should parse the attribute data-show-count", ->
      a.setAttribute "data-show-count", "true"
      expect parseOptions a
        .to.have.property "data-show-count"
        .and.equal "true"

    it "should parse the attribute data-count-api for backward compatibility", ->
      api = "/repos/:user/:repo#item"
      a.setAttribute "data-count-api", api
      expect parseOptions a
        .to.have.property "data-show-count"
        .and.equal "true"

    it "should parse the attribute aria-label", ->
      label = "GitHub"
      a.setAttribute "aria-label", label
      expect parseOptions a
        .to.have.property "aria-label"
        .and.equal label
