local component = require('component')
local linestep = require('data.step')
local data = require('data.data')
local ctrl = require('data.controller')
local oc = require('util.oc')

------ LOCAL FUNCTIONS ------
local function getAE2Link()
    local success, controller = pcall(component.getPrimary, "me_controller")
    if success and controller then
        print('Found AE2 controller')
        return controller
    end

    local success2, interface = pcall(component.getPrimary, "me_interface")
    if success2 and interface then
        print('Found AE2 interface')
        return interface
    end

    error('Unable to find AE2 connection (Controller or Interface).')
end

local function initStep(key, limit)
    local dataEntry = data[key]
    if dataEntry == nil then
        error('There is no data entry for the given key: ' .. key)
    end

    -- Try to find the step on the network
    local machine = oc.findGTMachine(dataEntry.name)
    if machine == nil then
        return nil
    end

    local machineName = dataEntry.name
    local fluidName = dataEntry.fluid
    return linestep.new(machine, machineName, limit, fluidName)
end

local function registerSteps(config)
    local steps = {}

    for i = 1, 8 do
        local key = 'Grade' .. i
        local configEntry = config[key]

        if configEntry ~= nil then
            local step = initStep(key, configEntry.limit)

            if step == nil then
                print('Unable to find machine for step: ' .. key)
            else
                print('Registered machine for step: ' .. key)
            end

            table.insert(steps, step)
        end
    end

    return steps
end

local function getNextStep(steps)
    local nextStep = nil
    for _, step in ipairs(steps) do
        if step.amount < step.limit then
            nextStep = step
            break
        end
    end
    return nextStep
end

local WaterMonitor = {}
WaterMonitor.__index = WaterMonitor

function WaterMonitor.new(config)
    local self = setmetatable({}, WaterMonitor)

    self.steps = {}
    self.lookup = {}

    self.AE = getAE2Link()
    self.controller = ctrl.new()
    self.activeStep = nil
    self.scheduledStep = false

    -- Find all steps on the waterline
    local steps = registerSteps(config)
    self.steps = steps
    self.lookup = {}

    for _, step in ipairs(self.steps) do
        if step.fluidLabel then
            self.lookup[step.fluidLabel] = step
        end
    end

    -- Disable all steps in the waterline.
    self:disable()

    return self
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
    for _, step in ipairs(self.steps) do
        step:disable()
    end
end

function WaterMonitor:swapSteps(next)
    local current = self.activeStep
    self.activeStep = next

    if current and (not next or current.name ~= next.name) then
        if not next then
            print("All limits met. Waiting...")
        else
            print("Switching: " .. current.fluidLabel .. " -> " .. next.fluidLabel)
        end
        current:disable()
    end

    if next then
        print(string.format("Scheduled step %s %d | %d", next.fluidLabel, next.amount, next.limit))
        next:enable()
    end
end

function WaterMonitor:loop()
    if self.controller:isEnabled() == false then
        print('Controller is disabled, waiting...')
        return
    end

    local progress = self.controller:getProgress()

    if progress < 60 then
        -- Ready monitor to setup next cycle
        self.scheduledStep = false
        return
    end

    if self.scheduledStep == true then
        return
    end

    self:updateFluids()
    local nextStep = getNextStep(self.steps)
    self:swapSteps(nextStep)
    self.scheduledStep = true
end

return WaterMonitor
