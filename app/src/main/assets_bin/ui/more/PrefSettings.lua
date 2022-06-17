import "util.DbHelper"
import "util.preferences.Preferences"

function createThemeDialog(fragment)
  local mode
  local selectedItem
  local themeMode=Preferences.themeMode():get()
  local listOf={"Ikuti system","Mode gelap","Mode Terang"}
  switch themeMode
   case Preferences.values.apptheme.system
    selectedItem=0
   case Preferences.values.apptheme.dark
    selectedItem=1
   case Preferences.values.apptheme.light
    selectedItem=2
  end
  return MaterialAlertDialogBuilder()
  .setTitle("Tema aplikasi")
  .setSingleChoiceItems(listOf, selectedItem, function(dialog,which)
    if which==0 then
      mode=Preferences.values.apptheme.system
     elseif which==1 then
      mode=Preferences.values.apptheme.dark
     elseif which==2 then
      mode=Preferences.values.apptheme.light
    end
    Preferences.themeMode().setpref(mode) dialog.dismiss()
    ActivityCompat.recreate(fragment.getActivity())
  end)
  .create()
end

function createThemeStyleDialog(fragment)
  local ids = {}
  local dialog
  local sourceIndex = 1
  local data = Themes.APPTHEMES
  
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

  local item = {
    LinearLayout,
    layout_width="match_parent",
    layout_height="wrap_content",
    {
      MaterialCardView,
      id="card_container",
      radius="20dp",
      clickable=true,
      layout_width="match_parent",
      layout_height="wrap_content",
      cardBackgroundColor=0,
      layout_margin="1dp",
      {
        LinearLayout,
        layout_width="match_parent",
        layout_height="wrap_content",
        {
          MaterialCardView,
          id="card_color",
          layout_margin="15dp",
          layout_height="33dp",
          layout_width="33dp",
          elevation="0dp",
          radius="600dp",
        },
        {
          AppCompatTextView,
          id="title",
          layout_gravity="center",          
        },
      }
    },
  }

  local adapter = LuaAdapter(LuaAdapter.AdapterCreator{
    getCount = function() return #data end,
    getView = function(position, convertView, parent)
      position = position + 1
      if convertView == nil then
        local views = {}
        convertView = loadlayout(item, views)
        convertView.setTag(views)
      end
      local views = convertView.getTag()
      local item = data[position]
      views.title.text = item.name
      views.title.textAppearance=uihelper.getAttr("textAppearanceSubtitle1")
      views.card_color.cardBackgroundColor = item.show.preview
      views.card_container.onClick=function()
        dialog.dismiss()
        Themes.setAppTheme(tostring(item.name))
        ActivityCompat.recreate(fragment.getActivity())
      end
      return convertView
    end
  })

  dialog = MaterialAlertDialogBuilder()
  .setTitle("Warna Tema")
  .setView(loadlayout(layout, ids))
  .create()

  ids.listview.adapter = adapter
  ids.listview.dividerHeight = uihelper.dp2int(0)
  return dialog
end


function createColumnsDialog(views, data)
  local ids={}
  local potrait = Preferences.potraitColumns():get()
  local landscape = Preferences.landscapeColumns():get()  
  return MaterialAlertDialogBuilder(this)
  .setTitle("Ukuran grid")
  .setView(loadlayout(PrefColumnsLayout, ids))
  .setPositiveButton("Terapkan",function(view)    
    Preferences.potraitColumns().setpref(potrait)
    Preferences.landscapeColumns().setpref(landscape)
    columnsText=string.format("Potrait: %d, lanskap: %d", potrait, landscape)
    views.summary.text=columnsText
    data.summary=columnsText
  end)
  .setNegativeButton("Batal", nil).create(),
  ids.portrait_columns.setOnValueChangedListener(
  NumberPicker.OnValueChangeListener{
    onValueChange=function(view, oldValue, newValue)
      potrait = newValue
    end
  }),
  ids.landscape_columns.setOnValueChangedListener(
  NumberPicker.OnValueChangeListener{
    onValueChange=function(view, oldValue, newValue)
      landscape = newValue
    end
  }),
  ids.portrait_columns.setValue(tonumber(potrait)),
  ids.landscape_columns.setValue(tonumber(landscape))
end

function deleteCovers()
  local cacheDir = File(activity.externalCacheDir, "cover_cache")
  table.foreach(luajava.astable(cacheDir.listFiles()),function(index,content)
    if content.exists() then
      content.delete()
      MyToast.showToast("Cache gambar di hapus")
    end
  end)
end

function deleteFavoriteDialog()
  return MaterialAlertDialogBuilder(this)
  .setTitle("Peringatan")
  .setMessage("Yakin ingin menghapus semua favorite?")
  .setPositiveButton("Hapus",function(view)
    DbHelper.instance.deleteAllFavorite()
    MyToast.showToast("Semua favorite di hapus.")
  end)
  .setNegativeButton("Batal", nil).create()
end

function deleteEpisodeDialog()
  return MaterialAlertDialogBuilder(this)
  .setTitle("Peringatan")
  .setMessage("Yakin ingin menghapus semua episode yang sudah di tandai?")
  .setPositiveButton("Hapus",function(view)
    DbHelper.instance.deleteAllEpisode()
    MyToast.showToast("Semua episode tertandai di hapus.")
  end)
  .setNegativeButton("Batal", nil)
  .create()
end