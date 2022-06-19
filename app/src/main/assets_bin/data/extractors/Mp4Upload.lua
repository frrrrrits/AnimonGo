require "import"
import "util.api"
import "org.jsoup.*"
import "com.androlua.network.LuaHttp"

local Mp4Upload = {}
Mp4Upload.name = "Mp4Upload"
Mp4Upload.mainUrl = "https://www.mp4upload.com"

local function srcRegex(code)
  local regex = [[player\.src\("(.*?)"]]   
  local pattern = Pattern.compile(regex, Pattern.MULTILINE)
  local matcher = pattern.matcher(code)
  if matcher.find() then
    return matcher.group(1) 
  end
  return nil
end

Mp4Upload.getUrl = function(url, data)
  LuaHttp.request({url = url, headers = { api.user_agent }, method="GET"}, function(error, code, body)
    if error or code ~= 200 then print("Blogger: Links not found") return end        
    local unpacked = getJsUnpacker(body)    
    local quality = string.match(unpacked, " HEIGHT=(%d+)")
    local link = srcRegex(unpacked)  
    extractLink(Mp4Upload.name, link, url, quality)
  end)
end

return Mp4Upload
