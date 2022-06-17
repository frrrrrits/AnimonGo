local BrowseSource={}

import "source.SourceUtil"
import "source.online.ParsedHttpSource"

local function nilOrBlank(s)
  return s == "" or s == nil
end

function BrowseSource.load(plugin)
  local err = SourceUtil.loadSource(plugin)
  if err then print("Terjadi kesalahan") return err end
  return err
end

function BrowseSource.fetchLatest(data,pages,adapter,ids,reload)
  ParsedlatestUpdate(data,pages,adapter,ids,reload)
end

function BrowseSource.fetchDetails(url,data,data2,data3,adapter,ids,fragment)
  if nilOrBlank(url) then
    print("Terjadi kesalahan, coba lagi.")
    return else
    Get(url,fragment,function()
      url=getDetailUrl(document)
      ParsedEpisode(url, data, data2, data3, adapter, ids, fragment)
      -- ParsedEpisode(url,data,adapter,ids,fragment)
    end)
  end
end

function BrowseSource.fetchEpisode(url,data,adapter,ids,fragment)
  if nilOrBlank(url) then
    print("Terjadi kesalahan, coba lagi.")
    return else
    Get(url,fragment,function()
      url=getDetailUrl(document)
      ParsedEpisode(url,data,adapter,ids,fragment)
    end)
  end
end

function BrowseSource.fetchDownloadData(url,data,adapter,ids,fragment)
  if nilOrBlank(url) then
    print("Terjadi kesalahan, coba lagi.")
    return else
    ParsedDownloadUrl(url,data,adapter,ids,fragment)
  end
end

function BrowseSource.fetchUpdateEpisode(url,data)
  if nilOrBlank(url) then
    print("Terjadi kesalahan, coba lagi.")
    return else
    ParsedUpdateEpisode(url, data)
  end
end


function BrowseSource.fetchStreamUrl(_url, data)
  if isStreamAble() then
    if nilOrBlank(_url) then
      print("Terjadi kesalahan, coba lagi.")
      return
    end    
    LuaHttp.request({url = _url, method="GET"},function(error, code, body)
      if error or code ~= 200 then
        print("Terjadi kesalahan gagal memuat streaming url")
        return
      end
      for k, v in ipairs(data) do data[k] = nil end
      local jsouparse = Jsoup.parse(body)
      local iterator = jsouparse.select(getStreamSelector()).iterator()
      uihelper.runOnUiThread(activity, function()
        while iterator.hasNext() do
          local element = iterator.next()
          fetchStreamingLinks(element, jsouparse)
          table.insert(data, {url = url})
        end     
        PlayerSource.urlLoaded = true
      end)
    end)
  end
end

function BrowseSource.baseUrl()
  return getBaseUrl()
end

function BrowseSource.streamAble()  
  return isStreamAble()
end

return BrowseSource