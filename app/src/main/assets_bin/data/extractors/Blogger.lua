require "import"
import "org.jsoup.*"
import "com.androlua.network.LuaHttp"

local Blogger = {}
Blogger.name = "Blogger"
Blogger.mainUrl = "https://www.blogger.com"

Blogger.getUrl = function(url, data)
  local headers={ 'user-agent: Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36' }
  LuaHttp.request({url=url, headers = headers},function(error, code, body)
    if error or code ~= 200 then return end

    local jsouparse = Jsoup.parse(body)
    local script = jsouparse.select("script")
    local result = tostring(script):match('"streams":(.*)}')    
    local json = json.decode(result)
    
    for index, content in ipairs(json) do
      local quality = 0 local play_url = content.play_url
      local format_id = content.format_id
      if format_id == 18 then quality = 360
       elseif format_id == 22 then quality = 720
      end      
      extractLink(Blogger.name,play_url,"https://www.youtube.com/", quality)
    end
  end)
end

return Blogger