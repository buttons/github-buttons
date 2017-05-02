describe "Event", ->
  input = null

  beforeEach ->
    input = document.body.appendChild createElement "input"

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
  describe "onceScriptLoad", ->
    head = document.getElementsByTagName("head")[0]
    script = null

    beforeEach ->
      script = createElement "script"

    afterEach ->
      script.parentNode.removeChild script

    it "should call the function on script load only once", (done) ->
      script.src = "../buttons.js"
      onceScriptLoad script, done
      head.appendChild script

    it "should call the function on script error only once", (done) ->
      script.src = "404.js"
      onceScriptLoad script, done
      head.appendChild script
