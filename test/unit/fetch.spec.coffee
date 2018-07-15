import {
  fetch
} from "@/fetch"

describe "Fetch", ->
  beforeEach ->
    sinon.spy JSON, "parse"

  afterEach ->
    JSON.parse.restore()

  describe "fetch(url, func)", ->
    it "should fetch url as json", (done) ->
      fetch "/base/test/fixtures/api.github.com/repos/ntkme/github-buttons", (error, data) ->
        expect !!error
          .to.be.false
        done()
        expect data.owner.login
          .to.equal "ntkme"
        done()

    it "should handle error", (done) ->
      fetch "/404", (error, data) ->
        expect !!error
          .to.be.true
        done()

    it "should combine identical pending requests", ->
      Promise.all([
        new Promise (resolve, reject) ->
          fetch "/base/test/fixtures/api.github.com/users/ntkme", (error, data) ->
            expect data.login
              .to.equal "ntkme"
            resolve()
          return
      ,
        new Promise (resolve, reject) ->
          fetch "/base/test/fixtures/api.github.com/users/ntkme", (error, data) ->
            expect data.login
              .to.equal "ntkme"
            resolve()
          return
      ]).then ->
        expect JSON.parse
          .to.be.calledOnce

