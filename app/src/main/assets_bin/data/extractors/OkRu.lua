require "import"
import "org.jsoup.*"
import "com.androlua.network.LuaHttp"

-- error 400 gak tau cara fix nya
-- jadi engga di pakai

local OkRu = {}
OkRu.name = "OkRu"
OkRu.mainUrl = "https://ok.ru"

local function notblank(s)
  return s ~= "" or s ~= nil
end

local function replace(str)
  local r
  local s = string.lower(tostring(str))
  if s:match("mobile") then
    r = "144p"
   elseif s:match("lowest")
    r = "240p"
   elseif s:match("low")
    r = "360p"
   elseif s:match("sd")
    r = "480p"
   elseif s:match("hd")
    r = "720p"
   elseif s:match("full")
    r = "1080p"
   elseif s:match("quad")
    r = "1440p"
   elseif s:match("ultra")
    r = "4k"
  end
  return r
end

OkRu.getUrl = function(url, data)
  local tag = string.format("%s_%d", OkRu.name, math.random(1, 50))
  LuaHttp.request({url=url, tag=tag},function(error, code, body)
    if error or code ~= 200 then return end
    local jsouparse = Jsoup.parse(body)
    OkRu.tag = tag

    local datajson = jsouparse.select("div[data-options]").attr("data-options")
    if notblank(datajson) then

      local jsonmain = json.decode(datajson)
      local metadata = json.decode(jsonmain.flashvars.metadata)

      for index, content in ipairs(metadata.videos) do
        local quality = replace(content.name)
        local extracturl = content.url:gsub("\\\\u0026", "&")

        data[ #data + 1 ] = {
          name = OkRu.name,
          play_url = extracturl,
          referer = OkRu.url,
          quality = quality,
        }
      end
    end
  end)
end

return OkRu