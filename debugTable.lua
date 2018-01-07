indent = ""

function displayTable(t)
  local n=0
  local keyset={}
  for k,v in pairs(t) do

    if type(v) == 'table' then
      print(indent .. k .. ": {")
      indent = indent .. "    "
      displayTable(v)
      indent = string.sub(indent, 0, string.len(indent) - 4)
      print(indent .. '}')
    else
      print(indent .. k, v)
    end
  end
end