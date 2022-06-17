import "ui.anime.ItemLayout"

local function isEpisode(id)
  return DbHelper.instance.isEpisode(id)
end

return function(data)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return position
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder
      holder=LuaRecyclerHolder(loadlayout(item_download, views))
      holder.itemView.setTag(views)
      views.card.onClick=function(position)
        local pos=holder.getAdapterPosition()+1
        BottomSheetDownload:build()
        :setTitle(data[pos].title)
        :parsedUrl(data[pos].url)
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position=position + 1
      local item=data[position]
      local views=holder.itemView.getTag()
      if item==nil or views==nil then return end
      if item then
        views.item_title.text=item.title 
        views.item_title.textAppearance = uihelper.m3appreance("BodyMedium")
      end
    end,
  }))
end

