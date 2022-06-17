require "import"
import "initapp"
import "ui.anime.DetailPagerAdapter"
import "ui.browse.BrowseSource"
import "ui.player.PlayerImport"
import "com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton"
import "android.graphics.drawable.ColorDrawable"

TableData = require "data.TableData"

local base_url, title, plugin = ...
local function nilOrBlank(s) return s == nil or s == "" end
local ic_window_close = R.drawable.ic_window_close_24dp

if nilOrBlank(title) then title = R.string.app_name end
dataFragmentDetail = { titles = {}, fragments = {} }
thisUrl = current_url 
idsmain = {}

TableData.Details = {
  source = plugin,
  sourcename = tostring(plugin.name)
}

iserr = BrowseSource.load(plugin)

local layout={
  CoordinatorLayout,
  id="mainlay",
  layout_height="match",
  layout_width="match",
  {
    AppBarLayout,
    id="appbar",
    layout_height="wrap_content",
    layout_width="match_parent",
    fitsSystemWindows="true",
    liftOnScroll=false,
    liftable=false,
    {
      CollapsingToolbarLayout,
      id="collaps",
      layout_height="109dp",
      layout_width="match_parent",      
      layout_scrollFlags="scroll|enterAlwaysCollapsed",
      backgroundColor = theme.color.colorSurface,
      {
        MaterialToolbar,
        elevation="0dp",
        layout_height=theme.number.actionBarSize,
        layout_width="match_parent",
        id="toolbar",
        navigationIcon=ic_window_close,
        layout_collapseMode="pin",
      },
    },
    {
      TabLayout,
      id="tabs",
      layout_height="wrap_content",
      layout_width="match_parent",
      layout_scrollFlags="enterAlways",
    },
  },
  {
    ExtendedFloatingActionButton,
    id="actionFab",
    text="Ikuti",
    layout_width="wrap",
    layout_height="wrap",
    layout_margin="16dp",
    layout_gravity="bottom|right",
    icon="@drawable/ic_bookmark__24dp",
  },
  {
    ViewPager,
    id="viewpager",
    layout_height="match",
    layout_width="match",
    layout_behavior="appbar_scrolling_view_behavior",
  }
}

local detailFragment=require "ui.anime.AnimeInfoFragment"
local episodeFragment=require "ui.anime.EpisodeFragment"

table.insert(dataFragmentDetail.fragments, episodeFragment.newInstance(base_url, title))
table.insert(dataFragmentDetail.titles, 'Unduh')

table.insert(dataFragmentDetail.fragments,detailFragment.newInstance(base_url))
table.insert(dataFragmentDetail.titles, 'Informasi')

function onCreate(bundle)
  activity.setContentView(layout,idsmain)
  idsmain.toolbar.setTitle(title)
  idsmain.toolbar.inflateMenu(R.menu.menu_webview)

  idsmain.toolbar.setNavigationOnClickListener{
    onClick=function()
      finishActivity()
    end
  }

  idsmain.toolbar.onMenuItemClick=function(menuItem)
    switch menuItem.itemId
     case R.id.action_webview
      openInBrowser(thisUrl)
    end
  end

  if iserr then
    MyToast.showErrorDialog()
    return
  end

  idsmain.viewpager.adapter=DetailPagerAdapter(dataFragmentDetail, idsmain)
  idsmain.viewpager.setOffscreenPageLimit(#dataFragmentDetail.fragments)
  idsmain.viewpager.currentItem=0
  idsmain.viewpager.setSaveEnabled(false)
  
  idsmain.tabs.tabMode=TabLayout.MODE_FIXED
  idsmain.tabs.tabGravity=TabLayout.GRAVITY_FILL
  idsmain.tabs.setupWithViewPager(idsmain.viewpager)

  Insetter.builder()
  .padding(WindowInsetsCompat.Type.navigationBars())
  .applyToView(idsmain.mainlay)
end

function onDestroy()
  LuaHttp.cancelAll()
end

function getSourceName()
  return tostring(plugin.name)
end

function getSourceId()
  return plugin
end

function getUrl()
  return tostring(url)
end

function onKeyDown(keyCode,keyEvent)
  finishActivity(1,keyCode,keyEvent)
end

function onDestroy()
  Thread.currentThread().interrupt()
end