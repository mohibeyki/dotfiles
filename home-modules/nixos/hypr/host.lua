local host = require("generated-host")

for _, env in ipairs(host.env) do
    hl.env(env[1], env[2])
end

for _, monitor in ipairs(host.monitors) do
    hl.monitor(monitor)
end

local function trim(value)
    return value:match("^%s*(.-)%s*$")
end

local function workspace_rule(value)
    local rule = {}
    local index = 0

    local function warn(message)
        print("[hypr host] " .. message)
    end

    for raw in value:gmatch("[^,]+") do
        index = index + 1
        local part = trim(raw)

        if index == 1 then
            rule.workspace = part
        else
            local key, raw_value = part:match("^([^:]+):(.+)$")
            if key ~= nil then
                key = trim(key)
                raw_value = trim(raw_value)

                if key == "monitor" then
                    rule.monitor = raw_value
                elseif key == "default" then
                    rule.default = raw_value == "true"
                elseif key == "persistent" then
                    rule.persistent = raw_value == "true"
                else
                    warn("Ignoring unknown workspace key '" .. key .. "' in rule: " .. value)
                end
            else
                warn("Ignoring malformed workspace segment '" .. part .. "' in rule: " .. value)
            end
        end
    end

    hl.workspace_rule(rule)
end

for _, workspace in ipairs(host.workspaces) do
    workspace_rule(workspace)
end
