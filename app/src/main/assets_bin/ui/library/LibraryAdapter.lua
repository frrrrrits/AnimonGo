import "ui.browse.source.CatalogueItem"

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
    title=t:match([[title={(.-)},]]),
    url=t:match('url={(.-)},'),
    update=t:match("update=(.-)}")
  }
end

return function(data,ids)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      return position
    end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder=LuaRecyclerHolder(loadlayout(CatalogueItem.compact_grid, views))
      local cover_height=ids.recycler.getMeasuredWidth() / manager.spanCount / 3 * 3.5
      local params = RelativeLayout.LayoutParams(
        ViewGroup.LayoutParams.MATCH_PARENT, cover_height
      )
      views.card.layoutParams = params
      holder.itemView.setTag(views)
      holder.itemView.setFocusable(true)
      views.cards.onClick=function()
        local pos = holder.getAdapterPosition() + 1         
        newActivity("ui/anime/DetailActivity",{
          tableRegex(data[pos].latesteps).url,
          tableRegex(data[pos].latesteps).title,
          pluginRegex(data[pos].source)
        })

      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position=position + 1
      local item=data[position]
      local views=holder.itemView.getTag()
      if item==nil or views==nil then return end
      local title=item.title
      local cover=item.cover
      if title then
        views.title.text=title
        views.episode.text=tostring(tableRegex(item.latesteps).title)
        CatalogueItem.textAppearance(views.title, "textAppearanceTitleMedium")
        CatalogueItem.textAppearance(views.episode, "textAppearanceBodyMedium")
        .textColor = theme.color.textColorSecondary
      end

      views.cardupdate.visibility = View.VISIBLE
      views.total_eps.text = tostring("%d"):format(item.totaleps)
      CatalogueItem.textAppearance(views.total_eps, "textAppearanceLabelMedium")
      .textColor = theme.color.colorSurface

      if tableRegex(item.latesteps).update ~= "noupdate" then
        views.total_eps.text = tostring("New Eps %d"):format(item.totaleps)
      end

      if cover then
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
    end,
  }))
end