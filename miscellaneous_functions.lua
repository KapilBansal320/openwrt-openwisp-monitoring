#!/usr/bin/env lua

utils = require('utils')
uci = require('uci')
uci_cursor = uci.cursor()


function parse_hostapd_clients(clients)
  local data = {}
  for mac, properties in pairs(clients) do
      properties.mac = mac
      table.insert(data, properties)
  end
  return data
end

function parse_iwinfo_clients(clients)
  local data = {}
  for i, p in pairs(clients) do
      client = {}
      client.ht = p.rx.ht
      client.mac = p.mac
      client.authorized = p.authorized
      client.vht = p.rx.vht
      client.wmm = p.wme
      client.mfp = p.mfp
      client.auth = p.authenticated
      client.signal = p.signal
      client.noise = p.noise
      table.insert(data, client)
  end
  return data
end

function parse_disk_usage()
    file = io.popen('df')
    disk_usage_info = {}
    for line in file:lines() do
        if line:sub(1, 10) ~= 'Filesystem' then
            filesystem, size, used, available, percent, location =
                line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
            if filesystem ~= 'tmpfs' and not string.match(filesystem, 'overlayfs') then
                percent = percent:gsub('%W', '')
                -- available, size and used are in KiB
                table.insert(disk_usage_info, {
                    filesystem = filesystem,
                    available_bytes = tonumber(available) * 1024,
                    size_bytes = tonumber(size) * 1024,
                    used_bytes = tonumber(used) * 1024,
                    used_percent = tonumber(percent),
                    mount_point = location
                })
            end
        end
    end
    file:close()
    return disk_usage_info
end

function get_cpus()
    processors = io.popen('cat /proc/cpuinfo | grep -c processor')
    cpus = tonumber(processors:read('*a'))
    processors:close()
    return cpus
end

function get_vpn_interfaces()
    -- only openvpn supported for now
    local items = uci_cursor:get_all('openvpn')
    local vpn_interfaces = {}

    if utils.is_table_empty(items) then
        return {}
    end

    for name, config in pairs(items) do
        if config and config.dev then
            vpn_interfaces[config.dev] = true
        end
    end
    return vpn_interfaces
end
