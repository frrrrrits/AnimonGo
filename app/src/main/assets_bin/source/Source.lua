local Source={}

import "source.SourceUtil"

local function flatType(id)
  if not(SourceUtil.isDirectoryExist(id)) then
    return "Unduh plugin" else return "Perbarui plugin"
  end
end

local function start(url,id,fileName,message,data)
  data.type = 'downloading'
  notifyAdapterData()
  SourceManager.download(url,id,fileName,function()
    MyToast("Download Selesai")
    data.type = 'uninstall'
    notifyAdapterData()
  end)
end

function Source.download(data,url)
  local id = data.id
  local icon = data.icon
  local name = data.name
  local streamAble = data.streamAble
  local stream = "Tidak support streaming"
  if streamAble then stream = "Support streaming" end  
  
  local versionName = data.versionName
  local versionCode = data.versionCode 
  local url=("%s/%s.lua"):format(RELEASE_URL,name)
  local message=("Name - %s\nVersion - %s\n\n%s"):format(name,versionName,stream)
  local fileName=("%s.lua"):format(name)
  
  MaterialAlertDialogBuilder(this)
  .setTitle(flatType(id)).setMessage(message)
  .setPositiveButton("Unduh",function()
    start(url,id,fileName,message,data)
    SourceUtil.createInfo(id,name,icon,versionName,versionCode)
    MyToast("Mengunduh plugin")
  end)
  .setNegativeButton("Batal",nil)
  .show()
end

function Source.uninstall(plugin)
  MaterialAlertDialogBuilder(this)
  .setTitle(plugin.name)
  .setMessage("Uninstall Plugin")
  .setPositiveButton("Uninstall", function()
    local pluginId = plugin.id
    local localList= SourceUtil.getPluginList()
    for index,content in ipairs(localList) do
      if content.id==pluginId then
        LuaUtil.rmDir(File(SourceUtil.getSourceDir(content.id)))
        MyToast("Plugin di uninstall")
        plugin.type = 'install'
        notifyAdapterData()   
      end
    end
  end)
  .setNegativeButton("Batal",nil)
  .show()
end

return Source