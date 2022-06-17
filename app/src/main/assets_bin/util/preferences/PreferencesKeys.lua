import "android.content.res.Configuration"
local preference={}

preference.values = {
  apptheme = {
    light = "Terang",
    dark = "Gelap",
    system = "Ikuti system",
  },

  appthemestyle = {
    defaults = "Animongo",
  },

  orientation = {
    landscape = Configuration.ORIENTATION_LANDSCAPE,
    portrait = Configuration.ORIENTATION_PORTRAIT
  },

  updater = {
    autoupdate = false
  }
}

preference.keys = {
  isUpdate = {
    keys = "is_update",
    default_value = false,
  },

  scheduleUpdate = {
    keys = "schedule_update_date",
    default_value = "not_set"
  },

  navbarPosition = {
    keys = "nav_position",
    default_value = 0,
  },

  portraitColumns = {
    keys = "columns_portrait_key",
    default_value = 2,
  },

  landscapeColumns = {
    keys = "columns_landscape_key",
    default_value = 3,
  },

  themeMode = {
    keys = "theme_mode",
    default_value = preference.values.apptheme.system,
  },

  themeStyle = {
    keys = "theme_style",
    default_value = preference.values.appthemestyle.defaults,
  },

  updater = {
    keys = "auto_update",
    default_value = preference.values.updater.autoupdate
  },

  configOrientation = {
    keys = "config_orientation",
    default_value = preference.values.orientation.portrait,
  }
}

return preference