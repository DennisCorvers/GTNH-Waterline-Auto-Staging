local oc = require('util.oc')

local machine = oc.findGTMachine("multimachine.purificationunitphadjustment")



local function listMethods(obj)
    print("--- Methods/Properties for Object ---")
    -- Check the object itself
    for k, v in pairs(obj) do
        print(string.format("Property: %-15s [%s]", k, type(v)))
    end
    
    -- Check the metatable (where the functions live)
    local mt = getmetatable(obj)
    if mt and mt.__index then
        for k, v in pairs(mt.__index) do
            print(string.format("Function: %-15s [%s]", k, type(v)))
        end
    end
end

-- Usage:
listMethods(machine)