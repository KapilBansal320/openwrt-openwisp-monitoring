package.path = package.path .. ";../?.lua"

local miscellaneous_functions = require('miscellaneous_functions')

local luaunit = require('luaunit')

local test_file_dir = './test_files/'

local miscellaneous_data = require('test_files/miscellaneous_data')

io.popen = function(arg)
	if arg == 'df' then
		return io.open(test_file_dir .. 'disk_usage.txt')
	elseif arg == 'cat /proc/cpuinfo | grep -c processor' then
		return '8'
	end
end

function test_disk_usage()
	luaunit.assertEquals(miscellaneous_functions.parse_disk_usage(), miscellaneous_data.disk_usage)
end

function test_get_cpus()
	luaunit.assertEquals(miscellaneous_functions.get_cpus(), 8)
end

os.exit( luaunit.LuaUnit.run() )
