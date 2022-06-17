local UpdateLibrary={}

function UpdateLibrary.scheduleUpdate()
  import "util.preferences.Preferences"
  local osd = os.date
  local old_date = string.lower(Preferences.scheduleUpdate():get())
  local current_date = string.lower(osd("%A"))
  return old_date, current_date
end

function doWork(db)
  require "import"
  import "org.jsoup.Jsoup"
  import "data.TableUtil"
  import "data.TableData"
  import "util.DbHelper"
  import "source.SourceUtil"
  import "data.updater.UpdateAlert"
  import "com.androlua.network.LuaHttp"

  local data = {}
  local toupdate = {}
  local newdata = {}
  local source, baseurl, pname, titlela
  local tablelibrary = TableData.library

  local function pluginRegex(source)
    return {
      id=source:match("id=(.-),"),
      icon=source:match("icon=(.-),"),
      name=source:match("name=(.-),"),
      position=source:match("position=(.-),"),
      versionName=source:match("versionName=(.-),"),
      versionCode=source:match("versionCode=(%d)")
    }
  end

  local function tableRegex(t)
    return {
      title=t:match("title={(.-)},"),
      url=t:match("url={(.-)},"),
      update=t:match("update=(.-)}")
    }
  end

  local function compare_episode(last, new)
    local last = tonumber(last)
    local new = new
    if type(new) == "string" and
      type(last) == "string" then
      return
    end
    if last < new then
      return 1 else
      return 0
    end
  end

  local function getDatabase()
    for k, v in ipairs(tablelibrary) do tablelibrary[k] = nil end
    tablelibrary.empty = true
    local cursor = DbHelper.instance.queryFavorite()
    while cursor.moveToNext() do
      table.insert(tablelibrary,{
        id = cursor.getInt(0),
        url = cursor.getString(1),
        title = cursor.getString(2),
        source = cursor.getString(3),
        cover = cursor.getString(4),
        latesteps = cursor.getString(5),
        totaleps = cursor.getString(6),
      })
      tablelibrary.empty = false
    end
    return tablelibrary
  end

  if getDatabase().empty ~= true then
    for index, content in ipairs(tablelibrary) do
      source = pluginRegex(content.source)
      baseurl = content.url
      titlela = tableRegex(content.latesteps).title
      table.insert(toupdate, {
        source = source, baseurl = baseurl, titlela = titlela, totaleps = content.totaleps,
        url = content.url, title = content.title, cover = content.cover, source_raw = content.source
      })
    end else MyToast("Favorit kosong.")
    return
  end

  for index,content in ipairs(toupdate) do
    table.insert(newdata,{
      source_id = content.source.id,
      this_source = content.source,

      old_data = {
        title_oldeps = content.titlela,
        base_url = content.baseurl,
        total_eps = content.totaleps
      },

      old_db = {
        url = content.url, title = content.title ,
        cover = content.cover, source = content.source_raw
      }
    })
  end

  for index, content in ipairs(newdata) do
    if string.match(content.source_id,content.source_id) == content.source_id then
      
      local base_url = content.old_data.base_url
      local tag = string.format("library_updater_%d", math.random(1, 60))
      
      LuaHttp.request({url = base_url, tag=tag},function(error, code, body)
        if error or code ~= 200 then
          print(("Koneksi error, Tidak dapat memuat: %s"):format(base_url))
          return
        end
      
        SourceUtil.loadSource(content.this_source)
        local jsouparse = Jsoup.parse(body)
        local astable = luajava.astable(jsouparse.select(episodeSelector))

        uihelper.runOnUiThread(this,function()
          for k,v in pairs(data) do data[k] = nil end
                    
          for index,content in ipairs(astable)
            local document = Jsoup.parseBodyFragment(tostring(content))
            fetchEpisodeList(document)
            table.insert(data, {title=title, url=url})
          end

          local compare_result = compare_episode(content.old_data.total_eps, #data)

          if compare_result == 1 then
            local olddata = content.old_db
            local firstdata = TableUtil.first(data)

            if tostring(firstdata.title) ~= "" then
              data.totaleps = #data
              data.latesteps = "{title={"..firstdata.title.."},url={"..firstdata.url.."},update=newupdate}"

              DbHelper.updateLibrary(db,
              olddata.url, olddata.title,
              olddata.source, olddata.cover,
              data.latesteps, data.totaleps
              )

              UpdateAlert:createNotifiUpdate(
              activity.getContext(), olddata.title,
              string.format("New Episode: %s", firstdata.title)
              )
            end
            return
           elseif compare_result == 0 then
            LuaHttp.cancelWithTag(tag)
            return
          end
        end)
      end)
    end
  end
end

function UpdateLibrary.doWorkUpdater(db)
  doWork(db)
  MyToast.showToast("Memperbarui episode favorit.")
end

return UpdateLibrary