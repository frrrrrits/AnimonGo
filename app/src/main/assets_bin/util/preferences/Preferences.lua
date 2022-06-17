local Preferences={}
import "util.preferences.PreferencesKeys"
local context = context or activity

Preferences.keys = PreferencesKeys.keys
Preferences.values = PreferencesKeys.values

function setPref(...)
  return context.setSharedData(...)
end

function getPref(...)
  return context.getSharedData(...)
end

function Preferences.getkeys(v)
  return PreferencesKeys.keys[v].keys
end

function Preferences.setPrefIfNull(k, v)
  if getPref(k) == nil then setPref(k, v) end
end

function Preferences.key(k)
  local self = { keys = Preferences.getkeys(k) }
  local setpref = function(v) setPref(self.keys, v) end
  local get = function() return getPref(self.keys) end
  return { get = get, setpref = setpref }
end

----- preferences start ------

-- set preferences first open app
table.foreach(PreferencesKeys.keys,function(index,content)
  Preferences.setPrefIfNull(content.keys, content.default_value)
end)

function Preferences.themeMode()
  return Preferences.key("themeMode")
end
function Preferences.themeStyle()
  return Preferences.key("themeStyle")
end
function Preferences.potraitColumns()
  return Preferences.key("portraitColumns")
end
function Preferences.landscapeColumns()
  return Preferences.key("landscapeColumns")
end
function Preferences.orientation()
  return Preferences.key("configOrientation")
end
function Preferences.updater()
  return Preferences.key("updater")
end
function Preferences.scheduleUpdate()
  return Preferences.key("scheduleUpdate")
end
function Preferences.navbarPosition()
  return Preferences.key("navbarPosition")
end
function Preferences.isUpdate()
  return Preferences.key("isUpdate")
end

return Preferences