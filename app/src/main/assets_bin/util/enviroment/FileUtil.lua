local FileUtil={}

import "util.enviroment.AppPath"

local context = activity or service

local function copyFile(fromFile,toFile,rewrite)
  local toFileParent=toFile.getParentFile()
  if not(toFileParent.exists()) then
    toFileParent.mkdirs()
   elseif toFile.exists() and rewrite then
    toFile.delete()
  end
  local fosfrom = FileInputStream(fromFile)
  local fosto = FileOutputStream(toFile)
  local bt = byte[1024]
  local c = fosfrom.read(bt)
  while c>=0 do
    fosto.write(bt, 0, c)
    c = fosfrom.read(bt)
  end
  fosfrom.close()
  fosto.close()
end
FileUtil.copyFile=copyFile

local function copyDir(fromFile,toFile,rewrite)
  if toFile.isFile() and rewrite then
    toFile.delete()
  end
  toFile.mkdirs()
  local toFilePath=toFile.getPath()
  for index,content in ipairs(luajava.astable(fromFile.listFiles())) do
    local newFile=File(toFilePath.."/"..content.getName())
    if content.isFile() then
      copyFile(content,newFile,rewrite)
     else
      copyDir(content,newFile,rewrite)
    end
  end

end
FileUtil.copyDir=copyDir

local function isDirectoryExist(dirname)
  if dirname then
    import "java.io.File"
    local extdir = AppPath.LuaExtDir
    local files = File(Environment.getExternalStoragePublicDirectory(extdir).getPath().."/"..dirname)
    if files.exists() && files.isDirectory() then
      return true
    end
  end
end
FileUtil.isDirectoryExist=isDirectoryExist

local function write(filePath, txt)
  pcall(function()
    local file = File(filePath)
    file.getParentFile().mkdirs()
    local f = io.open(filePath, 'wb')
    f:write(txt)
    f:close()
  end)
end
FileUtil.write=write

local function externalMemoryAvailable()
  local storages = ContextCompat.getExternalFilesDirs(context, nil)
  if #storages > 1 && storages[0] != nil && storages[1] != nil then
    return true
   else
    return false
  end
end

FileUtil.externalMemoryAvailable = externalMemoryAvailable

return FileUtil