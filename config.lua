local colors = require("colors")
local sides = require('sides')

local config = {
    -- Minimum water level to maintain for each step
    steps = {
        Grade1 = { limit = 5000,        color = colors.white },
        Grade2 = { limit = 10000,       color = colors.pink },
        Grade3 = { limit = 2500,        color = colors.green },
        Grade4 = { limit = 8000,        color = colors.red },
        Grade5 = { limit = 12000,       color = colors.yellow },
        Grade6 = { limit = 4500,        color = colors.blue },
        Grade7 = { limit = 9000,        color = colors.purple },
        Grade8 = { limit = 3000,        color = colors.black },
    },
    direction = sides.west,
}

return config
