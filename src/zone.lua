--[[ zone:header
--]]
local zone = { }

--[[ zone:find
--]]
function zone:find(name)
    return trigger.misc.getZone(name)
end

return zone