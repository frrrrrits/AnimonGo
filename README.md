## Example ##

   httpGetInfo(url_path,function()
      -- menggunakan jsoup
      asbtable = jsoup.astable(jsouparse,'animepost')
      -- gunakan pungsi @loop 
      for index,content in ipairs(astable)
        
      end    
   end)

## Function ##
- `@httpGetInfo(str,function)` muat url.
 
- `@jsouparse` mengunakan jsoup.

- `@xpathparse` mengunakan xpath.

- `@addGetInfoData(str)` menambahkan data.
