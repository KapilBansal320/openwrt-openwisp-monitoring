package.path = package.path .. ";../?.lua"

local luaunit = require('luaunit')

local dhcp = require('dhcp')

local test_file_dir = './test_files/'

uci_cursor.get_all = function(arg)
	if arg == 'dhcp' then
		return io.open(test_file_dir .. 'dhcp.txt')
	end
end

io.open = function(arg)
	if arg == '/tmp/dhcp.leases' then
		return io.open(test_file_dir .. 'dhcp_leases.txt')


function test_get_dhcp_leases()
	
end

os.exit( luaunit.LuaUnit.run() )
