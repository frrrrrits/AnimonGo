require "import"
import "java.io.File"

-- so dont need to import per file
local astable = luajava.astable
local dir = activity.getLuaDir() .. "/data/extractors"
local file = File(dir)

table.foreach(astable(file.listFiles()),function(index, content)
  if not(content.isDirectory()) then
    local sub = tostring(content.name):gsub(".lua", "")    
    local str = string.format("data.extractors.%s", sub)
    import (str)
  end
end)