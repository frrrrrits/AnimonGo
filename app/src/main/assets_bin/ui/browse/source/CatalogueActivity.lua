require "import"
import "initapp"
import "util.ChromeTabs"
import "util.preferences.Preferences"
import "ui.browse.BrowseSource"
import "ui.browse.source.CatalogueAdapter"
import "ui.browse.source.CatalogueItem"
import "androidx.recyclerview.widget.FastScroller"

local plugin = ...
local landscapeColumns=Preferences.landscapeColumns():get()
local potraitColumns=Preferences.potraitColumns():get()

local layout={
  CoordinatorLayout,
  layout_height="match_parent",
  layout_width="match_parent",
  id="mainlay",
  {
    AppBarLayout,
    id="appbar",
    layout_height="wrap_content",
    layout_width="match_parent",
    fitsSystemWindows="true",
    elevation="0dp",
    liftOnScroll=true,
    {
      CollapsingToolbarLayout,
      id="collaps",
      layout_height="119dp",
      layout_width="match_parent",
      layout_scrollFlags="scroll|exitUtilCollapsed",
      {
        MaterialToolbar,
        elevation="0dp",
        layout_height=theme.number.actionBarSize,
        layout_width="match_parent",
        id="toolbar",
        layout_collapseMode="pin",
        backgroundColor=0,
      },
    }
  },
  {
    SwipeRefreshLayout,
    id="swiperefresh",
    layout_width="match_parent",
    layout_marginLeft="5dp",
    layout_marginRight="5dp",
    layout_behavior="appbar_scrolling_view_behavior",
    {
      AutofitRecyclerView,
      id="recycler",
      layout_width="match_parent",
      layout_height="match_parent",
    },
  },
}

local ids={}
local data={}
local pages={page=1}

local displayItem=2
local columnsCount=potraitColumns

function onCreate()
  activity.setContentView(loadlayout(layout, ids))
  activity.setSupportActionBar(ids.toolbar)

  local actionbar=activity.getSupportActionBar()
  actionbar.setTitle(tostring(plugin.name))
  actionbar.setDisplayHomeAsUpEnabled(true)

  ids.toolbar.setNavigationOnClickListener{
    onClick=function()
      finishActivity()
    end
  }

  window.statusBarColor = 0
  local iserr = BrowseSource.load(plugin) if iserr then
    MyToast.showErrorDialog("Terjadi kesalahan")
    return
  end

  setupRecycler(displayItem)

  ThemedSwipeRefresh()
  .init(ids.swiperefresh)
  .distanceToTrigger()

  ids.swiperefresh.setOnRefreshListener{
    onRefresh=function()
      pages.page=1
      BrowseSource.fetchLatest(data,pages,adapter,ids,true)
    end
  }

  BrowseSource.fetchLatest(data,pages,adapter,ids,true)

  Insetter.builder()
  .margin(WindowInsetsCompat.Type.navigationBars(),
  Side.create(true,false,false,false,true,false))
  .applyToView(ids.mainlay)
 
  local recycler = ids.recycler  
end

function onConfigurationChanged(config)
  if displayItem==2 then
    if config.orientation==2 then
      columnsCount=landscapeColumns else
      columnsCount=potraitColumns
    end
    setupRecycler(displayItem)
  end
end

function setupRecycler(count)
  displayItem=count
  if count==1 then
    manager=LinearLayoutManager(this)
   elseif count==2 then
    manager=GridLayoutManager(this,columnsCount)
  end
  adapter=CatalogueAdapter(data,pages,ids,displayItem)
  ids.recycler.adapter=adapter
  ids.recycler.setLayoutManager(manager)
  ids.recycler.columnWidth=uihelper.dp2int(140)
  ids.recycler.setHasFixedSize(true)
  activity.invalidateOptionsMenu()
end

function getSourceName()
  return tostring(plugin.name)
end

function getPluginData()
  return plugin
end

function onCreateOptionsMenu(menu,inflater)
  activity.getMenuInflater().inflate(R.menu.menu_display, menu)
  switch displayItem
   case 1 actions=R.id.action_list
   case 2 actions=R.id.action_compact_grid
  end
  menu.findItem(actions).checked=true
end

function onOptionsItemSelected(menuItem)
  switch menuItem.itemId
   case R.id.action_list
    setupRecycler(1)
   case R.id.action_compact_grid
    setupRecycler(2)
   case R.id.action_webview
    openInBrowser(BrowseSource.baseUrl())
  end
end

function onDestroy()
  LuaHttp.cancelAll()
end

function onKeyDown(keyCode,keyEvent)
  finishActivity(1,keyCode,keyEvent)
end