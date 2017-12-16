import {
  onEvent
  onceEvent
  onceScriptError
} from "@/event.coffee"

describe "Event", ->
  input = null

  beforeEach ->
    input = document.body.appendChild document.createElement "input"

  afterEach ->
    input.parentNode.removeChild input

  describe "onEvent(target, eventName, func)", ->
    it "should call the function on event", ->
      spy = sinon.spy()
      onEvent input, "click", spy

      input.click()
      expect spy
        .to.have.been.calledOnce

      input.click()
      expect spy
        .to.have.been.calledTwice

  describe "onceEvent(target, eventName, func)", ->
    it "should call the function on event only once", ->
      spy = sinon.spy()
      onceEvent input, "click", spy

      input.click()
      expect spy
        .to.have.been.calledOnce

      input.click()
      expect spy
        .to.have.been.calledOnce

      input.click()
      expect spy
        .to.have.been.calledOnce

describe "ScriptEvent", ->
  describe "onceScriptError(script, func)", ->
    head = document.getElementsByTagName("head")[0]
    script = null

    beforeEach ->
      script = document.createElement "script"

    afterEach ->
      script.parentNode.removeChild script

    it "should call the function on script error only once", (done) ->
      script.src = "404.js"
      onceScriptError script, (error) ->
        expect !!error
          .to.be.true
        done()
      head.appendChild script
