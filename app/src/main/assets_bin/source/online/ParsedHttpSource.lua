import "org.jsoup.*"
import "util.api"
import "data.TableData"
import "data.TableUtil"
import "util.Base64Util"
import "util.widget.EmptyView"
import "source.online.FetchOnError"
import "com.androlua.network.LuaHttp"

local function nilOrBlank(s)
  return s == nil or s == ""
end

function getLatestSelector()
  return tostring(latestSelector)
end

function getEpisodeSelector()
  return episodeSelector
end

function getDownloadSelector()
  return downloadSelector
end

function getStreamSelector()
  return tostring(streamSelector)
end

function getDetailUrl(document)
  return detailUrl(document)
end

function getBaseUrl()
  return tostring(baseUrl)
end

function isStreamAble()
  return streamable
end

function useExtractor()
  return useextractor
end

function updateDetail(fragment)
  uihelper.runOnUiThread(activity,function()
    DetailSummary.updateHeader(fragment)
    adapter.notifyDataSetChanged()
  end)
end

function updateGenre()
  DetailSummary.updateGenres()
end

local function isMarked(id)
  if DatabaseHelper.getInstance().isEpisode(id) then
    return 'marked'
   else
    return 'unmarked'
  end
end

function updateDownload(data, url, title)
  table.insert(data, {url = url, title = title})
end

function Get(uel, fragment, call)
  LuaHttp.request({url = uel}, function(error, code, body)
    if error or code ~= 200 then return end
    document = Jsoup.parse(body)
    uihelper.runOnUiThread(fragment.getActivity(), call)
  end)
end

function ParsedlatestUpdate(data, pages, adapter, ids, reload)
  local format_url = tostring(latestUpdateUrl):format(baseUrl, pages.page)
  local options = { method = "GET", url = format_url , headers = { api.user_agent }}

  if reload then
    TableUtil.clear(data)
    adapter.notifyDataSetChanged()
  end

  ids.swiperefresh.enabled=true
  ids.swiperefresh.setRefreshing(true)

  LuaHttp.request(options,function(error, code, body)
    if error or code ~= 200 then      
      local errMsg = tostring(error):gsub(".-:%s", "")
      print(errMsg)
      ids.swiperefresh.setRefreshing(false)
      if pages.page == 1 then
        FetchOnError.onError(ids,code,function()
          EmptyView:hide()
          ParsedlatestUpdate(data, pages, adapter, ids, true)
        end)
       else
        MyToast.snackActions(ids.mainlay,
        "Gagal memuat data.","coba lagi",function()
          ParsedlatestUpdate(data, pages, adapter, ids)
        end)
      end
      return
    end

    local jsouparse = Jsoup.parse(body)
    local iterator = jsouparse.select(getLatestSelector()).iterator()

    uihelper.runOnUiThread(activity,function()
      if pages.page == 1 then
        TableUtil.clear(data)
      end

      while iterator.hasNext() do
        local document = iterator.next()
        fetchLatestUpdate(document)
        local item = {title = title, cover = thumbnail, url = url, episode = episode}
        data[#data + 1] = item
      end

      pages.page = pages.page + 1
      adapter.notifyDataSetChanged()
      ids.swiperefresh.setRefreshing(false)
    end)
  end)
end

function ParsedEpisode(urlx, data, data2, data3, adapter, ids, fragment)
  if nilOrBlank(urlx) or urlx == nil then return end
  ids.swiperefresh.setRefreshing(true)

  LuaHttp.request({url = urlx, method="GET", headers = { api.user_agent }},function(error, code, body)
    if error or code ~= 200 then
      ids.swiperefresh.setRefreshing(false)
      FetchOnError.onError(ids,code,function()
        EmptyView:hide()
        ParsedEpisode(urlx, data, data2, data3, adapter, ids, fragment)
      end)
      return
    end

    local jsouparse = Jsoup.parse(body)
    if type(getEpisodeSelector()) == "boolean" then
      mselector = selectorEpisode(jsouparse) else
      mselector = jsouparse.select(getEpisodeSelector())
    end
    local astable = luajava.astable(mselector)

    uihelper.runOnUiThread(fragment.getActivity(),function()
      TableUtil.clear(data) TableUtil.clear(data2) TableUtil.clear(data3)

      table.foreach(astable,function(index,content)
        local document = Jsoup.parseBodyFragment(tostring(content))
        fetchEpisodeList(document)
        local item = {title = title, url = url, date = date, marked=isMarked(url), position = index}
        data[#data + 1] = item
      end)

      data2.baseurl = tostring(urlx)
      data2.totaleps = TableUtil.length(data)

      local eps_url = TableUtil.first(data).url
      local eps_title = TableUtil.first(data).title

      data2.latesteps = "{title={"..eps_title.."},url={"..eps_url.."},update=noupdate}"

      fetchDetail(data2, data3, jsouparse)
      DetailSummary.updateHeader()

      ids.swiperefresh.setRefreshing(false)
      adapter.notifyDataSetChanged()
      -- notifDataChanged(fragment)
    end)
  end)
end


function ParsedDownloadUrl(url, data, adapter, ids, fragment)
  if nilOrBlank(url) or url == nil then return end

  ids.swiperefresh.setRefreshing(true)
  LuaHttp.request({url = url, method="GET", headers={api.user_agent}},function(error, code, body)
    if error or code ~= 200 then
      ids.swiperefresh.setRefreshing(false)
      MyToast.snackActions("Terjadi kesalahan, Gagal memuat data.","coba lagi",function()
        ParsedDownloadUrl(url, data, adapter, ids, fragment)
      end)
      return
    end

    TableUtil.clear(data)

    local jsouparse = Jsoup.parse(body)
    if type(getDownloadSelector()) == "boolean" then
      mselector = selectorDownload(jsouparse) else
      mselector = jsouparse.select(getDownloadSelector())
    end

    local astable = luajava.astable(mselector)

    uihelper.runOnUiThread(fragment.getActivity(),function()      
      for index, content in ipairs(astable) do
        local document = Jsoup.parseBodyFragment(tostring(content))
        fetchDownload(data, document, jsouparse)        
      end

      ids.swiperefresh.setRefreshing(false)
      adapter.notifyDataSetChanged()
    end)
  end)
end
