# YAMS - Yet Another Mission Script for DCS World

> [!INFO] Work in progress
> This is a very new project and so it may not have all the features you are looking for right now.
> If this is the case I can highly recommend having a look at:
> 
> * [S.S.E - The basic API from Eagle Dynamics](https://wiki.hoggitworld.com/view/Simulator_Scripting_Engine_Documentation#Simulator_Scripting_Engine)
> * [M.O.O.S.E - An extremely powerful solution](https://flightcontrol-master.github.io/MOOSE_DOCS/)
> * [Mist](https://wiki.hoggitworld.com/view/Mission_Scripting_Tools_Documentation)

There are other frameworks that exist too, but these are the three most commonly used in 2023 for english speaking users.

## So ...why YAMS?

To be honest I found most of the above frameworks to be simulaneously awesome and frustration inducing. The primary reason for this
is the accessibility of the documentation in each scenario. 

The SSE docs are scant, the Mist docs are ridden with Ads, and the MOOSE docs, while comprehensive, are extremely difficult to search and learn.

In addition, I was not a fan of the structure and function of these APIs. Rather than try and turn one around, I felt that starting again was simpler for me. Hence the name - Yet Another Mission Script.

> [!INFO] This is my rifle. 
> There are many others like it, but this one is mine.
>

## Goals

The goal of this project is to provide a mission scripter a well documented set of tools with up to date examples, even if that set of tools is small to begin with.

Rather than solve every problem, the problems that get solved, should...

* Be well documented, with clear examples
* Have a low barrier to entry to achieve the goal of the feature
* Yield a consistent syntax that allows the editor to fall into the 'pit of success' as much as possible

Further, I want the documentation itself to be easy to generate, clean of ads, searchable, and generally easy to use. This is why I chose mkdocs and

## Getting started

If you want to include yams in your next mission, its as simple as:

1. Download the latest yams script from here: https://github.com/seska451/yams/releases
2. Unzip the script into a folder that you can easily access while in the mission editor (like your `Documents\Saved Games\DCS World\Scripts` folder for example )
3. Open your mission editor and either create a new mission or create a new one
4. In the mission editor, click the triggers manager
5. Create a new `trigger`, giving it a `condition` to wait for 1 second. Set the `action` to `DO SCRIPT FILE` and select the `yams-dcs.lua` file from your filesystem
6. Start your mission. Yams is now loaded but how can you tell? We will need to write our first in game script for that.

### Adding your first script

Now that yams is available for your use, your code can use the library in subsequent scripts.

Create a new trigger and use a `FLAG ON condition` checking for flag 31337, and use the `DO SCRIPT` action this time.

In that `DO SCRIPT` block, paste in the following code:

```lua
yams.message
   :with_text("YAMS v0.1 loaded.")
   :for_seconds(15)
   :clear_previous_messages()
```

###### _The DCS Mission editor, highlighting the trigger button_
![The DCS Mission editor, highlighting the trigger button](/assets/open-triggers.png)

###### _The Trigger Manager, showing the correct settings for your `DO SCRIPT FILE` trigger_
![The Trigger Manager, showing the correct settings for your DO SCRIPT FILE trigger](assets%2Fadding-yams.png)

###### _In game, showing your output to prove that YAMS is now available for use in your other scripts_