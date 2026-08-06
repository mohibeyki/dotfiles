local host = require("generated-host")

for _, env in ipairs(host.env) do
    hl.env(env[1], env[2])
end

for _, monitor in ipairs(host.monitors) do
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
