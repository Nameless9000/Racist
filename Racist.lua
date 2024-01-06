-- Constants

local NAME_INSERT <const> = "@name"
local LANGUAGES = {
    [0] = "English",
    [1] = "French",
    [2] = "German",
    [3] = "Italian",
    [4] = "Spanish",
    [5] = "Brazilian",
    [6] = "Polish",
    [7] = "Russian",
    [8] = "Korean",
    [9] = "Chinese",
    [10] = "Japanese",
    [11] = "Mexican",
    [12] = "Chinese"
}

-- Variables

local banned_languages = {}
local punishment: string = "kick "..NAME_INSERT

-- Functions

-- what should happen to a blocked player
local function punish(player_id: number): void
	local player_name = players.get_name(player_id)
	
	local command = punishment:replace(NAME_INSERT, player_name)
	menu.trigger_commands(command)
	
	util.toast(player_name.." was punished for using a blocked language!")
end

-- runs every time a player joins
local function on_player_joined(player_id: number): void
	local language: number = players.get_language(player_id)
	
	if language in banned_languages then
		punish(player_id)
	end
end

players.on_join(on_player_joined)

-- Create menu

local menu_root = menu.my_root()

local languages = menu_root:list("Banned Languages")

for language_id, language in LANGUAGES do
	local function toggle_changed(toggled: boolean): void
		banned_languages[language_id] = toggled ? language_id : -1
	end

	languages:toggle(
		language,
		{},
		$"This will punish people using the {language} language.",
		toggle_changed
	)
end

menu_root:text_input(
	$"Player Punishment ({NAME_INSERT} = Player)",
	{"addlanguagepunishment"},
	$"Insert the punishment for players using the specific language, use {NAME_INSERT} to insert the player's name to the command e.g. kick {NAME_INSERT}.",
	function(text: string) punishment = text end,
	punishment
)

menu_root:action(
	"[DEBUG] Check for blocked languages",
	{},
	"This is a debug option that checks for people with blocked languages in the current session.",
	function()
		players.list(false):foreach(on_player_joined)
	end
)

util.keep_running()