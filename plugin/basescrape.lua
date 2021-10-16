--
-- Create by: frrrrrits
-- Date: 2021/10/16
--

plugin={}
local url_base="url"

local function getbaseurl()
  return url_base
end

local function getinfo()
  --- %s untuk string
  path_url = ("%s/page path url/%s"):format(getbaseurl(),current_page)  
  -- @httpGetInfo: hanya untuk getinfo
  httpGetInfo(path_url,function()
    -- gunakan metode @loop
    -- tambahkan data
    addGetInfoData(
       url,title,
       cover,episode
    )
    -- @end
  end)
end

plugin.getinfo = getinfo
plugin.getbaseurl = getbaseurl

return plugin
