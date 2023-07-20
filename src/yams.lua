env.info("-=_ YAMS v0.1 LOADING _=-")

local log = {
    context = "[YAMS]"
}

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
        context = "[YAMS - " .. context .."]"
        self.context = context
    end
end

function log:clear_context()
    self.context = "[YAMS]"
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

--[[ yams:(enum) starting_positions
| index | value | summary |
|---|---|---|
| 0 | FROM_PARKING_HOT | Spawn at an airbase parking bay, ready to taxi to runway |
| 1 | FROM_AIR | Spawn 15000ft in the air |
--]]

starting_positions = {
    FROM_PARKING_HOT = 0,
    FROM_AIR = 1,
}

--[[ generator:header
The generator module allows you to dynamically generate units, groups & static objects on the fly.
--]]
local generator = {
    group = nil,
    min = 0,
    max = 10,
    count = -1,
    starting_position = starting_positions.FROM_AIR
}

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

--[[ generator:using_group
Set the group name you wish to target for generation.
--]]
function generator:using_group(group_name)
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
function generator:no_more_than(max)
    self.max = max
    return self
end

--[[ generator:no_less_than
Limit the generation to have no less than `min` units
--]]
function generator:no_less_than(min)
    self.min = min
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

--[[ generator:get_next_unit_name
Given a unit name `baseName` as a template, find the next unit name
--]]
function generator:get_next_unit_name(baseName, clonedGroupData)
    local count = 1
    local newName = baseName

    while clonedGroupData.units[newName] do
        count = count + 1
        newName = baseName .. "-" .. count
    end

    return newName
end


--[[ generator:with_starting_position
Set the starting position of generated spawns. Defaults to in air.
--]]
function generator:with_starting_position(starting_position)
    self.starting_position = starting_position
    return self
end

function generator:start_in_air(altitude)
    self.start_air = true
    self.start_ground = false
    self.altitude = altitude
    return self
end

--[[ generator:start_from_ground

!!! warning not yet implemented
    Planned feature.
--]]
function generator:start_from_ground()
    self.start_air = false
    self.start_ground = true
    self.altitude = 0
    return self
end

--[[ generator:clone_group
Clones a template group `template_group_name` to a new group name (format: `template_group_name-N`) and new position.


--]]
function generator:clone_group(template_group_name, position)
    local templateGroup = group:find(template_group_name)

    if templateGroup ~= nil then
        local cloned_group_name = generator:get_next_group_name(template_group_name)
        local cloned_group_data = generator:deep_clone(templateGroup, nil)
        cloned_group_data.name = cloned_group_name

        -- Check for duplicate unit names within the cloned group
        for unit_id, unit_data in pairs(cloned_group_data.units) do
            local originalUnitName = unit_data.name
            local newUnitName = generator:get_next_unit_name(originalUnitName, cloned_group_data)
            unit_data.name = newUnitName
            unit_data.x = position.x
            unit_data.y = position.y
            unit_data.z = position.z
        end

        local clonedGroup = coalition.addGroup(templateGroup:getCoalition(), templateGroup:getCategory(), cloned_group_data)
        return clonedGroup
    else
      -- Handle the case when the template group doesn't exist
        log:set_context("Generator")
        log:error("Template group not found:" .. template_group_name)
        log:clear_context()
        return nil
    end
end

--[[ generator:spawn
This is the final command of the Fluent generator API. Starts spawning given the parameters set by other functions.position

You might use this with the `using_group`, `at_random_locations`, `no_less_than` and `no_more_than` functions.
!!! example
    ```lua
    local my_gen = yams.generator
    my_gen
        :using_group("My late activated group template
        :at_random_locations({ coord1, coord2, coord3 })
        :no_more_than(10)
        :no_less_than(1)
        :spawn()
    ```
--]]
function generator:spawn()
    local spawnedGroups = {}
    for i = self.min, self.max do
        local randomIndex = math.random(#self.locations)
        local randomLoc = self.locations[randomIndex]
        if self.start_air == true then
            randomLoc.z = 4570 --in metres, equiv to 15000ft
        end
        if self.start_ground == true then
            log:error("This functionality is not yet implemented.")
        end
        local spawnedGroup = generator:clone_group(self.group, randomLoc)
        spawnedGroups[i] = spawnedGroup
    end
    return spawnedGroups
end

--[[ random_air_traffic:header
Generates random air traffic (RAT) based on a template group. Yams will spawn no more than the desired number of groups.

For best results, set the template group to **late activation** to supress it from being spawned on startup. This saves a bit of CPU processing for you.

!!! example
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
    positions = nil
}

--[[ random_air_traffic:using_group
Use a `group_name` to find a late activated template group for use in random air traffic generation
--]]
function random_air_traffic:using_group(group_name)
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

--[[ random_air_traffic:start_in_air
Tells all traffic to be spawned in the air at a given altitude
--]]
function random_air_traffic:start_in_air(altitude)
    self.start_air = true
    self.start_altitude = altitude
    return self
end

--[[ random_air_traffic:start_from_ground

!!! warning not yet implemented
    Planned feature.
--]]
function random_air_traffic:start_from_ground()
    self.start_air = false
    return self
end

function get_airbase_positions_for(coa)
    local coordinates = {}
    for _, airbase_data in pairs(coalition.getAirbases(coa)) do
        local pos = airbase_data:getPosition().p

        -- Store the airbase name and position in the airbases table
        table.insert(coordinates, pos)
    end
    return coordinates
end

--[[ random_air_traffic:init
Final call in the random_air_traffic fluent API. Use this to start random air traffic using the parameters set by previous calls.
--]]
function random_air_traffic:init()
    log:set_context("RAT")
    log:info("Commencing RAT")

    log:info("finding " .. self.template)
    g = group:find(self.template)
    if g == nil then
        log:error(self.template .. " group not found.")
        return
    end
    local coalition = Group.getCoalition(g)
    coordinates = get_airbase_positions_for(coalition)

    if self.start_air == true then
        generator
                :using_group(self.template)
                :no_more_than(self.max_groups)
                :no_more_than(1)
                :at_random_locations(coordinates)
                :start_in_air(self.altitude)
                :spawn()

    else
        generator
                :using_group(self.template)
                :no_more_than(self.max_groups)
                :no_more_than(1)
                :at_random_locations(coordinates)
                :start_from_ground()
                :spawn()
    end

    log:info("RAT Started")
    log:clear_context()
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
    random_air_traffic = random_air_traffic
}


-- let the server know that yams has been loaded via this flag
flag:set(31337)
log:info("-=_ YAMS v0.1 LOADED _=-")
return yams