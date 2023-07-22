local utils = require('utils')
--[[ generator:header
# Generator
The generator module allows you to dynamically generate units, groups & static objects on the fly.

!!! example
    The following example is lifted directly from the random_air_traffic module, because it uses `generator` under the hood.
    ```lua
    generator
            :new()
            :using_template(template)              -- sets the template
            :from_pool_of(pool_size):groups()      -- sets the original count of groups available
            :generate(max_groups):groups()         -- sets how many groups to spawn at once
            :every(20):seconds()                   -- sets the generation interval
            :until_there_are(max_groups):groups()  -- sets the maximum number of active groups
            :at_random_locations(coordinates)      -- sets the locations in which these groups could appear
            :at_altitude(start_altitude)           -- sets the altitude at which these groups appear
            :with_rules_of_engagement(roe)         -- sets the ROE for the groups
            :with_reaction_to_threat(rtt)          -- sets the RTT for the groups
            :spawn()                               -- kicks it all off
    ```
--]]
local generator = {
    utils = {}
}

--[[ generator:new

Initializes the generator.

!!! warning
    You need to do this before each call to start in order for this module to work correctly.
--]]
function generator:new()
    self.group = { }
    self.groups_per_generation = 0
    self.max = 10
    self.count = -1
    self.starting_position = { }
    self.locations = { }
    self.roe = enums.rules_of_engagement.WEAPON_HOLD
    self.rtt = enums.reaction_to_threat.NO_REACTION
    self.interval = nil
    self.generation_primitive = "groups"
    self.pool_size = 0
    self.spawned_groups = { }
    return self
end

--[[ generator:from_pool_of
!!! example
    ```lua
    yams.generator:from_pool_of(count)

    ```
--]]
function generator:from_pool_of(count)
    self.pool_size = count
    return self
end


--[[ generator:deep_clone

You won't typically need this however I've left this public just in case. Use this to create a deep, recursive clone of any table.
Useful for spawning units and groups based on templates. Typically used by other generator functions.deep_clone

!!! warning Take care cloning groups and units yourself
    This function will not do the job of renaming the cloned groups so be careful when adding the group or unit to a coalition.deep_clone
    There is the generator:get_next_unit_name and generator:get_next_group_name to assist with this.

!!! example
    ```lua
    local group = group:find("My group")
    local clone = generator:deep_clone(group, nil)
    ```
--]]
function generator:deep_clone(object, lookup_table)
  lookup_table = lookup_table or {}

  if type(object) ~= "table" then
    return object
  elseif lookup_table[object] then
    return lookup_table[object]
  end

  local new_table = {}

  lookup_table[object] = new_table

  for index, value in pairs(object) do
    new_table[generator:deep_clone(index, lookup_table)] = generator:deep_clone(value, lookup_table)
  end

  return setmetatable(new_table, getmetatable(object))
end

--[[ generator:groups
!!! example
    ```lua
    yams.generator:groups()
    ```
--]]
function generator:groups()
    self.generation_primitive = "groups"
    return self
end

--[[ generator:generate
Generate `count` groups everytime `interval` elapses.
--]]
function generator:generate(count)
    self.groups_per_generation = count
    return self
end

--[[ generator:every
Set the generation interval. When this elapses a series of checks are performed. If they pass, another generation of groups
are spawned into the world.
!!! example
    ```lua
    yams.generator:every(interval_in_seconds)
    ```
--]]
function generator:every(interval_in_seconds)
    self.interval = interval_in_seconds
    return self
end

--[[ generator:minutes
!!! example
    ```lua
    yams.generator:minutes()
    ```
--]]
function generator:minutes()
    self.interval = self.interval * 60
    return self
end

--[[ generator:seconds
!!! example
    ```lua
    yams.generator:seconds()

    ```
--]]
function generator:seconds()
    return self
end

--[[ generator:with_rules_of_engagement
!!! example
    ```lua
    yams.generator:with_rules_of_engagement(roe)

    ```
--]]
function generator:with_rules_of_engagement(roe)
    self.roe = roe
    return self
end

--[[ generator:with_reaction_to_threat
!!! example
    ```lua
    yams.generator:with_reaction_to_threat(rtt)

    ```
--]]
function generator:with_reaction_to_threat(rtt)
    self.rtt = rtt
    return self
end

--[[ generator:using_group
Set the group name you wish to target for generation.
--]]
function generator:using_template(group_name)
    self.group = group_name
    return self
end

--[[ generator:at_random_locations
Provide a table of coordinates to randomly choose when spawning units
--]]
function generator:at_random_locations(coordinates)
    self.locations = coordinates
    return self
end

--[[ generator:no_more_than
Limit the generation to have no more than `max` units
--]]
function generator:until_there_are(max)
    self.max = max
    return self
end

--[[ generator:exactly
Limit the generation to have exactly `count` units
--]]
function generator:exactly(count)
    self.count = count
    return self
end


--[[ generator:get_next_group_name
Given a group name `baseName` as a template, find the next group name
--]]
function generator:get_next_group_name(baseName)
  local count = 1
  local newName = baseName

  while group:find(newName) do
    count = count + 1
    newName = baseName .. "-" .. count
  end

  return newName
end

local function get_guid()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function get_short_guid()
    return string.upper(string.sub(get_guid(), 1, 6))
end

--[[ generator:get_next_unit_name
Given a unit name `baseName` as a template, find the next unit name
--]]
function generator:get_next_unit_name(baseName)
    return baseName .. "-" .. get_short_guid()
end

--[[ generator:with_starting_location
Set the starting position of generated spawns. Defaults to in air.
--]]
function generator:with_starting_position(pos)
    self.starting_position = pos
    return self
end

--[[ generator:at_altitude
!!! example
    ```lua
    yams.generator:at_altitude(altitude)

    ```
--]]
function generator:at_altitude(altitude)
    self.start_altitude = altitude
    return self
end

function generator:copy_group_data(source_group, position)
    local group_name = source_group:getName()
    local pos_str = "x: " .. position.x .. ", y: " .. position.y .. ", z: " .. position.z
    log:debug("copying " .. group_name .. " to position " .. pos_str)
    local copied_data = {
        name = generator:get_next_group_name(source_group:getName()),
        visible = true,
        taskSelected = source_group.taskSelected,
        route = source_group.route,
        tasks = source_group.tasks,
        hidden = false,
        units = source_group.units,
        x = source_group.x,
        y = source_group.y,
        alt = source_group.alt,
        alt_type = source_group.alt_type,
        speed = source_group.speed,
        payload = source_group.payload,
        start_time = source_group.start_time,
        task = source_group.task,
        livery_id = source_group.livery_id,
        onboard_num = source_group.onboard_num,
        uncontrolled = true
    }

    local units = {}
    -- Check for duplicate unit names within the cloned group
    for _, unit_data in pairs(source_group:getUnits()) do
        local unit_data_copy = {}
        local originalUnitName = Unit.getName(unit_data)
        local newUnitName = generator:get_next_unit_name(originalUnitName)
        unit_data_copy.name = newUnitName
        unit_data_copy.type = Unit.getTypeName(unit_data)
        unit_data_copy.x = position.x
        unit_data_copy.y = position.y
        unit_data_copy.alt = position.z

        table.insert(units, unit_data_copy)
    end
    copied_data.units = units

    return copied_data
end
--[[ generator:clone_group
Clones a template group `template_group_name` to a new group name (format: `template_group_name-N`) and new position.
--]]
function generator:clone_group(template_group_name, position)
    local cloned_group
    local templateGroup = group:find(template_group_name)
    local country_id = group:get_country(templateGroup)
    if templateGroup ~= nil then
        log:debug("Cloning group:" .. template_group_name)
        local cloned_group_data = generator:copy_group_data(templateGroup, position)
        coalition.addGroup(country_id, templateGroup:getCategory(), cloned_group_data)
        cloned_group = group:find(cloned_group_data.name)
        if cloned_group == nil then
            log:error("Added group not found:" .. cloned_group_data.name)
            return nil
        end
    else
        log:error("Template group not found:" .. template_group_name)
    end
    local group_controller = cloned_group:getController()
    group_controller:setOption(enums.reaction_to_threat.get_id(), self.rtt)
    group_controller:setOption(enums.rules_of_engagement.get_id(), self.roe)
    return cloned_group
end

function get_next_random(from_list)
    local randomIndex = math.random(1, #from_list)
    log:debug("RNGesus rolled a " .. randomIndex .. " on a " .. #from_list .. " sided dice.")
    return from_list[randomIndex]
end

function send_group_to_refuel_with(tanker_group, grp)
     local receiver_units = grp:getUnits()

    -- Create the refueling task
    local task = {
        id = "Refueling",
        params = {
            tanker = tanker_group:getUnit(1):getID(),
            speed = 400, -- Replace with the desired refueling speed
        },
    }

    for _, unit in pairs(receiver_units) do
        -- Set the refueling task for the receiving group's first unit
        Unit.getController(unit):setTask(task)
    end
end

function get_cap_task_for_zone(grp, zone)
    local firstUnit = grp:getUnit(1)
    return {
                id = "EngageTargets",
                params = {
                    route = {
                        points = {
                            [1] = {
                                action = "From Waypoint",
                                x = firstUnit:getPosition().p.x,
                                y = firstUnit:getPosition().p.z,
                                speed = 200, -- Replace with the desired speed
                                ETA = 0,
                                ETA_locked = false,
                                name = "WP1",
                                task = {
                                    id = "EngageTargets",
                                    params = {
                                        targetTypes = {
                                            [1] = "Air",
                                            [2] = "Ground"
                                        },
                                        targetPosition = {
                                            zone.point,
                                        },
                                    }
                                }
                            },
                        },
                    },
                },
            }
end

function create_new_groups(self)



    for i = 1, self.max do
        log:debug("Spawn #"..i)
        local location
        if #self.locations > 0 then
            location = get_next_random(self.locations)
        else
             location = self.starting_position
        end

        if self.start_altitude > 0 then
            location.z = self.start_altitude
        end

        local g = generator:clone_group(self.group, location)

        if self.patrol_area ~= nil then
            local zone = self.patrol_area
            local cap = get_cap_task_for_zone(g, zone)
            g:getController():setTask(cap)
        end

        table.insert(self.spawned_groups, g)
    end
end

--[[ generator:defending_zone
!!! example
    ```lua
    yams.generator:defending_zone(zone)

    ```
--]]
function generator:defending_zone(patrol_area)
    self.patrol_area = patrol_area
    return self
end

--[[ generator:refuelling_at
!!! example
    ```lua
    yams.generator:refuelling_at(tanker_group)

    ```
--]]
function generator:refuelling_at(tanker_group)
    self.tanker_group = tanker_group
    return self
end

--[[ generator:spawn
This is the final command of the Fluent generator API. Starts spawning given the parameters set by other functions.position

You might use this with the `using_group`, `at_random_locations`, `no_less_than` and `no_more_than` functions.
!!! example
    ```lua
    local my_gen = yams.generator
    my_gen
        :using_group("My late activated group template")
        :at_random_locations({ coord1, coord2, coord3 })
        :no_more_than(10)
        :no_less_than(1)
        :spawn()
    ```
--]]
function generator:spawn()
    log:debug("Initializing spawn with settings:\n" ..utils:serialize(self, 2))
    create_new_groups(self)
    if self.groups_per_generation > 0 then
        timer.scheduleFunction(schedule_spawning, self, timer.getTime() + self.interval)
        return
    end
end

function check_fuel_state(groups, tanker_group)
    local low_fuel = 0.2
    local groups_to_refuel = {}
    for _, grp in pairs(groups) do
        if Group.isExist(grp) then
            for _, unit in pairs(Group.getUnits(grp)) do
               local fuelConsumption = Unit.getFuelConsumption(unit)
               local fuelCapacity = Unit.getFuelCapacity(unit)
               local fuelLevel = fuelConsumption / fuelCapacity
               if fuelLevel <= low_fuel then
                    log:debug("Group " .. Group.getName(grp) .. " has a unit with low fuel, sending to the tanker")
                   table.insert(groups_to_refuel, grp)
               end
            end
        end
    end
    for _, grp in pairs(groups_to_refuel) do
        send_group_to_refuel_with(tanker_group, grp)
    end
end

function check_if_alive(groups)
    local keys_to_remove = {}
    for index, grp in pairs(groups) do
        if Group.isExist(grp) == false then
            log:debug("Group dead: " .. (grp.name or "[unknown]"))
            table.insert(keys_to_remove, index)
        end
    end

    for _, key in ipairs(keys_to_remove) do
        table.remove(groups, key)
    end
end

function schedule_spawning(cfg, time)
    log:debug(
        "Spawn time " .. time ..
        "\n# groups left in pool: " .. cfg.pool_size ..
        "\n# already spawned: " .. #cfg.spawned_groups ..
        "\n# active max: " .. cfg.max)

    check_if_alive(cfg.spawned_groups)
    if cfg.tanker_group ~= nil then
        check_fuel_state(cfg.spawned_groups, cfg.tanker_group)
    end

    if #cfg.spawned_groups >= cfg.max then
        log:debug("There are enough units out there right now, I'll come back in " .. cfg.interval .. "seconds to check again.")
        return time + cfg.interval
    end
    local count
    if cfg.pool_size >= cfg.groups_per_generation then
        count = cfg.groups_per_generation
    else
        count = cfg.pool_size
    end

    cfg.pool_size = cfg.pool_size - count
    log:debug("spawning " .. count .. " at a time, leaving" .. cfg.pool_size .. "in the pool")
    local spawned = create_new_groups(cfg) -- todo: bug here - not setting count????
    log:debug("Now there are the following spawned groups for this generation: " .. utils:serialize(cfg.spawned_groups, 2))
    return time + cfg.interval
end
return generator