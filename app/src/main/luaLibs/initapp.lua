require "import"
import "math"
import "util.preferences.Preferences"

R = luajava.bindClass(activity.getPackageName()..".R")
aR = luajava.bindClass("com.androlua.R")

import "androidx"
import "toimport"

uihelper = require "uihelper"

local fitsystem = false
context = content or activity or service
resources = context.getResources()

if activity then
  window = activity.getWindow() else
  notLoadTheme = true
end

window = activity.getWindow()
appbar_scrolling_behavior = import "com.google.android.material.appbar.AppBarLayout$ScrollingViewBehavior"

local theme={
  color={ActionBar={}},
  number={id={}},
  boolean={}
}
_G.theme = theme

if not(notLoadTheme) then
  local color = theme.color
  local number = theme.number
  local dimens = {"card_radius","dialog_radius","button_radius"}
  for index,content in ipairs(dimens) do
    number[content] = resources.getDimension(R.dimen[content])
  end
  import "util.system.Themes"
  Themes.refreshUI()
end