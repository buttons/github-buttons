import {
  render
} from  "@/button"

describe "Button", ->
  root = document.body

  describe "render(root, config)", ->
    beforeEach ->
      sinon.stub root, "appendChild"

    afterEach ->
      root.appendChild.restore()

    it "should append the button to root when the necessary config is given", ->
      render root, {}
      expect root.appendChild
        .to.have.been.calledOnce
      button = root.appendChild.args[0][0]
      expect button
        .to.have.property "className"
        .and.equal "btn"

    it "should append the button with given href", ->
      config = "href": "https://ntkme.github.com/"
      render root, config
      button = root.appendChild.args[0][0]
      expect button.getAttribute "href"
        .to.equal config.href

    it "should create a button with href # if domain is not github", ->
      render root, "href": "https://twitter/ntkme"
      button = root.appendChild.args[0][0]
      expect button
        .to.have.property "href"
        .to.equal document.location.href + "#"
      expect button
        .to.have.property "target"
        .to.equal "_self"

    it "should create an anchor with href # if url contains javascript", ->
      for i, protocol of [
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
        render root, "href": protocol
        button = root.appendChild.args[i][0]
        expect button
          .to.have.property "href"
          .to.equal document.location.href + "#"
        expect button
          .to.have.property "target"
          .to.equal "_self"

    it "should create an anchor with target _top if url is a download link", ->
      for i, url of [
        "https://github.com/ntkme/github-buttons/archive/master.zip"
        "https://codeload.github.com/ntkme/github-buttons/zip/master"
        "https://github.com/octocat/Hello-World/releases/download/v1.0.0/example.zip"
      ]
        render root, "href": url
        button = root.appendChild.args[i][0]
        expect button
          .to.have.property "target"
          .to.equal "_top"

    it "should append the button with the default icon", ->
      render root, {}
      button = root.appendChild.args[0][0]
      expect " #{button.firstChild.getAttribute "class"} ".indexOf " octicon "
        .to.be.at.least 0
      expect " #{button.firstChild.getAttribute "class"} ".indexOf " octicon-mark-github "
        .to.be.at.least 0

    it "should append the button with given icon", ->
      config = "data-icon": "octicon-star"
      render root, config
      button = root.appendChild.args[0][0]
      expect " #{button.firstChild.getAttribute "class"} ".indexOf " #{config["data-icon"]} "
        .to.be.at.least 0

    it "should append the button with given text", ->
      config = "data-text": "Follow"
      render root, config
      button = root.appendChild.args[0][0]
      expect button.lastChild.innerHTML
        .to.equal config["data-text"]

    it "should append the button with given aria label", ->
      config = "aria-label": "GitHub"
      render root, config
      button = root.appendChild.args[0][0]
      expect button.getAttribute "aria-label"
        .to.equal config["aria-label"]
