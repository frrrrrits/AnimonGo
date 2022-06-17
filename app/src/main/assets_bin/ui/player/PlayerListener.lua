local PlayerListener = {}
PlayerListener.isPlayings = false
PlayerSource = require "ui.player.PlayerSource"

local vfalse = View.GONE
local vtrue = View.VISIBLE

PlayerListener.onPlayerError=function(error)
  local sourceException = error.getSourceException()
  MyToast.showToast(sourceException.getMessage())
end

local function changeui(bool, ids)
  local visi = vfalse
  if bool then  visi = vtrue end
  ids.exo_play_pause.visibility = visi
  ids.exo_ffwd.visibility = visi
  ids.exo_rew.visibility = visi
end

PlayerListener.onPlayerStateChanged = function(playWhenReady, playBackState, ids)
  if PlayerBuilder.exoPlayer ~= nil then
    ids.exo_play_pause.visibility = View.VISIBLE
    PlayerBuilder.isPlaying = PlayerBuilder.exoPlayer.isPlaying
  end
  if playWhenReady then
    switch playBackState
     case Player.STATE_READY
     changeui(true, ids)
     case Player.STATE_ENDED
      PlayerSource.loadNextEpisode()
      changeui(false, ids)
     case Player.STATE_BUFFERING
      ids.exo_play_pause.visibility = vfalse 
     case Player.STATE_IDLE
    end
  end
end

return PlayerListener