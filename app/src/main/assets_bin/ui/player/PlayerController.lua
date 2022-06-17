local PlayerController={}
setmetatable(PlayerController,PlayerController)

isShowing = true

PlayerController.keepScreenOn=function(on)
  if on then
    activity.window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON) else
    activity.window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
  end
end

function PlayerController.changeStatusBarState(hide)
  if hide then
    window.setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN) else
    window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
  end
end

function PlayerController.hideSystemUi()
  window.decorView.systemUiVisibility =
  View.SYSTEM_UI_FLAG_LAYOUT_STABLE
  | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
  | View.SYSTEM_UI_FLAG_FULLSCREEN
  | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
  | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
end

function PlayerController.showSystemUi()
  window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  PlayerController.changeStatusBarState(false)
end

PlayerController.setCutoutShort = function(bool)
  local params = nil
  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.P then
    if bool then
      params = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES else
      params = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_DEFAULT
    end
    window.attributes.layoutInDisplayCutoutMode = params
  end
end

PlayerController.initGesture = function(exoplayer)
end

return PlayerController
