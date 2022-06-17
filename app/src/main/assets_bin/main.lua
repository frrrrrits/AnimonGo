require "import"
import "initapp"
import "util.DbHelper"
import "util.preferences.Preferences"
import "util.BottomAnimation"
import "data.updater.UpdateAlert"
import "com.androlua.network.LuaHttp"

local position
local isVisible
local fragment = nil
local lastExitTime = 0
local mode = AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM
local themeMode = Preferences.themeMode():get()
local navposition = Preferences.navbarPosition():get()
local InsetBuilder = Insetter.builder()
local updater = Preferences.updater(0)
local context = activity.getContext()

local fragment_library = require "ui.library.LibraryFragment"
local fragment_browse = require "ui.browse.BrowseFragment"
local fragment_more = require "ui.more.MoreFragment"

function onCreate(bundle)
  local iInflater=LayoutInflater.from(this or activity)
  local layout=iInflater.inflate(R.layout.layout_main, nil)
  activity.setContentView(layout)

  local root = activity.findViewById(R.id.root_coordinator)
  local frame = activity.findViewById(R.id.framelayout)

  bottomNav = activity.findViewById(R.id.bottom_nav)
  bottomNav.setLabelVisibilityMode(0)
  
  ActivityUtil.setRoot(fragment_library.newInstance()) 
  WindowCompat.setDecorFitsSystemWindows(window, false) 
  
  Insetter.builder()
  .padding(WindowInsetsCompat.Type.navigationBars())
  .applyToView(root)
  
  UpdateAlert:createNotificationChannel(context)

  bottomNav.setOnNavigationItemSelectedListener{
    onNavigationItemSelected=function(item)
      local itemId = item.getItemId()
      switch itemId
       case R.id.nav_library
        position = 0 fragment = fragment_library.newInstance()
       case R.id.nav_browse
        position = 1 fragment = fragment_browse.newInstance()
       case R.id.nav_more then
        position = 2 fragment = fragment_more.newInstance()
      end
      if fragment ~= nil then
        setFragmentRoot(position,fragment)
        Preferences.navbarPosition().setpref(position)
      end
    end
  }

  switch navposition
   case 0 fragment = fragment_library.newInstance()
   case 1 fragment = fragment_browse.newInstance()
   case 2 fragment = fragment_more.newInstance()
  end

  if fragment ~= nil then
    setFragmentRoot(navposition, fragment)
  end

  switch themeMode
   case Preferences.values.apptheme.light
    mode = AppCompatDelegate.MODE_NIGHT_NO
   case Preferences.values.apptheme.dark
    mode = AppCompatDelegate.MODE_NIGHT_YES
   case Preferences.values.apptheme.system
    mode = AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM
  end

  AppCompatDelegate.setDefaultNightMode(mode)
end

function setFragmentRoot(position,fragment)
  bottomNav.getMenu().getItem(position).setChecked(true)
  ActivityUtil.setRoot(fragment)
end

function onKeyDown(KeyCode,event)
  if KeyCode == KeyEvent.KEYCODE_BACK then
    if lastExitTime < System.currentTimeMillis() - 2000 then
      MyToast.showToast("Tekan lagi untuk keluar")
      lastExitTime = System.currentTimeMillis()
      return true
    end
  end
end

function onDestroy()
  LuaHttp.cancelAll()
  Thread.currentThread().interrupt()
  if updater ~= false then
    Preferences.isUpdate().setpref(false)
  end
end
