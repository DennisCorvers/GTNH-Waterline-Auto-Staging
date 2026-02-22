local oc = require('util.oc')
local data = require('data.data')

local Controller = {}
Controller.__index = Controller

function Controller.new()
    local self = setmetatable({}, Controller)

    local name = data.Controller.name
    local machine = oc.findGTMachine(name)
    if machine == nil then
        error('Waterline controller cannot be found.')
    end

    self.proxy = machine
    self.name = name

    print('Registered waterline controller')
    return self
end

function Controller:getProgress()
    if self.proxy.hasWork() then
        return math.ceil(self.proxy.getWorkProgress() / 20)
    end

    return 0
end

function Controller:isEnabled()
    return self.proxy.isWorkAllowed() == true
end

return Controller
