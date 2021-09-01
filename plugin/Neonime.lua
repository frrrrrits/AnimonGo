plugin = {}

local function getinfo(url)
  url = "https://doujindesu.id"
  dirurl = url .. "/komik-list/page/".. current_page .."/?title=&order=update&status=&type="
  Http.get(dirurl,function(code,content)
    if (code == 200 and content) then
      parse = jsoup.parse(content)
      asbtable = jsoup.astable(parse,'animepost')
      swipeRefresh.setRefreshing(false)  
      activity.runOnUiThread(Runnable{
        run=function()
          for c,response in pairs(asbtable) do
            byfragment=jsoup.byfragment(response)
            title=jsoup.bytag(byfragment, "img").attr("title")
            if title==nil or title=="" then title="tidak di ketahui" return end
            url=jsoup.bytag(byfragment, "a").attr("href")
            if url==nil or url=="" then url="error" return end
            status=string.match(tostring(byfragment),'<div class="type">(.-)</div>'):gsub("%s","")
            coverurl=jsoup.bytag(byfragment, "img").attr("src")
            table.insert(data,{icon=coverurl,title=title,status=status})
          end
        end
      })
      current_page=current_page+1
      adapter.notifyDataSetChanged()
     else
      MyToast.showNetErrorToast(code,mainLay)
    end
  end)
end

plugin.getinfo = getinfo
return plugin
