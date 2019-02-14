import {
  render
} from "@/content"
import {
  setApiBaseURL
} from "@/config"

setApiBaseURL "/base/test/fixtures/api.github.com"

describe "Content", ->
  root = null

  beforeEach ->
    root = document.body.appendChild document.createElement "div"

  afterEach ->
    root.parentNode.removeChild root
    root = null

  describe "render(root, config, callback)", ->
    it "should do nothing when no option given", ->
      render root

    it "should render stylesheet", ->
      render root, {}
      expect root.querySelector "style"
        .be.an.instanceof HTMLElement

    it "should create a widget with className widget", ->
      render root, {}
      expect root.querySelector ".widget"
        .be.an.instanceof HTMLElement
      expect root.querySelector ".widget.large"
        .be.null

    it "should add large to widget.className when data-size is large", ->
      render root, "data-size": "large"
      expect root.querySelector ".widget.large"
        .be.an.instanceof HTMLElement

    it "should append the button to widget when the necessary config is given", ->
      render root, {}
      expect root.querySelector ".btn"
        .be.an.instanceof HTMLElement

    it "should callback with widget", (done) ->
      render root, {}, (widget) ->
        expect widget
          .be.an.instanceof HTMLElement
        done()

    it "should append the button with given href", ->
      config = "href": "https://ntkme.github.com/"
      render root, config
      expect root.querySelector(".btn").getAttribute "href"
        .to.equal config.href

    it "should create a button with href # if domain is not github", ->
      render root, "href": "https://twitter/ntkme"
      expect root.querySelector(".btn").href
        .to.equal document.location.href + "#"
      expect root.querySelector(".btn").target
        .to.equal "_self"

    it "should create an anchor with href # if url contains javascript", ->
      render root, "href": protocol for protocol in [
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
      for btn in root.querySelectorAll ".btn"
        expect btn.href
          .to.equal document.location.href + "#"
        expect btn.target
          .to.equal "_self"

    it "should create an anchor with target _top if url is a download link", ->
      render root, "href": url for url in [
        "https://github.com/ntkme/github-buttons/archive/master.zip"
        "https://codeload.github.com/ntkme/github-buttons/zip/master"
        "https://github.com/octocat/Hello-World/releases/download/v1.0.0/example.zip"
      ]
      for btn in root.querySelectorAll ".btn"
        expect btn
          .to.have.property "target"
          .to.equal "_top"

    it "should append the button with the default icon", ->
      render root, {}
      expect root.querySelector(".btn").querySelector(".octicon.octicon-mark-github")
        .be.an.instanceof SVGElement

    it "should append the button with given icon", ->
      render root, "data-icon": "octicon-star"
      expect root.querySelector(".btn").querySelector(".octicon.octicon-star")
        .be.an.instanceof SVGElement

    it "should append the button with the default if given icon is invalid", ->
      render root, "data-icon": "null"
      expect root.querySelector(".btn").querySelector(".octicon.octicon-mark-github")
        .be.an.instanceof SVGElement

    it "should append the button with given text", ->
      config = "data-text": "Follow"
      render root, config
      expect root.querySelector(".btn").lastChild.innerHTML
        .to.equal config["data-text"]

    it "should append the button with given aria label", ->
      config = "aria-label": "GitHub"
      render root, config
      expect root.querySelector(".btn").getAttribute "aria-label"
        .to.equal config["aria-label"]


    it "should append the count when a known button type is given", (done) ->
      config =
        "href": "https://github.com/ntkme"
        "data-show-count": "true"
      render root, config, (widget) ->
        expect widget.querySelector(".social-count")
          .be.an.instanceof HTMLElement
        done()

    it "should append the count for follow button", (done) ->
      config =
        "href": "https://github.com/ntkme"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        expect count.lastChild.innerHTML
          .to.equal "58"
        expect count.getAttribute "aria-label"
          .to.equal "58 followers on GitHub"
        done()

    it "should append the count for watch button", (done) ->
      config =
        "href": "https://github.com/ntkme/github-buttons/subscription"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/watchers"
        expect count.lastChild.innerHTML
          .to.equal "18"
        expect count.getAttribute "aria-label"
          .to.equal "18 subscribers on GitHub"
        done()

    it "should append the count for star button", (done) ->
      config =
        "href": "https://github.com/ntkme/github-buttons"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/stargazers"
        expect count.lastChild.innerHTML
          .to.equal "397"
        expect count.getAttribute "aria-label"
          .to.equal "397 stargazers on GitHub"
        done()

    it "should append the count for fork button", (done) ->
      config =
        "href": "https://github.com/ntkme/github-buttons/fork"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/network"
        expect count.lastChild.innerHTML
          .to.equal "60"
        expect count.getAttribute "aria-label"
          .to.equal "60 forks on GitHub"
        done()

    it "should append the count for issue button", (done) ->
      config =
        "href": "https://github.com/ntkme/github-buttons/issues"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issue on GitHub"
        done()

    it "should append the count for issue button when it links to new issue", (done) ->
      config =
        "href": "https://github.com/ntkme/github-buttons/issues/new"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issue on GitHub"
        done()

    it "should append the count for button whose link has a tailing slash", (done) ->
      config =
        "href": "https://github.com/ntkme/"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a query", (done) ->
      config =
        "href": "https://github.com/ntkme?tab=repositories"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a hash", (done) ->
      config =
        "href": "https://github.com/ntkme#github-buttons"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a query", (done) ->
      config =
        "href": "https://github.com/ntkme/?tab=repositories"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a hash", (done) ->
      config =
        "href": "https://github.com/ntkme/#github-buttons"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a tailing slash, a query, and a hash", (done) ->
      config =
        "href": "https://github.com/ntkme/?tab=repositories#github-buttons"
        "data-show-count": "true"
      render root, config, (widget) ->
        count = widget.querySelector(".social-count")
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should not append the count for unknown button type", (done) ->
      config =
        "href": "https://github.com/"
        "data-show-count": "true"
      render root, config, (widget) ->
        expect widget.querySelector(".social-count")
          .to.be.null
        done()
