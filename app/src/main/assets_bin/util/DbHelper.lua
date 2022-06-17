local DbHelper={}

import "data.TableData"
import "id.lxs.animongo.database.DatabaseHelper"
import "id.lxs.animongo.database.DatabaseHelper$DatabaseListener"

function DbHelper.onChanged(context, f)
  local listener = DatabaseListener{ onDatabaseChanged = f or function() end}
  return DatabaseHelper(context, listener)
end

local db = DbHelper.onChanged(activity.getContext())
local instance = DatabaseHelper.getInstance()

DbHelper.instance = instance
DbHelper.get = db.getWritableDatabase()

local function s(str)
  return tostring(str)
end

function DbHelper.addFavorite()
  local data = TableData.Details  
  local url = s(data.baseurl)
  local title = s(data.title)
  local thumb = s(data.cover)
  local source = s(data.source)
  local totaleps = s(data.totaleps)
  local latesteps = s(data.latesteps)  
    
  local db = DbHelper.onChanged(activity,function() MyToast("Mulai mengikuti") end)
  db.insertFavorite(url, title, source, thumb, latesteps, totaleps)
end

function DbHelper.updateFavorite()
  --- get data from tables
  local data = TableData.Details
  local url = s(data.baseurl)
  local thumb = s(data.cover)
  local title = s(data.title)  
  local source = s(data.source)
  local totaleps = s(data.totaleps)
  local latesteps = s(data.latesteps)
  
  -- search for id
  local query = "SELECT _id FROM animes WHERE name='"..title.."'"
  local result = DbHelper.get.rawQuery(query, nil)
  while result.moveToNext() do
    db.updateFavorite(result.getInt(0),url,title,source, thumb, latesteps, totaleps)
  end
end

function DbHelper.updateLibrary(db, url,title,source,thumb,latesteps,totaleps)
  local query = "SELECT _id FROM animes WHERE name='"..title.."'"
  local result = DbHelper.get.rawQuery(query, nil)
  while result.moveToNext() do
    db.updateFavorite(result.getInt(0),s(url),s(title),s(source),s(thumb),s(latesteps),s(totaleps))
  end
end

function DbHelper.addEpisodeMark(db,url,title)
  db.insertEpisode(url,title)
end

function DbHelper.deleteFavorite()
  local data = TableData.Details
  DbHelper.instance.deleteFavorite(s(data.title))
end

function DbHelper.deleteEpisode(id)
  DbHelper.instance.deleteEpisode(id)
end

return DbHelper