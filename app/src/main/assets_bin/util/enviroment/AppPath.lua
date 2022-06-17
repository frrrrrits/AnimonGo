local AppPath={}
local context=activity or service
local application=activity.getApplication()

local extDir=("Android/data/%s/files"):format(context.getPackageName())
context.setLuaExtDir(extDir)

local appName
appName=application.get("appName")
if appName==nil then
  appName=context.getApplicationInfo().loadLabel(context.getPackageManager())
  application.set("appName",appName)
end

import "android.os.Environment"

AppPath.Sdcard=Environment.getExternalStorageDirectory().getPath()
AppPath.Temp=context.getLuaExtDir("temp")

local function getSelfPublicPath(value)
  return Environment.getExternalStoragePublicDirectory(value).getPath().."/AnimonGo/"..appName
end

AppPath.Downloads=getSelfPublicPath(Environment.DIRECTORY_DOWNLOADS)
AppPath.Movies=getSelfPublicPath(Environment.DIRECTORY_MOVIES)
AppPath.Pictures=getSelfPublicPath(Environment.DIRECTORY_PICTURES)
AppPath.Music=getSelfPublicPath(Environment.DIRECTORY_MUSIC)

AppPath.LuaDir=context.getLuaDir()
AppPath.LuaExtDir=extDir
AppPath.LuaSharedDir=AppPath.Downloads.."/.shared"
AppPath.AppSdcardDataDir=AppPath.LuaExtDir

return AppPath