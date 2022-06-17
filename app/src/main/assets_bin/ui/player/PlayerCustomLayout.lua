function getColorAlpha(color, alpha)
  local colors = MaterialColors.getColor(this, color, Color.BLACK)
  return ColorUtils.setAlphaComponent(colors, alpha)
end

textColorPrimary = Color.WHITE
textColorSecondary = Color.WHITE

alphaBlack = getColorAlpha(android.R.color.black, 130)

local borderlessButton = theme.number.id.selectableItemBackgroundBorderless

local screenHeight = activity.resources.displayMetrics.heightPixels / 2
local screen_edge_margin = resources.getDimension(R.dimen.screen_edge_margin)

function textAppearance(view, color)
  return view.setTextAppearance(activity.getContext(), uihelper.getAttr(color))
end

local drawable_gradient = GradientDrawable(
GradientDrawable.Orientation.TOP_BOTTOM,{
  alphaBlack,0x00FFFFFF,
})

return {
  FrameLayout,
  layout_height="match_parent",
  layout_width="match_parent",
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
  {
    FrameLayout,
    id="player_holder",
    layout_height="match_parent",
    layout_width="match_parent",
    {
      MaterialToolbar,
      id="player_top_holder",
      layout_width="match_parent",
      backgroundDrawable = drawable_gradient,
      {
        ImageButton,
        id="action_exit",
        src="@drawable/ic_arrow_back_white_24dp",
        layout_gravity="center|left",
        layout_height="50dp",
        layout_width="50dp",
        layout_marginLeft="41dp",
        scaleType="centerCrop",
        backgroundResource = borderlessButton,
        onClick = function()
          finishActivity()
        end,
      },
      {
        TextView,
        text="Kaguya sama",
        id="exo_title",
        textColor = textColorPrimary,
        layout_gravity = "center",
        layout_height = "wrap_content",
        layout_width = "wrap_content",
      },
    },
    {
      ImageButton,
      id="player_pause_play",     
      src="@drawable/ic_play_circle_white_24dp",
      layout_gravity="center",
      layout_height="86dp",
      layout_width="86dp",
      scaleType="centerCrop",
      backgroundResource = borderlessButton,
    },
    {
      FrameLayout,
      id="bottom_player_bar",
      layout_gravity="bottom",
      layout_height="90dp",
      layout_width="match_parent",
      {
        LinearLayout,
        layout_gravity="bottom",
        orientation="vertical",
        layout_height="65dp",
        layout_width="match_parent",
        backgroundColor = alphaBlack,
        {
          FrameLayout,
          layout_marginTop="17dp",
          layout_marginLeft="63dp",
          layout_marginRight="53dp",
          layout_height="wrap_content",
          layout_width="match_parent",
          {
            LinearLayout,
            layout_height="wrap_content",
            layout_width="wrap_content",
            layout_gravity="left|top",
            {
              TextView,
              text="15:38",
              id="exo_position",
              layout_height = "wrap_content",
              layout_width = "wrap_content",
            },
            {
              TextView,
              text="•",
              textSize="12sp",
              textColor = textColorPrimary,
              layout_height = "wrap_content",
              layout_width = "wrap_content",
              layout_marginLeft="6dp",
              layout_marginRight="6dp",
            },
            {
              TextView,
              text="23:40",
              id="exo_duration",
              layout_height = "wrap_content",
              layout_width = "wrap_content",
            },
          },
          {
            LinearLayout,
            layout_gravity="right|top",
            layout_height="wrap_content",
            layout_width="wrap_content",
            {
              TextView,
              text="Blogger 360p",
              id="exo_source",
              textColor = textColorPrimary,
              layout_height = "wrap_content",
              layout_width = "wrap_content",
            },
            {
              TextView,
              text="•",
              textSize="12sp",
              textColor = textColorPrimary,
              layout_height = "wrap_content",
              layout_width = "wrap_content",
              layout_marginLeft="6dp",
              layout_marginRight="6dp",
            },
            {
              ImageButton,
              id="action_source",
              layout_height="20dp",
              layout_width="20dp",
              src="@drawable/ic_hd_white_24dp",
              layout_gravity = "right|top",
              backgroundResource = borderlessButton,
              onClick = function()
                print("dosomethin()")
              end,
            },
          },
        }
      },
      {
        Slider,
        id="exo_progress",
        layout_height="23dp",
        layout_width="match_parent",
        layout_gravity="top",
        layout_marginLeft="50dp",
        layout_marginRight="40dp",
      },
    },
  },
}