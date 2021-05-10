package.path = package.path .. ";../?.lua"

-- local interface_functions = require('interface_functions')

local luaunit = require('luaunit')

local test_file_dir = './test_files/'
local address_data = require('test_files/address_data')
local interface_data = io.open('test_files/interface_data.lua'):read('*a')

-- to be removed once interface_functions.lua is connected
function find_default_gateway(routes)
    for i = 1, #routes do
        if routes[i].target == '0.0.0.0' then
            return routes[i].nexthop
        end
    end
    return nil
end

-- remove once interface_functions.lua is connected
function new_address_array(address, interface, family)
    proto = interface['proto']
    if proto == 'dhcpv6' then
        proto = 'dhcp'
    end
    new_address = {
        address = address['address'],
        mask = address['mask'],
        proto = proto,
        family = family,
        gateway = find_default_gateway(interface.route)
    }
    return new_address
end

function test_find_default_gateway()
	luaunit.assertEquals(find_default_gateway(address_data.routes), "192.168.0.1")
end

function test_new_address_array()
	luaunit.assertEquals(new_address_array(address_data.ipv4_address, address_data.eth2_interface, 'ipv4'), address_data.address_array)
end

os.exit( luaunit.LuaUnit.run() )
