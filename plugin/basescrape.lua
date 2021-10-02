--
-- Create by: frrrrrits
-- Date: 2021/10/02
--

plugin={}
local url_base="url here"

local function getbaseurl()
  return url_base
end

local function getinfo()
  --- %s untuk string
  dir_url = ("%s/path url/%s"):format(getbaseurl(),current_page)
  Http.get(dir_url,function(code,content)
    if (code == 200 and content) then
      swipeRefresh.setRefreshing(false)
      activity.runOnUiThread(Runnable{
        run=function()
          title = "title string here"
          url = "url content here"
          episode = "episodd string here"
          coverurl = "image url here"
          -- loop method
          -- for i=0, #title-1
            -- send data
            table.insert(data,{
              url=url[i],icon=coverurl[i],
              title=title[i],episode=episode[i]
            })
          -- end
        end
      })
      current_page=current_page+1-- ke page 2 & seterusnya
      adapter.notifyDataSetChanged()
     else
      MyToast.showNetErrorToast(code,mainLay)
    end
  end)
end

plugin.getinfo = getinfo
plugin.getbaseurl = getbaseurl

return plugin
