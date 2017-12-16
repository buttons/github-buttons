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

    it "should set up the callback function", ->
      jsonp "hello", ->

      expect window._
        .to.be.a "function"

      expect window._._
        .to.be.a "function"

    it "should setup the script and add callback query to request url", ->
      url = "/random/url/" + new Date().getTime()

      jsonp url

      expect head.appendChild
        .to.have.been.calledOnce

      expect head.appendChild.args[0][0]
        .to.have.property "tagName"
        .to.equal "SCRIPT"

      expect head.appendChild.args[0][0].getAttribute "src"
        .to.equal url + "?callback=_"

    it "should append callback query to request url with existing query", ->
      url = "/random/url?query=" + new Date().getTime()

      jsonp url

      expect head.appendChild.args[0][0].getAttribute "src"
        .to.equal url + "&callback=_"

    it "should clean up and run callback when request is fulfilled", (done) ->
      data = test: "test"

      jsonp "world", (error, json) ->
        expect window._
          .to.be.null
        expect !!error
          .to.be.false
        expect json
          .to.deep.equal data
        done()

      window._ data

    it "should clean up when request is failed", (done) ->
      jsonp "fail", (error, json) ->
        expect !!error
          .to.be.true
        done()

      head.appendChild.args[0][0].dispatchEvent new CustomEvent "error"
