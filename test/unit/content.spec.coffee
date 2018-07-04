import {
  render
} from "@/content"

describe "Frame Content", ->
  root = document.body

  describe "render(root, config)", ->
    className = root.className

    afterEach ->
      root.className = className

    it "should do nothing when no option given", ->
      render root

    it "should set root.className when data-size is large", ->
      render root, "data-size": "large"
      expect root.className
        .to.equal "large"

    it "should call Button::render()", ->
      render root, "href": "https://google.com"

    it "should call SocialCount::render() when data-show-count is true", ->
      render root,
        "href": "https://google.com"
        "data-show-count": true
