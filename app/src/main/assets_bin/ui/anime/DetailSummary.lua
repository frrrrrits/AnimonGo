import "util.DbHelper"
local DetailSummary={}

local animinfo = TableData.Details
local animgenre = TableData.Genre

local stringUnFavorite = "Mengikuti"
local stringToFavorite = "Ikuti"
local stringUnTrailer = "Trailer tidak tersedia"
local stringUknown = "Tidak di ketahui"

local function nilOrBlank(s)
  if s == "" or s == nil then
    return stringUknown
   else
    return s or "uknown"
  end
end

function notifDataChanged(fragment, adapter)
  uihelper.runOnUiThread(fragment.getActivity(),function()
    adapter.notifyDataSetChanged()
  end)
end

local function isFavorite(id)
  return DbHelper.instance.isFavorite(id)
end

local function addChip(title,config,group)
  local chip = loadlayout({Chip,text = title,tag = config, checkable = false})
  group.addView(chip)
  local drawable = ChipDrawable.createFromAttributes(this, nil, 0, R.style.Widget_Chip_Action)
  chip.setChipDrawable(drawable)
end

local function setFavorieText()
  if isFavorite(animinfo.title) then
    idsmain.actionFab.text=stringUnFavorite
    idsmain.actionFab.iconResource=R.drawable.ic_bookmark_add_24dp
   else
    idsmain.actionFab.text=stringToFavorite
    idsmain.actionFab.iconResource=R.drawable.ic_bookmark_24dp
  end
end

local function updateHeader()
  local requestOptions = RequestOptions()
  .diskCacheStrategy(DiskCacheStrategy.RESOURCE)

  if !activity.isFinishing() then
    Glide.with(this)
    .load(animinfo.cover)
    .apply(requestOptions)
    .into(anime_cover)
  end

  anime_title.text = nilOrBlank(animinfo.title)
  anime_status.text = nilOrBlank(animinfo.status)
  anime_airdate.text = nilOrBlank(animinfo.airdate)
  anime_desc.text = nilOrBlank(animinfo.description)
  anime_source.text = nilOrBlank(animinfo.sourcename)

  anime_cover.clipToOutline = true
  anime_title.textAppearance = uihelper.m3appreance("TitleLarge")
  total_episode.textAppearance = uihelper.m3appreance("BodyLarge")
    
  actions_filters.onClick = function()
    SortingDialog()
  end

  actions_trailer.onClick = function()
    local isnil = tostring(animinfo.trailer) == nil
    or tostring(animinfo.trailer) == ""
    if isnil then
      MyToast(stringUnTrailer)
     else
      openInBrowser(tostring(animinfo.trailer))
      MyToast.showToast("Membuka")
    end
  end

  idsmain.actionFab.onClick = function()
    if isFavorite(animinfo.title) then
      DbHelper.deleteFavorite()
     else
      DbHelper.addFavorite()
    end
    setFavorieText()
  end

  anime_desc.onClick=function()
    return MaterialAlertDialogBuilder(this)
    .setTitle("Sinopsis")
    .setMessage(nilOrBlank(animinfo.description))
    --.setPositiveButton("Tutup", nil)
    .show()
  end

  total_episode.text = tostring("Total Episode " .. adapter.getCount())

  if isFavorite(animinfo.title) then
    setFavorieText()
    DbHelper.updateFavorite()
  end

  notifDataChanged(animinfo.fragment, adapter)
end

local function updateGenres()
  addChip(animgenre.title,animgenre.url,genre_group)
end

DetailSummary.updateHeader = updateHeader
DetailSummary.updateGenres = updateGenres

return DetailSummary