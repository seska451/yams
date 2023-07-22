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


--[[ generator:new

Initializes the generator.

!!! warning
    You need to do this before each call to start in order for this module to work correctly.
--]]

local generator = {
    group = nil,
    groups_per_generation = 0,
    max = 0,
    count = 0,
    starting_position = { },
    locations = { },
    roe = enums.rules_of_engagement.WEAPON_HOLD,
    rtt = enums.reaction_to_threat.NO_REACTION,
    interval = nil,
    generation_primitive = "groups",
    pool_size = 0,
    spawned_groups = { },
}
generator.__index = generator
function generator.new()
    return setmetatable({}, generator)
end

function generator:validate()
    if self.group == nil then
        log:error("group should not be nil")
        return false
    end
    if self.starting_position == nil then
        log:error("starting_position should not be nil")
        return false
    end
    return true
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

--[[ generator:using_template
Set the group name you wish to target for generation.
--]]
function generator:using_template(group_name)
    if Group.getByName(group_name) == nil then
        log:error("Non-existent group: " .. group_name)
    else
        self.group = group_name
    end
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
    log:debug("copying " .. group_name .. " to position:\n" .. utils:serialize(position, 2))
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
    if template_group_name == nil then
        log:error("clone_group called without a template group name!")
        return
    end
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
local group = require('group')
function send_group_to_refuel_with(tanker_group_name, grp)
    local receiver_units = grp:getUnits()
    if tanker_group_name == nil or grp == nil then
        log:error("Expected a tanker group name and a group to refuel!")
    end
    local tanker_groups = group:find_starting_with(tanker_group_name)
    if #tanker_groups < 1 then
        log:warn("Looks like we could not find a tanker group starting with " .. tanker_group_name)
    else
        local tanker_group = tanker_groups[1]
        local tanker = Group.getUnits(tanker_group)[1]
        if tanker == nil then
            log:error("Please make sure the first member of the group is a tanker aircraft")
            return
        end
        local tanker_id = Unit.getID(tanker)
        -- Create the refueling task
        local task = {
            id = "Refueling",
            params = {
                tanker = tanker_id,
                speed = 400, -- Replace with the desired refueling speed
            },
        }

        for _, unit in pairs(receiver_units) do
            -- Set the refueling task for the receiving group's first unit
            Unit.getController(unit):setTask(task)
        end
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

function generator:create_new_groups(count)
    for i = 1, count + 1 do
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

--[[ generator:spawn_over_time
Starts spawning groups over time, given the parameters set by other functions.position

You might use this with the `using_group`, `at_random_locations`, `no_less_than` and `no_more_than` functions.
!!! example
    ```lua
    local my_gen = yams.generator
    my_gen
        :using_group("My late activated group template")
        :at_random_locations({ coord1, coord2, coord3 })
        :no_more_than(10)
        :no_less_than(1)
        :spawn_over_time()
    ```
--]]
function generator:spawn_over_time()
    log:debug("Initializing spawn with settings:\n" ..utils:serialize(self, 2))
    -- todo: do a better job of checking all the preconditions
    if self.group == nil then
        log:error("Couldn't find template group - ejecting from spawn operation.")
        return
    end
    local count = clamp(self.groups_per_generation, 0, self.max)
    self:create_new_groups(count)
    timer.scheduleFunction(self.schedule_spawning, self, timer.getTime() + self.interval)
end

function check_fuel_state(groups, tanker_group)
    local low_fuel = 0.2
    local groups_to_refuel = {}
    for _, grp in pairs(groups) do
        if Group.isExist(grp) then
            for _, unit in pairs(Group.getUnits(grp)) do
               local fuelLevel = Unit.getFuel(unit)
               if fuelLevel <= low_fuel then
                   local unit_name = Unit.getName(unit)
                   log:debug("Unit " .. unit_name .. " in " .. Group.getName(grp) .. " has fuel state " .. 0 .. ", re-routing to refuel.")
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
            log:debug("Group dead: " .. (Group.getName(grp) or "[unknown]"))
            table.insert(keys_to_remove, index)
        else
            -- check if each unit is below 1 health
            local all_damaged = false
            for _, unit in pairs(Group.getUnits(grp)) do
                all_damaged = all_damaged and (Unit.GetLife(unit) < 1)
            end
            if all_damaged then
                table.insert(keys_to_remove, index)
            end
        end
    end

    for _, ndx in ipairs(keys_to_remove) do
        table.remove(groups, ndx)
    end
end

function generator:schedule_spawning(time)
    log:debug(
        "Spawn time " .. time ..
        "\n# groups left in pool: " .. self.pool_size ..
        "\n# already spawned: " .. #self.spawned_groups ..
        "\n# active max: " .. self.max)

    check_if_alive(self.spawned_groups)
    if self.tanker_group ~= nil then
        check_fuel_state(self.spawned_groups, self.tanker_group)
    end

    if #self.spawned_groups >= self.max then
        log:debug("There are enough units out there right now, I'll come back in " .. self.interval .. "seconds to check again.")
        return time + self.interval
    end
    local count
    if self.pool_size >= self.groups_per_generation then
        count = self.groups_per_generation
    else
        count = self.pool_size
    end

    self.pool_size = self.pool_size - count
    local count = clamp(self.groups_per_generation, 0, self.max)
    log:debug("spawning " .. count .. " at a time, leaving" .. self.pool_size .. "in the pool")
    self:create_new_groups(count)
    log:debug("Now there are the following spawned groups for this generation: " .. utils:serialize(self.spawned_groups, 2))
    return time + self.interval
end

function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

--[[ generator:spawn_once
--]]
function generator:spawn_once()
    log:debug("Initializing spawn with settings:\n" ..utils:serialize(self, 2))
    -- todo: do a better job of checking all the preconditions
    if self.group == nil then
        log:error("Couldn't find template group - ejecting from spawn operation.")
        return
    end
    local count = clamp(self.groups_per_generation, 0, self.max)
    self:create_new_groups(count)
    return self.spawned_groups[1]
end

return generator