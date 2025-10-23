{ ... }:
{
  programs.waybar.style = ''
    * {
        font-family: Hack Nerd Font;
        font-weight: 400;
        font-size: 12px;
        border-radius: 7px;
    }

    window#waybar {
        background-color: transparent;
        color: #ffffff;
        border-radius: 8px;
    }

    #waybar > box {
        margin: 4px 8px 0 8px;
        padding: 2px;
        background-color: rgba(0, 0, 0, 0.1);
        border-radius: 8px;
    }

    tooltip {
        background: rgb(30, 30, 46);
        border-radius: 7px;
    }

    window#waybar.termite {
        background-color: #3f3f3f;
    }

    window#waybar.chromium {
        background-color: #11111b;
        border: none;
    }

    button {
        /* Use box-shadow instead of border so the text isn't offset */
        box-shadow: inset 0 3px transparent;
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 0;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    button:hover {
        background: inherit;
    }
    #workspaces button {
        padding: 0 5px;
        color: #ffffff;
        background-color: transparent;
    }

    #workspaces button:hover {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 7px;
    }

    #workspaces button.focused {
        background-color: rgba(0, 0, 0, 0.1);
        box-shadow: inset 0 0px #ffffff;
    }

    #workspaces button.urgent {
        background-color: #eb4d4b;
        border-radius: 7px;
    }

    #workspaces button.visible {
        background: rgba(255, 255, 255, 0.1);
        border-radius: 7px;
    }

    #mode {
        background-color: #64727d;
        box-shadow: inset 0 0px #ffffff;
        background: rgba(5, 5, 5, 0.3);
        color: #000000;
        padding: 1px 10px 1px 10px;
        border-radius: 0px 0px 0px 0px;
        margin-top: 5px;
    }

    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #custom-swaync,
    #backlight,
    #pulseaudio,
    #wireplumber,
    #tray,
    #mode,
    #custom-weather,
    #idle_inhibitor,
    #scratchpad,
    #custom-power #power-profiles-daemon,
    #custom-gpt,
    #mpd {
        background: rgba(30, 30, 46, 0);
        padding: 1px 10px 1px 10px;
    }

    #window,
    #workspaces {
        color: #f5e0dc;
        padding: 1px 1px 1px 1px;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }

    #clock {
        color: #ffffff;
        margin-right: 5px;
    }

    #clock:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #custom-weather {
        color: #ffffff;
        padding: 1px 6px 1px 8px;
    }

    #custom-weather:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #custom-gpt {
        font-size: 20px;
        background-image: url("/etc/xdg/waybar/icons/openai-transparent.png");
        background-position: center;
        background-repeat: no-repeat;
        background-size: 15px 15px;
        color: #ffffff;
        border-radius: 7px;
    }

    #custom-gpt:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #cava-player .status {
        font-size: 18px;
        color: #ffffff; /* White icon color */
    }

    #custom-power {
        color: #ffffff;
        padding: 1px 5px 1px 3px;
        margin-right: 1px;
    }

    #custom-power:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #battery {
        color: #ffffff;
    }

    #battery.charging,
    #battery.plugged {
        color: #85eb81;
    }

    #battery:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    @keyframes blink {
        to {
            background: rgb(30, 30, 46);
            color: #000000;
            padding: 1px 10px 1px 10px;
            margin-top: 5px;
        }
    }

    /* Using steps() instead of linear as a timing function to limit cpu usage */
    #battery.critical:not(.charging) {
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: steps(12);
        animation-iteration-count: infinite;
        animation-direction: alternate;
    }

    #power-profiles-daemon {
        padding-right: 15px;
        color: #000000;
    }

    #power-profiles-daemon.performance {
        color: #ffffff;
    }

    #power-profiles-daemon.balanced {
        color: #ffffff;
    }

    #power-profiles-daemon.power-saver {
        color: #000000;
    }

    label:focus {
        background: rgb(30, 30, 46);
    }

    #memory {
        color: #ffffff;
        padding: 1px 9px 1px 5px;
    }

    #memory:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #disk {
        background: rgb(30, 30, 46);
    }

    #backlight {
        color: #ffffff;
    }

    #pulseaudio {
        color: #ffffff;
    }

    #pulseaudio.muted {
        color: #ffffff;
    }

    #wireplumber {
        color: #000000;
    }

    #pulseaudio:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #wireplumber.muted {
        background: rgb(30, 30, 46);
        padding: 1px 10px 1px 10px;
        margin-top: 5px;
    }

    #custom-media {
        color: #2a5c45;
        min-width: 100px;
    }

    #custom-media.custom-vlc {
        background: rgb(30, 30, 46);
        margin-top: 5px;
    }

    #custom-swaync {
        color: #ffffff;
    }

    #custom-swaync:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #tray {
        background-color: #2980b9;
    }

    #tray > .passive {
        -gtk-icon-effect: dim;
    }

    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
    }

    #idle_inhibitor {
        color: #ffffff;
        padding: 1px 12px 1px 5px;
    }

    #idle_inhibitor.activated {
        color: #ffffff;
    }

    #idle_inhibitor:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #mpd {
        background-color: #66cc99;
        color: #2a5c45;
    }

    #mpd.disconnected {
        background-color: #f53c3c;
    }

    #mpd.stopped {
        background-color: #90b1b1;
    }

    #mpd.paused {
        background-color: #51a37a;
    }

    #language {
        background: #00b093;
        color: #740864;
        padding: 0 5px;
        margin: 0 5px;
        min-width: 16px;
    }

    #keyboard-state {
        background: #97e1ad;
        color: #000000;
        padding: 0 0px;
        margin: 0 5px;
        min-width: 16px;
    }

    #keyboard-state > label {
        padding: 0 5px;
    }

    #keyboard-state > label.locked {
        background: rgb(30, 30, 46);
    }

    #scratchpad {
        background: rgb(30, 30, 46);
        background: rgba(5, 5, 5, 0.2);
        color: #000000;
        padding: 1px 10px 1px 10px;
        margin-top: 5px;
    }

    #scratchpad.empty {
        background-color: transparent;
        background: rgb(30, 30, 46);
        color: #000000;
        padding: 1px 10px 1px 10px;
        margin-top: 5px;
    }

    #privacy {
        padding: 0;
    }

    #privacy-item {
        padding: 0 5px;
        color: white;
    }

    #privacy-item.screenshare {
        background-color: #cf5700;
    }

    #privacy-item.audio-in {
        background-color: #1ca000;
    }

    #privacy-item.audio-out {
        background-color: #0069d4;
    }
  '';
}
