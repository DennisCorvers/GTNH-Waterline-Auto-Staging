local component = require("component")

local oc = {}

function oc.findGTMachine(machineName)
    for key, value in pairs(component.list()) do
        if value == "gt_machine" then
            local machineProxy = component.proxy(key, "gt_machine")
            if machineProxy.getName() == machineName then
                return machineProxy
            end
        end
    end

    return nil
end

return oc
