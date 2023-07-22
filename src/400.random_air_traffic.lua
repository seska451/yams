--[[ random_air_traffic:header
Generates random air traffic (RAT) based on a template group. Yams will spawn no more than the desired number of groups.
It will schedule a check every 60 seconds to ensure there is enough aircraft in the sky.

For best results, set the template group to **late activation** to supress it from being spawned on startup. This saves a bit of CPU processing for you.

!!! info Abstraction ahead
    This function is a convenience over the generator:spawn function it is basically an opinionated wrapper. If you want more control, check out the `generator` module.


!!! example Starting a RAT
    ```lua
    local rat = yams.random_air_traffic
    local positions = {

    }
    rat                             -- configure the RAT
        :using_group("RAAF F18C")   -- tell it the name of the group to use for the traffic
        :no_more_than(10)           -- configure the maximum number of groups in the air
        :start_from_air(4500)        -- (Optional) tell the RAT to start planes at a specific altitude
        :init()
    ```
--]]
local random_air_traffic = {
    template = nil,
    max_groups = 0,
    start_air = true,
    positions = nil,
    name = "",
    roe = enums.rules_of_engagement.WEAPON_HOLD,
    rtt = enums.reaction_to_threat.BYPASS_AND_ESCAPE
}
random_air_traffic.__index = random_air_traffic
function random_air_traffic.new()
    return setmetatable({}, random_air_traffic)
end
function random_air_traffic:validate()
    if self.template == nil then
        log:error("template should not be nil")
        return false
    end
    if self.positions == nil then
        log:error("positions should not be nil")
        return false
    end
    return true
end
--[[ random_air_traffic:with_rules_of_engagement
By default, air traffic will have zero aggression and will land at the first sign of trouble.
It's primary use case is for modelling civilian air traffic.

This behaviour may be adjusted with this function to observe different `rules_of_engagement` & `reaction_to_threat`.
This applies to every aircraft. If you wish to use the behaviour set in the aircraft template, use
`yams.enums.rules_of_engagement.inherit`.

!!! example
    ```lua
    local rat = yams.random_air_traffic
    local weapons_free = yams.enums.rules_of_engagement.WEAPONS_FREE
    local evade_fire = yams.enums.reaction_to_threat.EVADE_FIRE
    rat
        :with_name("Iranian Combat Air Patrol")
        :using_group("IRANAF-CAP")
        :no_more_than(5)
        :start_in_air(4500)
        :with_rules_of_engagement(weapons_free)
        :with_reaction_to_threat(evade_fire)
        :init()
    ```
--]]
function random_air_traffic:with_rules_of_engagement(roe)
    self.roe = roe or enums.rules_of_engagement.WEAPON_HOLD
    return self
end

--[[ random_air_traffic:with_reaction_to_threat
!!! example
    ```lua
    yams.random_air_traffic:with_reaction_to_threat(rtt)

    ```
--]]
function random_air_traffic:with_reaction_to_threat(rtt)
    self.rtt = rtt or enums.reaction_to_threat.BYPASS_AND_ESCAPE
    return self
end
--[[ random_air_traffic:with_name
Gives this random air traffic a name to identify it by, which is displayed in logs
--]]
function random_air_traffic:with_name(name)
    self.name = name
    return self
end

--[[ random_air_traffic:using_template
Use a `group_name` to find a late activated template group for use in random air traffic generation
--]]
function random_air_traffic:using_template(group_name)
    self.template = group_name
    return self
end

--[[ random_air_traffic:no_more_than
Set the maximum number of aircraft spawned for random air traffic
--]]
function random_air_traffic:no_more_than(max)
    self.max_groups = max
    return self
end

--[[ random_air_traffic:from_pool_of
!!! example
    ```lua
    yams.random_air_traffic:from_pool_of(count)

    ```
--]]
function random_air_traffic:from_pool_of(count)
    self.pool_size = count
    return self
end

--[[ random_air_traffic:start_in_air
Tells all traffic to be spawned in the air at a given altitude
--]]
function random_air_traffic:start_in_air(altitude)
    self.start_air = true
    self.start_altitude = altitude
    return self
end

--[[ random_air_traffic:get_airbase_positions_for
!!! example
    ```lua
    yams.random_air_traffic:get_airbase_positions_for(coalition)

    ```
--]]
function get_airbase_positions_for(coa)
    local coordinates = {}
    for _, airbase_data in pairs(coalition.getAirbases(coa)) do
        local pos = Airbase.getPosition(airbase_data).p

        -- Store the airbase name and position in the airbases table
        table.insert(coordinates, pos)
    end
    log:debug("Found " .. #coordinates .. " airbases for coalition: " .. coa)
    return coordinates
end

--[[ random_air_traffic:start
Final call in the random_air_traffic fluent API. Use this to start random air traffic using the parameters set by previous calls.
--]]
function random_air_traffic:start()
    if self.name ~= nil then
        log:debug("Creating random air traffic for " .. self.name)
    else
        log:debug("Creating random air traffic with " .. Group.getName(self.template))
    end

    g = group:find(self.template)
    if g == nil then
        log:error(self.template .. " group not found.")
        return
    end
    local coalition = Group.getCoalition(g)
    coordinates = get_airbase_positions_for(coalition)
    local pool_size = 1000
    generator.new()
    :using_template(self.template)              -- sets the template
    :from_pool_of(pool_size):groups()                  -- sets the original count of groups available
    :generate(self.max_groups):groups()                       -- sets how many groups to spawn at once
    :every(20):seconds()                        -- sets the generation interval
    :until_there_are(self.max_groups):groups()  -- sets the maximum number of active groups
    :at_random_locations(coordinates)           -- sets the locations in which these groups could appear
    :at_altitude(self.start_altitude)           -- sets the altitude at which these groups appear
    :with_rules_of_engagement(self.roe)         -- sets the ROE for the groups
    :with_reaction_to_threat(self.rtt)          -- sets the RTT for the groups
    :spawn_over_time()                                    -- kicks it all off

    log:debug("RAT Started")
end
return random_air_traffic