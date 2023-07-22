env:info('DCS is running. Overriding the require function, since DCS has disabled it anyway')
require = function(script_name)
    env:info('script requested: ' .. script_name)
    if _G[script_name] then
        env:info('We found a variable that looks like the script you are after: ' .. utils:serialize(_G[script_name]))
        return _G[script_name]
    else
        env:error('We have no idea where to find: ' .. script_name)
    end
end
config = {}
function house_keeping()
    -- announce ourselves
    env.info("-=_ YAMS v0.1 LOADING _=-")
    -- check the script run seed, useful for replaying some random behaviour later
    local seed = math.random(1, 100)
    env.info("-=_ TODAY'S SCRIPT BROUGHT TO YOU BY THE NUMBER " .. seed .. " _=-")
    -- initialize configuration settings
    config = {
        debug = false
    }
end
house_keeping()
-- let's test this out
local test = require('test')
test:hello_world()

function config:set_debug(val)
    env.info("[DEBUG] setting debug to " .. tostring(val))
    self.debug = val
    return self
end

function config:get_debug()
    return self.debug
end

local log = {
    context = "[YAMS]"
}

local waypoint_type = {
    TAKEOFF = AI.Task.WaypointType.TAKEOFF,
    TAKEOFF_PARKING = AI.Task.WaypointType.TAKEOFF_PARKING,
    TURNING_POINT = AI.Task.WaypointType.TURNING_POINT,
    TAKEOFF_PARKING_HOT = AI.Task.WaypointType.TAKEOFF_PARKING_HOT,
    LAND = AI.Task.WaypointType.LAND
}
--[[ enums:rules_of_engagement
| index | value | summary |
|---|---|---|
| 0 | WEAPON_FREE | Use weapons against any enemy target |
| 1 | PRIORITY_DESIGNATED | Use weapons, against enemy targets in order of priority |
| 2 | ONLY_DESIGNATED | Use weapons, against only designated enemy targets |
| 3 | RETURN_FIRE | Use weapons, against only enemy units that are firing on this unit |
| 4 | WEAPON_HOLD | Do not use weapons |
--]]
local rules_of_engagement = {
    WEAPON_FREE = AI.Option.Air.val.ROE.WEAPON_FREE,
    PRIORITY_DESIGNATED = AI.Option.Air.val.ROE.OPEN_FIRE_WEAPON_FREE,
    ONLY_DESIGNATED = AI.Option.Air.val.ROE.OPEN_FIRE,
    RETURN_FIRE = AI.Option.Air.val.ROE.RETURN_FIRE,
    WEAPON_HOLD = AI.Option.Air.val.ROE.WEAPON_HOLD,
    get_id = function()
        return AI.Option.Air.id.ROE
    end
}

--[[ enums:reaction_to_threat
| index | value | summary |
|---|---|---|
| 0 | NO_REACTION | Do not react to threats |
| 1 | PASSIVE_DEFENCE | Passively defend against threats (e.g. staying out of range) |
| 2 | EVADE_FIRE | When fired upon, attempt to evade incoming missiles or bullets |
| 3 | BYPASS_AND_ESCAPE | Avoid confrontation by evading fire, while re-routing to complete mission objectives. |
| 4 | ALLOW_ABORT_MISSION | Avoid confrontation by evading fire and return to base (RTB). |
--]]
local reaction_to_threat = {
    NO_REACTION = AI.Option.Air.val.REACTION_ON_THREAT.NO_REACTION,
    PASSIVE_DEFENCE = AI.Option.Air.val.REACTION_ON_THREAT.PASSIVE_DEFENCE,
    EVADE_FIRE = AI.Option.Air.val.REACTION_ON_THREAT.EVADE_FIRE,
    BYPASS_AND_ESCAPE = AI.Option.Air.val.REACTION_ON_THREAT.BYPASS_AND_ESCAPE,
    ALLOW_ABORT_MISSION = AI.Option.Air.val.REACTION_ON_THREAT.ALLOW_ABORT_MISSION,
    get_id = function()
        return AI.Option.Air.id.REACTION_ON_THREAT
    end
}
--[[ enums:header
The enums table defines the many static values that are used in the mission editor.

- **rules_of_engagement** - dictates how a unit may use weapons
- **reaction_to_threat** - dictates how a unit may react to threats
- **waypoint_type** - dictates how a unit should deal with a waypoint
--]]
local enums = {
    rules_of_engagement = rules_of_engagement,
    reaction_to_threat = reaction_to_threat,
    waypoint_type = waypoint_type
}

local zone = { }

function zone:find(name)
    return trigger.misc.getZone(name)
end

--[[ utils:header
Every project has a bucket of _slightly_ useful functions, this is yams:utils.
]]--
local utils = { }

function utils:serialize(tbl, indent)
    local result = ""
    local indent = indent or 0

    for key, value in pairs(tbl) do
        if type(value) ~= "function" then
            local keyStr = (type(key) == "string") and ('"' .. key .. '": ') or tostring(key)
            local valueType = type(value)

            if valueType == "table" then
                result = result .. string.rep(" ", indent) .. keyStr .. "{\n"
                result = result .. utils:serialize(value, indent + 2)
                result = result .. string.rep(" ", indent) .. "},\n"
            else
                local valueStr = (valueType == "string") and ('"' .. value .. '"') or tostring(value)
                result = result .. string.rep(" ", indent) .. keyStr .. valueStr .. ",\n"
            end
        end
    end

    return result
end

--[[ log:info
Writes an info level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:info("Splash One Lizard")
    ```
--]]
function log:info(message)
    env.info(log.context .. " " .. message, false)
end

--[[ log:warn
Writes a warning level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:warn("Bogey on your six")
    ```
--]]
function log:warn(message)
    env.warning(log.context .. " " .. message, false)
end

--[[ log:error
Writes an error level message to the DCS Log.

| param | type | summary |
|---|---|---|
|message|string|The message you want to print into the log file.|

!!! example
    ```lua
    local log = yams.logger
    log:error("Joker Fuel.")
    ```
]]
function log:error(message)
    env.error(log.context .. " " .. message, false)
end



function log:set_context(context)
    if context == nil then
        self.context = "[YAMS]"
    else
        context = "[" .. context .."]"
        self.context = context
    end
end

function log:clear_context()
    self.context = "[YAMS]"
end

function log:debug(message)
    if config:get_debug() == true then
        log:set_context("YAMS - DEBUG")
        log:info(message)
        log:clear_context()
    end
end
--[[ message:header
# Message

!!! info message object
    The `yams.message` object is useful for sending messages to coalitions, groups, and units.

    Messages are the primary way to communicate information to players and can often be seen in both PVE and PVP, solo
    and multiplayer scenarios
--]]

--[[ message:
#### Summary
Data structure for messaging information.
#### Properties & Methods
 | property | type | summary |
 |-------|------|---------|
 |text    | string| the text to be sent.|
 |time    | int| the time to display the text for.|
 |should_clear    | bool| If true, clears the previous messages.|
 |with_text    |method| Sets the message text|
 |for_seconds    |method| Sets the message timer|
 |clear_previous_messages    |method| Determines if the previous messages should be cleared|

!!! example
    ```lua
    yams.message
        :with_text("Hello, YAMS!")  -- Output Hello, YAMS!
        :for_seconds(30)            --    for 30 seconds
        :clear_previous_messages()  --    clearing the previous messages
        :send()                     --    send to all players
    ```
--]]
local message = {
    text = nil,
    time = 10,
    should_clear = false,
    coalition = nil
}

--[[ message:with_text

Adds text to an ephemeral message shown to the user on the upper RHS of the screen.

 | param | type | summary |
 |-------|------|---------|
 |txt    | string| the text to be sent.|

Returns self

!!! example
    ```lua
    yams.message
        :with_text("Hello, YAMS!")
        :send() -- sends to all players in all coalitions
    ```
--]]
function message:with_text(txt)
    self.text = txt
    return self
end

--[[ message:for_seconds

Sets the message duration

 | param | type | summary |
 |-------|------|---------|
 |seconds|int| the number of seconds to apply the message to the screen before it is erased. _Defaults to 10 seconds_|

Returns self

!!! example
    ```lua
    yams.message
        :with_text("Hello, YAMS!")
        :for_seconds(5)
        :send() -- sends to all players in all coalitions
    ```
--]]
function message:for_seconds(seconds)
    self.time = seconds
    return self
end

--[[ message:clear_previous_messages

Upon displaying this message, remove all other messages

Returns self

!!! example
    ```lua
    yams.message
        :with_text("Hello, YAMS!")
        :clear_previous_messages()
        :send() -- sends to all players in all coalitions
    ```
--]]
function message:clear_previous_messages()
    self.should_clear = true
    return self
end

--[[ message:send

Display this message, to all players, in all coalitions. Messages appear in the upper RHS of the screen.

Returns self

!!! example
    ```lua
    local msg = yams.message:with_text("Bingo fuel"):to_coalition(coalition.side.RED)
    -- later
    msg:send()
    ```
--]]
function message:send()
    if self.coalition ~= nil then
        trigger.action.outTextForCoalition(self.coalition, self.text, self.time, self.should_clear )
    else
        trigger.action.outText(self.text, self.time, self.should_clear)
    end

    return self
end

--[[ message:to_coalition

Only send this message to the given coalition.

| param | type |
| --- | --- |
| coalition | SSE.coalition.side [Enumeration]|

!!! example
    ```lua
    yams.message
        :with_text("Hello, YAMS!")
        :to_coalition(coalition.side.BLUE)
        :send()
    ```
]]
function message:to_coalition(coalition)
    self.coalition = coalition
    return self
end

-- End Messages

--[[ flag:header
# Flag

> [!INFO]
> The `yams.flag` object is useful for storing binary state as flags. DCS uses flags to communicate across triggers and steps.
>
> For example, a trigger may use a condition that checks is a flag is set or not, before executing its action.
--]]
--[[ flag:
#### Summary
Data structure for flag management.
#### Properties & Methods
 | property | type | summary |
 |-------|------|---------|
 |flag_index    | int| the unique number representing the flag.|
 |value    | int| the numeric value of the flag. Non-zero values are considered 'true'|
 |set    | method| Sets a flag to 'true'|
 |unset    |method| Sets a flag to 'false'|
 |set_value    |method| Sets a flag to a given value|
 |clear_previous_messages    |method| Determines if the previous messages should be cleared|

!!! example
    ```lua
    yams.flag
        :set(31337)                 -- Sets Flag #31337 to true
        :unset(30)                  -- Sets Flag #30 to false
        :set_value(420, 8145317)    -- Sets Flag #420 to the number 8145317
    ```
--]]
local flag = {
    flag_index = 0,
    value = 0
}

--[[ flag:set_value
Sets the value of a given flag referred to by index.

--]]
function flag:set_value(ndx, value)
    self.flag_index = ndx
    self.value = value
    trigger.action.setUserFlag(self.flag_index, self.value)
    return self
end


--[[ flag:set
Sets a flag to ON.

--]]
function flag:set(ndx)
    self.flag_index = ndx
    self.value = true
    self:set_value(self.flag_index, self.value)
    return self
end


--[[ flag:unset
Sets a flag to OFF

--]]
function flag:unset(ndx)
    self.flag_index = ndx
    self.value = false
    self:set_value(self.flag_index, self.value)
    return self
end
-- end Flags

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


--[[ generator:header
The generator module allows you to dynamically generate units, groups & static objects on the fly.
--]]
local generator = { }
function generator:new()
    self.group = { }
    self.groups_per_generation = 0
    self.max = 10
    self.count = -1
    self.starting_position = { }
    self.locations = { }
    self.roe = enums.rules_of_engagement.WEAPON_HOLD
    self.rtt = enums.reaction_to_threat.NO_REACTION
    self.interval = 0
    self.generation_primitive = "groups"
    self.pool_size = 0
    self.spawned_groups = { }
    return self
end

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

function generator:groups()
    self.generation_primitive = "groups"
    return self
end

--[[
generator
:generate(5):groups()
:every(20):seconds()
:no_more_than(10)
:spawn()
--]]
function generator:generate(count)
    self.groups_per_generation = count
    return self
end

function generator:every(interval_in_seconds)
    self.interval = interval_in_seconds
    return self
end

function generator:minutes()
    self.interval = self.interval * 60
    return self
end

function generator:seconds()
    return self
end

function generator:with_rules_of_engagement(roe)
    self.roe = roe
    return self
end

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

function generator:at_altitude(altitude)
    self.start_altitude = altitude
    return self
end

function generator:copy_group_data(source_group, position)
    local group_name = source_group:getName()
    local pos_str = "x: " .. position.x .. ", y: " .. position.y .. ", z: " .. position.z
    log:debug("copying " .. group_name .. " to position " .. pos_str)
    local data = {
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
    data.units = units

    return data
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
        unit:getController():setTask(task)
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

function generator:defending_zone(patrol_area)
    self.patrol_area = patrol_area
    return self
end

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
               local fuelConsumption = unit:getFuelConsumption()
               local fuelCapacity = unit:getFuelCapacity()
               local fuelLevel = fuelConsumption / fuelCapacity
               if fuelLevel <= lowFuelThreshold then
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

    if cfg.pool_size == 0 then
        return nil
    end
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
    local spawned = create_new_groups(count, cfg.locations, cfg.start_altitude, cfg.group, cfg.spawned_groups)
    log:debug("Now there are the following spawned groups for this generation: " .. utils:serialize(cfg.spawned_groups))

    return time + cfg.interval
end

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

local random_air_traffic = {}

function random_air_traffic:new()
    self.template = nil
    self.max_groups = 0
    self.start_air = nil
    self.positions = nil
    self.name = ""
    self.roe = enums.rules_of_engagement.WEAPON_HOLD
    self.rtt = enums.reaction_to_threat.BYPASS_AND_ESCAPE
    return self
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
        log:debug("Creating random air traffic with " .. self.template:getName())
    end

    g = group:find(self.template)
    if g == nil then
        log:error(self.template .. " group not found.")
        return
    end
    local coalition = Group.getCoalition(g)
    coordinates = get_airbase_positions_for(coalition)
    local pool_size = 1000
    generator
            :new()
            :using_template(self.template)              -- sets the template
            :from_pool_of(pool_size):groups()                  -- sets the original count of groups available
            :generate(self.max_groups):groups()                       -- sets how many groups to spawn at once
            :every(20):seconds()                        -- sets the generation interval
            :until_there_are(self.max_groups):groups()  -- sets the maximum number of active groups
            :at_random_locations(coordinates)           -- sets the locations in which these groups could appear
            :at_altitude(self.start_altitude)           -- sets the altitude at which these groups appear
            :with_rules_of_engagement(self.roe)         -- sets the ROE for the groups
            :with_reaction_to_threat(self.rtt)          -- sets the RTT for the groups
            :spawn()                                    -- kicks it all off


    log:debug("RAT Started")
end

local combat_air_patrol = {}

function combat_air_patrol:new()
    self.template = nil
    self.max_groups = 0
    self.start_air = nil
    self.name = ""
    self.roe = enums.rules_of_engagement.WEAPON_FREE
    self.rtt = enums.reaction_to_threat.EVADE_FIRE
    self.start_location = nil
    self.patrol_area = nil
    self.tanker_group = nil
    self.squadron_size = 0
    return self
end

function combat_air_patrol:using_template(grp)
    self.template = grp
    return self
end

function combat_air_patrol:with_name(name)
    self.name = name
    return self
end

function combat_air_patrol:no_more_than(count)
    self.max_groups = count
    return self
end

function combat_air_patrol:start_in_air(altitude)
    self.start_air = true
    self.start_altitude = altitude
    return self
end

function combat_air_patrol:for_squadron_size(count)
    self.squadron_size = count
    return self
end

function combat_air_patrol:with_home_base(airbase_name)
    local ab = Airbase.getByName(airbase_name)
    self.start_location = Airbase.getPosition(ab)

    -- todo: this fails because ab is nil. 
    log:debug("home base at:" .. utils.serialize(self.start_location))
    return self
end

function combat_air_patrol:with_tanker_group(grp)
    self.tanker_group = grp
    return self
end

function combat_air_patrol:zone_to_defend(zone)
    self.patrol_area = zone
    return self
end

function combat_air_patrol:start()
    if self.name ~= nil then
        log:debug("Creating combat air patrol for " .. self.name)
    else
        log:debug("Creating combat air patrol with " .. self.template:getName())
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



--[[ yams:header

The `yams` object is the entry point into the YAMS API. See [Getting Started]('../../getting-started') to learn how to load YAMS into your mission.

There are several modules and methods you can use from yams.

## Modules

### message
The [message](/API-reference/message/) module is the entry point in to anything to do with sending information to players in the game.info

### flag
The [flag](/API-reference/flag/) module assists with setting and reading flag data.

## Methods

### Logging methods
The main way to print out debugging related information is via DCS.log which you can find in your `$ENV:USERPROFILE\Saved Games\DCS.openbeta\Logs\dcs.log`

So if your username is `sandra` and your profile is on the C:\ drive you can find your log file at `C:\Users\sandra\Saved Games\DCS.openbeta\Logs\dcs.log`

The following log functions are supported:

- info
- warn
- error

!!! example
    ```lua
    yams.flag:set(1337) -- sets the 1337 flag ON
    ```
--]]
yams = {
    message = message,
    flag = flag,
    group = group,
    logger = log,
    generator = generator,
    random_air_traffic = random_air_traffic,
    combat_air_patrol = combat_air_patrol,
    enums = enums,
    config = config,
    zone = zone
}


-- let the server know that yams has been loaded via this flag
flag:set(31337)
log:debug("Loaded and ready for action.")
return yams