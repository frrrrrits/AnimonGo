local ExtractorLink = {}

import "data.TableData"
import "util.extractor.ExtractorImport"

string.startwith = function(self, str)
  return self:find('^' .. str) ~= nil
end

local function httpsify(str)
  if str:startwith("//") then
    return "https:" .. str
  end
  return str
end

ExtractorLink.get = function(url)
  local url = httpsify(url)
  local stream_table = TableData.SourceStream    
  if url:startwith(Blogger.mainUrl) then
    Blogger.getUrl(url, stream_table)
  end  
  if url:startwith(FEmbed.mainUrl) then
    FEmbed.getUrl(url, stream_table)
  end
end

return ExtractorLink
