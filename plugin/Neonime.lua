plugin={}
local url_base="https://neonime.cc"

local function getbaseurl()
   return url_base
end

local function getinfo()
  dir_url = ("%s/episode/page/%s"):format(getbaseurl(),current_page)
  Http.get(dir_url,function(code,content)
    if (code == 200 and content) then
      classbb='//td[@class="bb"]/'
      jxdocument = JXDocument(content) -- xpath
      swipeRefresh.setRefreshing(false)
      activity.runOnUiThread(Runnable{
        run=function()          
          title = jxdocument.sel(classbb..'a/@href//text()')
          url = jxdocument.sel(classbb..'a/@href')
          episode = jxdocument.sel(classbb..'/span//text()]')
          coverurl = jxdocument.sel(classbb..'/img//@data-src')
          for i=0,#title-1 do
            if url=="" then url=nil end
            if title=="" then title="err" end
            table.insert(data,{url=url[i],icon=coverurl[i],title=title[i],episode=episode[i]})
          end
        end
      })
      current_page=current_page+1-- ke page 2 dan seterusnya
      adapter.notifyDataSetChanged()
     else
      MyToast.showNetErrorToast(code,mainLay)
    end
  end)
end

plugin.getinfo = getinfo
plugin.getbaseurl = getbaseurl

return plugin
