local lu = require('luaunit')

local basic_functions = require('basic_functions')

function testSplitFunction()
	-- When pattern is present
	lu.assertEquals(basic_functions.split("OpenWISP","n"), {"Ope", "WISP"})
	lu.assertEquals(basic_functions.split("OpenWISP","WISP"), {"Open"})

	-- When pattern is not available
	lu.assertEquals(basic_functions.split("OpenWISP","a"), {"OpenWISP"})
end

function testHasValue()
	-- When value is present
	lu.assertEquals(basic_functions.has_value({2,4,5},4), true)
	lu.assertEquals(basic_functions.has_value({1,2,3,7,9},9), true)

	-- When value is not present
	lu.assertEquals(basic_functions.has_value({2,4,5},3), false)
	lu.assertEquals(basic_functions.has_value({1,2,3,7,9},8), false)

end

function testRandom()
	-- When value is present
	-- lu.assertEquals(netjson_monitoring.)

end

os.exit( lu.LuaUnit.run() )
