require "import"
import "org.jsoup.*"
import "com.androlua.network.LuaHttp"

local YourUpload = {}
local name = "YourUpload"
local mainUrl = "https://www.yourupload.com"

YourUpload.name = name
YourUpload.mainUrl = mainUrl

function YourUpload.getUrl(url, data)
  local tag = string.format("%s_%d", name, math.random(1, 50))
  LuaHttp.request({url=url, tag=tag},function(error, code, body)
    if error or code ~= 200 then return end
    local jsouparse = Jsoup.parse(body)
    YourUpload.tag = tag
    local script = jsouparse.selectFirst("meta[property=og:video]")
    PlayerSource.streamUrlLoaded = true
    LuaHttp.cancelWithTag(tag)
  end)
end

return YourUpload