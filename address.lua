utils = require('utils')
nixio = require('nixio')
ubus_lib = require('ubus')

ubus = ubus_lib.connect()
-- if not ubus then
--     error('Failed to connect to ubusd')
-- end

interface_data = ubus:call('network.interface', 'dump', {})
nixio_data = nixio.getifaddrs()

function find_default_gateway(routes)
    for i = 1, #routes do
        if routes[i].target == '0.0.0.0' then
            return routes[i].nexthop
        end
    end
    return nil
end

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

-- collect interface addresses
function get_addresses(name)
    addresses = {}
    interface_list = interface_data['interface']
    addresses_list = {}
    for _, interface in pairs(interface_list) do
        if interface['l3_device'] == name then
            proto = interface['proto']
            if proto == 'dhcpv6' then
                proto = 'dhcp'
            end
            for _, address in pairs(interface['ipv4-address']) do
                table.insert(addresses_list, address['address'])
                new_address = new_address_array(address, interface, 'ipv4')
                table.insert(addresses, new_address)
            end
            for _, address in pairs(interface['ipv6-address']) do
                table.insert(addresses_list, address['address'])
                new_address = new_address_array(address, interface, 'ipv6')
                table.insert(addresses, new_address)
            end
        end
    end
    for i = 1, #nixio_data do
        if nixio_data[i].name == name then
            if not is_excluded(name) then
                family = nixio_data[i].family
                addr = nixio_data[i].addr
                if family == 'inet' then
                    family = 'ipv4'
                    -- Since we don't already know this from the dump, we can
                    -- consider this dynamically assigned, this is the case for
                    -- example for OpenVPN interfaces, which get their address
                    -- from the DHCP server embedded in OpenVPN
                    proto = 'dhcp'
                elseif family == 'inet6' then
                    family = 'ipv6'
                    if utils.starts_with(addr, 'fe80') then
                        proto = 'static'
                    else
                        ula = uci_cursor.get('network', 'globals', 'ula_prefix')
                        ula_prefix = utils.split(ula, '::')[1]
                        if utils.starts_with(addr, ula_prefix) then
                            proto = 'static'
                        else
                            proto = 'dhcp'
                        end
                    end
                end
                if family == 'ipv4' or family == 'ipv6' then
                    if not utils.has_value(addresses_list, addr) then
                        table.insert(addresses, {
                            address = addr,
                            mask = nixio_data[i].prefix,
                            proto = proto,
                            family = family
                        })
                    end
                end
            end
        end
    end
    return addresses
end

print(get_addresses('eth2'))
