local utils = require('utils')
--[[ combat_air_patrol:header
# Combat Air Patrol (CAP)

The `combat_air_patrol` fluent interface is designed to make building CAPs easy. It checks the state of the CAP every 20
seconds for you and will keep topping up the groups that are active in the world up to any limit that you set. Stops once
it has run out of groups to dispatch. Only works against air units. It will even check the fuel state of the groups and
tell them to refuel if required.

This module makes plenty of assumptions in order to achieve this ease of use.

!!! info
    If you want finer control, then you should look at the [`generator`](../generator) module instead.

!!! example
    ```lua
    yams.combat_air_patrol
        :new()                                      -- You must initialize this type
        :with_name("Iranian Combat Air Patrol")     -- Optionally name this CAP squadron
        :for_squadron_size(20)                      -- Set a size for the squadron, this is the number of groups
        :using_template("IRANAF-MIG29")             -- Use this template for generating groups, this dictates the # of planes per group
        :with_tanker_group("IRANAF-TANKER")         -- Use this to designate a tanker for refuelling
        :with_home_base("Ras Al Khaimah Intl")      -- Sets the home airbase
        :zone_to_defend("red-patrol-zone")          -- Sets the CAP patrol area to defend from threats
        :no_more_than(2)                            -- Limit the number of groups that can be active at any given point in time
        :start_in_air(6000)                         -- Set the cruising altitude for this CAP (all units are in metres)
        :start()                                    -- Send them on their way.
    ```
--]]
local combat_air_patrol = {}

function combat_air_patrol:new()
    self.template = nil
    self.max_groups = 0
    self.start_air = true
    self.name = ""
    self.roe = enums.rules_of_engagement.WEAPON_FREE
    self.rtt = enums.reaction_to_threat.EVADE_FIRE
    self.start_location = nil
    self.patrol_area = nil
    self.tanker_group = nil
    self.squadron_size = 0
    return self
end

--[[ combat_air_patrol:using_template
!!! example
    ```lua
    ```
--]]
function combat_air_patrol:using_template(grp)
    self.template = grp
    return self
end

--[[ combat_air_patrol:with_name
!!! example
    ```lua
    ```
--]]
function combat_air_patrol:with_name(name)
    self.name = name
    return self
end

--[[ combat_air_patrol:no_more_than
!!! example
    ```lua
    yams.combat_air_patrol:no_more_than(count)
    ```
--]]
function combat_air_patrol:no_more_than(count)
    self.max_groups = count
    return self
end

--[[ combat_air_patrol:start_in_air
!!! example
    ```lua
    yams.combat_air_patrol:start_in_air(altitude)

    ```
--]]
function combat_air_patrol:start_in_air(altitude)
    self.start_air = true
    self.start_altitude = altitude
    return self
end

--[[ combat_air_patrol:for_squadron_size
!!! example
    ```lua
    yams.combat_air_patrol:for_squadron_size(count)

    ```
--]]
function combat_air_patrol:for_squadron_size(count)
    self.squadron_size = count
    return self
end

--[[ combat_air_patrol:with_home_base
!!! example
    ```lua
    yams.combat_air_patrol:with_home_base(airbase_name)

    ```
--]]
function combat_air_patrol:with_home_base(airbase_name)
    local ab = Airbase.getByName(airbase_name)
    self.start_location = Airbase.getPosition(ab)

    -- todo: this fails because ab is nil.
    log:debug("home base at:" .. utils.serialize(self.start_location, 2))
    return self
end

--[[ combat_air_patrol:with_tanker_group
!!! example
    ```lua
    yams.combat_air_patrol:with_tanker_group(grp)

    ```
--]]
function combat_air_patrol:with_tanker_group(grp)
    self.tanker_group = grp
    return self
end

--[[ combat_air_patrol:zone_to_defend
!!! example
    ```lua
    yams.combat_air_patrol:zone_to_defend(zone)

    ```
--]]
function combat_air_patrol:zone_to_defend(zone)
    self.patrol_area = zone
    return self
end

--[[ combat_air_patrol:start
Starts the CAP with the settings you've provided earlier
!!! example
    ```lua
    local cap = yams.combat_air_patrol
    cap
        :new()
        :with_name("Iranian Combat Air Patrol")
        :for_squadron_size(20)
        :using_template("IRANAF-MIG29")
        :with_tanker_group("IRANAF-TANKER")
        :with_home_base("Ras Al Khaimah Intl")
        :zone_to_defend("red-patrol-zone")
        :no_more_than(2) -- groups
        :start_in_air(6000) -- metres
        :start()
    ```
--]]
function combat_air_patrol:start()
    if self.name ~= nil then
        log:debug("Creating combat air patrol for " .. self.name)
    else
        log:debug("Creating combat air patrol with " .. Groups.getName(self.template))
    end

    g = group:find(self.template)
    if g == nil then
        log:error(self.template .. " group not found.")
        return
    end
    generator
            :new()
            :using_template(self.template)              -- sets the template
            :from_pool_of(self.squadron_size):groups()                  -- sets the original count of groups available
            :generate(self.max_groups):groups()                       -- sets how many groups to spawn at once
            :every(20):seconds()                        -- sets the generation interval
            :until_there_are(self.max_groups):groups()  -- sets the maximum number of active groups
            :with_starting_position(self.start_location)   -- sets the location from which these groups must appear
            :defending_zone(zone:find(self.patrol_area))           -- sets the area to perform CAP operations
            :refuelling_at(self.tanker_group)           -- tells the group which tanker to go an refuel with
            :at_altitude(self.start_altitude)           -- sets the altitude at which these groups appear
            :with_rules_of_engagement(self.roe)         -- sets the ROE for the groups
            :with_reaction_to_threat(self.rtt)          -- sets the RTT for the groups
            :spawn()                                    -- kicks it all off


    log:debug("CAP Started")
end
return combat_air_patrol