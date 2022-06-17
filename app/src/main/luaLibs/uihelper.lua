import "android.util.TypedValue"
--[[
   m3appreance list:
   ActionBar.Title
   ActionBar.Subtitle

   BodyLarge   DisplayLarge
   BodyMedium  DisplayMedium
   BodySmall   DisplaySmall   
   
   HeadlineLarge  TitleLarge
   HeadlineMedium TitleMedium
   HeadlineSmall  TitleSmall
]]--

local uihelper = {}
local dp2intCache = {}

local function runOnUiThread(activity, f)
  activity.runOnUiThread(luajava.createProxy('java.lang.Runnable', {
    run = f
  }))
end

local density
local screenWidth
local context = activity or service

local function dp2px(dp)
  if density == nil then
    density = context.getResources().getDisplayMetrics().density
    screenWidth = context.getResources().getDisplayMetrics().widthPixels
  end
  return 0.5 + dp * density
end

local function getNavHeight()
  local navigationBarHeight = 0
  local resourceId = activity.getResources().getIdentifier("navigation_bar_height", "dimen", "android")
  if resourceId > 0 then
    navigationBarHeight = resources.getDimensionPixelSize(resourceId)
  end
  return navigationBarHeight
end

local function getScreenWidth()
  if screenWidth == nil then
    dp2px(0)
  end
  return screenWidth
end

local function getAttr(str)
  local attrs = {R.attr[str]}
  local ta = activity.obtainStyledAttributes(attrs)
  local resId = ta.getResourceId(0, 0)
  ta.recycle()
  return resId
end

local function m3appreance(s)
  local str = string.format("TextAppearance_Material3_%s", s)
  return R.style[str]
end

local function getIdentifier(type, name)
  return context.getResources().getIdentifier(name, type, activity.getPackageName())
end

local function dp2int(dpValue)
  local cache=dp2intCache[dpValue]
  if cache then
    return cache
   else
    import "android.util.TypedValue"
    local cache=TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, context.getResources().getDisplayMetrics())
    dp2intCache[dpValue]=cache
    return cache
  end
end

local function px2sp(pxValue)
  local scale=context.getResources().getDisplayMetrics().scaledDensity
  return pxValue/scale
end

uihelper.getAttr = getAttr
uihelper.runOnUiThread = runOnUiThread
uihelper.dp2px = dp2px
uihelper.dp2int = dp2int
uihelper.px2sp = px2sp
uihelper.getScreenWidth = getScreenWidth
uihelper.getNavHeight = getNavHeight
uihelper.getIdentifier = getIdentifier
uihelper.m3appreance = m3appreance

return uihelper