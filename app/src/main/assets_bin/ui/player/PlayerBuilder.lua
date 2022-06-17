local PlayerBuilder={}
setmetatable(PlayerBuilder,PlayerBuilder)

import "ui.player.PlayerImport"

PlayerBuilder.exoPlayer = nil
PlayerBuilder.simpleCache = nil
PlayerBuilder.playbackPosition = 0
PlayerBuilder.currentWindow = 0
PlayerBuilder.isPlaying = false

import "ui.player.PlayerListener"

local currentlink = nil
local isPlayings = false
local cacheSize = 100 * 1024 * 1024 -- 100 mb
local simpleCacheSize = 100 * 1024 * 1024 -- 100mb
local userAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36"

PlayerBuilder.getCache = function(context, cacheSize)
  local cacheEvictor = LeastRecentlyUsedCacheEvictor(cacheSize)
  local cacheDir = File(activity.externalCacheDir, "exoplayer")
  local databaseProvider = StandaloneDatabaseProvider(context)
  if PlayerBuilder.simpleCache == nil then
    return SimpleCache(cacheDir, cacheEvictor, databaseProvider)
  end
end

PlayerBuilder.createDataSource = function(link)
  local source = DefaultHttpDataSource.Factory()
  .setUserAgent(userAgent)
  .setAllowCrossProtocolRedirects(true)

  local headers = {
    ['accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    ['Referer'] = link.referer,
    ['sec-ch-ua'] = " 'Not A;Brand';v='99', 'Chromium';v='102', 'Google Chrome';v='102'",
    ['sec-ch-ua-mobile'] = '?0',
    ['sec-ch-ua-platform'] = 'windows',
    ['sec-fetch-dest'] = 'video',
    ['sec-fetch-mode'] = 'no-cors',
    ['sec-fetch-site'] = 'cross-site',
    ['User-Agent'] = userAgent ,
  }

  return source
  .setDefaultRequestProperties(headers)
end

PlayerBuilder.buildExoPlayer = function(context, mediaItem, cacheSize, currentWindow, playbackPosition, cacheFactory)
  local dfltrg
  local videoMediaSource
  local exoPlayerBuilder = ExoPlayer.Builder(context)

  if cacheSize <= 0 then
    dfltrg = DefaultLoadControl.DEFAULT_TARGET_BUFFER_BYTES else
    if cacheSize > Integer.MAX_VALUE then
      dfltrg = Integer.MIN_VALUE
     else
      dfltrg = tointeger(cacheSize)
    end
  end


  exoPlayerBuilder
  .setLoadControl(DefaultLoadControl.Builder()
  .setTargetBufferBytes(dfltrg)
  .setBufferDurationsMs(
  DefaultLoadControl.DEFAULT_MIN_BUFFER_MS,
  DefaultLoadControl.DEFAULT_MAX_BUFFER_MS,
  DefaultLoadControl.DEFAULT_BUFFER_FOR_PLAYBACK_MS,
  DefaultLoadControl.DEFAULT_BUFFER_FOR_PLAYBACK_AFTER_REBUFFER_MS
  ).build())
  .setSeekBackIncrementMs(5000)
  .setSeekForwardIncrementMs(5000)

  if cacheFactory ~= nil then
    videoMediaSource = DefaultMediaSourceFactory(cacheFactory)
    .createMediaSource(mediaItem)
  end

  return exoPlayerBuilder.build()
  .setPlayWhenReady(true)
  .seekTo(currentWindow, playbackPosition)
  .setMediaSource(videoMediaSource, playbackPosition)
  .setHandleAudioBecomingNoisy(true)
end

PlayerBuilder.loadExo = function(context, mediaItem, cacheFactory, ids)
  PlayerBuilder.exoPlayer = PlayerBuilder.buildExoPlayer(
  context, mediaItem, cacheSize, PlayerBuilder.currentWindow,
  PlayerBuilder.playbackPosition, cacheFactory)

  ids.playerView.player = PlayerBuilder.exoPlayer
  PlayerBuilder.exoPlayer.prepare()

  if PlayerBuilder.exoPlayer ~= nil then
    PlayerBuilder.isPlaying = PlayerBuilder.exoPlayer.isPlaying
  end

  PlayerBuilder.exoPlayer.addListener(Player.Listener{
    onPlayerStateChanged = function(playWhenReady, playBackState)
      PlayerListener.onPlayerStateChanged(playWhenReady, playBackState, ids)
    end,
    onPlayerError = function(error)
      PlayerListener.onPlayerError(error)
    end
  })
  return PlayerBuilder.exoPlayer
end

PlayerBuilder.loadPlayer = function(context, link, ids, samepisode)
  if samepisode then
    PlayerBuilder.saveData() else
    PlayerBuilder.playbackPostition = 0
  end
  PlayerBuilder.isPlaying = true
  if PlayerBuilder.exoPlayer ~= nil then
    PlayerBuilder.exoPlayer.release()
  end
  PlayerBuilder.exoPlayer = PlayerBuilder.loadOnlinePlayer(context, link, ids)
  return PlayerBuilder.exoPlayer
end

PlayerBuilder.loadOnlinePlayer = function(context, link, ids)
  currentlink = link

  local mediaItem = MediaItem.Builder()
  .setMimeType(MimeTypes.VIDEO_MP4)
  .setUri(link.play_url)
  .build()

  local dataSource = PlayerBuilder.createDataSource(link)
  if PlayerBuilder.simpleCache == nil then
    PlayerBuilder.simpleCache = PlayerBuilder.getCache(context, simpleCacheSize)
  end

  local cacheFactory = CacheDataSource.Factory()
  .setCache(PlayerBuilder.simpleCache)
  .setUpstreamDataSourceFactory(dataSource)
  .setFlags(CacheDataSource.FLAG_IGNORE_CACHE_ON_ERROR)

  return PlayerBuilder.loadExo(context, mediaItem, cacheFactory, ids)
end

function PlayerBuilder.getExoPlayer()
  return PlayerBuilder.exoPlayer
end

function PlayerBuilder.playback()
  PlayerBuilder.exoPlayer.seekTo(PlayerBuilder.playbackPosition)
end

function PlayerBuilder.saveData()
  local exo = PlayerBuilder.exoPlayer
  PlayerBuilder.playbackPosition = exo.currentPosition
  PlayerBuilder.currentWindow = exo.currentWindowIndex
  PlayerBuilder.isPlaying = exo.isPlaying
  PlayerBuilder.release()
end

function PlayerBuilder.safeReleasePlayer()
  uihelper.runOnUiThread(activity.getContext(),function()
    if PlayerBuilder.simpleCache ~= nil then
      PlayerBuilder.simpleCache.release()
      PlayerBuilder.simpleCache = nil
    end
    PlayerBuilder.release()
    PlayerBuilder.exoPlayer = nil
  end)
end

function PlayerBuilder.reloadPlayer(context, ids)
  if PlayerBuilder.exoPlayer ~= nil then
    PlayerBuilder.exoPlayer.release()
  end
  if currentlink ~= nil then
    PlayerBuilder.loadOnlinePlayer(context, currentlink, ids)
  end
end

function PlayerBuilder.release()
  if PlayerBuilder.exoPlayer ~= nil then
    PlayerBuilder.exoPlayer.release()
  end
end

return PlayerBuilder