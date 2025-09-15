-- ~/.wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action

------------------------------------------------------------
-- SSH-Domain Hook: Autotmux bei 192.168.178.x
------------------------------------------------------------
wezterm.on("ssh-domain-connect", function(window, pane, ssh)
	local host = ssh.hostname or ""
	if host:match("^192%.168%.178%.%d+$") then
		local session = host:match("(%d+)$") or "home"
		local cmd = string.format("tmux attach -t %s || tmux new -s %s\n", session, session)
		window:perform_action(act.SendString(cmd), pane)
	end
end)

------------------------------------------------------------
-- Config Basis
------------------------------------------------------------
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Keys initialisieren
config.keys = {}

------------------------------------------------------------
-- Frontend + Fonts + Theme
------------------------------------------------------------
config.front_end = "WebGpu"
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"FiraCode Nerd Font",
})
config.font_size = 13.0
config.color_scheme = "Tokyo Night"
config.window_background_opacity = 1.0

-- Tabs
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

------------------------------------------------------------
-- Launch Menu (Profile-Auswahl)
------------------------------------------------------------
if wezterm.target_triple:find("windows") then
	config.launch_menu = {
		{
			label = "PowerShell 7",
			args = { "pwsh.exe", "-NoLogo" },
		},
		{
			label = "Windows PowerShell",
			args = { "powershell.exe", "-NoLogo" },
		},
		{
			label = "Command Prompt",
			args = { "cmd.exe" },
		},
		{
			label = "WSL Ubuntu",
			args = { "wsl.exe", "-d", "Ubuntu" },
		},
		{
			label = "WSL (Default)",
			args = { "wsl.exe" },
		},
	}
end

------------------------------------------------------------
-- Default Shell je nach Plattform
------------------------------------------------------------
if wezterm.target_triple:find("windows") then
	-- Standard: WSL für Development, PowerShell als Fallback
	config.default_prog = { "wsl.exe" }
-- Alternative: PowerShell 7 als Standard
-- config.default_prog = { "pwsh.exe", "-NoLogo" }
elseif wezterm.target_triple:find("apple") then
	config.default_prog = { "/bin/zsh", "-l" }
else
	config.default_prog = { "/bin/zsh", "-l" }
end

------------------------------------------------------------
-- Leader-Key OS-abhängig
------------------------------------------------------------
if wezterm.target_triple:find("windows") then
	-- Windows (DE-QWERTZ: "<" links neben Y = phys:IntlBackslash)
	--config.leader = { key = "a", mods = "CTRL|SHIFT", timeout_milliseconds = 1000 }
	--
	-- config.leader = { key = "a", mods = "SUPER|SHIFT", timeout_milliseconds = 1000 }
	config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
else
	-- macOS/Linux: Cmd+< (Cmd+Shift+Comma)
	config.leader = { key = "Comma", mods = "SUPER|SHIFT", timeout_milliseconds = 1000 }
end

------------------------------------------------------------
-- SSH Domains
------------------------------------------------------------
config.ssh_domains = {
	{
		name = "pve64",
		remote_address = "192.168.178.64",
		username = "root",
	},
}

------------------------------------------------------------
-- Keybindings (tmux-Style)
------------------------------------------------------------

-- Debug Overlay (zum Testen)
table.insert(config.keys, {
	key = "i",
	mods = "CTRL|SHIFT",
	action = act.ShowDebugOverlay,
})
table.insert(config.keys, {
	key = "a",
	mods = "CTRL",
	action = act.DisableDefaultAssignment,
})
-- Launch Menu öffnen (Profile wechseln)
table.insert(config.keys, {
	key = "s",
	mods = "LEADER",
	action = act.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS" }),
})

-- Schnelle Profile-Shortcuts
if wezterm.target_triple:find("windows") then
	-- Leader+1 = WSL
	table.insert(config.keys, {
		key = "1",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({ args = { "wsl.exe" } }),
	})

	-- Leader+2 = PowerShell 7
	table.insert(config.keys, {
		key = "2",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({ args = { "pwsh.exe", "-NoLogo" } }),
	})

	-- Leader+3 = CMD
	table.insert(config.keys, {
		key = "3",
		mods = "LEADER",
		action = act.SpawnCommandInNewTab({ args = { "cmd.exe" } }),
	})
end

-- Leader+a = QuickSelect
table.insert(config.keys, { key = "a", mods = "LEADER", action = act.QuickSelect })

-- Splits
table.insert(
	config.keys,
	{ key = "-", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) }
)
table.insert(
	config.keys,
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) }
)

-- Tabs
table.insert(config.keys, { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") })
table.insert(config.keys, { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) })
table.insert(config.keys, { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) })

-- Pane-Navigation (vim-style)
table.insert(config.keys, { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") })
table.insert(config.keys, { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") })
table.insert(config.keys, { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") })
table.insert(config.keys, { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") })

-- Pane schließen
table.insert(config.keys, { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) })

-- Extras
table.insert(config.keys, { key = "r", mods = "LEADER", action = act.ReloadConfiguration })
table.insert(config.keys, { key = "f", mods = "LEADER", action = act.ToggleFullScreen })

------------------------------------------------------------

-- Block 1: Aktualisiert die Statusleiste rechts
wezterm.on("update-right-status", function(window, pane)
	local last_key_info = wezterm.GLOBAL.last_key_info or "Keine Taste gedrückt"
	window:set_right_status(wezterm.format({
		{ Background = { Color = "#007ACC" } },
		{ Foreground = { Color = "#FFFFFF" } },
		{ Text = " " .. last_key_info .. " " },
	}))
end)

-- Block 2: Fängt Tastendrücke ab und speichert die Info
wezterm.on("key", function(window, pane, key, mods)
	-- 'key' kann eine Tabelle sein, wir brauchen den String daraus
	local key_name = key
	if type(key) == "table" then
		key_name = key.key
	end

	-- Speichere die Info in einer globalen Variable
	wezterm.GLOBAL.last_key_info = string.format("key=%s, mods=%s", key_name, mods)

	-- Erzwingt eine sofortige Aktualisierung der Statusleiste
	window:invalidate_right_status()

	-- Wichtig: Leitet die Taste normal weiter
	return true
end)

--wezterm.on("key", function(window, pane, key, mods)
--	local name = key
--	if type(key) == "table" then
--		name = key.key
--	end
--	-- Gibt den Namen der gedrückten Taste und die Modifikatoren aus
--	wezterm.log_error("key=" .. name .. " mods=" .. mods)
--local	return true -- Wichtig: 'true' leitet die Taste weiter, damit das Terminal normal funktioniert
--end)

return config
