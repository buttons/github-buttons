import {
  baseURL
  setBaseURL
  currentScriptURL
} from "@/config"

originalBaseURL = "" + baseURL
setBaseURL currentScriptURL

describe "Config", ->
  it "should export base url", ->
    expect originalBaseURL
      .to.match ///^https?://buttons.github.io/$///

  describe "setBaseURL(url)", ->
    it "should set relative base url when document.currentScript is safe to use", ->
      expect originalBaseURL
        .to.not.equal baseURL
