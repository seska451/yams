local log = require('log')
--[[ group:header

All helper functions to do with group management

--]]
local group = {}

--[[ group:find
Find a group by its name.

!!! example
    ```lua
    local group = yams.group:find("RAAF-FA18C")
    ```
--]]
function group:find(group_name)
    return Group.getByName(group_name)
end

--[[ group:get_country
Gets the country ID for a given group, based on the first unit in the group.
--]]
function group:get_country(grp)
    local c_id
    for _, data in pairs(grp:getUnits()) do
        c_id = Unit.getCountry(data)
    end
    if c_id == nil then
        log:error("No units in group " ..grp:getName().. " yielded a country ID!")
    end
    return c_id
end
return group