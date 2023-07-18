-- Messages
yams = {}

local message = {
    text = nil,
    time = 10,
    should_clear = false
}

function message:with_text(txt)
    self.text = txt
    return message
end

function message:for_seconds(seconds)
    self.time = seconds
    return self
end

function message:clear_previous_messages()
    self.should_clear = true
    return self
end

function message:send()
    trigger.action.outText(self.text, self.time, self.should_clear)
    return self
end


-- End Messages
-- Flags
local flag = {
    flag_index = 0,
    value = 0
}


function flag:set_value(ndx, value)
    self.flag_index = ndx
    self.value = value
    trigger.action.setUserFlag(self.flag_index, self.value)
    return self
end

function flag:set(ndx)
    self.flag_index = ndx
    self.value = true
    self:set_value(self.flag_index, self.value)
    return self
end

function flag:unset(ndx)
    self.flag_index = ndx
    self.value = false
    self:set_value(self.flag_index, self.value)
    return self
end
-- end Flags

yams = {
    message = message,
    flag = flag
}

message
    :with_text("YAMS v0.1 loaded.")
    :for_seconds(20)
    :clear_previous_messages()
    :send()

flag
    :set(31337, true)

return yams