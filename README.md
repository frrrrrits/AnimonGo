## Example ##

html

    -<html><body>
        <div class="animepost">
             <div class='title'>some body</div>
             <div class='episode'>Two</div>
        </div>
    -</body></html>


lua
  
     httpGetInfo(url_path,function()
         -- menggunakan jsoup        
         -- tambahkan semuanya ke table
         asbtable = jsoup.astable(jsouparse,'animepost') -- sudah termasuk getElementsByClass("animepost")
         -- gunakan pungsi @loop 
         for index,content in ipairs(astable)
             byfragment = jsoup.byfragment(content)
             addGetInfoData(url,title,cover,episode)
         end
     end)


## Function ##
- `@httpGetInfo(str,function)` muat url.
 
- `@jsouparse` mengunakan jsoup.

- `@xpathparse` mengunakan xpath.

- `@addGetInfoData(str,str,str,str)` menambahkan data.
