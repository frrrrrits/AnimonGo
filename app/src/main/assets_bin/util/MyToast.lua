local MyToast={}
setmetatable(MyToast,MyToast)

local context=activity or service

function MyToast.showToast(text)
  local toast=Toast.makeText(context,text,Toast.LENGTH_SHORT)
  .show()
  return toast
end

function MyToast.showSnackBar(text)
  local snackBar=Snackbar.make(window.decorView, text, Snackbar.LENGTH_SHORT)
  .show()
  return snackBar
end

function MyToast.snackActions(text, msg, func, id)
  local snackBar=Snackbar.make(window.decorView, text, Snackbar.LENGTH_INDEFINITE)
  .setAction(msg,func)
  .show()
  return snackBar
end

function MyToast.autoShowToast(text,view)
  local view=view or window.decorView
  local toast
  if view then
    toast=MyToast.showSnackBar(text,view)
   else
    toast=MyToast.showToast(text)
  end
  return toast
end

function MyToast.copyText(text,view)
  _G.copyText(text)
  return MyToast.autoShowToast("Copied",view)
end

function MyToast.pcallToToast(successStr,failedStr,succeed)
  local text
  if succeed then
    text=successStr
   else
    text=failedStr
  end
  return MyToast.showToast(text)
end

function MyToast.pcallToSnackbar(view,succeedStr,failedStr,succeed)
  local text
  if succeed then
    text=succeedStr
   else
    text=failedStr
  end
  return MyToast.showSnackBar(view,text)
end

function MyToast.showErrorDialog(msg)
  return MaterialAlertDialogBuilder(this)
  .setTitle("Error")
  .setMessage(msg or "Terjadi kesalahan, Coba lagi.")
  .setPositiveButton("Tutup", function()
    finishActivity()
  end)
  .create()
  .show()
end

function MyToast.__call(self,text,view)
  return MyToast.autoShowToast(text,view)
end

return MyToast