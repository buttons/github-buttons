import {
  currentScriptURL
} from "@/current-script"

describe "Current Script", ->
  it "should export current script url if available and safe", ->
    if currentScriptURL
      expect currentScriptURL
        .to.have.string "current-script.spec"
    else
      expect currentScriptURL
        .to.be.undefined
