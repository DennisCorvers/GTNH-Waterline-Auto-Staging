local LineStep = {}
LineStep.__index = LineStep

function LineStep.new(machine, name, limit, fluid)
    local self = setmetatable({}, LineStep)

    self.proxy = machine
    self.name = name
    self.limit = limit;

    self.fluidLabel = fluid
    self.amount = 0

    return self
end

function LineStep:enable()
    self.proxy.setWorkAllowed(true)
end

function LineStep:disable()
    self.proxy.setWorkAllowed(false)
end

function LineStep:updateAmount(amount)
    self.amount = amount
end

function LineStep:isEnabled()
    return self.controllerProxy.isWorkAllowed() == true
end

return LineStep
