import "com.google.android.material.slider.Slider"
import "com.google.android.material.switchmaterial.SwitchMaterial"
import "com.google.android.material.divider.MaterialDivider"

local PrefSettingsLayUtil = {}

PrefSettingsLayUtil.TITLE = 1
PrefSettingsLayUtil.ITEM = 2
PrefSettingsLayUtil.ITEM_NOSUMMARY = 3
PrefSettingsLayUtil.ITEM_SWITCH = 4
PrefSettingsLayUtil.ITEM_SWITCH_NOSUMMARY = 5
PrefSettingsLayUtil.ITEM_ITEMWITHSLIDER = 6
PrefSettingsLayUtil.ITEM_AVATAR_NOSUMMARY = 7
PrefSettingsLayUtil.ITEM_ONLYSUMMARY = 8
PrefSettingsLayUtil.ITEM_COLORS = 9
PrefSettingsLayUtil.ITEM_DIVIDER = 10
PrefSettingsLayUtil.ITEM_PREFHEADER = 11
PrefSettingsLayUtil.ITEM_PREFMARGIN = 12

local colorAccent = theme.color.colorAccent
local colorPrimary = theme.color.colorPrimary
local textColorPrimary = theme.color.textColorPrimary
local textColorSecondary = theme.color.textColorSecondary
local colorOnSurface = theme.color.colorOnSurface
local toolbarColor = theme.color.colorSurface
local colorScrim = theme.color.scrimColor
local dividerColor = ContextCompat.getColor(this, R.color.divider_default)

local newPageIconLay = {
    AppCompatImageView,
    id = "rightIcon",
    layout_margin = "16dp",
    layout_marginLeft = 0,
    layout_width = "24dp",
    layout_height = "24dp",
    colorFilter = textColorSecondary
}

local pref_header = {
    LinearLayoutCompat,
    id = "card",
    gravity = "center",
    elevation = "0dp",
    orientation = "vertical",
    layout_width = "match_parent",
    layout_height = "wrap_content",
    backgroundColor = toolbarColor,
    {
        AppCompatImageView,
        id = "icon",
        layout_margin = "18dp",
        layout_width = "70dp",
        layout_height = "70dp"
    },
    {
        AppCompatTextView,
        id = "title",
        textColor = textColorPrimary,
        layout_marginBottom = "5dp",
        textAppearance = "textAppearanceTitleLarge"
    },
    {
        AppCompatTextView,
        textSize = "14sp",
        id = "summary",
        layout_marginBottom = "15dp"
    }
}

local itemsLay = {
    {
        LinearLayoutCompat,
        id = "card",
        layout_width = "match_parent",
        layout_height = "40dp",
        gravity = "center|left",
        focusable = false,
        {
            AppCompatTextView,
            id = "title",
            AllCaps = true,
            textSize = "14sp",
            textColor = colorPrimary,
            layout_marginLeft = "24dp",
            layout_marginRight = "16dp",
            letterSpacing = "0.1"
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                orientation = "vertical",
                gravity = "center",
                layout_margin = "13dp",
                {
                    AppCompatTextView,
                    id = "title",
                    textSize = "16sp",
                    layout_width = "match_parent",
                    textColor = textColorPrimary,
                    textAppearance = "textAppearanceBodyLarge",
                },
                {
                    AppCompatTextView,
                    textSize = "14sp",
                    id = "summary",
                    layout_width = "match_parent",
                    textAppearance = "textAppearanceBodySmall",
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                layout_width = "match_parent",
                gravity = "center",
                focusable = true,
                {
                    AppCompatImageView,
                    id = "icon",
                    layout_margin = "16dp",
                    layout_width = "24dp",
                    layout_height = "24dp",
                    colorFilter = colorAccent
                },
                {
                    AppCompatTextView,
                    id = "title",
                    textSize = "16sp",
                    textColor = textColorPrimary,
                    layout_weight = 1,
                    layout_margin = "16dp"
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                gravity = "center|left",
                layout_width = "match_parent",
                focusable = true,
                {
                    LinearLayoutCompat,
                    orientation = "vertical",
                    gravity = "center|left",
                    layout_weight = 1,
                    layout_margin = "13dp",
                    {
                        AppCompatTextView,
                        textSize = "16sp",
                        textColor = textColorPrimary,
                        id = "title",
                        layout_width = "match_parent",
                        textAppearance = "textAppearanceBodyLarge",
                    },
                    {
                        AppCompatTextView,
                        textAppearance = "textAppearanceBodySmall",
                        layout_width = "match_parent",
                        textSize = "14sp",
                        id = "summary"
                    }
                },
                {
                    SwitchMaterial,
                    focusable = false,
                    clickable = false,
                    layout_marginRight = "16dp",
                    id = "status"
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                gravity = "center",
                layout_width = "match_parent",
                focusable = true,
                {
                    AppCompatImageView,
                    id = "icon",
                    layout_margin = "16dp",
                    layout_width = "24dp",
                    layout_height = "24dp",
                    colorFilter = colorAccent
                },
                {
                    AppCompatTextView,
                    id = "title",
                    textSize = "16sp",
                    layout_weight = 1,
                    layout_margin = "16dp",
                    textColor = textColorPrimary,
                    textAppearance = "textAppearanceBodyLarge",
                },
                {
                    SwitchMaterial,
                    id = "status",
                    focusable = false,
                    clickable = false,
                    layout_marginRight = "16dp"
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                layout_width = "match_parent",
                gravity = "center",
                focusable = true,
                {
                    LinearLayoutCompat,
                    orientation = "vertical",
                    gravity = "center",
                    layout_weight = 1,
                    layout_margin = "13dp",
                    {
                        AppCompatTextView,
                        id = "title",
                        textSize = "16sp",
                        layout_width = "match_parent",
                        textColor = textColorPrimary,
                        textAppearance = "textAppearanceBodyLarge",
                    },
                    {
                        AppCompatTextView,
                        textSize = "14sp",
                        id = "summary",
                        layout_width = "match_parent",
                        textAppearance = "textAppearanceBodySmall",
                    },
                    {
                        Slider,
                        id = "slider",
                        layout_height = "wrap_content",
                        layout_width = "match_parent",
                        layout_marginEnd = "12dp",
                        paddingTop = "6dp",
                        paddingBottom = "6dp",
                        valueFrom = "0",
                        valueTo = "7",
                        stepSize = "1"
                    }
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                layout_width = "match_parent",
                gravity = "center",
                focusable = true,
                {
                    MaterialCardView,
                    layout_height = "40dp",
                    layout_width = "40dp",
                    layout_margin = "16dp",
                    radius = "20dp",
                    {
                        CardView,
                        layout_height = "match_parent",
                        layout_width = "match_parent",
                        radius = "18dp",
                        {
                            AppCompatImageView,
                            layout_height = "match_parent",
                            layout_width = "match_parent",
                            id = "icon"
                        }
                    }
                },
                {
                    AppCompatTextView,
                    id = "title",
                    textSize = "16sp",
                    layout_weight = 1,
                    textColor = textColorPrimary,
                    layout_margin = "16dp",
                    layout_marginLeft = 0,
                    textAppearance = "textAppearanceBodyLarge",
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                gravity = "center",
                layout_width = "match_parent",
                focusable = false,
                {
                    AppCompatTextView,
                    layout_weight = 1,
                    textAppearance = "textAppearanceBodySmall",            
                    layout_marginLeft = "72dp",
                    layout_margin = "16dp",
                    layout_width = "match_parent",
                    textSize = "14sp",
                    id = "summary"
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        layout_width = "match_parent",
        focusable = true,
        {
            MaterialCardView,
            id = "card",
            clickable = true,
            layout_marginLeft = "13dp",
            layout_marginRight = "13dp",
            layout_width = "match_parent",
            cardBackgroundColor = colorScrim,
            {
                LinearLayoutCompat,
                gravity = "center|left",
                layout_width = "match_parent",
                focusable = false,
                {
                    LinearLayoutCompat,
                    orientation = "vertical",
                    gravity = "center|left",
                    layout_weight = 1,
                    layout_margin = "15dp",
                    {
                        AppCompatTextView,
                        textSize = "16sp",
                        textColor = textColorPrimary,
                        id = "title",
                        textAppearance = "textAppearanceBodyLarge",
                        layout_width = "match_parent",
                    },
                    {
                        AppCompatTextView,
                        layout_width = "match_parent",
                        layout_height = "wrap_content",
                        textSize = "14sp",
                        id = "summary",
                        textAppearance = "textAppearanceBodySmall",
                    }
                },
                {
                    MaterialCardView,
                    layout_marginRight = "17dp",
                    layout_height = "30dp",
                    layout_width = "30dp",
                    cardBackgroundColor = theme.color.colorPrimary,
                    elevation = "0dp",
                    radius = "600dp"
                }
            }
        }
    },
    {
        LinearLayoutCompat,
        id = "card",
        layout_width = "match_parent",
        {
            LinearLayoutCompat,
            layout_marginLeft = "26dp",
            layout_marginRight = "26dp",
            layout_width = "match_parent",
            layout_height = "1.3dp",
            backgroundColor = dividerColor
        }
    },
    pref_header,
    {
        LinearLayoutCompat,
        id = "card",
        gravity = "center",
        layout_height = "80dp",
        layout_width = "match_parent",
        focusable = false
    }
}

PrefSettingsLayUtil.itemsLay = itemsLay

function PrefSettingsLayUtil.adapter(data, onItemClick)
    return LuaRecyclerAdapter(
        LuaRecyclerAdapter.AdapterCreator({
                getItemCount = function()
                    return #data
                end,
                getItemViewType = function(position)
                    return data[position + 1][1]
                end,
                onCreateViewHolder = function(parent, viewType)
                    local ids = {}
                    local view = loadlayout(itemsLay[viewType], ids)
                    local holder = LuaRecyclerHolder(view)
                    holder.itemView.setTag(ids)
                    if viewType ~= 1 then
                        holder.itemView.setFocusable(true)
                        ids.card.onClick = function(view)
                            local data = ids._data
                            local key = data.key
                            if not (onItemClick and onItemClick(view, ids, key, data)) then
                                local statusView = ids.status
                                if statusView then
                                    local checked = not (statusView.checked)
                                    statusView.setChecked(checked)
                                    if data.checked ~= nil then
                                        data.checked = checked
                                    elseif data.key then
                                        activity.setSharedData(data.key, checked)
                                    end
                                end
                            end
                        end
                    end
                    return holder
                end,
                onBindViewHolder = function(holder, position)
                    local data = data[position + 1]
                    local tag = holder.itemView.getTag()
                    tag._data = data
                    local title = data.title
                    local taxtAlCaps = data.taxtAlCaps
                    local icon = data.icon
                    local summary = data.summary
                    local statusView = tag.status
                    local rightIconView = tag.rightIcon
                    local iconView = tag.icon
                    local card = tag.card
                    local shapeable = data.shapeable

                    if title then
                        tag.title.text = title
                    end
                    if summary then
                        tag.summary.text = summary
                        tag.summary.textAppearance=uihelper.getAttr("textAppearanceBodySmall")
                    end
                    if icon then
                        if type(icon) == "number" then
                            iconView.setImageResource(icon)
                        end
                    end

                    if card.class == MaterialCardView then
                        if shapeable then
                            local radius = uihelper.dp2int(10)
                            local radiustop = 0
                            local radiusbottom = 0

                            if data.topcorner then
                                radiustop = radius
                            end
                            if data.bottomcorner then
                                radiusbottom = radius
                            end

                            card.setShapeAppearanceModel(
                                card.getShapeAppearanceModel().toBuilder()
                                   .setAllCornerSizes(0)
                                   .setTopRightCorner(radiustop,radiustop)
                                   .setTopLeftCorner(radiustop, radiustop)
                                   .setBottomRightCorner(radiusbottom, radiusbottom)
                                   .setBottomLeftCorner(radiusbottom, radiusbottom)
                                   .build()
                            )
                        else
                            card.setShapeAppearanceModel(
                                card.getShapeAppearanceModel()
                                    .toBuilder()
                                    .setAllCornerSizes(0)
                                    .build()
                            )
                        end
                    end
                    if statusView then
                        if data.checked ~= nil then
                            statusView.setChecked(data.checked)
                        elseif data.key then
                            statusView.setChecked(activity.getSharedData(data.key) or false)
                        else
                            statusView.setChecked(false)
                        end
                    end
                end
            }
        )
    )
end

return PrefSettingsLayUtil
