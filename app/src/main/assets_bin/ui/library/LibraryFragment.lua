require "import"
import "initapp"
import "ui.library.LibraryAdapter"
import "util.DbHelper"
import "android.preference.PreferenceManager"
import "data.updater.UpdateLibrary"

local function notifyDataChanged(fragment, adapter)
  uihelper.runOnUiThread(fragment.getActivity(),function()
    adapter.notifyDataSetChanged()
  end)
end

local function getData(data, adapter, ids, fragment)
  ids.swiperefresh.setRefreshing(true)
  data.empty = true
  for k, v in ipairs(data) do data[k] = nil end
  local cursor = DbHelper.instance.queryFavorite()
  while cursor.moveToNext() do
    table.insert(data,{
      id = cursor.getInt(0),
      url = cursor.getString(1),
      title = cursor.getString(2),
      source = cursor.getString(3),
      cover = cursor.getString(4),
      latesteps = cursor.getString(5),
      totaleps = cursor.getString(6),
    })
    data.empty = false
  end
  ids.swiperefresh.setRefreshing(false)
  notifyDataChanged(fragment, adapter)
end

local function newInstance()
  local layout = {
    CoordinatorLayout,
    id = "mainlay",
    layout_height = "match_parent",
    layout_width = "match_parent",
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
        layout_height="109dp",
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
      id = "swiperefresh",
      layout_width = "match_parent",
      layout_marginLeft="5dp",
      layout_marginRight="5dp",
      layout_behavior = "appbar_scrolling_view_behavior",
      {
        AutofitRecyclerView,
        id = "recycler",
        layout_width = "match_parent",
        layout_height = "match_parent",
        visibility = View.GONE,
      }
    }
  }

  local ids = {}
  local data = {}
  local isVisible
  local emptyView = EmptyView()
  local adapter = LibraryAdapter(data, ids)

  local updater = Preferences.updater()
  local is_updater = Preferences.isUpdate()
  local old_date, current_date = UpdateLibrary.scheduleUpdate()
  local schedule_update = old_date ~= current_date

  local landscapeColumns = Preferences.landscapeColumns():get()
  local potraitColumns = Preferences.potraitColumns():get()
  local orientationConfig = Preferences.orientation():get()

  local columnsCount = potraitColumns
  local fragment = LuaFragment.newInstance()

  ids.widgetEmptyView = emptyView

  local function setupRecycler()
    manager = GridLayoutManager(this, columnsCount)

    ids.recycler.adapter = adapter
    ids.recycler.setLayoutManager(manager)
    ids.recycler.columnWidth = uihelper.dp2int(140)
    ids.recycler.setHasFixedSize(true)

    Insetter.builder()
    .margin(WindowInsetsCompat.Type.navigationBars(),
    Side.create(true,true,true,true))
    .applyToView(ids.swiperefresh)
  end

  local function onFavorite()
    if data.empty then
      ids.widgetEmptyView:show()
      ids.swiperefresh.enabled = false
      ids.recycler.visibility = View.GONE
     else
      ids.recycler.visibility = View.VISIBLE
      ids.swiperefresh.enabled = true
      ids.widgetEmptyView:hide()
    end
  end

  local function onSetupData()
    if orientationConfig == 1 then
      columnsCount = potraitColumns else
      columnsCount = landscapeColumns
    end
    setupRecycler()
    getData(data,adapter,ids,fragment)
    onFavorite()
  end

  local function onScheduleUpdater(db)
    if updater:get() ~= false then
      if is_updater:get() == false then
        if schedule_update then
          UpdateLibrary.doWorkUpdater(db)
          is_updater.setpref(true)
          Preferences.scheduleUpdate()
          .setpref(current_date)
        end
      end
    end
  end

  fragment.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout, ids)
    end,
    onResume=function()
      onSetupData()
      window.statusBarColor = 0
      task(100,function()
        BottomAnimation.onScrollHide(ids,bottomNav)
      end)
    end,
    onViewCreated = function(view, savedInstanceState)
      ids.widgetEmptyView:intoView(ids.mainlay)
      :label("Belum mengikuti apapun")

      activity.setSupportActionBar(ids.toolbar)
      local actionbar = activity.getSupportActionBar()
      actionbar.setTitle(R.string.label_library)

      ThemedSwipeRefresh().init(ids.swiperefresh).distanceToTrigger()

      ids.mainlay.onTouch=function(view,...)
        ids.recycler.onTouchEvent(...)
      end

      db = DbHelper.onChanged(activity.getContext(),function()
        onSetupData()
        notifyDataChanged(fragment, adapter)
      end)

      ids.swiperefresh.setOnRefreshListener{
        onRefresh = function()
          onSetupData()
          UpdateLibrary.doWorkUpdater(db)
          notifyDataChanged(fragment, adapter)
        end
      }

      onScheduleUpdater(db)
      onSetupData()
    end,
    onConfigurationChanged = function(config)
      Preferences.orientation(1, config.orientation)
      if config.orientation == 2 then
        columnsCount = landscapeColumns
       else
        columnsCount = potraitColumns
      end
      setupRecycler()
    end
  })

  return fragment
end

return {
  newInstance = newInstance
}
