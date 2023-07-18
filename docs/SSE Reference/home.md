!!! info Work in progress
    This is a very new project and so it may not have all the documentation you are looking for right now.
    If this is the case I can highly recommend having a look at [Simulator Scripting Environment on Hoggit](https://wiki.hoggitworld.com/view/Simulator_Scripting_Engine_Documentation#Simulator_Scripting_Engine) as it covers all of the content you would find here.

The DCS Simulator Scripting Engine (SSE) is the foundation from which all missions are built. It is useful to learn how this works when implementing your own scripts.

You can use the SSE functionality alongside YAMS to create some awesome gaming experience for other pilots and players of DCS World.

# Classes

| Name                               | Purpose                                                                                       |
|------------------------------------|-----------------------------------------------------------------------------------------------|
| [Object](./classes/object)         | Root object for many of the placeable elements in the editor.                                 |
| [Group](./classes/group)           | Groups are a way to refer to a set of in game units that typically work together in some way. |
| [Controller](./classes/controller) |                                                                                               |
| [Spot](./classes/spot)             | Represents a spot on the ground targeted by a laser.                                          |
| [SceneryObject](./classes/SceneryObject)                  ||
| [CoalitionObject](./classes/CoalitionObject)               ||
| [Unit](./classes/Unit)                             ||
| [Airbase](./classes/Airbase)                          ||
| [Weapon](./classes/Weapon)                           ||
| [StaticObject](./classes/StaticObject)                     ||

# Modules

| Name                | Purpose                                                                 |
|---------------------|-------------------------------------------------------------------------|
| [env](./modules/env)   |                                                                         |    
| [timer](./modules/timer)           |                                                                         |    
| [land](./modules/land)            |                                                                         |      
| [atmosphere](./modules/atmosphere)      |                                                                         |
| [world](./modules/world)           |                                                                         |     
| [coalition](./modules/coalition)       | 	Entry point to information on the all of the units within the mission. | 
| [trigger](./modules/trigger)         |                                                                         |   
| [coord](./modules/coord)           |                                                                         |     
| [missionCommands](./modules/missionCommands) |                                                                         |
| [VoiceChat](./modules/VoiceChat)       |                                                                         |    
| [net](./modules/net)             |                                                                         |         


Represents a 
# Enumerations

| Name                                 | Purpose                                       |
|--------------------------------------|-----------------------------------------------|
| [country](./enumerations/country)    | List of all the supported countries           | 
| [AI](./enumerations/AI)              |                                               | 
| [world](./enumerations/world)        |                                               | 
| [radio](./enumerations/radio)        |                                               | 
| [trigger](./enumerations/trigger)    |                                               | 
| [coalition](./enumerations/coalition) | Defines the supported coalitions and services | 
| [weapon](./enumerations/weapon)       |                                               | 
| [callsign](./enumerations/callsign)   |                                               | 
| [formation](./enumerations/formation) |                                               | 
| [attributes](./enumerations/attributes)|                                               |