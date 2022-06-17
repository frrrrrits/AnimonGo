require "import"
import "initapp"
import "ui.anime.AnimeInfoAdapter"
import "util.ChromeTabs"
import "ui.anime.DetailSummary"
import "util.DbHelper"

selectedItem = 0

function EpisodeFragmentReload(pos)
  thisUrl = pos.url
  idsEpisode.title.text=tostring(pos.title)
  BrowseSource.fetchDownloadData(pos.url,dataEpisode,episodeAdapter,idsEpisode,fragmentEpisode)
  idsmain.viewpager.setCurrentItem(0)  
end

local function newInstance(url)
  local layout = {
    CoordinatorLayout,
    id="mainlay",
    layout_height="match_parent",
    layout_width="match_parent",
    {
      NestedScrollView,
      id="nestedscroll",
      fillViewport="true",
      layout_width="match_parent",
      layout_height="match_parent",
      {
        SwipeRefreshLayout,
        id="swiperefresh",
        layout_width="match_parent",
        {
          ListView,
          id="listview",
          layout_width="match_parent",
          layout_height="match_parent",
          overScrollMode=2,
          VerticalScrollBarEnabled=false,
          horizontalScrollBarEnabled=false,
        }
      }
    };
  }

  local ids={}
  local isVisible
  local data = TableData.Episode
  local fragment = LuaFragment.newInstance()

  TableData.Details.fragment = fragment
  adapter = AnimeInfoAdapter(data)
  
  function SortingDialog()
    local listOf={"Terbaru","Paling Awal"}
    return MaterialAlertDialogBuilder(this)
    .setTitle("Sortir Episode")
    .setSingleChoiceItems(listOf,selectedItem,function(dialog,which)
      switch which
       case 0
        selectedItem = 0
        table.sort(data, function(l,r)
          return r.position > l.position
        end)
        notifDataChanged(fragment, adapter)
        dialog.dismiss()
       case 1
        selectedItem = 1        
        table.sort(data, function(l,r)
          return r.position < l.position
        end)
        notifDataChanged(fragment, adapter)
        dialog.dismiss()
      end
    end)
    .show()
  end

  local function getData()
    BrowseSource.fetchDetails(url,data,TableData.Details,TableData.Genre,adapter,ids,fragment)
    notifDataChanged(fragment, adapter)
  end

  fragment.setCreator(LuaFragment.FragmentCreator{
    onCreateView = function(inflater, container, savedInstanceState)
      return loadlayout(layout,ids)
    end,
    onResume = function() end,
    onViewCreated = function(view, savedInstanceState)
      ViewCompat.setNestedScrollingEnabled(ids.listview,true)

      ThemedSwipeRefresh().init(ids.swiperefresh)
      .progressOffset(uihelper.dp2int(40))
      .distanceToTrigger()

      local header = loadlayout(item_header)
      local footer = loadlayout({View})

      header.setLayoutParams(AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,ViewGroup.LayoutParams.WRAP_CONTENT))
      footer.setLayoutParams(AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,uihelper.dp2int(76)))

      ids.listview.addHeaderView(header,nil,false)
      ids.listview.addFooterView(footer,nil,false)

      ids.listview.setAdapter(adapter)
      ids.listview.setDivider(ColorDrawable(theme.color.elevationOverlay))
      ids.listview.setDividerHeight(uihelper.dp2int(1))

      ids.listview.setOnScrollListener{
        onScroll = function(view, visibleItem, visibleItemC, totalItem)
          local childView = view.getChildAt(0)
          if childView then
            local top = childView.getTop()
            if top>= 0 and visibleItem == 0 then
              idsmain.actionFab.extend()
             elseif top < 0 or visibleItem > 0 then
              idsmain.actionFab.shrink()
            end
           else
            idsmain.actionFab.extend()
          end
        end
      }

      ids.swiperefresh.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{
        onRefresh=function()
          selectedItem=0
          getData()
        end
      })

      getData()
    end,
    onUserVisible=function(visible)
      isVisible = visible
      idsmain.actionFab.show()
    end,
  })

  return fragment
end

return {
  newInstance = newInstance
}