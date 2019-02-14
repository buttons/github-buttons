import {
  baseURL
  htmlPath
  setBaseURL
} from "@/config"

originalBaseURL = "" + baseURL
setBaseURL "/something/else"

describe "Config", ->
  it "should export base url", ->
    expect originalBaseURL
      .to.match ///^https?://(?:buttons.github.io|unpkg.com/.*@.*/dist)$///

  it "should export html path", ->
    expect htmlPath
      .to.equal "/buttons.html"

  describe "setBaseURL(url)", ->
    it "should set relative base url when document.currentScript is safe to use", ->
      expect originalBaseURL
        .to.not.equal baseURL
