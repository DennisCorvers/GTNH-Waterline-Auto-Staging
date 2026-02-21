local redstone = require('util.redstone')

local LineStep = {}
LineStep.__index = LineStep

local fluidMap = {
    Grade1 = 'Filtered Water (Grade 1)',
    Grade2 = 'Ozonated Water (Grade 2)',
    Grade3 = 'Flocculated Water (Grade 3)',
    Grade4 = 'pH Neutralized Water (Grade 4)',
    Grade5 = 'Extreme-Temperature Treated Water (Grade 5)',
    Grade6 = 'Ultraviolet Treated Electrically Neutral Water (Grade 6)',
    Grade7 = 'Degassed Decontaminant-Free Water (Grade 7)',
    Grade8 = 'Subatomically Perfect Water (Grade 8)',
}

local function parseGrade(grade)
    local label = fluidMap[grade]
    if label == nil then
        error('Incorrect waterline step name for: ' .. grade)
    end
    return label
end

function LineStep.new(grade, limit, colour)
    local self = setmetatable({}, LineStep)

    self.limit = limit;
    self.isEnabled = false

    self.colour = colour;
    self.fluidLabel = parseGrade(grade)
    self.amount = 0

    return self
end

function LineStep:enable(side)
    redstone.setRedstone(self.colour, side)
    self.isEnabled = true
end

function LineStep:disable(side)
    redstone.clearRedstone(self.colour, side)
    self.isEnabled = false
end

function LineStep:updateAmount(amount)
    self.amount = amount
end

return LineStep
