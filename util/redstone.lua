local component = require("component")

local redstone = {}

function redstone.setRedstone(colour, side)
    local rs = component.redstone
    rs.setBundledOutput(side, { [colour] = 15 })
end

function redstone.clearRedstone(colour, side)
    local rs = component.redstone
    rs.setBundledOutput(side, { [colour] = 0 })
end

return redstone
