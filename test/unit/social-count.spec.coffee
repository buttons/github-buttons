import {
  setApiBaseURL
} from "@/config"
import {
  render
} from "@/social-count"

setApiBaseURL "/base/test/fixtures/api.github.com/"

describe "Social Sount", ->
  describe "render(button)", ->
    button = null
    head = document.getElementsByTagName("head")[0]

    beforeEach ->
      button = document.body.appendChild document.createElement "a"

    afterEach ->
      button.parentNode.removeChild button

    testRenderCount = (url, func) ->
      sinon.stub document.body, "insertBefore"
        .callsFake ->
          document.body.insertBefore.restore()
          func.apply null, arguments
          return
      button.href = url
      render button

    it "should append the count when a known button type is given", (done) ->
      testRenderCount "https://github.com/ntkme", (count) ->
        expect count
          .to.have.property "className"
          .and.equal "social-count"
        done()

    it "should append the count for follow button", (done) ->
      testRenderCount "https://github.com/ntkme", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        expect count.lastChild.innerHTML
          .to.equal "58"
        expect count.getAttribute "aria-label"
          .to.equal "58 followers on GitHub"
        done()

    it "should append the count for watch button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/subscription", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/watchers"
        expect count.lastChild.innerHTML
          .to.equal "18"
        expect count.getAttribute "aria-label"
          .to.equal "18 subscribers on GitHub"
        done()

    it "should append the count for star button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/stargazers"
        expect count.lastChild.innerHTML
          .to.equal "397"
        expect count.getAttribute "aria-label"
          .to.equal "397 stargazers on GitHub"
        done()

    it "should append the count for fork button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/fork", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/network"
        expect count.lastChild.innerHTML
          .to.equal "60"
        expect count.getAttribute "aria-label"
          .to.equal "60 forks on GitHub"
        done()

    it "should append the count for issue button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/issues", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issues on GitHub"
        done()

    it "should append the count for issue button when it links to new issue", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/issues/new", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issues on GitHub"
        done()

    it "should append the count for button whose link has a tailing slash", (done) ->
      testRenderCount "https://github.com/ntkme/", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a query", (done) ->
      testRenderCount "https://github.com/ntkme?tab=repositories", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a hash", (done) ->
      testRenderCount "https://github.com/ntkme#github-buttons", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a query", (done) ->
      testRenderCount "https://github.com/ntkme/?tab=repositories", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a hash", (done) ->
      testRenderCount "https://github.com/ntkme/#github-buttons", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a tailing slash, a query, and a hash", (done) ->
      testRenderCount "https://github.com/ntkme/?tab=repositories#github-buttons", (count) ->
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should not append the count for unknown button type", ->
      sinon.stub document.body, "insertBefore"

      button.href = "https://twitter.com/"
      render button
      button.href = "https://github.com/"
      render button
      button.href = "https://github.com/ntkme/github-buttons/test"
      render button
      expect document.body.insertBefore
        .to.have.not.been.called

      document.body.insertBefore.restore()
