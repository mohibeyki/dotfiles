-- Caelestia shell binds
exec(main_mod .. " + P", "caelestia shell drawers toggle launcher")
exec(main_mod .. " + SHIFT + P", "caelestia shell drawers toggle session")
exec(main_mod .. " + V", "caelestia clipboard")
exec(main_mod .. " + comma", "caelestia shell drawers toggle sidebar")
exec(main_mod .. " + period", "caelestia emoji -p")
exec(main_mod .. " + CTRL + escape", "caelestia shell lock lock")
exec(main_mod .. " + CTRL + Q", "caelestia shell drawers toggle session")
exec("XF86AudioPlay", "caelestia shell mpris playPause")
exec("XF86AudioPrev", "caelestia shell mpris previous")
exec("XF86AudioNext", "caelestia shell mpris next")
exec("XF86AudioRaiseVolume", "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", volume_options)
exec("XF86AudioLowerVolume", "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", volume_options)
exec("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", volume_options)

-- Screenshots via Caelestia
exec("Print", "caelestia screenshot")
exec(main_mod .. " + Print", "caelestia screenshot -r")
exec(main_mod .. " + SHIFT + S", "caelestia screenshot -r")
