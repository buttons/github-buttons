import {
  render
} from "@/content"

describe "Frame Content", ->
  root = null

  beforeEach ->
    root = document.body.appendChild document.createElement "div"

  afterEach ->
    root.parentNode.removeChild root
    root = null

  describe "render(root, config, callback)", ->
    it "should do nothing when no option given", ->
      render root

    it "should call Style::render()", ->
      render root, {}
      expect root.getElementsByTagName("style").length
        .to.equal 1

    it "should add widget to container.className", ->
      render root, {}
      expect root.getElementsByTagName("div")[0].className
        .to.equal "widget"

    it "should add large to container.className when data-size is large", ->
      render root, "data-size": "large"
      expect root.getElementsByTagName("div")[0].className
        .to.equal "widget large"

    it "should call Button::render()", ->
      render root, "href": "https://google.com"

    it "should call SocialCount::render() when data-show-count is true", ->
      render root,
        "href": "https://google.com"
        "data-show-count": true

    it "should call callback function with created container", (done) ->
      render root, {}, (el) ->
        expect el.tagName
          .to.equal "DIV"
        done()

    it "should call callback function with created container when data-show-count is true", (done) ->
      render root,
        "href": "https://google.com"
        "data-show-count": true
      , (el) ->
        expect el.tagName
          .to.equal "DIV"
        done()
