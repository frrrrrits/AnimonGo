return function(data, ids)
  return LuaFragmentPageAdapter(activity.getSupportFragmentManager(),
  LuaFragmentPageAdapter.AdapterCreator{
    getCount=function()
      return #data.fragments
    end,
    getItem=function(position)
      position=position + 1     
      return data.fragments[position]
    end,
    getPageTitle=function(position)
      position=position + 1      
      return data.titles[position]
    end
  })
end