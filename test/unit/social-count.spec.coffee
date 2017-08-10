import {
  renderSocialCount
} from "@/social-count"

describe "Social Sount", ->
  describe "renderSocialCount(button)", ->
    button = null
    head = document.getElementsByTagName("head")[0]

    beforeEach ->
      button = document.body.appendChild document.createElement "a"
      sinon.stub document.body, "insertBefore"

    afterEach ->
      button.parentNode.removeChild button
      document.body.insertBefore.restore()

    testRenderCount = (url, func) ->
      sinon.stub head, "appendChild"
        .callsFake ->
          sinon.stub window, "_"
            .callsFake ->
              args = window._.args[0]
              window._.restore()
              window._.apply null, args
              func()
          script = head.appendChild.args[0][0]
          script.src = script.src.replace /^https?:\/\//, "/base/test/fixtures/"
          head.appendChild.restore()
          head.appendChild script
      button.href = url
      renderSocialCount button

    it "should append the count when a known button type is given", (done) ->
      testRenderCount "https://github.com/ntkme", ->
        expect document.body.insertBefore
          .to.have.been.calledOnce
        count = document.body.insertBefore.args[0][0]
        expect count
          .to.have.property "className"
          .and.equal "social-count"
        done()

    it "should append the count for follow button", (done) ->
      testRenderCount "https://github.com/ntkme", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        expect count.lastChild.innerHTML
          .to.equal "53"
        expect count.getAttribute "aria-label"
          .to.equal "53 followers on GitHub"
        done()

    it "should append the count for watch button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/subscription", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/watchers"
        expect count.lastChild.innerHTML
          .to.equal "14"
        expect count.getAttribute "aria-label"
          .to.equal "14 subscribers on GitHub"
        done()

    it "should append the count for star button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/stargazers"
        expect count.lastChild.innerHTML
          .to.equal "302"
        expect count.getAttribute "aria-label"
          .to.equal "302 stargazers on GitHub"
        done()

    it "should append the count for fork button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/fork", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/network"
        expect count.lastChild.innerHTML
          .to.equal "42"
        expect count.getAttribute "aria-label"
          .to.equal "42 forks on GitHub"
        done()

    it "should append the count for issue button", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/issues", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issues on GitHub"
        done()

    it "should append the count for issue button when it links to new issue", (done) ->
      testRenderCount "https://github.com/ntkme/github-buttons/issues/new", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/github-buttons/issues"
        expect count.lastChild.innerHTML
          .to.equal "1"
        expect count.getAttribute "aria-label"
          .to.equal "1 open issues on GitHub"
        done()

    it "should append the count for button whose link has a tailing slash", (done) ->
      testRenderCount "https://github.com/ntkme/", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a query", (done) ->
      testRenderCount "https://github.com/ntkme?tab=repositories", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a hash", (done) ->
      testRenderCount "https://github.com/ntkme#github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a query", (done) ->
      testRenderCount "https://github.com/ntkme/?tab=repositories", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has both a tailing slash and a hash", (done) ->
      testRenderCount "https://github.com/ntkme/#github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should append the count for button whose link has a tailing slash, a query, and a hash", (done) ->
      testRenderCount "https://github.com/ntkme/?tab=repositories#github-buttons", ->
        count = document.body.insertBefore.args[0][0]
        expect count.href
          .to.equal "https://github.com/ntkme/followers"
        done()

    it "should not append the count for unknown button type", ->
      button.href = "https://twitter.com/"
      renderSocialCount button
      button.href = "https://github.com/"
      renderSocialCount button
      button.href = "https://github.com/ntkme/github-buttons/test"
      renderSocialCount button
      expect document.body.insertBefore
        .to.have.not.been.called


    it "should not append the count when it fails to pull api data", ->
      sinon.stub head, "appendChild"
        .callsFake ->
          head.appendChild.restore()
          window._ meta: status: 404
          expect document.body.insertBefore
            .to.have.not.been.called
      button.href = "https://github.com/ntkme"
      renderSocialCount button
