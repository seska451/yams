--[[ zone:header

Use the `zone` module to find, create and manage zone.
--]]
local zone = { name = nil, zone_type = nil }
zone.__index = zone
--[[ zone:new
!!! example
    ```lua
    yams.zone:()
    ```
--]]
function zone.new()
    return setmetatable({}, zone)
end
--[[ zone:validate
!!! example
    ```lua
    yams.zone:validate()

    ```
--]]
function zone:validate()
    if self.name == "" or self.name == nil then
        log:error("name should not be nil")
        return false
    end
    if self.zone_type == nil then
        log:error("zone_type should not be nil")
        return false
    end
    return true
end
--[[ zone:set_name
!!! example
    ```lua
    yams.zone:set_name(name)

    ```
--]]
function zone:set_name(name)
    self.name = name
    return self
end
--[[ zone:set_zone_type
!!! example
    ```lua
    yams.zone:set_zone_type(zone_type)

    ```
--]]
function zone:set_zone_type(zone_type)
    self.zone_type = zone_type
    return self
end

--[[ zone:find
!!! example
    ```lua
    yams.zone:find(name)

    ```
--]]
function zone:find(name)
    return trigger.misc.getZone(name)
end

return zone