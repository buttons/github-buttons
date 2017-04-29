describe "JSON-P", ->
  describe "jsonp(url, func)", ->
    head = document.getElementsByTagName("head")[0]

    before ->
      sinon.stub head, "appendChild"

    after ->
      head.appendChild.restore()

    it "should setup the script and callback", (done) ->
      data = test: "test"
      url = "/random/url/" + new Date().getTime()

      jsonp url, (json) ->
        expect window.callback
          .to.be.undefined
        expect json
          .to.deep.equal data
        done()

      expect window.callback
        .to.be.a "function"

      expect window.callback.script
        .to.have.property "tagName"
        .to.equal "SCRIPT"

      expect window.callback.script.src.endsWith url + "?callback=callback"
        .to.be.true

      expect head.appendChild
        .to.have.been.calledOnce
        .and.have.been.calledWith window.callback.script

      window.callback data
