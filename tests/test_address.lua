package.path = package.path .. ";../?.lua"

local address_data = require('test_files/address_data')

local luaunit = require('luaunit')

local test_file_dir = './test_files/'

local interface_data = io.open('test_files/interface_data.lua'):read('*a')

routes = { {
    mask = 0,
    nexthop = "192.168.0.1",
    source = "192.168.0.144/32",
    target = "0.0.0.0"
  } }

ipv4_address = {
  address = "192.168.0.144",
  mask = 24
}

interface = {
  autostart = true,
  available = true,
  data = {
    hostname = "08-00-27-4F-CB-2E",
    leasetime = 86400
  },
  delegation = true,
  device = "eth2",
  ["dns-search"] = {},
  ["dns-server"] = { "192.168.0.1" },
  dns_metric = 0,
  dynamic = false,
  inactive = {
    ["dns-search"] = {},
    ["dns-server"] = {},
    ["ipv4-address"] = {},
    ["ipv6-address"] = {},
    neighbors = {},
    route = {}
  },
  interface = "lan",
  ["ipv4-address"] = { {
      address = "192.168.0.144",
      mask = 24
    } },
  ["ipv6-address"] = {},
  ["ipv6-prefix"] = {},
  ["ipv6-prefix-assignment"] = {},
  l3_device = "eth2",
  metric = 0,
  neighbors = {},
  pending = false,
  proto = "dhcp",
  route = { {
      mask = 0,
      nexthop = "192.168.0.1",
      source = "192.168.0.144/32",
      target = "0.0.0.0"
    } },
  up = true,
  updated = { "addresses", "routes", "data" },
  uptime = 1973
}

address_array = {
    address="192.168.0.144",
    family="ipv4",
    gateway="192.168.0.1",
    mask=24,
    proto="dhcp"
}

-- to be removed once address.lua is connected
function find_default_gateway(routes)
    for i = 1, #routes do
        if routes[i].target == '0.0.0.0' then
            return routes[i].nexthop
        end
    end
    return nil
end

-- remove once address.lua is connected
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
