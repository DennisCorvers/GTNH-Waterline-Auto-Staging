local watermonitor = require('data.watermonitor')
local config = require('config')
local component = require('component')


local monitor = watermonitor.new(config)
monitor:disable()


