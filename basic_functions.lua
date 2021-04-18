-- split function
function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function starts_with(str, start)
    return str:sub(1, #start) == start
end

function is_table_empty(table_)
    return not table_ or next(table_) == nil
end

function array_concat(source, destination)
    table.foreach(source, function(key, value)
        table.insert(destination, value)
    end)
end

function dict_merge(source, destination)
    table.foreach(source, function(key, value)
        destination[key] = value
    end)
end
