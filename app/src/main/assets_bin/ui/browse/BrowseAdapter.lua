import "com.google.android.material.imageview.ShapeableImageView"
import "util.widget.StyleButton"

local function flatType(type)
  if type=='uninstall' then return 'Uninstall'
   elseif type=='update' then return 'Perbarui'
   elseif type =='downloading' then return 'Mengunduh'
   else return 'Unduh'
  end
end

local item_view = {
  FrameLayout,
  id="frame",
  layout_height="wrap_content",
  layout_width="match_parent",
  {
    MaterialCardView,
    id="card",
    radius="10dp",
    elevation="0dp",
    clickable=true,
    layout_margin="8dp",
    layout_height="wrap_content",
    layout_width="match_parent",
    cardBackgroundColor=theme.color.scrimColor,
    {
      LinearLayout,
      layout_height="wrap_content",
      layout_width="match_parent",
      orientation="horizontal",
      layout_marginLeft="3dp",
      {
        ShapeableImageView,
        id="icon",
        layout_height="56dp",
        layout_width="56dp",
        scaleType="centerCrop",
        layout_margin="10dp",
        padding="6dp",
      },
      {
        LinearLayout,
        layout_gravity="center|left",
        layout_height="wrap_content",
        layout_width="wrap_content",
        orientation="vertical",
        layout_weight="1",
        {
          TextView,
          id="title",
          textAppearance="textAppearanceBody2",
          layout_width="match_parent",
        },
        {
          TextView,
          id="version",
          textAppearance="textAppearanceCaption",
          layout_width="match_parent",
          layout_marginTop="2dp",
        },
      },
      {
        LinearLayout,
        id="action",
        gravity="center",
        layout_height="wrap_content",
        layout_width="wrap_content",
        layout_marginRight="20dp",
        layout_gravity="center|right",
        {
          MaterialButton,
          layout_height="wrap_content",
          layout_width="wrap_content",
          id="actionbtn",
        }
      }
    }
  }
}

local item_banner = {
  LinearLayout,
  layout_height="wrap_content",
  layout_width="match_parent",
  {
    TextView,
    id="text",
    textSize="16sp",
    layout_width="match_parent",
    layout_margin="10dp",
    layout_marginLeft="17dp",
    textColor=theme.color.textColorSecondary,
  }
}

return function(data, adapter)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function()
      return #data
    end,
    getItemViewType=function(position)
      position = position + 1
      return data[position].viewtype
    end,
    onCreateViewHolder=function(parent,viewType)
      local views = {}
      local holder
      if viewType == 1 then
        holder = LuaRecyclerHolder(loadlayout(item_banner, views))
       elseif viewType == 2 then
        holder = LuaRecyclerHolder(loadlayout(item_view, views))
       elseif viewType == 3 then
        holder = LuaRecyclerHolder(loadlayout(item_view, views))
      end
      holder.itemView.setTag(views)
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position = position + 1
      local plugin = data[position]
      local views = holder.itemView.getTag()
      if plugin == nil or views == nil then return end
      if plugin.viewtype == 1 then
        views.text.text = plugin.text
        views.text.textAppearance=uihelper.getAttr("textAppearanceTitleLarge")
       elseif plugin.viewtype == 2 then
        local cover = plugin.item.icon
        local name = plugin.item.name
        local version = plugin.item.versionName
        if name then
          views.title.text = name
          views.version.text = "Version: ".. version
          views.title.textAppearance=uihelper.getAttr("textAppearanceBodyLarge")
          views.version.setTextAppearance(uihelper.getAttr("textAppearanceBodySmall"))
          .textColor = theme.color.textColorSecondary
        end
        if cover then
          local requestOptions = RequestOptions()
          .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
          Glide.with(this)
          .load(cover)
          .apply(requestOptions)
          .into(views.icon)
        end
        views.actionbtn.text = flatType(plugin.item.type)
        views.actionbtn.onClick = function()
          if plugin.item.type == 'downloading' then
            return
           elseif plugin.item.type == 'update' or plugin.item.type == 'install' then
            Source.download(plugin.item)
           elseif plugin.item.type == "uninstall" then
            Source.uninstall(plugin.item)
          end
        end
        views.card.onClick = function()
          if plugin.item.type == 'install' then
            Source.download(plugin.item)
           elseif plugin.item.type == "uninstall" or plugin.item.type == "update" then
            newActivity("ui/browse/source/CatalogueActivity",{
              plugin.item,
            })
          end
        end
       elseif plugin.viewtype == 3 then
        views.action.visibility = View.INVISIBLE
        local cover = plugin.item.icon
        local name = plugin.item.name
        local version = plugin.item.versionName
        if name then
          views.title.text = name
          views.version.text = "Version: ".. version
          views.title.textAppearance = uihelper.m3appreance("TitleMedium")
          views.version.textAppearance = uihelper.m3appreance("BodyMedium")
        end
        if cover then
          local requestOptions = RequestOptions()
          .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
          Glide.with(this)
          .load(cover)
          .apply(requestOptions)
          .into(views.icon)
        end
        views.card.onClick = function()
          newActivity("ui/browse/source/CatalogueActivity",{
            plugin.item,
          })
        end
      end
    end,
  }))
end