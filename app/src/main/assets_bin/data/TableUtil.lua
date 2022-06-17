local _M = {}

function _M.length(t)
  local count = 0
  for _ in pairs(t) do
    count = count + 1
  end
  return count
end

function _M.first(t)
  if _M.length(t) > 0 then
    for k,v in pairs(t) do
      return v
    end
   else
    return nil,nil
  end
end

function _M.copy(f, t)  
  local new_tbl = t or {}
  for k,v in pairs(f) do
    new_tbl[k] = v
  end
  return new_tbl
end

function _M.clear(tbl)
  for k,v in ipairs(tbl) do
    tbl[k] = nil
  end
end

function _M.sort_asc(t, v)
  local new_tbl = _M.copy(t)
  table.sort(new_tbl, function(a, b) 
    return a[v] < b[v] end)
  return new_tbl
end

function _M.sort_desc(t, v)
  local new_tbl = _M.copy(t)
  table.sort(new_tbl, function(a, b) 
    return a[v] > b[v] end)
  return new_tbl
end


return _M