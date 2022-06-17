local BottomAnimation={}
setmetatable(BottomAnimation,BottomAnimation)

import "android.animation.Animator"
import "android.animation.ObjectAnimator"
import "androidx.interpolator.view.animation.LinearOutSlowInInterpolator"

local animator = nil
local duration = 300

local function translationObjectY(targetView,startY,endY,duration,fun)
 return ObjectAnimator.ofFloat(targetView, "translationY", {startY, endY})
  .setDuration(duration)
  .setInterpolator(LinearOutSlowInInterpolator())
  .start()
  .addListener(Animator.AnimatorListener({onAnimationEnd=fun}))
end

function BottomAnimation.slideDown(id)
  local nav_view = id
  local value = nav_view.height + uihelper.dp2int(20)
  if animator == nil and nav_view.translationY == 0 then
    animator = translationObjectY(nav_view, 0, value, duration, function()
      animator = nil
    end)
  end
end

function BottomAnimation.slideUp(id)
  local nav_view = id
  local value = nav_view.height + uihelper.dp2int(20)
  if animator == nil and nav_view.translationY == value then
    animator = translationObjectY(nav_view, value, 0, duration, function()
      animator = nil
    end)
  end
end

function BottomAnimation.onScrollHide(ids,id,lifted)
  Handler().postDelayed(Runnable({
    run=function()
      ids.recycler.addOnScrollListener(RecyclerView.OnScrollListener{
        onScrolled = function(view, dx, dy)
          if (dy > 0) then
            BottomAnimation.slideDown(id) else
            BottomAnimation.slideUp(id)
          end
          if lifted then
            Themes.setColorLifted(view, ids)
          end
        end
      })
    end
  }),20)
end

function BottomAnimation.__call(self)
  self=table.clone(self)
  return self
end

return BottomAnimation