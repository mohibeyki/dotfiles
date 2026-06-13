local main_mod = "SUPER"

local function bind(key, action, options)
    hl.bind(key, action, options or {})
end

local function exec(key, command, options)
    bind(key, hl.dsp.exec_cmd(command), options)
end

exec(main_mod .. " + RETURN", "ghostty")
exec(main_mod .. " + B", "brave")

bind(main_mod .. " + Q", hl.dsp.window.close())
exec(main_mod .. " + CTRL + R", "hyprctl reload")
bind(main_mod .. " + T", hl.dsp.window.float())
bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
bind(main_mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
exec(main_mod .. " + CTRL + SHIFT + Q", "hyprctl -j activewindow | jq -e '.pid' | xargs -I{} kill -9 {}")
bind(main_mod .. " + SHIFT + D", hl.dsp.layout("swapsplit"))
bind(main_mod .. " + SHIFT + S", hl.dsp.layout("togglesplit"))

exec(main_mod .. " + E", "dolphin")
exec(main_mod .. " + S", "grimblast copy area")
exec("Print", "grimblast save area")

local directions = {
    { "H", "left" },
    { "J", "down" },
    { "K", "up" },
    { "L", "right" },
    { "left", "left" },
    { "down", "down" },
    { "up", "up" },
    { "right", "right" },
}

for _, entry in ipairs(directions) do
    local key = entry[1]
    local direction = entry[2]

    bind(main_mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
end

for _, entry in ipairs(directions) do
    local key = entry[1]
    local direction = entry[2]

    bind(main_mod .. " + CTRL + " .. key, hl.dsp.window.move({ direction = direction }))
end

local resize_delta = {
    { "H", -100, 0 },
    { "J", 0, 100 },
    { "K", 0, -100 },
    { "L", 100, 0 },
    { "left", -100, 0 },
    { "down", 0, 100 },
    { "up", 0, -100 },
    { "right", 100, 0 },
}

for _, entry in ipairs(resize_delta) do
    bind(main_mod .. " + SHIFT + " .. entry[1], hl.dsp.window.resize({ x = entry[2], y = entry[3], relative = true }))
end

for _, entry in ipairs(directions) do
    local key = entry[1]
    local direction = entry[2]

    bind(main_mod .. " + ALT + " .. key, hl.dsp.window.swap({ direction = direction }))
end

bind(main_mod .. " + TAB", hl.dsp.focus({ workspace = "m+1" }))
bind(main_mod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "m-1" }))

for i = 1, 10 do
    local key = tostring(i % 10)
    local workspace = tostring(i)
    bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
end

local volume_options = { locked = true, repeating = true }

bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
