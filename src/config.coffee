Config =
  api:         "https://api.github.com"
  anchorClass: "github-button"
  iconClass:   "octicon"
  icon:        "octicon-mark-github"
  scriptId:    "github-bjs"
  styles:     ["default", "mega"]

if Config.script = document.getElementById Config.scriptId
  Config.url = Config.script.src.replace /buttons\.js([?#].*)?$/, ""
