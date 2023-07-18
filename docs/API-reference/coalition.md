There are three coalitions, red, blue and neutral. The SSE defines these has

| name | number |
| --- | --- |
| NEUTRAL | 0 |
| RED | 1 |
| BLUE | 2 |

You can use these in your own code to reference coalitions. For example - using the messaging module:has

```lua
yams.message
    :with_text("This should only go to the blue coalition")
    :to_coalition(coalition.side.BLUE)
    :send()
```

***

### coalition:service

The `coalition.service` enumeration defines the cross-cutting services each coalition has:

| name | number | description |
| --- | --- | --- |
| ATC | 0 | Air Traffic Control - the people who tell us when we can land/takeoff. |
| AWACS | 1 | Airborne Warning And Control System - the people who tell us how is attacking us and where. |
| TANKER | 2 | Refueling services for in-air refuelling capable aircraft, like the Hornet or Viper. |
| FAC | 3 | Forward Air Controller - the people who tell us what we can attack and where. |

