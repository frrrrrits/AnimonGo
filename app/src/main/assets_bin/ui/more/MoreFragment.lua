require "import"
import "initapp"
import "util.PrefSettingsLayUtil"
import "ui.more.PrefSettingsLayout"
import "ui.more.PrefColumnsLayout"
import "ui.more.PrefSettings"

local function newInstance()
  local layout = {
    CoordinatorLayout,
    id = "mainlay",
    layout_height = "fill",
    layout_width = "fill",
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
        layout_scrollFlags = "scroll|exitUtilCollapsed",
        {
          MaterialToolbar,
          elevation = "0dp",
          layout_height = theme.number.actionBarSize,
          layout_width="match_parent",
          id="toolbar",
          layout_collapseMode = "pin",
          backgroundColor = 0,
        },
      }
    },
    {
      RecyclerView,
      id = "recycler",
      layout_height = "fill",
      layout_width = "fill",
      overScrollMode = 2,
      layout_behavior = "appbar_scrolling_view_behavior",
    },
  };

  local ids={}
  local data={titles={}, fragments={}}
  local fragment = LuaFragment.newInstance()

  local function onItemClick(view,views,key,data)
    if key=="theme_picker" then
      createThemeDialog(fragment).show()
     elseif key=="theme_style" then
      createThemeStyleDialog(fragment).show()
     elseif key=="auto_update" then
      Preferences.isUpdate().setpref(false)
     elseif key=="grid_size" then
      createColumnsDialog(views, data)
      .show()
     elseif key=="delete_cover" then
      deleteCovers()
     elseif key=="delete_favorite" then
      deleteFavoriteDialog()
      .show()
     elseif key=="delete_episode" then
      deleteEpisodeDialog()
      .show()
    end
  end

  fragment.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout,ids)
    end,
    onResume=function()
      window.statusBarColor = 0
      task(100,function()
        BottomAnimation.onScrollHide(ids,bottomNav)
      end)
    end,
    onViewCreated = function(view, savedInstanceState)
      ActivityUtil.fadeThrough(fragment,ids.mainlay)

      activity.setSupportActionBar(ids.toolbar)
      local actionbar = activity.getSupportActionBar()
      actionbar.setTitle(R.string.label_more)

      local layoutManager=LinearLayoutManager(fragment.getActivity())
      ids.recycler.adapter = PrefSettingsLayUtil.adapter(PrefSettingsLayout,onItemClick)
      ids.recycler.setLayoutManager(layoutManager)
    end,
  })

  return fragment
end

return {
  newInstance = newInstance
}