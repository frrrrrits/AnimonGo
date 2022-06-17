import "android.view.View"
import "ui.browse.source.CatalogueItem"
import "com.google.android.material.shape.ShapeAppearanceModel"

return function(data,pages,ids,display)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      position = position + 1
      return data[position].viewtype
    end,
    onCreateViewHolder=function(parent, viewType)
      local views = {}
      local itemType
      if display == 1 then
        itemType = loadlayout(CatalogueItem.item_list, views)
       elseif display == 2 then
        itemType = loadlayout(CatalogueItem.compact_grid, views)
        local coverHeight=ids.recycler.getMeasuredWidth() / manager.spanCount / 3 * 3.5
        local params=RelativeLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT,coverHeight)
        views.card.layoutParams=params
      end
      local holder = LuaRecyclerHolder(itemType)
      holder.itemView.setTag(views)
      views.cards.onClick=function()
        local pos=holder.getAdapterPosition() + 1
        newActivity("ui/anime/DetailActivity",{
          data[pos].url,
          data[pos].title,
          getPluginData()
        })
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position = position + 1
      local item = data[position]
      local views = holder.itemView.getTag()
      if item == nil or views == nil then return end
      local title=item.title
      local episode=item.episode
      local cover=item.cover
      if title then
        views.title.text=title
        views.episode.text=episode
        CatalogueItem.textAppearance(views.title, "textAppearanceTitleMedium")
        CatalogueItem.textAppearance(views.episode, "textAppearanceBodyMedium")
        .textColor = theme.color.textColorSecondary               
      end
      if cover then
        views.cardupdate.visibility = View.INVISIBLE
        views.total_eps.text=episode
        CatalogueItem.textAppearance(views.total_eps, "textAppearanceLabelMedium")
         .textColor = theme.color.colorSurface   
         
        local requestOptions=RequestOptions()
        .diskCacheStrategy(DiskCacheStrategy.RESOURCE)

        local factory=DrawableCrossFadeFactory.Builder()
        .setCrossFadeEnabled(true)
        .build()

        Glide.with(this)
        .load(cover)
        .apply(requestOptions)
        .transition(DrawableTransitionOptions
        .withCrossFade(factory))
        .into(views.cover)

        views.cover.setShapeAppearanceModel(views.cover.getShapeAppearanceModel()
        .toBuilder()
        .setAllCornerSizes(theme.number.card_radius)
        .build())
      end

      if position == #data then
        BrowseSource.fetchLatest(data,pages,adapter,ids)
      end
    end,
  }))
end