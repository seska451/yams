The generator module allows you to dynamically generate units, groups & static objects on the fly.

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

### generator:clone_group

Clones a template group `template_group_name` to a new group name (format: `template_group_name-N`) and new position.



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
