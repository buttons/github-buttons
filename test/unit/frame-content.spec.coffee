import {
  renderFrameContent
} from "@/frame-content"

describe "Frame Content", ->
  describe "renderFrameContent(config)", ->
    className = document.body.className

    afterEach ->
      document.body.className = className

    it "should do nothing when no option given", ->
      renderFrameContent()

    it "should set document.body.className when data-size is large", ->
      renderFrameContent "data-size": "large"
      expect document.body.className
        .to.equal "large"

    it "should call renderButton()", ->
      renderFrameContent "href": "https://google.com"

    it "should call renderSocialCount() when data-show-count is true", ->
      renderFrameContent
        "href": "https://google.com"
        "data-show-count": true
