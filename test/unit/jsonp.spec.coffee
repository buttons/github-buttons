import {
  jsonp
} from "@/jsonp"

describe "JSON-P", ->
  describe "jsonp(url, func)", ->
    head = document.getElementsByTagName("head")[0]

    beforeEach ->
      sinon.stub head, "appendChild"

    afterEach ->
      head.appendChild.restore()

    it "should set up the script and callback function", ->
      jsonp "hello", ->

      expect window._
        .to.be.a "function"

      expect window._.$
        .to.have.property "tagName"
        .to.equal "SCRIPT"

      expect head.appendChild
        .to.have.been.calledOnce
        .and.have.been.calledWith window._.$

    it "should add callback query to request url", ->
      url = "/random/url/" + new Date().getTime()

      jsonp url

      expect window._.$.src.endsWith url + "?callback=_"
        .to.be.true

    it "should append callback query to request url with existing query", ->
      url = "/random/url?query=" + new Date().getTime()

      jsonp url

      expect window._.$.src.endsWith url + "&callback=_"
        .to.be.true

    it "should clean up and run callback when request is fulfilled", (done) ->
      data = test: "test"

      jsonp "world", (json) ->
        expect window._
          .to.be.null
        expect json
          .to.deep.equal data
        done()

      window._ data

    it "should clean up when request is failed", ->
      jsonp "fail"

      window._.$.dispatchEvent new CustomEvent "error"

      expect window._
        .to.be.null
