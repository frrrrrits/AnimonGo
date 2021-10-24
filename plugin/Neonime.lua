plugin={}
local url_base="https://neonime.cc"

local function getbaseurl()
  return url_base
end

local function getinfo()
  --- %s untuk string
  httpGetInfo("%s/episode/page/%s",getbaseurl(),function()
    classbb = '//td[@class="bb"]/'

    title = xpathparse.sel(classbb..'a/@href//text()')
    url = xpathparse.sel(classbb..'a/@href')
    episode = xpathparse.sel(classbb..'/span//text()]')
    cover = xpathparse.sel(classbb..'/img//@data-src')

    for i=0,#title-1 do
      addGetInfoData(url[i],title[i],cover[i],episode[i])
    end
  end)
end

plugin.getinfo = getinfo
plugin.getbaseurl = getbaseurl

return plugin
