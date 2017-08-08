import data from "octicons/build/data"

octicon = (icon, height) ->
  icon = "#{icon}".toLowerCase().replace /^octicon-/, ""
  icon = "mark-github" unless data[icon]
  width = height * data[icon].width / data[icon].height
  """
  <svg version="1.1" width="#{width}" height="#{height}" viewBox="0 0 #{data[icon].width} #{data[icon].height}" class="octicon octicon-#{icon}" aria-hidden="true">#{data[icon].path}</svg>
  """

export { octicon }
