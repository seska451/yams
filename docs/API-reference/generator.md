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

***

### generator:new


Initializes the generator.

!!! warning
    You need to do this before each call to start in order for this module to work correctly.

***

### generator:from_pool_of

!!! example
    ```lua
    yams.generator:from_pool_of(count)

    ```

***

### generator:deep_clone


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

***

### generator:groups

!!! example
    ```lua
    yams.generator:groups()
    ```

***

### generator:generate

Generate `count` groups everytime `interval` elapses.

***

### generator:every

Set the generation interval. When this elapses a series of checks are performed. If they pass, another generation of groups
are spawned into the world.
!!! example
    ```lua
    yams.generator:every(interval_in_seconds)
    ```

***

### generator:minutes

!!! example
    ```lua
    yams.generator:minutes()
    ```

***

### generator:seconds

!!! example
    ```lua
    yams.generator:seconds()

    ```

***

### generator:with_rules_of_engagement

!!! example
    ```lua
    yams.generator:with_rules_of_engagement(roe)

    ```

***

### generator:with_reaction_to_threat

!!! example
    ```lua
    yams.generator:with_reaction_to_threat(rtt)

    ```

***

### generator:using_group

Set the group name you wish to target for generation.

***

### generator:at_random_locations

Provide a table of coordinates to randomly choose when spawning units

***

### generator:no_more_than

Limit the generation to have no more than `max` units

***

### generator:exactly

Limit the generation to have exactly `count` units

***

### generator:get_next_group_name

Given a group name `baseName` as a template, find the next group name

***

### generator:get_next_unit_name

Given a unit name `baseName` as a template, find the next unit name

***

### generator:with_starting_location

Set the starting position of generated spawns. Defaults to in air.

***

### generator:at_altitude

!!! example
    ```lua
    yams.generator:at_altitude(altitude)

    ```

***

### generator:clone_group

Clones a template group `template_group_name` to a new group name (format: `template_group_name-N`) and new position.

***

### generator:defending_zone

!!! example
    ```lua
    yams.generator:defending_zone(zone)

    ```

***

### generator:refuelling_at

!!! example
    ```lua
    yams.generator:refuelling_at(tanker_group)

    ```

***

### generator:spawn

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
