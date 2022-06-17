-- created by @lxs7499
import "android.view.View"

local EmptyView={}
local config={}

setmetatable(EmptyView,EmptyView)

config.layout={
  CoordinatorLayout,
  id="layout_container",
  layout_width="match_parent",
  layout_height="match_parent",
  visibility=View.GONE,
  {
    LinearLayout,
    id="layout_child",
    layout_width="match_parent",
    layout_height="match_parent",
    layout_marginBottom="90dp",
    orientation="vertical",
    gravity="center",
    padding="16dp",
    {
      TextView,
      id="text_face",
      textSize="48sp",
      gravity="center",
      layout_width="wrap_content",
      layout_height="wrap_content",
     -- textColor=theme.color.textColorSecondary,
    },
    {
      TextView,
      id="text_label",
      gravity="center",
      layout_margin="16dp",
      layout_width="wrap_content",
      layout_height="wrap_content",
      --textColor=theme.color.textColorSecondary,
    },
    {
      LinearLayout,
      id="actions_container",
      layout_width="match_parent",
      layout_height="wrap_content",
      gravity="center",
    }
  }
}

local errorFace={
  "(･o･;)",
  "Σ(ಠ_ಠ)",
  "ಥ_ಥ",
  "(˘･_･˘)",
  "(；￣Д￣)",
  "(･Д･。",
  "ԅ(¯ㅂ¯ԅ)",
  "(｡•ˇ‸ˇ•｡)"
}

function getRandomFace()
  return tostring(errorFace[math.random(#errorFace)])
end

function EmptyView:intoView(view)  
  local ids={}
  loadlayout(config.layout,ids)

  self.text_face=ids.text_face
  self.text_label=ids.text_label
  self.layout_child=ids.layout_child
  self.actions_container=ids.actions_container
  self.layout_container=ids.layout_container

  view.addView(ids.layout_container)
  ids.text_face.text=getRandomFace()
  return self
end

function EmptyView:addActions(label,icon,call)
  local buttonContext = ContextThemeWrapper(this, R.style.Widget_Button_ActionButton)
  local actionsButton = MaterialButton(buttonContext,nil)
     actionsButton.layoutParams=LinearLayout.LayoutParams(
     0,LinearLayout.LayoutParams.WRAP_CONTENT,1
  )
  actionsButton.text=label
  actionsButton.iconResource=icon or R.drawable.ic_refresh_24dp
  actionsButton.onClick=call or function() end
  self.actions_container.addView(actionsButton)
  return self
end

function EmptyView:label(text)
  self.text_label.text=text
  return self
end

function EmptyView:hide()
  self.layout_container.visibility=View.GONE
  return self
end

function EmptyView:show()
  self.layout_container.visibility=View.VISIBLE
  return self
end

function EmptyView.__call()
  self=table.clone(EmptyView)
  return self
end

return EmptyView