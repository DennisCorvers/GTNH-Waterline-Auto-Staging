local linestep = require('data.line-step')
local component = require('component')
local redstone = require('util.redstone')

------ LOCAL FUNCTIONS ------
local function getAE2Link()
    local success, controller = pcall(component.getPrimary, "me_controller")
    if success and controller then
        return controller
    end

    local success2, interface = pcall(component.getPrimary, "me_interface")
    if success2 and interface then
        return interface
    end

    error('Unable to find AE2 connection (Controller or Interface).')
end


local WaterMonitor = {}
WaterMonitor.__index = WaterMonitor

function WaterMonitor.new(config)
    local self = setmetatable({}, WaterMonitor)

    self.steps = {}
    self.lookup = {}
    self.direction = config.direction

    self.AE = getAE2Link()

    -- Map config options to line steps.
    for i = 1, 8 do
        local key = 'Grade' .. i
        local data = config.steps[key]

        if data ~= nil then
            local step = linestep.new(key, data.limit, data.color)
            table.insert(self.steps, step)
            self.lookup[step.fluidLabel] = step

            print('Registering ' .. key .. ' for fluid ' .. step.fluidLabel)
        end
    end

    -- Disable all steps in the waterline.
    self:disable()

    return self
end

function WaterMonitor:tick()
    for _, step in ipairs(self.steps) do

    end
end

function WaterMonitor:updateFluids()
    print('Updating steps with current AE2 fluid levels...')
    local allFluids = self.AE.getFluidsInNetwork()
    for _, fluid in ipairs(allFluids) do
        local step = self.lookup[fluid.label]
        if step ~= nil then
            step:updateAmount(fluid.amount)
        end
    end
end

function WaterMonitor:disable()
    for step in pairs(self.steps) do
        step:disable(self.direction)
    end
end

function WaterMonitor:disableActive()
    for _, step in ipairs(self.steps) do
        if step.isEnabled == true then
            step:disable(self.direction)
        end
    end
end

return WaterMonitor
