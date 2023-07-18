# Coalition
The coalition object is small, but it has some important properties: `coalition` and `service`.

!!! example

    ```lua
    local red_for = coalition.side.RED
    local all_awacs = coalition.service.AWACS
    ```
## Sides
There are three coalitions, red, blue and neutral. The SSE defines these has

| name | number |
| --- | --- |
| NEUTRAL | 0 |
| RED | 1 |
| BLUE | 2 |


!!! example 
    You can use these in your own code to reference coalitions. For example - using the yams.messaging module:
    
    ```lua
    yams.message
        :with_text("This should only go to the blue coalition")
        :to_coalition(coalition.side.BLUE)
        :send()
    ```
## Services
Each coalition houses a series of services that are provided to the whole coalition.

| name   | number | meaning                                                                          |
|--------|--------|----------------------------------------------------------------------------------|
| ATC    | 0      | Air Traffic Control - tells us when/where to land                                |
| AWACS  | 1      | Airborne Warning and Control Service - tells us where threats are                |
| TANKER | 2      | Airborne Refuelling Services                                                     |
| FAC    | 3      | Forward Air Controller - tells us where our targets are during Close Air Support |
|        |        |                                                                                  |