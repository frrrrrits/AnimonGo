local Base64Util={}

import "android.util.Base64"
import "java.lang.*"
import "android.util.*"
import "android.content.*"

local base64 = luajava.bindClass("android.util.Base64")

function Base64Util.encode(data)  
  return base64.encodeToString(String(data).getBytes(),base64.NO_WRAP)
end

function Base64Util.decode(data)
  return String(base64.decode(data,base64.DEFAULT)).toString()
end

function Base64Util.__call(self, text)
  return Base64Util.decode(text)
end
return Base64Util
