# Getting started

Download the [latest yams script](https://github.com/seska451/yams/releases)

Move the script into a folder that you can easily access while in the mission editor.
```bash
# EXAMPLE ONLY

mv $ENV:USERPROFILE\Downloads\yams-dcs.min.lua
"$ENV:USERPROFILE\Documents\Saved Games\DCS World\Scripts"
```

Open the mission editor and either create a new mission or create a new one. In the mission editor, click the triggers manager.

![The DCS Mission editor, highlighting the trigger button](/assets/open-triggers.png)

Create a new `trigger`, giving it a `condition` to wait for 1 second. Set the `action` to `DO SCRIPT FILE` and select the `yams-dcs.lua` file from your filesystem

![The Trigger Manager, showing the correct settings for your DO SCRIPT FILE trigger](assets%2Fadding-yams.png)

This concludes the process for loading yams, but now you want to build your own scripts around it.

## Adding your first script

Now that yams is available for your use, your code can use the library in subsequent scripts.

Create a new trigger and use a `FLAG ON condition` checking for flag `31337`, and use the `DO SCRIPT` action this time.

!!! example
    In that `DO SCRIPT` block, paste in the following code:

    ```lua
    yams.message
       :with_text("YAMS v0.1 loaded.")
       :for_seconds(15)
       :clear_previous_messages()
    ```

When you start the mission now, you should see the following message in the upper RHS of screen.

```
YAMS v0.1 loaded.
```