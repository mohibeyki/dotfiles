local host = require("generated-host")

local function secondary_disabled()
    local state_home = os.getenv("XDG_STATE_HOME")
    if not state_home or state_home == "" then
        local home = os.getenv("HOME")
        if not home then
            return false
        end
        state_home = home .. "/.local/state"
    end

    local file = io.open(state_home .. "/hypr/secondary-monitor", "r")
    if not file then
        return false
    end

    local line = file:read("*l")
    file:close()
    return line == "disabled"
end

local disable_secondary = secondary_disabled()

for _, monitor in ipairs(host.monitors) do
    if disable_secondary and monitor.output == host.secondaryMonitorOutput then
        monitor.disabled = true
    end
    hl.monitor(monitor)
end

for _, workspace in ipairs(host.workspaces) do
    hl.workspace_rule({
        workspace = tostring(workspace.id),
        monitor = workspace.monitor,
        default = workspace.default,
        persistent = workspace.persistent,
    })
end
