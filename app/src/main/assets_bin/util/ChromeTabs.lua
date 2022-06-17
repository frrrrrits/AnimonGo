function openInBrowser(uri)
  import "android.net.Uri"
  import "android.content.Intent"  
  import "android.content.pm.PackageManager"
  import "androidx.browser.customtabs.*"

  local PACKAGE_NAME="com.android.chrome"  
  local builder=CustomTabsIntent.Builder()

  builder.setToolbarColor((theme.color.scrimColor))
  builder.addDefaultShareMenuItem()
  builder.setShowTitle(true)

  local CustomTab=builder.build()
  local intent=CustomTab.intent
  intent.data=Uri.parse(uri)

  local packageManager=activity.getPackageManager()
  local resolveInfoList=packageManager.queryIntentActivities(CustomTab.intent, PackageManager.MATCH_DEFAULT_ONLY)

  for index,resolveInfo in ipairs(luajava.astable(resolveInfoList)) do
    local packageName=resolveInfo.activityInfo.packageName
    if string.match(packageName,PACKAGE_NAME) then
      CustomTab.intent.setPackage(PACKAGE_NAME)
    end
  end
  CustomTab.launchUrl(this, CustomTab.intent.data)
end