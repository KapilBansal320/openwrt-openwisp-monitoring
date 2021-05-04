package.path = package.path .. ";../?.lua"

local luaunit = require('luaunit')

local basic_functions = require('../basic_functions')

function testSplitFunction()
	-- When pattern is present
	luaunit.assertEquals(basic_functions.split("OpenWISP","n"), {"Ope", "WISP"})
	luaunit.assertEquals(basic_functions.split("OpenWISP","WISP"), {"Open"})

	-- When pattern is not available
	luaunit.assertEquals(basic_functions.split("OpenWISP","a"), {"OpenWISP"})
end

function testHasValue()
	-- When value is present
	luaunit.assertEquals(basic_functions.has_value({2,4,5},4), true)
	luaunit.assertEquals(basic_functions.has_value({1,2,3,7,9},9), true)

	-- When valuaunite is not present
	luaunit.assertEquals(basic_functions.has_value({2,4,5},3), false)
	luaunit.assertEquals(basic_functions.has_value({1,2,3,7,9},8), false)

end

function testStartsWith()
	-- When valuaunite is present
	-- luaunit.assertEquals(netjson_monitoring.)

end

os.exit(luaunit.LuaUnit.run())
