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
         -- tambahkan semuanya ke table
         asbtable = jsoup.astable(jsouparse,'animepost') -- sudah termasuk getElementsByClass("animepost")

         -- gunakan pungsi @loop 
         for index,content in ipairs(astable)
             -- decode
             byfragment = jsoup.byfragment(content)

             -- scrape
             url = jsoup.bytag(byfragment,"a").attr("href")
             title = jsoup.byclass(byfragment,"title")
             episode = jsoup.byclass(byfragment,"episode")
             cover = "cover image url"

             -- tambahkan ke data
             addGetInfoData(url,title,cover,episode)
         end
     end)


## Function ##
- `@httpGetInfo(str,function)` muat url.
 
- `@jsouparse` mengunakan jsoup.

- `@xpathparse` mengunakan xpath.

- `@addGetInfoData(str,str,str,str)` menambahkan data.
