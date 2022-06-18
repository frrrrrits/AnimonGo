require "import"
import "org.jsoup.*"
import "com.androlua.network.LuaHttp"

local cjson = require "cjson" 
-- need to use cjson cuz of char \/\/

local FEmbed = {}
FEmbed.name = "FEmbed"
FEmbed.mainUrl = "https://www.fembed.com"
local domainUrl = "https://embedsito.com/api/source"

FEmbed.getUrl = function(url, data)
  local headers={
    'referer: ' .. url, 
    'user-agent: Mozilla/5.0 (Windows NT 6.1; rv:78.0) Gecko/20100101 Firefox/78.0'
  }
  local new_url = string.format("%s/%s", domainUrl, tostring(url):gsub(".+/v/", ""))    
  LuaHttp.request({url = new_url, headers = headers, method="POST"}, function(error, code, body)
    if error or code ~= 200 then return end    
    local json = cjson.decode(body)    
    if json.success == false then return end       
    for index, content in ipairs(json.data) do     
      data[ #data + 1 ] = {
        name = FEmbed.name,
        play_url = content.file, referer = "",
        quality = content.label,
      }
    end
  end)
end

return FEmbed