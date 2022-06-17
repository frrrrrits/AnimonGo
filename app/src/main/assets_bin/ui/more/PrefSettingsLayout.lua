-- settings layout
local portrait = Preferences.potraitColumns():get()
local landscape = Preferences.landscapeColumns():get()
columnsText = string.format("Potrait: %d, lanskap: %d",portrait,landscape)
local sumari = "Otomatis mengecek pembaruan episode favorit, jadwal sekali per-hari."

local PackInfo=activity.PackageManager.getPackageInfo(activity.getPackageName(),64)
local themeName = Preferences.themeStyle():get()

return {
  {
    PrefSettingsLayUtil.ITEM_PREFHEADER,
    title=R.string.app_name,
    summary=("%s(%s)"):format(PackInfo.versionName,PackInfo.versionCode),
    icon=R.mipmap.ic_launcher_round,
  },
  {
    PrefSettingsLayUtil.TITLE,
    title="Tampilan",
  },
  {
    PrefSettingsLayUtil.ITEM,
    title="Tema aplikasi",
    key="theme_picker",
    summary=Preferences.themeMode():get(),
    shapeable=true,
    topcorner=true,
  },
  {
    PrefSettingsLayUtil.ITEM_COLORS,
    title="Warna tema",
    key="theme_style",
    summary=themeName,
    shapeable=true,
    bottomcorner=true,
  },
  {
    PrefSettingsLayUtil.TITLE,
    title="Layar",
  },
  {
    PrefSettingsLayUtil.ITEM,
    title="Ukuran grid",
    key="grid_size",
    summary=columnsText,
    shapeable=true,
    topcorner=true,
  },
  {
    PrefSettingsLayUtil.ITEM_SWITCH,
    title="Perbarui favorit otomatis",
    key="auto_update",
    summary=sumari,
    shapeable=true,
    bottomcorner=true,
  },
  {
    PrefSettingsLayUtil.TITLE,
    title="Lainnya",
  },
  {
    PrefSettingsLayUtil.ITEM,
    title="Hapus cache",
    key="delete_cover",
    summary="hapus cache gambar.",
    shapeable=true,
    topcorner=true,
  },
  {
    PrefSettingsLayUtil.ITEM,
    title="Hapus favorite",
    key="delete_favorite",
    summary="hapus semua favorite.",
  },
  {
    PrefSettingsLayUtil.ITEM,
    title="Hapus episode tertandai.",
    key="delete_episode",
    summary="hapus semua episode yang di tandai.",
    shapeable=true,
    bottomcorner=true,
  },
  {
    PrefSettingsLayUtil.ITEM_PREFMARGIN
  },
}