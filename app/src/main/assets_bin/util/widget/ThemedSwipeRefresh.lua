module(...,package.seeall)

local ThemedSwipeRefresh={}
ThemedSwipeRefresh.view = {}

function ThemedSwipeRefresh.init(view)
  self.view = view
  self.view.setProgressBackgroundColorSchemeColor(theme.color.colorPrimary)
  self.view.setColorSchemeColors(int{theme.color.colorSurface})
  return self
end

function ThemedSwipeRefresh.progressOffset(int)
  self.view.setProgressViewOffset(true,0,int or uihelper.dp2int(60))
  return self
end

function ThemedSwipeRefresh.distanceToTrigger(int)
  self.view.setDistanceToTriggerSync(int or 2 * 64 *resources.displayMetrics.density)
  return self
end

function __call()
  self=table.clone(ThemedSwipeRefresh)
  return self
end