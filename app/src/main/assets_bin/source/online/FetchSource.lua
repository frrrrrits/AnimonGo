import "json"
import "util.api"
import "source.SourceUtil"
import "util.MyToast"
import "util.widget.EmptyView"
import "source.online.FetchOnError"

API_URL=api.raw_url
RELEASE_URL=api.plugin_url

function notifyAdapterData(fragment)
  uihelper.runOnUiThread(activity.getContext(),function()
    browse_adapter.notifyDataSetChanged()
  end)
end

function getFetchSource(data, adapter, ids, bool)
  ids.swiperefresh.enabled=true
  ids.swiperefresh.setRefreshing(true)

  if bool then
    for k,v in ipairs(data) do data[k]=nil end
    adapter.notifyDataSetChanged()
  end

  LuaHttp.request({url=API_URL,method="GET"},function(error,code,body)
    if error or code ~= 200 then
      ids.swiperefresh.setRefreshing(false)
      getLocalFetchSource(data, adapter, ids, error)
      MyToast("Gagal memuat data. Refresh untuk mencoba lagi.")
      return
    end

    for k,v in ipairs(data) do data[k]=nil end
    table.insert(data,{viewtype=1, text="Unduh Plugin"})

    local localList = SourceUtil.getPluginList()
    local json=json.decode(body)
    local list=json.config

    uihelper.runOnUiThread(ids.fragment.getActivity(), function()
      for i=1, #list do
        local plugin=list[i]
        plugin.position=i
        SourceUtil.compareWithLocal(localList, plugin)
        data[#data+1]={viewtype=2, item=plugin}
      end
      ids.swiperefresh.setRefreshing(false)
      adapter.notifyDataSetChanged()
    end)
  end)
end

function getLocalFetchSource(data, adapter, ids, code)
  for k,v in ipairs(data) do data[k]=nil end
  local localList = SourceUtil.getPluginList()
  if tonumber(#localList) == 0 then
    FetchOnError.onError(ids,code,function()
      EmptyView:hide()
      getFetchSource(data,adapter,ids)
    end)
   else
    table.insert(data,{viewtype=1, text="Plugin terinstall"})
    for i=1, #localList do
      local pos=localList[i - 0]
      local item = {
        id=pos.id,
        name=pos.name,
        icon=pos.icon,
        versionName=pos.versionName,
        versionCode=pos.versionCode,
        position=9999 + i,
      }
      data[#data+1]={viewtype=3, item=item}
    end
    notifyAdapterData(ids.fragment)
  end
end