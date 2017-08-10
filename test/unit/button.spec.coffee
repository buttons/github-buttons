import {
  renderButton
} from  "@/button"

describe "Button", ->
  describe "renderButton(config)", ->
    beforeEach ->
      sinon.stub document.body, "appendChild"

    afterEach ->
      document.body.appendChild.restore()

    it "should append the button to document.body when the necessary config is given", ->
      renderButton {}
      expect document.body.appendChild
        .to.have.been.calledOnce
      button = document.body.appendChild.args[0][0]
      expect button
        .to.have.property "className"
        .and.equal "btn"

    it "should append the button with given href", ->
      config = "href": "https://ntkme.github.com/"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect button.getAttribute "href"
        .to.equal config.href

    it "should create a button with href # if domain is not github", ->
      renderButton "href": "https://twitter/ntkme"
      button = document.body.appendChild.args[0][0]
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
        renderButton "href": protocol
        button = document.body.appendChild.args[i][0]
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
        renderButton "href": url
        button = document.body.appendChild.args[i][0]
        expect button
          .to.have.property "target"
          .to.equal "_top"

    it "should append the button with the default icon", ->
      renderButton {}
      button = document.body.appendChild.args[0][0]
      expect " #{button.firstChild.getAttribute "class"} ".indexOf " octicon "
        .to.be.at.least 0
      expect " #{button.firstChild.getAttribute "class"} ".indexOf " octicon-mark-github "
        .to.be.at.least 0

    it "should append the button with given icon", ->
      config = "data-icon": "octicon-star"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect " #{button.firstChild.getAttribute "class"} ".indexOf " #{config["data-icon"]} "
        .to.be.at.least 0

    it "should append the button with given text", ->
      config = "data-text": "Follow"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect button.lastChild.innerHTML
        .to.equal config["data-text"]

    it "should append the button with given aria label", ->
      config = "aria-label": "GitHub"
      renderButton config
      button = document.body.appendChild.args[0][0]
      expect button.getAttribute "aria-label"
        .to.equal config["aria-label"]
