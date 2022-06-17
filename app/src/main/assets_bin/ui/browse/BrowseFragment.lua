require "import"
import "initapp"
import "ui.browse.BrowseAdapter"
import "source.online.FetchSource"
import "source.Source"

local function newInstance()
  local layout = {
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
      id="swiperefresh",
      layout_width="match_parent",
      layout_behavior="appbar_scrolling_view_behavior",
      {
        AutofitRecyclerView,
        id="recycler",
        layout_width="match_parent",
        layout_height="match_parent",
      }
    }
  }

  local ids={}
  local data={}  
  local data_type={banner=1,list=2}  
  local fragment=LuaFragment.newInstance()

  ids.fragment = fragment
 
  browse_adapter = BrowseAdapter(data, adapter)

  fragment.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout,ids)
    end,
    onResume=function()
      window.statusBarColor = 0
    end,
    onViewCreated = function(view, savedInstanceState)         
      ActivityUtil.fadeThrough(fragment,ids.mainlay)

      activity.setSupportActionBar(ids.toolbar)
      local actionbar=activity.getSupportActionBar()
      actionbar.setTitle(R.string.label_browse)

      ThemedSwipeRefresh().init(ids.swiperefresh).distanceToTrigger()

      local layoutManager = LinearLayoutManager(fragment.getActivity())
      ids.recycler.adapter = browse_adapter
      ids.recycler.setLayoutManager(layoutManager)

      Insetter.builder()
      .margin(WindowInsetsCompat.Type.navigationBars(),
      Side.create(true,true,true,true))
      .applyToView(ids.swiperefresh)

      ids.swiperefresh.setOnRefreshListener{
        onRefresh=function()
          getFetchSource(data,browse_adapter,ids,true)
        end
      }        
      getFetchSource(data,browse_adapter,ids,true)
    end,
    onConfigurationChanged=function(config) end
  })

  return fragment
end

return {
  newInstance = newInstance
}