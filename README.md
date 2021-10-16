## Example ##

Html example

    <html><body>
        <div class="animepost">
             <a href="https"/>
             <div class='title'>some body</div>
             <div class='episode'>Two</div>
        </div>
    </body></html>


Lua
  
     httpGetInfo(url_path,function()
         -- menggunakan jsoup
         asbtable = jsoup.astable(jsouparse,'animepost') -- sudah termasuk getElementsByClass("animepost")

         -- gunakan iterator @loop 
         for index,content in ipairs(astable)           
             byfragment = jsoup.byfragment(content)

             -- scrape
             url = jsoup.bytag(byfragment,"a").attr("href")
             title = jsoup.byclass(byfragment,"title")
             episode = jsoup.byclass(byfragment,"episode")
             cover = "cover image url"

             -- tambahkan ke data
             addGetInfoData(url,title,cover,episode)
         end
        

         -- mengunakan xpath
         animepost = '//div[@class="animepost"]/'
         url = xpathparse.sel(animepost..'a@href/')
         title = xpathparse.sel(animepost..'/div[@class="title"]/')
         episode = xpathparse.sel(animepost..'/div[@class="episode"]/')
         
         for index=0, #title-1
             addGetInfoData(url[index],title[index],cover[index],episode[index])
         end
     end)


## Operator ##
- `@httpGetInfo(path_url,function)` muat url.
 
- `@jsouparse` mengunakan jsoup.

- `@xpathparse` mengunakan xpath.

- `@addGetInfoData(url,title,cover,episode)` menambahkan data.
