import {
  onEvent
  onceEvent
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
