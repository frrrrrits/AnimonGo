local ActivityUtil={}

local anim_fadein = R.anim.fade_in_short
local anim_fadeout = R.anim.fade_out_short
local no_anim = R.anim.no_animation

function newActivity(luaPath,...)
  activity.newActivity(luaPath,anim_fadein,no_anim,...)
end

local function finish()
  activity.finish()
  activity.overridePendingTransition(0,anim_fadeout)
end

function finishActivity(is,code,event)
  local codeBack=KeyEvent.KEYCODE_BACK
  if is==nil then finish()
   elseif is==1 then
    if code==codeBack then
      finish()
    end
  end
end

local function fadeThrough(fragment,view)
  import "com.google.android.material.transition.MaterialFadeThrough"
  local fadeThrough = MaterialFadeThrough()
  fadeThrough.addTarget(view)
  fragment.setEnterTransition(fadeThrough)
end

local function setRoot(fragment,id)
  local manager = activity.getSupportFragmentManager()
    
  manager.beginTransaction()    
  .setCustomAnimations(anim_fadein,no_anim)
  .replace(id or R.id.framelayout, fragment)
  .commit()
end

function onBackPressed(event)
  local KEYCODE_BACK = string.find(tostring(event),"KEYCODE_BACK")
  if KEYCODE_BACK ~= nil then
    activity.finish()
    return true
  end
end

local function hasDisplayCutout()
  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.P then
    local rootWindowInsets = window.decorView.rootWindowInsets
    if rootWindowInsets != nil then
      local displayCutout = rootWindowInsets.displayCutout
      if displayCutout != nil then
        return true
      end
    end
  end
end

ActivityUtil.anim_fadein = anim_fadein
ActivityUtil.anim_fadeout = anim_fadeout
ActivityUtil.no_anim = no_anim
ActivityUtil.setRoot = setRoot
ActivityUtil.fadeThrough = fadeThrough
ActivityUtil.hasDisplayCutout = hasDisplayCutout

return ActivityUtil