--- @script yams-dcs.lua
--- Description; The YAMS API script which you can use for mission scripting in DCS World.
--- It has no other dependencies other than the Server Side Scripting Engine (SSSE) used by DCS itself, so you dont need
--- To install other scripts to make use of it.

yams = {}

--- The messaging module. This module contains a fluent interface for constructing and displaying message content on the RHS of screen, and in the chat.
--- @module message
local message = {
    text = nil,
    time = 10,
    should_clear = false
}

--- Adds text to an ephemeral message shown to the user on the upper RHS of the screen.
--- @param txt the text to be sent.
--- @returns a message object.
function message:with_text(txt)
    self.text = txt
    return self
end

--- Sets the message duration
--- @param for_seconds the number of seconds to apply the message to the screen before it is erased.
--- @returns a message object.
function message:for_seconds(seconds)
    self.time = seconds
    return self
end

--- Upon displaying this message, remove all other messages
--- @returns a message object.
function message:clear_previous_messages()
    self.should_clear = true
    return self
end

--- Send the ephemeral message to all users on the Upper RHS Screen area.
function message:send()
    trigger.action.outText(self.text, self.time, self.should_clear)
    return self
end

-- End Messages

-- Flags
--- The flag module exposes a fluent interface for dealing with flags
--- @module flag
local flag = {
    flag_index = 0,
    value = 0
}

--- Sets the value of a flag for a given index.
--- @param ndx The flags index number.
--- @param value The value to set the flag. 0 means off, or false. 1 or higher means on, or true.
function flag:set_value(ndx, value)
    self.flag_index = ndx
    self.value = value
    trigger.action.setUserFlag(self.flag_index, self.value)
    return self
end

--- Sets a flag for a given index, to ON.
--- @param ndx The flags index number.
function flag:set(ndx)
    self.flag_index = ndx
    self.value = true
    self:set_value(self.flag_index, self.value)
    return self
end

--- Sets a flag for a given index, to OFF.
--- @param ndx The flags index number.
function flag:unset(ndx)
    self.flag_index = ndx
    self.value = false
    self:set_value(self.flag_index, self.value)
    return self
end
-- end Flags

--- This is the root module that acts as the entry point to all yams functionality.
--- @module yams
yams = {
    message = message,
    flag = flag
}

-- let the server know that yams has been loaded via this flag
yams.flag:set(31337)

return yams