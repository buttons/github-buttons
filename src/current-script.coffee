import {
  document
} from "./alias"

currentScript = "currentScript"
### istanbul ignore next ###
currentScriptURL = if not {}.hasOwnProperty.call(document, currentScript) \
                      and document[currentScript] \
                      and delete document[currentScript] \
                      and document[currentScript]
  document[currentScript].src

export {
  currentScriptURL
}
