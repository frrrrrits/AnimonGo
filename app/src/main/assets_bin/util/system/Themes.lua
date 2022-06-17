local Themes={}

local context=activity or service
local theme=_G.theme
local SDK_INT=Build.VERSION.SDK_INT

import "util.preferences.Preferences"

local function isSysNightMode()
  import "android.content.res.Configuration"
  return (context.getResources().getConfiguration().uiMode)==Configuration.UI_MODE_NIGHT_YES+1
  and Preferences.values.apptheme.dark
end

local defaults, gurein, pingu

if isSysNightMode() then
  defaults = 0xFFAEC6FF
  gurein = 0xff7DDC6F
  pingu = 0xffffb4a9
 else
  defaults = 0xFF0057CE
  gurein = 0xFF006E0D
  pingu = 0xFFC0000F
end

Themes.APPTHEMES = {
  {
    name="Animongo",
    show={
      name="Animongo",
      preview=defaults,
    },
  },
  {
    name="Gurein",
    show={
      name="Animongo_Gurein",
      preview=gurein,
    },
  },
  {
    name="Pingu",
    show={
      name="Animongo_Pingu",
      preview=pingu,
    },
  },
}

Themes.NowAppTheme=nil

local Name2AppTheme={}
Themes.Name2AppTheme=Name2AppTheme

for index,content in ipairs(Themes.APPTHEMES)
  Name2AppTheme[content.name]=content
end

Themes.isSysNightMode=isSysNightMode

function Themes.refreshThemeColor()
  local array = context.getTheme().obtainStyledAttributes({
    android.R.attr.textColorTertiary,
    android.R.attr.textColorPrimary,
    android.R.attr.colorPrimary,
    android.R.attr.colorPrimaryDark,
    android.R.attr.colorAccent,
    android.R.attr.navigationBarColor,
    android.R.attr.statusBarColor,
    android.R.attr.colorButtonNormal,
    android.R.attr.windowBackground,
    android.R.attr.textColorSecondary,
    R.attr.colorSurface,
    R.attr.colorOnSurface,
    R.attr.colorTertiary,
    R.attr.colorOnTertiary,
    R.attr.colorPrimaryInverse,
  })

  local colorList=theme.color
  colorList.textColorTertiary=array.getColor(0,0)
  colorList.textColorPrimary=array.getColor(1,0)
  colorList.colorPrimary=array.getColor(2,0)
  colorList.colorPrimaryDark=array.getColor(3,0)
  colorList.colorAccent=array.getColor(4,0)
  colorList.navigationBarColor=array.getColor(5,0)
  colorList.statusBarColor=array.getColor(6,0)
  colorList.colorButtonNormal=array.getColor(7,0)
  colorList.windowBackground=array.getColor(8,0)
  colorList.textColorSecondary=array.getColor(9,0)
  colorList.colorSurface=array.getColor(10,0)
  colorList.colorOnSurface=array.getColor(11,0)
  colorList.colorTertiary=array.getColor(12,0)
  colorList.colorOnTertiary=array.getColor(13,0)
  colorList.colorPrimaryInverse=array.getColor(14,0)
  array.recycle()

  local numberList=theme.number
  local array = context.getTheme().obtainStyledAttributes({
    android.R.attr.selectableItemBackgroundBorderless,
    android.R.attr.selectableItemBackground,
    R.attr.actionBarTheme,
  })

  numberList.id.selectableItemBackgroundBorderless=array.getResourceId(0,0)
  numberList.id.selectableItemBackground=array.getResourceId(1,0)
  numberList.id.actionBarTheme=array.getResourceId(2,0)
  array.recycle()

  local booleanList=theme.boolean
  local array = context.getTheme().obtainStyledAttributes({
    R.bool.lightStatusBar,
    R.bool.lightNavigationBar,
  })

  booleanList.lightNavigationBar=array.getBoolean(0,false)
  booleanList.lightStatusBar=array.getBoolean(1,false)
  array.recycle()

  local array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    android.R.attr.textColorSecondary,
    R.attr.colorControlNormal,
  })

  local actionBarColorList=theme.color.ActionBar
  actionBarColorList.textColorSecondary=array.getColor(0,0)
  actionBarColorList.colorControlNormal=array.getColor(1,0)
  array.recycle()

  local array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    R.attr.elevation,
    R.attr.actionBarSize
  })

  numberList.actionBarElevation=array.getDimension(0,0)
  numberList.actionBarSize=array.getDimension(1,0)
  array.recycle()
  return colorList
end


function Themes.setStatusBarColor(color)
  theme.color.statusBarColor=color
  window.setStatusBarColor(color)
  return color
end

function Themes.setNavigationbarColor(color)
  theme.color.navigationBarColor=color
  window.setNavigationBarColor(color)
  return color
end

function Themes.setColorLifted(recycler,ids)
  local colorLifted
  local colorSurface = MaterialColors.getColor(this, R.attr.colorSurface,Color.BLACK)
  local elevationOverlay = ElevationOverlayProvider(this)
  .compositeOverlayIfNeeded(colorSurface, 12.0)
  if recycler.canScrollVertically(-1) then
    colorLifted = elevationOverlay
   else
    colorLifted = theme.color.colorSurface
  end
  ids.toolbar.backgroundColor = colorLifted
  window.statusBarColor = colorLifted
end

function setAppbarLifted(ids)
  ids.recycler.addOnScrollListener(RecyclerView.OnScrollListener{
    onScrolled = function(recycler, dx, dy)
      Themes.setColorLifted(recycler,ids)
    end
  })
  ids.recycler.getViewTreeObserver().addOnGlobalLayoutListener({
    onGlobalLayout=function()
      if activity.isFinishing() then
        return
      end
      Themes.setColorLifted(ids.recycler,ids)
    end
  })
end

function Themes.getMaterialColor(color)
  return MaterialColors.getColor(context,color, Color.BLACK)
end

function Themes.getRippleDrawable(color,square)
  local rippleId
  if square then
    rippleId=theme.number.id.selectableItemBackground
   else
    rippleId=theme.number.id.selectableItemBackgroundBorderless
  end
  local drawable=context.getResources().getDrawable(rippleId)
  if color then
    if type(color)=="number" then
      drawable.setColor(ColorStateList({{}},{color}))
     else
      drawable.setColor(color)
    end
  end
  return drawable
end

local function setAppTheme(key)
  activity.setSharedData("theme_style",key)
  return ThemeUtil
end
Themes.setAppTheme=setAppTheme

local function getAppTheme(key)
  return activity.getSharedData("theme_style")
end

Themes.getAppTheme=getAppTheme

function Themes.refreshUI()
  local themeKey,appTheme

  themeKey=getAppTheme()
  appTheme=Name2AppTheme[themeKey]

  if not(appTheme) then
    themeKey="Animongo"
    appTheme=Name2AppTheme[themeKey]
    setAppTheme(themeKey)
  end

  local themeString=("Theme_%s"):format(appTheme.show.name)
  activity.setTheme(R.style[themeString])

  local systemUiVisibility=0
  if not(decorView) then
    decorView=activity.getDecorView()
  end

  local colorList=theme.color

  Themes.refreshThemeColor()

  if appTheme.color then
    for index,content in pairs(appTheme.color) do
      colorList[index]=content
    end
  end

  if isSysNightMode() then alpha = 211 else alpha = 211 end
  local colorSurface = MaterialColors.getColor(context,R.attr.colorSurface,Color.BLACK)
  local colorPrimaryInverse = MaterialColors.getColor(context,R.attr.colorPrimaryInverse,Color.BLACK)
    theme.color.elevationOverlay = ElevationOverlayProvider(this).compositeOverlayIfNeeded(
    colorSurface, 12
  )

  theme.color.scrimColor = ColorUtils.setAlphaComponent(theme.color.elevationOverlay, alpha)
  theme.color.primaryInverseScrim = ColorUtils.setAlphaComponent(theme.color.colorPrimary, 50)

  window.setStatusBarColor(theme.color.colorSurface)
  window.setNavigationBarColor(theme.color.scrimColor)

  if not(isSysNightMode()) then
    if SDK_INT >= 23 then
      systemUiVisibility=systemUiVisibility| View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR|
      View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
    end
  end

  decorView.setSystemUiVisibility(systemUiVisibility)
  WindowCompat.setDecorFitsSystemWindows(window, false)
end

return Themes