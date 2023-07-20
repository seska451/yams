
All helper functions to do with group management


***

### group:find

Find a group by its name.

!!! example
    ```lua
    local group = yams.group:find("RAAF-FA18C")
    ```

***

### group:get_country

Gets the country ID for a given group, based on the first unit in the group.
