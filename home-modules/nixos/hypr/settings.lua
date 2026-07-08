hl.config({
    general = {
        border_size = 0,
        gaps_in = 8,
        gaps_out = 8,
        layout = "dwindle",
    },
    input = {
        kb_layout = "us",
        kb_options = "altwin:swap_lalt_lwin",
        numlock_by_default = true,
        follow_mouse = 1,
        mouse_refocus = false,
        sensitivity = -0.2,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
        },
    },
    decoration = {
        rounding = 8,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        blur = {
            enabled = true,
            size = 16,
            passes = 4,
            ignore_opacity = true,
            xray = false,
        },
        shadow = {
            enabled = true,
            range = 16,
            render_power = 3,
            color = "0xee1a1a1a",
        },
    },
    animations = {
        enabled = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        font_family = "JetBrainsMono Nerd Font",
    },
    dwindle = {
        preserve_split = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.animation({ leaf = "global", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "default", style = "popin 60%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "default", style = "slide" })

hl.on("hyprland.start", function()
    hl.dispatch(hl.dsp.exec_cmd("systemctl --user start plasma-kwallet-pam.service"))
    hl.dispatch(hl.dsp.exec_cmd("@kservice@/bin/kbuildsycoca6"))
    hl.dispatch(hl.dsp.exec_cmd("@polkitKde@/libexec/polkit-kde-authentication-agent-1"))
    hl.dispatch(hl.dsp.exec_cmd("@blueman@/bin/blueman-applet"))
    @shellStartup@
    hl.dispatch(hl.dsp.exec_cmd("@onePassword@/bin/1password --silent"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch workspace 1"))
    hl.dispatch(hl.dsp.exec_cmd("hyprctl dispatch workspace 2"))
end)
