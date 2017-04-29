describe "Frame", ->
  iframe = null

  getRandomInt = (min = 0, max = 1000) ->
    min = Math.ceil min
    max = Math.floor max
    Math.floor(Math.random() * (max - min)) + min

  html = (size) ->
    """
    <!DOCTYPE html>
    <html lang="ja">
    <head>
      <meta charset="utf-8">
      <title></title>
    </head>
    <body style="margin: 0;">
      <div style="width: #{size[0]}px; height: #{size[1]}px;"></div>
    </body>
    </html>
    """

  beforeEach ->
    iframe = document.body.appendChild createElement "iframe"

  afterEach ->
    iframe.parentNode.removeChild iframe

  describe "getFrameContentSize(iframe)", ->
    it "should return iframe content size", (done) ->
      size = [getRandomInt(), getRandomInt()]
      setFrameSize iframe, [1, 0]
      onEvent iframe, "load", ->
        expect getFrameContentSize iframe
          .to.deep.equal size
        done()
      contentDocument = iframe.contentWindow.document
      contentDocument.open().write html size
      contentDocument.close()

  describe "setFrameSize(iframe, size)", ->
    it "should set width and height on iframe", ->
      setFrameSize iframe, [0, 0]
      expect iframe.scrollWidth
        .to.equal 0
      expect iframe.scrollHeight
        .to.equal 0

      setFrameSize iframe, [50, 100]
      expect iframe.scrollWidth
        .to.equal 50
      expect iframe.scrollHeight
        .to.equal 100
