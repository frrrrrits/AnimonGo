local MaterialButton=luajava.bindClass "com.google.android.material.button.MaterialButton"
local widgets={
  MaterialButton={"TextButton","OutlinedButton","ButtonIcon", "Borderless", "ButtonTonal"},
}
local types={}
for mainWidget,content in pairs(widgets) do
  for index,content in ipairs(content) do
    local widgetName=mainWidget..content
    table.insert(types,widgetName)
    local myWidget={
      _baseClass=_ENV[mainWidget],
      __call=function(self,context)
        local iInflater=LayoutInflater.from(context)
        return iInflater.inflate(R.layout["layout_materialbutton_"..string.lower(content)],nil)
      end,
    }
    setmetatable(myWidget,myWidget)
    _G[widgetName]=myWidget
  end
end


return {types=types,widgets=widgets}