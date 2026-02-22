local watermonitor = require('data.monitor')
local config = require('config')


local monitor = watermonitor.new(config)

-- Disable all steps first.
monitor:disable()

while true do
    monitor:loop()
    os.sleep(30)
end