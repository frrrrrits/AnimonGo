local PlayerSource={}

tbdata = require "data.TableData"
tbutil = require "data.TableUtil"

local runnable = nil
local handler = Handler()

local initplayer = false
local urlloaded = false
local reversedPosition = false

PlayerSource.sourceIndex = 0
PlayerSource.reversePosition = 0

PlayerSource.urlLoaded = false
PlayerSource.streamUrlLoaded = false

PlayerSource.episodeList = {}
PlayerSource.currentEpisode = {}
PlayerSource.episodePosition = {}

local function isemptytable(t) return next(t) == nil end

local first = function()
  table.sort(tbdata.SourceStream, function(a, b) return a.name < b.name end)
  return tbutil.first(tbdata.SourceStream)
end

local function extractorAble()
  return BrowseSource.useExtractor()
end

function Reset()
  initplayer = false
  urlloaded = false

  PlayerSource.sourceIndex = 0
  PlayerSource.urlLoaded = false
  PlayerSource.streamUrlLoaded = false

  tbutil.clear(tbdata.StreamUrl)
  tbutil.clear(tbdata.SourceStream)
end

PlayerSource.fetchStreamUrl = function(episode)
  local data = tbdata.StreamUrl
  if extractorAble() == false then
    data = tbdata.SourceStream
  end
  local mepisode = episode or PlayerSource.currentEpisode
  BrowseSource.fetchStreamUrl(mepisode.url, data)
end

PlayerSource.InitStreamUrl = function()
  if initplayer then
    task(1,function()
      local tb = first()
      PlayerBuilder.release()
      PlayerBuilder.safeReleasePlayer()
      PlayerBuilder.playbackPosition = 0
      initPlayer(tb, false)
    end)
    PlayerSource.removehandler()
  end
  initplayer = true
end

PlayerSource.loadNextEpisode = function()
  local next = PlayerSource.getNextEpisode()
  if next == nil or PlayerSource.currentEpisode == nil then
    print("Episode selanjutnya tidak tersedia")
    return
  end

  Reset()
  Buffering(true)
  PlayerSource.fetchStreamUrl(next)
  PlayerSource.runhandler()
end

local function positionReverse(v, k)
  local reverse = PlayerSource.reversePosition
  if tonumber(reverse) == 1 then
    reversedPosition = true
    return v[k + 1]
  end
  return v[k - 1]
end

PlayerSource.getNextEpisode = function()
  local episode = PlayerSource.episodeList
  local currentPosition = PlayerSource.episodePosition
  local isNextEpisode = positionReverse(episode, currentPosition)
  if not isNextEpisode then isNextEpisode = nil return end
  -- re position
  local reversed = currentPosition - 1
  if reversedPosition then
    reversed = currentPosition + 1
  end
  -- save it
  PlayerSource.episodePosition = reversed
  PlayerSource.currentEpisode = isNextEpisode
  return isNextEpisode
end

PlayerSource.getSourceUrl = function()
  if PlayerSource.urlLoaded then
    for index, content ipairs(tbdata.StreamUrl)
      ExtractorLink.get(content.url)
    end
  end
end

PlayerSource.runhandler = function()
  runnable = Runnable({
    run = function()
      if extractorAble() == false then
        if not isemptytable(tbdata.SourceStream) then
          PlayerSource.InitStreamUrl()
         else
          handler.postDelayed(runnable, 600)
        end
       elseif extractorAble() == true or extractorAble() == nil then
        if isemptytable(tbdata.StreamUrl) then
          handler.postDelayed(runnable, 600)
         else
          if urlloaded == false then
            PlayerSource.getSourceUrl()
          end
          urlloaded = true
          if not isemptytable(tbdata.SourceStream) then
            PlayerSource.InitStreamUrl()
           else
            handler.postDelayed(runnable, 600)
          end
        end
      end
    end
  })
  handler.postDelayed(runnable, 100)
  handler.post(runnable)
end

PlayerSource.removehandler = function()
  handler.removeCallbacksAndMessages(nil)
  handler.removeCallbacks(runnable)
end

PlayerSource.createSourceDialog = function()
  local ids = {}
  local isPlaying = PlayerBuilder.isPlaying
  local exoPlayer = PlayerBuilder.exoPlayer

  local sourceIndex = PlayerSource.sourceIndex
  local sourceList = tbutil.sort_asc(tbdata.SourceStream, "name")

  exoPlayer.pause()

  local layout = {
    LinearLayout,
    layout_width="match_parent",
    layout_height="wrap_content",
    {
      ListView,
      id="listview",
      layout_margin="8dp",
      layout_width="match_parent",
      layout_height="wrap_content",
    },
  }

  local adapter = ArrayAdapter(context, R.layout.mtrl_alert_select_dialog_singlechoice)
  for index,content in pairs(sourceList)
    adapter.add(string.format("%s %s", content.name, content.quality))
  end

  local dialog = MaterialAlertDialogBuilder()
  .setTitle("Resolusi")
  .setView(loadlayout(layout, ids))

  ids.listview.choiceMode = AbsListView.CHOICE_MODE_SINGLE
  ids.listview.adapter = adapter

  ids.listview.setSelection(sourceIndex)
  ids.listview.setItemChecked(sourceIndex, true)
  ids.listview.dividerHeight = uihelper.dp2int(0)

  ids.listview.onItemClick = function(vie, item, which, position)
    sourceIndex = which
    ids.listview.setItemChecked(which, true)
  end

  dialog.setPositiveButton("terapkan", function()
    local isame = sourceIndex == PlayerSource.sourceIndex
    if isame == true then return end
    PlayerSource.sourceIndex = sourceIndex
    initPlayer(sourceList[sourceIndex+1], true)
  end)

  dialog.onDismiss = function()
    if isPlaying then
      exoPlayer.play()
    end
  end

  dialog.create()
  return dialog
end

return PlayerSource
