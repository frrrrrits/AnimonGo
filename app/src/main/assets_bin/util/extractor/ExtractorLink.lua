local ExtractorLink = {}

import "util.api"
import "data.TableData"
import "java.util.regex.Pattern"
import "id.lxs.animongo.utils.JsUnpacker"
import "util.extractor.ExtractorImport"

function extractLink(name, url, referer, quality)
  local data = TableData.SourceStream
  table.insert(data,{
    name = name,
    play_url = url,
    referer = referer,
    quality = quality,
  })
end

string.startwith = function(self, str)
  return self:find('^' .. str) ~= nil
end

local function httpsify(str)
  if str:startwith("//") then
    return "https:" .. str
  end
  return str
end

function getJsUnpacker(code)
  local regex = getEvalCode(code)
  local jsunpacker = JsUnpacker(regex)
  if jsunpacker.detect() then
    return jsunpacker.unpack()
  end
end

function ExtractorLink.get(url)
  local url = httpsify(url)
  local stream_table = TableData.SourceStream
 
  if url:startwith(Blogger.mainUrl) then
    Blogger.getUrl(url, stream_table)
  end
  if url:startwith(FEmbed.mainUrl) then
    FEmbed.getUrl(url, stream_table)
  end
  if url:startwith(Mp4Upload.mainUrl) then
    Mp4Upload.getUrl(url, stream_table)
  end
end

function getEvalCode(html)
  local regex = "eval(.*)"
  local pattern = Pattern.compile(regex, Pattern.MULTILINE)
  local matcher = pattern.matcher(html)
  if matcher.find() then
    return matcher.group(0)
  end
  return nil
end

return ExtractorLink
