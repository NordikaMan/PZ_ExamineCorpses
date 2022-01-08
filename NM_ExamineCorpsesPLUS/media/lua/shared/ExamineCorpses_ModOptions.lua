--Default options.
local SETTINGS = { 
	options = {
		dropdown1 = 3,
	},
	names= {
		dropdown1 = "XP Gain Rate",
	},
	mod_id = "ExamineCorpsesPLUS",
	mod_shortname = "Examine Corpses"
}

-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then
	local settings = ModOptions:getInstance(SETTINGS)
	local drop1 = settings:getData("dropdown1")
	drop1[1] = "Very Slow"
	drop1[2] = "Slow"
	drop1[3] = "Normal"
	drop1[4] = "Fast"
	drop1.tooltip = "Tweaks XP reward to require an average number of examinations per level gain (Very Slow = 50, Slow = 20, normal = 10, fast = 5)"

end

ExamineCorpses_global = {}
ExamineCorpses_global.SETTINGS = SETTINGS