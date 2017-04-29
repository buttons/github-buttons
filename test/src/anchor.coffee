describe "Anchor", ->
  base = null

  before ->
    base = document.getElementsByTagName("head")[0].appendChild createElement "base"

  after ->
    base.parentNode.removeChild base

  describe "createAnchor(url, baseUrl)", ->
    it "should create an anchor element", ->
      expect createAnchor()
        .to.have.property "tagName"
        .to.equal "A"

    it "should create an anchor with given url", ->
      url = "https://github.com/"
      expect createAnchor url
        .to.have.property "href"
        .to.equal url

    it "should create an anchor with given relative url", ->
      expect createAnchor "/ntkme/github-buttons", "https://github.com/ntkme"
        .to.have.property "href"
        .to.equal "https://github.com/ntkme/github-buttons"

    it "should create an anchor with given relative url withoug rely on new URL()", ->
      sinon.stub window, "URL"
        .throws()
      expect createAnchor "/ntkme/github-buttons", "https://github.com/ntkme"
        .to.have.property "href"
        .to.equal "https://github.com/ntkme/github-buttons"
      return if typeof window.URL isnt "function"
      window.URL.restore()

    it "should not set base href", ->
      sinon.stub window, "URL"
        .throws()
      createAnchor "/ntkme/github-buttons", "https://github.com/ntkme"
      expect base.getAttribute "href"
        .to.be.null
      return if typeof window.URL isnt "function"
      window.URL.restore()

    it "should create an anchor with href # if domain is not github", ->
      anchor = createAnchor "https://twitter/ntkme"
      expect anchor
        .to.have.property "href"
        .to.equal document.location.href + "#"
      expect anchor
        .to.have.property "target"
        .to.equal "_self"

    it "should create an anchor with href # if url contains javascript", ->
      for protocol in [
        "javascript:"
        "JAVASCRIPT:"
        "JavaScript:"
        " javascript:"
        "   javascript:"
        "\tjavascript:"
        "\njavascript:"
        "\rjavascript:"
        "\fjavascript:"
      ]
        anchor = createAnchor protocol
        expect anchor
          .to.have.property "href"
          .to.equal document.location.href + "#"
        expect anchor
          .to.have.property "target"
          .to.equal "_self"

    it "should create an anchor with target _top if url is a download link", ->
      for url in [
        "https://github.com/ntkme/github-buttons/archive/master.zip"
        "https://codeload.github.com/ntkme/github-buttons/zip/master"
        "https://github.com/octocat/Hello-World/releases/download/v1.0.0/example.zip"
      ]
        expect createAnchor url
          .to.have.property "target"
          .to.equal "_top"

