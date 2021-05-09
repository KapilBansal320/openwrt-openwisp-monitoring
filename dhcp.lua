uci = require('uci')
uci_cursor = uci.cursor()

utils = require('utils')

function parse_dhcp_lease_file(path, leases)
    local f = io.open('tests/test_files/dhcp_leases.txt', 'r')
    if not f then
        return leases
    end

    for line in f:lines() do
        local expiry, mac, ip, name, id = line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
        table.insert(leases, {
            expiry = tonumber(expiry),
            mac = mac,
            ip = ip,
            client_name = name,
            client_id = id
        })
    end

    return leases
end

function get_dhcp_leases()
    local dhcp_configs = uci_cursor:get_all('dhcp')
    local leases = {}

    if utils.is_table_empty(dhcp_configs) then
        return nil
    end

    for name, config in pairs(dhcp_configs) do
        if config and config['.type'] == 'dnsmasq' and config.leasefile then
            leases = parse_dhcp_lease_file(config.leasefile, leases)
        end
    end
    return leases
end

print(get_dhcp_leases())