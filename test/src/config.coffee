describe "Config", ->
  a = null

  beforeEach ->
    a = createElement "a"

  describe "parseConfig(anchor)", ->
    it "should parse the anchor without attribute", ->
      expect parseConfig a
        .to.deep.equal
          "href": ""
          "data-text": ""
          "aria-label": null
          "data-icon": null
          "data-size": null
          "data-show-count": null

    it "should parse the attribute href", ->
      a.href = "https://buttons.github.io/"
      expect parseConfig a
        .to.have.property "href"
        .and.equal a.href

    it "should parse the attribute data-text", ->
      text = "test"
      a.setAttribute "data-text", text
      expect parseConfig a
        .to.have.property "data-text"
        .and.equal text

    it "should parse the text content", ->
      text = "something"
      a.appendChild createTextNode text
      expect parseConfig a
        .to.have.property "data-text"
        .and.equal text

    it "should ignore the text content when the attribute data-text is given", ->
      text = "something"
      a.setAttribute "data-text", text
      a.appendChild createTextNode "something else"
      expect parseConfig a
        .to.have.property "data-text"
        .and.equal text

    it "should parse the attribute data-icon", ->
      icon = "octicon"
      a.setAttribute "data-icon", icon
      expect parseConfig a
        .to.have.property "data-icon"
        .and.equal icon

    it "should parse the attribute data-size", ->
      size = "large"
      a.setAttribute "data-size", size
      expect parseConfig a
        .to.have.property "data-size"
        .and.equal size

    it "should parse the attribute data-style for backward compatibility", ->
      a.setAttribute "data-style", "mega"
      expect parseConfig a
        .to.have.property "data-size"
        .and.equal "large"

    it "should parse the attribute data-show-count", ->
      a.setAttribute "data-show-count", "true"
      expect parseConfig a
        .to.have.property "data-show-count"
        .and.equal "true"

    it "should parse the attribute data-count-api for backward compatibility", ->
      api = "/repos/:user/:repo#item"
      a.setAttribute "data-count-api", api
      expect parseConfig a
        .to.have.property "data-show-count"
        .and.equal "true"

    it "should parse the attribute aria-label", ->
      label = "GitHub"
      a.setAttribute "aria-label", label
      expect parseConfig a
        .to.have.property "aria-label"
        .and.equal label
