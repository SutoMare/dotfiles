--
-- Pacchetti richiesti (pacman -S):
--   waybar hyprpaper dunst networkmanager nm-applet polkit-gnome
--   hypridle cliphist wl-clipboard kitty dolphin wofi gr2im slurp
--   playerctl brightnessctl
--
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "wofi --show drun"  -- oppure "hyperlauncher" se installato da AUR
local OK, bordo_dinamico = pcall(require, "colore_bordo")
if not OK then
    bordo_dinamico = "0xff33ccff" -- Colore di fallback se lo script non è ancora partito
end


-------------------
---- AUTOSTART ----
-------------------

-- FIX: sezione era interamente commentata → nessun processo partiva all'avvio,
--      da qui la mancanza di icone e tray.

hl.on("hyprland.start", function()
    -- Status bar
    hl.exec_cmd("waybar")
    -- Wallpaper daemon (configura ~/.config/hypr/hyprpaper.conf)
    hl.exec_cmd("hyprpaper")
    -- Notifiche desktop
    -- hl.exec_cmd("dunst")
    -- Tray network manager
    -- hl.exec_cmd("nm-applet --indicator")
    -- Agente polkit (richiesto per dialog di autenticazione grafica)
    -- hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    -- Idle management (blocco schermo / spegnimento display)
    -- hl.exec_cmd("pgrep swayidle || swayidle -w timeout 300 'hyprlock' before-sleep 'hyprlock'")
    hl.exec_cmd("hypridle")
    -- Clipboard history daemon
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    -- Tema GTK e icone (Adwaita è sempre disponibile su Arch)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'Sans 9'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface document-font-name 'Sans 9'")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("swayosd-server -s ~/.config/swayosd/style.css")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE",              "20")
hl.env("HYPRCURSOR_SIZE",           "20")
hl.env("QT_QPA_PLATFORM",           "wayland")    -- forza Qt su Wayland
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")        -- fix per app Java


-----------------------
----- PERMISSIONS -----
-----------------------

-- Decommentare se si usa enforce_permissions = true
-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        
        gaps_in  = 2,
        gaps_out = 4,

        border_size = 1,

        ["col.active_border"] = bordo_dinamico,
        ["col.inactive_border"] = "0xff595959",

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 5,

        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

-- Animations
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 100,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Layout: Dwindle
hl.config({
    dwindle = {
        preserve_split = true,
    },
})

-- Layout: Master
hl.config({
    master = {
        new_status = "master",
    },
})

-- Layout: Scrolling
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
    misc = {
        middle_click_paste = false,
    },

})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",   -- layout italiano; cambia in "us" se preferisci
        kb_variant = "",
        kb_model   = "",
        kb_options = "altwin:swap_alt_win",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0.15,
        accel_profile = "adaptive",
        scroll_method = "on_button_down", 
        scroll_button = 274,

        touchpad = {
            natural_scroll = true,
            tap_to_click = false,
            middle_button_emulation = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Esempio configurazione device specifico
-- hl.device({
--     name        = "epic-mouse-v1",
--     sensitivity = -0.5,
-- })

hl.device({
    name = "synaptics-tm3276-022",
    enabled = true,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"
-- local capsMod = "Mod3"

-- Terminale
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))

-- Chiudi finestra
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())

-- Esci da Hyprland
-- FIX: era "hyprctl dispatch 'hl.dsp.exit()'" → sintassi Lua non valida per hyprctl
hl.bind(mainMod .. " + M",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))

-- File manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- Float toggle
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Launcher
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- Pseudotile
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Dwindle split
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Focus con frecce
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))


-- Workspace 1-10 (tasto 0 → workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll tra workspace con rotella
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize con mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"))

-- Luminosita'
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness raise"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))

-- Media
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })

-- Screenshot (richiede: grim slurp wl-clipboard)
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region -o /home/Giova/Pictures/Screenshot"))

-- Clipboard history (richiede: cliphist wofi wl-clipboard)
hl.bind(mainMod .. " + CTRL + V",
    hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Ignora richieste di maximize da tutte le app
local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix drag con XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})


-- Posizione hyprland-run
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
