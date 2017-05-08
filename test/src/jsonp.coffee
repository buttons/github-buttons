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
        expect window._
          .to.be.null
        expect json
          .to.deep.equal data
        done()

      expect window._
        .to.be.a "function"

      expect window._.$
        .to.have.property "tagName"
        .to.equal "SCRIPT"

      expect window._.$.src.endsWith url + "?callback=_"
        .to.be.true

      expect head.appendChild
        .to.have.been.calledOnce
        .and.have.been.calledWith window._.$

      window._ data
