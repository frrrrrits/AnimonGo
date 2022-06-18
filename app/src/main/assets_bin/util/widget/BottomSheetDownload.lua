-- BottomSheet show download list url

import "util.ChromeTabs"
import "android.util.DisplayMetrics"
import "com.google.android.material.bottomsheet.BottomSheetBehavior"
import "com.google.android.material.bottomsheet.BottomSheetDialog"

local ids={}
local data={}

local bottomSheetAdapter
local BottomSheetDownload={}

local dividerColor=ContextCompat.getColor(this,R.color.divider_default)
local actionbarSize=theme.number.actionBarSize
local textColorPrimary=theme.color.textColorPrimary
local colorScrim=theme.color.scrimColor
local colorSurface=theme.color.colorSurface
local colkrPrimary=theme.color.colorPrimary
local colorOnSurface=theme.color.colorOnSurface
local borderless=theme.number.id.selectableItemBackgroundBorderless
local backgroundColor= theme.color.elevationOverlay
local backgroundBorderless = theme.number.id.selectableItemBackgroundBorderless
local flg=View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
local function nilOrBlank(s) return s==nil or s=="" end

BottomSheetDownload.layout= {
  LinearLayout,
  id="mainlay",
  layout_height="match_parent",
  layout_width="match_parent",
  orientation="vertical",
  {
    MaterialCardView,
    id="card",
    radius="15dp",
    elevation="0",
    layout_margin="11dp",
    layout_height="match_parent",
    layout_width="match_parent",
    cardBackgroundColor=colorSurface,
    {
      LinearLayout,
      orientation="vertical",
      layout_height="match_parent",
      layout_width="match_parent",
      {
        LinearLayout,
        gravity="center|left",
        layout_height=actionbarSize,
        layout_width="match_parent",        
        {
          ImageButton,
          id="actionClose",
          layout_margin="3dp",
          src="@drawable/ic_window_close_24dp",
          colorFilter=colorOnSurface,
          layout_gravity="center|left",
          backgroundResource=backgroundBorderless
        },
        {
          TextView,
          id="title",
          maxLines="1",
          gravity="center",
          ellipsize="end",
          textSize="19sp",          
          layout_gravity="center|right",
          layout_margin="8dp",
          layout_marginLeft="14dp",
          layout_marginRight="12dp",
          textColor=textColorPrimary,
        },
        {
          View,
          layout_width="match_parent",
          layout_height="1dp",
          -- backgroundColor=dividerColor,
          layout_gravity="bottom",
        },
      },
      {
        FrameLayout,
        layout_height="wrap_content",
        layout_width="match_parent",
        layout_gravity="top",
        {
          RecyclerView,
          layout_height="match_parent",
          layout_width="match_parent",
          overScrollMode=2,
          id="recycler",
        }
      }
    }
  }
}


BottomSheetDownload.item={
  LinearLayoutCompat,
  orientation="vertical",
  layout_height="wrap_content",
  layout_width="match_parent",
  gravity="center",
  {
    MaterialCardView,
    id="card",
    radius="12dp",
    clickable=true,
    layout_height="wrap_content",
    layout_width="match_parent",
    layout_margin="8dp",
    layout_marginLeft="12dp",
    layout_marginRight="12dp",
    elevation="0dp",
    cardBackgroundColor=theme.color.primaryInverseScrim,
    {
      TextView,
      id="item_title",
      layout_margin="13dp",
      layout_marginTop="20dp",
      layout_marginBottom="20dp",
      textColor=textColorPrimary,
      layout_gravity="center",
      layout_width="match_parent",
    }
  }
}

function BottomSheetDownload:adapter(data)
  return LuaRecyclerAdapter(LuaRecyclerAdapter.AdapterCreator({
    getItemCount=function() return #data end,
    getItemViewType=function(position) return position end,
    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder=LuaRecyclerHolder(loadlayout(BottomSheetDownload.item, views))
      holder.itemView.setTag(views)
      views.card.onClick=function()
        local pos=holder.getAdapterPosition() + 1        
        local url=data[pos].url
        if nilOrBlank(url) then
          MyToast("Laman tidak di temukan") else
          openInBrowser(url)
        end
      end
      return holder
    end,
    onBindViewHolder=function(holder,position)
      position=position + 1
      local item=data[position]
      local views=holder.itemView.getTag()
      if item==nil or views==nil then return end
      local title=item.title
      if title then
        views.item_title.text=title
        views.item_title.textAppearance=uihelper.getAttr("textAppearanceBodyMedium")
      end
    end,
  }))
end

function BottomSheetDownload:parsedUrl(url)
  for k,v in ipairs(data) do data[k]=nil end
  local element=Jsoup.parseBodyFragment(tostring(url))
  local astable=luajava.astable(element.select("a"))
  table.foreach(astable,function(index,content)
    local element=Jsoup.parseBodyFragment(tostring(content))
    local aElement=element.select("a")
    local url=aElement.attr("href")
    table.insert(data,{title=aElement.text(),url=url})
  end)
  bottomSheetAdapter.notifyDataSetChanged()
  return self
end

function BottomSheetDownload:setTitle(title)
  self.title.text=title
  return self
end

function BottomSheetDownload:build()
  local viewParent=loadlayout(BottomSheetDownload.layout,ids)
  local bottomSheetDialog=BottomSheetDialog(this,R.style.ThemeOverlay_BottomSheetDialog)
  bottomSheetDialog.setContentView(viewParent)

  local metrics=DisplayMetrics()
  activity.getWindowManager().getDefaultDisplay().getMetrics(metrics)

  bottomSheetDialog.setOnShowListener {
    onShow = function(dialogInterface)
      local bottomSheet = dialogInterface.findViewById(R.id.design_bottom_sheet)
      local behavior = BottomSheetBehavior.from(bottomSheet)
      local layoutParams = bottomSheet.getLayoutParams()
    end
  }

  local bottomSheet=bottomSheetDialog.findViewById(R.id.design_bottom_sheet)
  local behavior=BottomSheetBehavior.from(bottomSheet)
  local layoutParams=bottomSheet.layoutParams

  layoutParams.height=WindowManager.LayoutParams.MATCH_PARENT
  bottomSheet.layoutParams=layoutParams

  behavior.peekHeight=metrics.heightPixels/2

  if not(Themes.isSysNightMode()) then
    viewParent.parent.setSystemUiVisibility(flg)
  end

  bottomSheetDialog.window.setNavigationBarColor(0)

  ids.title.getPaint().setFakeBoldText(true)
  ids.actionClose.onClick=function()
    bottomSheetDialog.dismiss()
  end

  self.title=ids.title
  self.recycler=ids.recycler
  self.title.textAppearance = uihelper.getAttr("textAppearanceTitleLarge")
  
  bottomSheetAdapter=BottomSheetDownload:adapter(data)
  local manager=LinearLayoutManager(this)

  ids.recycler.adapter=bottomSheetAdapter
  ids.recycler.setLayoutManager(manager)
  ids.recycler.setHasFixedSize(true)

  bottomSheetDialog.show()
  return self
end

return BottomSheetDownload