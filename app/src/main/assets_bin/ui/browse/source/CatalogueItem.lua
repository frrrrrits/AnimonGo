import "com.google.android.material.progressindicator.CircularProgressIndicator"
import "android.view.View"

local CatalogueItem={}
local cardScrimColor = theme.color.scrimColor
local colorPrimary = theme.color.colorPrimary
local textColorOnTertiary = theme.color.colorTertiary
local textColorSecondary = theme.color.textColorSecondary
local textColorPrimary = theme.color.textColorPrimary

function CatalogueItem.textAppearance(view, str)
  return view.setTextAppearance(activity.getContext(), uihelper.getAttr(str))
end

CatalogueItem.compact_grid={
  LinearLayout,
  layout_height="wrap_content",
  layout_width="match_parent",
  {
    FrameLayout,
    id="frame",
    layout_height="wrap_content",
    layout_width="match_parent",
    layout_margin="2dp",
    padding="1dp",
    {
      MaterialCardView,
      id="cards",
      radius="10dp",
      clickable=true,
      layout_margin="1dp",
      layout_height="wrap_content",
      layout_width="match_parent",
      cardBackgroundColor=cardScrimColor,
      {
        RelativeLayout,
        padding="0dp",
        layout_height="wrap_content",
        layout_width="match_parent",
        {
          FrameLayout,
          id="card",
          layout_height="190dp",
          layout_width="match_parent",
          {
            CircularProgressIndicator,
            layout_width="wrap_content",
            layout_height="wrap_content",
            layout_gravity="center",
            trackCornerRadius="100dp",
            indicatorSize="34dp",
            indeterminate=true,
          },
          {
            ShapeableImageView,
            id="cover",
            layout_height="match_parent",
            layout_width="match_parent",
            scaleType="centerCrop",
          },
          {
            MaterialCardView,
            id="cardupdate",
            layout_gravity="top|left",
            layout_margin="5dp",
            layout_height="wrap_content",
            visibility = View.INVISIBLE,
            cardBackgroundColor = colorPrimary,
            {
              TextView,
              id="total_eps",
              layout_margin="4dp",
              layout_marginLeft = "6dp",
              layout_marginRight = "6dp",
              layout_gravity = "center",
              textColor = textColorOnTertiary,
            },
          },
        },
        {
          LinearLayout,
          layout_below="card",
          layout_height="wrap_content",
          layout_width="match_parent",
          orientation="vertical",
          layout_marginBottom="4dp",
          padding="8dp",
          {
            TextView,
            id="title",
            ellipsize="end",
            maxLines="1",
            textSize="15sp",
            textColor=textColorPrimary,
            textAppearance="textAppearanceSubtitle2",
          },
            {
              TextView,
              id="episode",
              ellipsize="end",
              maxLines="2",              
              textColor = textColorSecondary,
            },                
        }
      }
    }
  }
}

CatalogueItem.item_list={
  FrameLayout,
  layout_height="wrap_content",
  layout_width="match_parent",
  {
    MaterialCardView,
    id="cardupdate",
    layout_margin="0dp",
    layout_height="0dp",
    layout_width="0dp",
    {
      TextView,
      id="total_eps",
      textSize="0dp",
    },
  },
  {
    MaterialCardView,
    id="cards",
    radius="10dp",
    clickable=true,
    layout_margin="5dp",
    layout_height="wrap_content",
    layout_width="match_parent",
    cardBackgroundColor=cardScrimColor,
    {
      LinearLayout,
      layout_height="wrap_content",
      layout_width="match_parent",
      orientation="horizontal",
      layout_marginLeft="0dp",
      {
        ShapeableImageView,
        id="cover",
        layout_height="76dp",
        layout_width="76dp",
        scaleType="centerCrop",
        layout_margin="0dp",
        padding="0dp",
      },
      {
        LinearLayout,
        layout_height="wrap_content",
        layout_width="wrap_content",
        orientation="vertical",
        layout_margin="10dp",
        layout_marginLeft="13dp",
        layout_margin="12dp",
        {
          TextView,
          id="title",
          ellipsize="end",
          maxLines="2",
          textSize="16sp",
          textColor=textColorPrimary,
        },
        {
          TextView,
          id="episode",
          ellipsize="end",
          maxLines="2",
          textSize="14sp",
          layout_marginTop="2dp",
          textColor=textColorSecondary,
        }
      }
    }
  }
}

CatalogueItem.loading = {
  FrameLayout,
  id="card",
  layout_height="100dp",
  layout_width="match_parent",
  {
    CircularProgressIndicator,
    layout_width="wrap_content",
    layout_height="wrap_content",
    layout_gravity="center",
    trackCornerRadius="100dp",
    indicatorSize="34dp",
    indeterminate=true,
  }
}

return CatalogueItem