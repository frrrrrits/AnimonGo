import "java.io.File"
import "com.androlua.source.SourceManager"
import "util.enviroment.FileUtil"
import "json"

local SourceUtil = {}
local astable = luajava.astable

local function getSourceDir(id)
  return ("%s/%s"):format(SourceManager.getAndroLuaDir(),id)
end

local function isDirectoryExist(id)
  local pluginDir=File(getSourceDir(id))
  if pluginDir.exists() then
    return true
  end
end

function SourceUtil.getPluginList()
  local pluginList={}
  local pluginDir=File(SourceManager.getAndroLuaDir())
  if !pluginDir.exists() then return end
  table.foreach(astable(pluginDir.listFiles()),function(index,content)
    local plugin=SourceUtil.parseSourceInfo(content)
    table.insert(pluginList,plugin)
  end)
  return pluginList
end

function SourceUtil.parseSourceInfo(pluginDir)
  for index,content in ipairs(luajava.astable(pluginDir.listFiles())) do
    if content.isDirectory() then
     elseif content.name:find("info.json") then
      local path=content.getPath()
      local readInfo=io.open(path,"r"):read("*a")
      local jsonDecode=json.decode(readInfo)
      local plugin={}
      plugin.updateAt=content.lastModified()
      for index,content ipairs(jsonDecode) do        
        plugin.id=content.id
        plugin.name=content.name
        plugin.icon=content.icon
        plugin.versionName=content.versionName
        plugin.versionCode=content.versionCode
      end
      return plugin
    end
  end
end

function SourceUtil.compareWithLocal(localList, plugin)
  plugin.type='install'
  for i=1, #localList do
    local pos=localList[i - 0]
    if pos.id==plugin.id then
      if pos.versionCode < plugin.versionCode then
        plugin.type='update'
        plugin.versionName=string.format('%s -> %s',pos.versionName, plugin.versionName)
        plugin.position=plugin.position - 999
       else plugin.type='uninstall'
      end
    end
  end
  if plugin.type=='install' then
    plugin.position=-plugin.position
  end
end

function SourceUtil.createInfo(id,name,icon,versionName,versionCode)
  local info=[{
    id=id,
    name=name,
    icon=icon,
    versionCode=versionCode,
    versionName=versionName,
  }]
  local infoPath=('%s/info.json'):format(getSourceDir(id))
  FileUtil.write(infoPath, json.encode(info))
end

function SourceUtil.getSourceRead(plugin)
  local readfile
  local filepath
  local pluginId = plugin.id
  local pluginName = plugin.name
  local infoPath = ('%s/'):format(getSourceDir(pluginId))
  local pluginDir = File(tostring(infoPath))  
  table.foreach(astable(pluginDir.listFiles()),function(index,content)
    if content.isDirectory() then
     elseif content.name:find(pluginName) then
      filepath = content.getPath()
      local open = io.open(filepath, "r")
      readfile = open:read("*a")
      open:close()
    end
  end)
  return readfile, filepath
end

function SourceUtil.loadSource(plugin)
  local iserror = false
  xpcall(function()
    local readfile, filepath = SourceUtil.getSourceRead(plugin)
    activity.doString(readfile,{})
    return
  end,function()
    iserror = true
    return
  end)
  return iserror
end

SourceUtil.getSourceDir=getSourceDir
SourceUtil.isDirectoryExist=isDirectoryExist

return SourceUtil