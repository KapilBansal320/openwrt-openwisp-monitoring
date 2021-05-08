#!/usr/bin/env lua
-- retrieve monitoring information
-- and return it as NetJSON Output
io = require('io')
ubus_lib = require('ubus')
cjson = require('cjson')
utils = require('utils')

ubus = ubus_lib.connect()
if not ubus then
    error('Failed to connect to ubusd')
end

-- collect system info
system_info = ubus:call('system', 'info', {})
board = ubus:call('system', 'board', {})
loadavg_output = io.popen('cat /proc/loadavg'):read()
loadavg_output = utils.split(loadavg_output, ' ')
load_average = {tonumber(loadavg_output[1]), tonumber(loadavg_output[2]), tonumber(loadavg_output[3])}

-- init netjson data structure
netjson = {
    type = 'DeviceMonitoring',
    general = {
        hostname = board.hostname,
        local_time = system_info.localtime,
        uptime = system_info.uptime
    },
    resources = {
        load = load_average,
        memory = system_info.memory,
        swap = system_info.swap
    }
}

-- determine the monitored interfaces
monitored_interfaces = arg[1]
monitored = {}
if monitored_interfaces then
    monitored_interfaces = utils.split(monitored_interfaces, ' ')
    for i, name in pairs(monitored_interfaces) do
        monitored[name] = true
    end
end

-- collect device data
network_status = ubus:call('network.device', 'status', {})
interfaces = {}

-- collect interface stats
for name, interface in pairs(network_status) do
    -- only collect data for specified interfaces
    if monitored[name] then
        netjson_interface = {
            name = name,
            statistics = interface.statistics
        }
        table.insert(interfaces, netjson_interface)
    end
end

if next(interfaces) ~= nil then
    netjson.interfaces = interfaces
end

print(cjson.encode(netjson))
