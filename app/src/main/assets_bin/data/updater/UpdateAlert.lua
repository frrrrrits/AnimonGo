local UpdateAlert={}
setmetatable(UpdateAlert,UpdateAlert)

import "android.content.Context"
import "android.app.NotificationManager"
import "android.app.NotificationChannel"
import "androidx.core.app.NotificationCompat"
import "androidx.core.app.NotificationManagerCompat"

local CHANNEL_ID = tostring("Updater_Library")

function UpdateAlert:createNotifiUpdate(context, title, text)
  local unique_id = math.random(1, 30)  

  local builder = NotificationCompat.Builder(context, CHANNEL_ID)
  builder.setSmallIcon(R.mipmap.ic_launcher_round)
  builder.setContentTitle(title)
  builder.setContentText(text)
  builder.setPriority(NotificationCompat.PRIORITY_DEFAULT)  

  local notifycationManager = NotificationManagerCompat.from(context)
  notifycationManager.notify(unique_id, builder.build())
end

function UpdateAlert:createNotificationChannel(context)
  if Build.VERSION.SDK_INT >= Build.VERSION_CODES.O then
    local name = tostring("Update Library")
    local description = tostring("Notification Test")

    local importance = NotificationManager.IMPORTANCE_DEFAULT
    local channel = NotificationChannel(CHANNEL_ID, name, importance)
    channel.setDescription(description)    

    local notifycationManager = context.getSystemService(Context.NOTIFICATION_SERVICE)
    notifycationManager.createNotificationChannel(channel)
  end
end

function UpdateAlert.__call(self)
  self=table.clone(self)
  return self
end

return UpdateAlert
