hl.layer_rule({
    name = "logout-dialog-blur",
    match = { namespace = "logout_dialog" },
    blur = true,
})

hl.layer_rule({
    name = "selection-no-anim",
    match = { namespace = "^(selection)$" },
    no_anim = true,
})

hl.window_rule({ name = "tag-chromium", match = { class = "([cC]hrom(e|ium)|[bB]rave-browser|Microsoft-edge|Vivaldi-stable)" }, tag = "+chromium-based-browser" })
hl.window_rule({ name = "tag-firefox", match = { class = "([fF]irefox|zen|librewolf)" }, tag = "+firefox-based-browser" })
hl.window_rule({ name = "tag-terminal", match = { class = "(Alacritty|kitty|com.mitchellh.ghostty)" }, tag = "+terminal" })
hl.window_rule({ name = "tag-game", match = { initial_class = "^(steam_app_.*)$" }, tag = "+game" })
hl.window_rule({ name = "tag-floating-centered", match = { class = "^(1password)$" }, tag = "+floating-centered" })
hl.window_rule({ name = "tag-steam-chat", match = { class = "^(steam)$", title = "^(Friends List|Chat)$" }, tag = "+steam-chat" })
hl.window_rule({ name = "tag-wiremix", match = { class = "^(com.github.tsowell.wiremix)$" }, tag = "+quick-access" })
hl.window_rule({ name = "tag-kcalc", match = { class = "^(org.kde.kcalc)$" }, tag = "+quick-access" })
hl.window_rule({ name = "tag-gparted", match = { class = "^(gparted)$" }, tag = "+quick-access" })
hl.window_rule({ name = "tag-transmission", match = { class = "^(transmission-gtk)$" }, tag = "+quick-access" })
hl.window_rule({ name = "tag-pavucontrol", match = { class = "^(org.pulseaudio.pavucontrol)$" }, tag = "+quick-access" })
hl.window_rule({ name = "tag-nm-editor", match = { title = "^(nm-connection-editor)$" }, tag = "+quick-access" })
hl.window_rule({ name = "tag-floating-window", match = { class = "(Impala|com.gabm.satty|About|TUI.float)" }, tag = "+floating-window" })
hl.window_rule({ name = "tag-file-dialogs", match = { class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors)", title = "^(Open.*Files?|Open [Ff]older.*|Save.*Files?|Save.*As|Save|All Files)" }, tag = "+floating-window" })

hl.window_rule({ name = "games-workspace", match = { tag = "game" }, workspace = "9 silent" })
hl.window_rule({ name = "games-fullscreen", match = { tag = "game" }, fullscreen = true })
hl.window_rule({ name = "chromium-tile", match = { tag = "chromium-based-browser" }, tile = true })

hl.window_rule({ name = "floating-centered-float", match = { tag = "floating-centered" }, float = true })
hl.window_rule({ name = "floating-centered-center", match = { tag = "floating-centered" }, center = true })
hl.window_rule({ name = "floating-centered-size", match = { tag = "floating-centered" }, size = "1200 800" })

hl.window_rule({ name = "steam-chat-float", match = { tag = "steam-chat" }, float = true })

hl.window_rule({ name = "quick-access-float", match = { tag = "quick-access" }, float = true })
hl.window_rule({ name = "quick-access-center", match = { tag = "quick-access" }, center = true })

hl.window_rule({ name = "floating-window-float", match = { tag = "floating-window" }, float = true })
hl.window_rule({ name = "floating-window-center", match = { tag = "floating-window" }, center = true })
hl.window_rule({ name = "floating-window-size", match = { tag = "floating-window" }, size = "800 600" })

hl.window_rule({ name = "gparted-size", match = { class = "^(gparted)$" }, size = "900 700" })
hl.window_rule({ name = "transmission-size", match = { class = "^(transmission-gtk)$" }, size = "900 600" })

hl.window_rule({ name = "pip-float", match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ name = "pip-pin", match = { title = "^(Picture-in-Picture)$" }, pin = true })
hl.window_rule({ name = "pip-move", match = { title = "^(Picture-in-Picture)$" }, move = "69.5% 4%" })

hl.window_rule({ name = "screensaver-fullscreen", match = { class = "Screensaver" }, fullscreen = true })
hl.window_rule({ name = "idle-inhibit-fullscreen", match = { fullscreen = 1 }, idle_inhibit = "fullscreen" })
