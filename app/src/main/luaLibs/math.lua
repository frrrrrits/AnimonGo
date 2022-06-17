local context=activity or service
local dp2intCache={}

function math.dp2int(dpValue)
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

function math.px2sp(pxValue)
  local scale=context.getResources().getDisplayMetrics().scaledDensity
  return pxValue/scale
end
