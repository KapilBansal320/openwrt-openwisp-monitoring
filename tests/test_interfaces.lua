package.path = package.path .. ";../?.lua"
package.loaded.ubus = {
    connect = function()
        return {
            call = function(...)
                return require('test_files/interface_data')
            end
        }
    end
}

local interface_functions = require('interfaces')

local luaunit = require('luaunit')

local test_file_dir = './test_files/'
local address_data = require('test_files/address_data')

function test_find_default_gateway()
	luaunit.assertEquals(interface_functions.find_default_gateway(address_data.routes), "192.168.0.1")
end

function test_new_address_array()
	luaunit.assertEquals(interface_functions.new_address_array(address_data.ipv4_address, address_data.eth2_interface, 'ipv4'), address_data.address_array)
end

os.exit( luaunit.LuaUnit.run() )
