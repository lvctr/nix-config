-- Shared Hyprland config.
-- Hardware-specific monitor layout stays in ~/.config/hypr/monitors.lua,
-- written per host by home/<name>.nix.

pcall(dofile, os.getenv("HOME") .. "/.config/hypr/monitors.lua")

local terminal = "kitty"
local fileManager = "pcmanfm"
local menu = "pkill rofi || rofi -theme default -show drun"
local openWindows = "pkill rofi || rofi -theme default -show window"

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("hyprpaper")
end)

hl.env("XCURSOR_THEME", "Simp1e-Solarized-Dark")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Simp1e-Solarized-Dark")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 1,
        col = {
            active_border = "rgb(2aa198)",
            inactive_border = "rgb(073642)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    render = {
        direct_scanout = true,
    },

    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = false,
        },
        blur = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    cursor = {
        no_warps = true,
    },

    misc = {
        vrr = true,
        middle_click_paste = false,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",
        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = true,
            tap_to_click = true,
            disable_while_typing = true,
            drag_3fg = false,
        },
    },
})

hl.device({
    name = "syna802e:00-06cb:cfa8-touchpad",
    sensitivity = 0,
    accel_profile = "adaptive",
})

hl.device({
    name = "tpps/2-elan-trackpoint",
    sensitivity = 0.4,
})

hl.device({
    name = "at-translated-set-2-keyboard",
    kb_options = "caps:swapescape",
})

hl.device({
    name = "wacom-intuos-pt-s-2-finger",
    sensitivity = 0,
    accel_profile = "adaptive",
})

hl.device({
    name = "logitech-mx-anywhere-3",
    sensitivity = 0,
    accel_profile = "flat",
})

hl.device({
    name = "razer-razer-mouse-dock-pro-1",
    sensitivity = 0,
    accel_profile = "flat",
})

hl.device({
    name = "bsk-v3-pro-mouse",
    sensitivity = 0,
    accel_profile = "flat",
})

hl.device({
    name = "logitech-g502-1",
    sensitivity = 0,
    accel_profile = "flat",
})

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(openWindows))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -ar"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("sh -c 'grim -g \"$(slurp)\" - | wl-copy'"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("sh -c 'grim - | wl-copy'"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("sh -c 'mkdir -p \"$HOME/Pictures/Screenshots\" && grim -g \"$(slurp)\" \"$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png\"'"))

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("sh -c 'brightnessctl -d intel_backlight -s set 10%- || true'"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("sh -c 'brightnessctl -d intel_backlight -s set +10% || true'"), { locked = true, repeating = true })
hl.bind("XF86WLAN", hl.dsp.exec_cmd("rfkill toggle wifi"), { locked = true })
hl.bind("XF86Bluetooth", hl.dsp.exec_cmd("rfkill toggle bluetooth"), { locked = true })
hl.bind("XF86Launch5", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86Launch6", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "float-fcitx5-config",
    match = { class = "^(org.fcitx.fcitx5-config-qt)$" },
    float = true,
})

hl.window_rule({
    name = "float-pavucontrol",
    match = { class = "^(org.pulseaudio.pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "float-blueman-manager",
    match = { class = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name = "float-file-op-progress",
    match = { title = "^(File Operation Progress)$" },
    float = true,
})

hl.window_rule({
    name = "idle-inhibit-fullscreen",
    match = { fullscreen = true },
    idle_inhibit = "fullscreen",
})

hl.window_rule({
    name = "idle-inhibit-looking-glass",
    match = { class = "^(looking-glass-client)$" },
    idle_inhibit = "focus",
})

hl.window_rule({
    name = "render-unfocused-looking-glass",
    match = { class = "^(looking-glass-client)$" },
    render_unfocused = true,
})

hl.window_rule({
    name = "looking-glass-workspace",
    match = { class = "^(looking-glass-client)$" },
    workspace = "4 silent",
})

hl.window_rule({
    name = "float-bitwarden",
    match = { class = "^(Bitwarden)$" },
    float = true,
})

hl.window_rule({
    name = "vesktop-workspace",
    match = { class = "^(vesktop)$" },
    workspace = "5 silent",
})

hl.window_rule({
    name = "spotify-launcher-workspace",
    match = { class = "^(spotify-launcher)$" },
    workspace = "5 silent",
})

hl.window_rule({
    name = "spotify-workspace",
    match = { class = "^(spotify)$" },
    workspace = "5 silent",
})