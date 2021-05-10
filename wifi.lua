#!/usr/bin/env lua

wifi = {}

function wifi.parse_hostapd_clients(clients)
  local data = {}
  for mac, properties in pairs(clients) do
      properties.mac = mac
      table.insert(data, properties)
  end
  return data
end

function wifi.parse_iwinfo_clients(clients)
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

return wifi
