import "ui.anime.ItemLayout"

defaultPrimary = theme.color.textColorPrimary
defaultSecondary = theme.color.textColorSecondary
markPrimary = ColorUtils.setAlphaComponent(theme.color.colorOnSurface,100)

local isMarked = { defaultText = defaultColorPrimary, defaultTextSecond = defaultColorSecondary }

local function isinDb(id)
  return DbHelper.instance.isEpisode(id)
end

local is_stream_able = function()
  return BrowseSource.streamAble()
end

function setEpisodeColor(item,c1,c2)
  item.item_title.textColor=c1
  item.item_date.textColor=c2
end

local function markedEpisode(pos,item)
  if isinDb(pos.url) then
    pos.marked = "unmarked"
    DbHelper.deleteEpisode(pos.url)
    setEpisodeColor(item, defaultPrimary, defaultSecondary)
    notifDataChanged(TableData.Details.fragment, adapter)
    return
  end

  mdb = DbHelper.onChanged(this,function()
    pos.marked = "marked"
    MyToast.showToast("di tandai.")
    setEpisodeColor(item, markPrimary, markPrimary)
  end)

  DbHelper.addEpisodeMark(mdb,tostring(pos.url),tostring(pos.title))
  notifDataChanged(TableData.Details.fragment, adapter)
end

return function(data)
  return LuaAdapter(LuaAdapter.AdapterCreator{
    getCount=function() return #data end,
    getView=function(position, convertView, parent)
      position=position+1

      if convertView==nil then
        local views={}
        convertView=loadlayout(item_episode, views)
        convertView.setTag(views)
      end

      local views=convertView.getTag()
      local item=data[position]

      if item then
        views.item_title.text=item.title
        views.item_date.text=item.date
        views.item_date.textColor=defaultSecondary

        views.item_title.textAppearance = uihelper.getAttr("textAppearanceBodyMedium")
        views.item_date.textAppearance = uihelper.getAttr("textAppearanceBodyMedium")

        if item.marked == 'marked' then
          isMarked.defaultText = markPrimary
          isMarked.defaultTextSecond = markPrimary
         else
          isMarked.defaultText = defaultPrimary
          isMarked.defaultTextSecond = defaultSecondary
        end

        views.item_title.textColor=isMarked.defaultText
        views.item_date.textColor=isMarked.defaultTextSecond
        data.episodecount = #data

        local stream_button = views.action_stream
        if is_stream_able() then
          stream_button.visibility = View.VISIBLE
        end

        views.action_download.onLongClick = function(view)
          local pos = data[position]
          markedEpisode(pos, views)
          return true
        end

        views.action_download.onClick = function(adapter)
          local pos = data[position]
          EpisodeFragmentReload(pos)
        end

        views.action_stream.onClick = function(adapter)
          local pos = data[position]
          local reverse = selectedItem
          local plugin = TableData.Details.source
                   
          newActivity("ui/player/PlayerActivity", {
            {current_episode = pos, data = data},
            position, plugin, reverse
          })
        end

      end
      return convertView
    end
  })
end