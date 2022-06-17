require "import"
import "initapp"
import "ui.player.PlayerImport"
import "ui.player.PlayerCustomLayout"
import "ui.browse.BrowseSource"

local ids = {}
local borderlessButton = theme.number.id.selectableItemBackgroundBorderless
local loading_layout = {
  FrameLayout,
  id="mainlay",
  layout_height="match_parent",
  layout_width="match_parent",
  {
    MaterialToolbar,
    layout_width="match_parent",
    backgroundColor = 0 ,
    {
      ImageButton,
      id="action_exit",
      src="@drawable/ic_arrow_back_white_24dp",
      padding="9dp",
      layout_height="50dp",
      layout_width="50dp",
      scaleType="centerCrop",
      layout_margin="20dp",
      backgroundResource = borderlessButton,
      onClick = function()
        finishActivity()
      end,
    },
  },
  {
    CircularProgressIndicator,
    id="player_buffering",
    layout_width="50dp",
    layout_height="50dp",
    layout_gravity="center",
    trackCornerRadius="100dp",
    indicatorSize="50dp",
    indeterminate=true,
    focusable=false,
    clickable=false,
    focusableInTouchMode=false,
  },
}

local data, position, plugin, reverse = ...

-- userdata to table
local all_episode = luajava.astable(data.data)
local current_episode = luajava.astable(data.current_episode)

PlayerBuilder = require "ui.player.PlayerBuilder"
PlayerController = require "ui.player.PlayerController"
PlayerSource = require "ui.player.PlayerSource"

PlayerSource.episodePosition = position
PlayerSource.reversePosition = reverse
PlayerSource.currentEpisode = current_episode
PlayerSource.episodeList = tbutil.copy(all_episode)

local appContext = activity.getContext().applicationContext
local exoPlayer = PlayerBuilder.getExoPlayer()

local drawable_gradient = GradientDrawable(
GradientDrawable.Orientation.TOP_BOTTOM,{
  alphaBlack, 0x00FFFFFF,
})

local function getViewById(id)
  return activity.findViewById(R.id[id])
end

function onCreate()
  local iInflater=LayoutInflater.from(this)
  local layout=iInflater.inflate(R.layout.layout_player, nil)
  activity.setContentView(layout)

  ids.container = getViewById("player_background")
  ids.container.addView(loadlayout(loading_layout, ids))

  ids.player_go_back = getViewById("player_go_back")
  ids.player_source = getViewById("player_source")
  ids.player_source_action = getViewById("player_source_action")

  ids.player_top_holder = getViewById("player_top_holder")
  ids.player_top_holder.backgroundDrawable = drawable_gradient
  ids.player_video_title = getViewById("player_video_title")

  ids.exo_bottom_bar = getViewById("exo_bottom_bar")
  ids.exo_play_pause = getViewById("exo_play_pause")

  ids.exo_rew = getViewById("exo_rew")
  ids.exo_ffwd = getViewById("exo_ffwd")

  ids.exo_bottom_bar.onTouch=function(v, view)
    return true
  end

  ids.exo_play_pause.visibility = 8
  ids.exo_rew.visibility = 8
  ids.exo_ffwd.visibility = 8

  ids.exo_buffering = getViewById("exo_buffering")
  ids.exo_buffering.getIndeterminateDrawable()
  .setColorFilter(theme.color.colorPrimary, PorterDuff.Mode.SRC_IN);

  ids.playerView = getViewById("player_view")

  ids.playerView.visibility = 8
  ids.playerView.showBuffering = 2

  window.statusBarColor = 0
  window.navigationBarColor = 0
  window.decorView.rootView.backgroundColor = Color.BLACK

  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.P then
    PlayerController.setCutoutShort(true)
  end

  BrowseSource.load(plugin)
  PlayerSource.fetchStreamUrl()
  PlayerSource.runhandler()
end

function Buffering(bolean)
  local mainlay_show = 8
  local player_show = 0

  if bolean then
    mainlay_show = 0
    player_show = 8
  end

  ids.mainlay.visibility = mainlay_show
  ids.playerView.visibility = player_show

  ids.exo_play_pause.visibility = 8
  ids.exo_ffwd.visibility = 8
  ids.exo_rew.visibility = 8
end

function initPlayer(data, samepisode)
  local source = tbutil.copy(data)
  if source == nil or source.play_url == nil then
    MyToast.showToast("Url tidak di temukan, Coba Lagi")
    return
  end

  Buffering(false)

  ids.player_video_title.text = PlayerSource.currentEpisode.title
  ids.player_source.text = string.format("%s %s", source.name, source.quality)
  ids.player_go_back.onClick = function()
    finishActivity()
  end

  ids.player_source_action.onClick = function()
    PlayerSource.createSourceDialog()
    .show()
  end

  exoPlayer = PlayerBuilder.loadPlayer(appContext, source, ids, samepisode)
end

function onStart()
  if exoPlayer ~= nil then
    PlayerBuilder.playback()
    PlayerBuilder.reloadPlayer(appContext, ids)
  end
end

function onStop()
  if exoPlayer ~= nil then
    PlayerBuilder.saveData()
    exoPlayer.pause()
    PlayerBuilder.release()
  end
end

function onPause()
  if exoPlayer ~= nil then
    PlayerBuilder.saveData()
    exoPlayer.pause()
    PlayerBuilder.release()
  end
end

function onResume()
  PlayerController.hideSystemUi()
  activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE

  PlayerController.setCutoutShort(true, ids)
  PlayerController.keepScreenOn(true)

  if exoPlayer == nil then
    PlayerBuilder.reloadPlayer(appContext, ids)
  end
end

function onDestroy()
  PlayerSource.removehandler()

  PlayerController.showSystemUi()
  activity.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_USER

  PlayerController.setCutoutShort(false, ids)
  PlayerController.keepScreenOn(false)

  if exoPlayer ~= nil then
    PlayerBuilder.safeReleasePlayer()
  end
end
