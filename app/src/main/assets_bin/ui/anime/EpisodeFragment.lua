require "import"
import "initapp"
import "util.preferences.Preferences"
import "ui.anime.EpisodeAdapter"
import "util.widget.BottomSheetDownload"

local landscapeColumns= Preferences.landscapeColumns():get()
local portraitColumns = Preferences.potraitColumns():get()
local columnsCount=2

local function newInstance(url,title)
  local layout = {
    CoordinatorLayout,
    id="mainlay",
    layout_height="match_parent",
    layout_width="match_parent",
    {
      RelativeLayout,
      layout_height="wrap_content",
      layout_width="match_parent",
      {
        SwipeRefreshLayout,
        id="swiperefresh",
        layout_width="match_parent",
        {
          LinearLayout,
          orientation="vertical",
          layout_height="wrap_content",
          layout_width="match_parent",
          {
            MaterialCardView,
            id="card",
            radius="15dp",
            elevation="0dp",
            layout_margin="9dp",
            layout_marginTop="18dp",
            layout_height="wrap_content",
            layout_width="match_parent",
            cardBackgroundColor=theme.color.colorPrimary,
            {
              TextView,
              id="title",
              textSize="16sp",
              layout_margin="16dp",
            },
          },
          {
            RecyclerView,
            id="recycler",
            layout_width="match_parent",
            layout_height="match_parent",
            overScrollMode=2,
          }
        }
      }
    }
  }

  local isVisible
  local manager
  idsEpisode = {}
  dataEpisode = {}
  fragmentEpisode = LuaFragment.newInstance()
  episodeAdapter = EpisodeAdapter(dataEpisode)

  local function getData()
    if not isVisible then return end
    BrowseSource.fetchDownloadData(url,dataEpisode,episodeAdapter,idsEpisode,fragmentEpisode)
   end

  fragmentEpisode.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout,idsEpisode)
    end,
    onResume=function() end,
    onViewCreated = function(view, savedInstanceState)
      idsEpisode.title.text=tostring(title)
      idsEpisode.title.setTextAppearance(this,uihelper.getAttr("textAppearanceTitleMedium"))      
      .textColor = Themes.getMaterialColor(R.attr.colorOnPrimary)

      ThemedSwipeRefresh()
      .init(idsEpisode.swiperefresh)
      .progressOffset(uihelper.dp2int(10))
      .distanceToTrigger()

      manager = GridLayoutManager(fragmentEpisode.getActivity(), columnsCount)
      idsEpisode.recycler.adapter = episodeAdapter
      idsEpisode.recycler.setLayoutManager(manager)

      idsEpisode.swiperefresh.setOnRefreshListener({
        onRefresh = function()
          thisUrl = url
          idsEpisode.title.text = tostring(title)
          getData()
        end
      })
        
      if not(iserr) then getData() else
        MyToast("Terjadi kesalahan, coba lagi.")
      end    
    end,
    onUserVisible=function(visible)
      isVisible = visible
      idsmain.actionFab.hide()
    end,  
    onConfigurationChanged = function(config)
      local configLanscape = Configuration.ORIENTATION_LANDSCAPE
      if config.orientation == configLanscape then
        columnsCount=landscapeColumns else columnsCount=2
      end
      manager.setSpanCount(columnsCount)
    end
  })

  return fragmentEpisode
end

return {
  newInstance = newInstance
}