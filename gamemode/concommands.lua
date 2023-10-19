--Allows the player to save their local stats to the sv.db file without having to leave the server.
function ForceSave(ply, cmd, args)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	if forceDisableProgression == true then return end
	UninitializeNetworkInt(ply, "playerKills")
	UninitializeNetworkInt(ply, "playerDeaths")
	UninitializeNetworkInt(ply, "playerScore")
	UninitializeNetworkInt(ply, "matchesPlayed")
	UninitializeNetworkInt(ply, "matchesWon")
	UninitializeNetworkInt(ply, "highestKillStreak")
	UninitializeNetworkInt(ply, "highestKillGame")
	UninitializeNetworkInt(ply, "farthestKill")
	UninitializeNetworkInt(ply, "playerLevel")
	UninitializeNetworkInt(ply, "playerPrestige")
	UninitializeNetworkInt(ply, "playerXP")
	UninitializeNetworkString(ply, "chosenPlayermodel")
	UninitializeNetworkString(ply, "chosenPlayercard")
	UninitializeNetworkInt(ply, "playerAccoladeOnStreak")
	UninitializeNetworkInt(ply, "playerAccoladeBuzzkill")
	UninitializeNetworkInt(ply, "playerAccoladeLongshot")
	UninitializeNetworkInt(ply, "playerAccoladePointblank")
	UninitializeNetworkInt(ply, "playerAccoladeSmackdown")
	UninitializeNetworkInt(ply, "playerAccoladeHeadshot")
	UninitializeNetworkInt(ply, "playerAccoladeClutch")
	for p, t in pairs(weaponArray) do
		UninitializeNetworkInt(ply, "killsWith_" .. t[1])
	end
end
concommand.Add("tm_forcesave", ForceSave)

--Allows the player to prestige if they have hit the max level cap (Level 60).
function PlayerPrestige(ply, cmd, args)
	if ply:GetNWInt("playerLevel") == 60 then
		ply:SetNWInt("playerLevel", 1)
		ply:SetNWInt("playerPrestige", ply:GetNWInt("playerPrestige") + 1)
		ply:SetNWInt("playerXP", 0)
		ply:SetNWInt("playerXPToNextLevel", 750)
	end
end
concommand.Add("tm_prestige", PlayerPrestige)

--Allows the player to test the look and feel of their customized kill/death/level up UI's.
function HUDTestKill(ply, cmd, args)
	net.Start("NotifyKill")
	net.WriteEntity(ply)
	net.WriteString("KRISS Vector")
	net.WriteFloat(math.random(20, 60))
	net.WriteInt(math.random(1, 2), 5)
	net.WriteInt(math.random(1, 10), 10)
	net.Send(ply)
end
concommand.Add("tm_hud_testkill", HUDTestKill)

function HUDTestDeath(ply, cmd, args)
	net.Start("NotifyDeath")
	net.WriteEntity(ply)
	net.WriteString("KRISS Vector")
	net.WriteFloat(math.random(20, 60))
	net.WriteInt(math.random(1, 2), 5)
	net.Send(ply)
end
concommand.Add("tm_hud_testdeath", HUDTestDeath)

function HUDTestLevelUp(ply, cmd, args)
	net.Start("NotifyLevelUp")
	net.WriteInt(math.random(1, 59), 8)
	net.Send(ply)
end
concommand.Add("tm_hud_testlevelup", HUDTestLevelUp)

function HUDTestTimeWarning(ply, cmd, args)
	net.Start("NotifyMatchTime")
	net.WriteInt(300, 16)
	net.Send(ply)
end
concommand.Add("tm_hud_testtimewarning", HUDTestTimeWarning)

--Allows the player to wipe their account and start fresh.
function PlayerAccountWipe(ply, cmd, args)
	if ply:GetNWBool("mainmenu") == false then return end
	ply:SetNWInt("playerKills", 0)
	ply:SetNWInt("playerDeaths", 0)
	ply:SetNWInt("playerScore", 0)
	ply:SetNWInt("matchesPlayed", 0)
	ply:SetNWInt("matchesWon", 0)
	ply:SetNWInt("highestKillStreak", 0)
	ply:SetNWInt("highestKillGame", 0)
	ply:SetNWInt("farthestKill", 0)
	ply:SetNWInt("playerLevel", 1)
	ply:SetNWInt("playerPrestige", 0)
	ply:SetNWInt("playerXP", 0)
	ply:SetNWInt("playerXPToNextLevel", 750)
	ply:SetNWString("chosenPlayermodel", "models/player/Group03/male_02.mdl")
	ply:SetNWString("chosenPlayercard", "cards/default/construct.png")
	ply:SetNWInt("playerAccoladeHeadshot", 0)
	ply:SetNWInt("playerAccoladeSmackdown", 0)
	ply:SetNWInt("playerAccoladeLongshot", 0)
	ply:SetNWInt("playerAccoladePointblank", 0)
	ply:SetNWInt("playerAccoladeOnStreak", 0)
	ply:SetNWInt("playerAccoladeBuzzkill", 0)
	ply:SetNWInt("playerAccoladeClutch", 0)

	--Checking if PData exists for every single fucking weapon, GG.
	for k, v in pairs(weaponArray) do
		ply:SetNWInt("killsWith_" .. v[1], 0)
	end
end
concommand.Add("tm_wipeplayeraccount_cannotbeundone", PlayerAccountWipe)

--Allows the player to reset their custom HUD settings to default.
function PlayerHUDReset(ply, cmd, args)
	RunConsoleCommand("tm_hud_bounds_x", 15)
	RunConsoleCommand("tm_hud_bounds_y", 15)
	RunConsoleCommand("tm_hud_text_color_r", 255)
	RunConsoleCommand("tm_hud_text_color_g", 255)
	RunConsoleCommand("tm_hud_text_color_b", 255)
	RunConsoleCommand("tm_hud_font", "Arial")
	RunConsoleCommand("tm_hud_ammo_style", 0)
	RunConsoleCommand("tm_hud_ammo_bar_color_r", 150)
	RunConsoleCommand("tm_hud_ammo_bar_color_g", 100)
	RunConsoleCommand("tm_hud_ammo_bar_color_b", 50)
	RunConsoleCommand("tm_hud_health_size", 450)
	RunConsoleCommand("tm_hud_health_offset_x", 0)
	RunConsoleCommand("tm_hud_health_offset_y", 0)
	RunConsoleCommand("tm_hud_health_color_high_r", 100)
	RunConsoleCommand("tm_hud_health_color_high_g", 180)
	RunConsoleCommand("tm_hud_health_color_high_b", 100)
	RunConsoleCommand("tm_hud_health_color_mid_r", 180)
	RunConsoleCommand("tm_hud_health_color_mid_g", 180)
	RunConsoleCommand("tm_hud_health_color_mid_b", 100)
	RunConsoleCommand("tm_hud_health_color_low_r", 180)
	RunConsoleCommand("tm_hud_health_color_low_g", 100)
	RunConsoleCommand("tm_hud_health_color_low_b", 100)
	RunConsoleCommand("tm_hud_equipment_offset_x", 525)
	RunConsoleCommand("tm_hud_equipment_offset_y", 0)
	RunConsoleCommand("tm_hud_equipment_anchor", 0)
	RunConsoleCommand("tm_hud_killfeed_style", 0)
	RunConsoleCommand("tm_hud_killfeed_limit", 4)
	RunConsoleCommand("tm_hud_killfeed_offset_x", 0)
	RunConsoleCommand("tm_hud_killfeed_offset_y", 40)
	RunConsoleCommand("tm_hud_killfeed_opacity", 80)
	RunConsoleCommand("tm_hud_killdeath_offset_x", 0)
	RunConsoleCommand("tm_hud_killdeath_offset_y", 335)
	RunConsoleCommand("tm_hud_kill_iconcolor_r", 255)
	RunConsoleCommand("tm_hud_kill_iconcolor_g", 255)
	RunConsoleCommand("tm_hud_kill_iconcolor_b", 255)
	RunConsoleCommand("tm_hud_keypressoverlay_x", 0)
	RunConsoleCommand("tm_hud_keypressoverlay_y", 0)
	RunConsoleCommand("tm_hud_keypressoverlay_inactive_r", 255)
	RunConsoleCommand("tm_hud_keypressoverlay_inactive_g", 255)
	RunConsoleCommand("tm_hud_keypressoverlay_inactive_b", 255)
	RunConsoleCommand("tm_hud_keypressoverlay_actuated_r", 255)
	RunConsoleCommand("tm_hud_keypressoverlay_actuated_g", 255)
	RunConsoleCommand("tm_hud_keypressoverlay_actuated_b", 255)
	RunConsoleCommand("tm_hud_velocitycounter_x", 0)
	RunConsoleCommand("tm_hud_velocitycounter_y", 190)
	RunConsoleCommand("tm_hud_velocitycounter_r", 255)
	RunConsoleCommand("tm_hud_velocitycounter_g", 255)
	RunConsoleCommand("tm_hud_velocitycounter_b", 255)
	RunConsoleCommand("tm_hud_obj_scale", 1)
	RunConsoleCommand("tm_hud_obj_color_empty_r", 255)
	RunConsoleCommand("tm_hud_obj_color_empty_g", 255)
	RunConsoleCommand("tm_hud_obj_color_empty_b", 255)
	RunConsoleCommand("tm_hud_obj_color_occupied_r", 255)
	RunConsoleCommand("tm_hud_obj_color_occupied_g", 255)
	RunConsoleCommand("tm_hud_obj_color_occupied_b", 0)
	RunConsoleCommand("tm_hud_obj_color_contested_r", 255)
	RunConsoleCommand("tm_hud_obj_color_contested_g", 0)
	RunConsoleCommand("tm_hud_obj_color_contested_b", 0)
	RunConsoleCommand("tm_hud_dmgindicator", 1)
	RunConsoleCommand("tm_hud_dmgindicator_color_r", 255)
	RunConsoleCommand("tm_hud_dmgindicator_color_g", 0)
	RunConsoleCommand("tm_hud_dmgindicator_color_b", 0)
	RunConsoleCommand("tm_hud_dmgindicator_opacity", 85)
end
concommand.Add("tm_resethudtodefault_cannotbeundone", PlayerHUDReset)

function ImportHUDCode(ply, cmd, args)
	local code = args[1]
	local var = {}
	if code == nil then return end
	for s in string.gmatch(code, "[^-]+") do
		table.insert(var, s)
	end
	if table.Count(var) != 60 then return end
	RunConsoleCommand("tm_hud_font", var[1])
	RunConsoleCommand("tm_hud_bounds_x", var[2])
	RunConsoleCommand("tm_hud_bounds_y", var[3])
	RunConsoleCommand("tm_hud_text_color_r", var[4])
	RunConsoleCommand("tm_hud_text_color_g", var[5])
	RunConsoleCommand("tm_hud_text_color_b", var[6])
	RunConsoleCommand("tm_hud_ammo_style", var[7])
	RunConsoleCommand("tm_hud_ammo_bar_color_r", var[8])
	RunConsoleCommand("tm_hud_ammo_bar_color_g", var[9])
	RunConsoleCommand("tm_hud_ammo_bar_color_b", var[10])
	RunConsoleCommand("tm_hud_health_size", var[11])
	RunConsoleCommand("tm_hud_health_offset_x", var[12])
	RunConsoleCommand("tm_hud_health_offset_y", var[13])
	RunConsoleCommand("tm_hud_health_color_high_r", var[14])
	RunConsoleCommand("tm_hud_health_color_high_g", var[15])
	RunConsoleCommand("tm_hud_health_color_high_b", var[16])
	RunConsoleCommand("tm_hud_health_color_mid_r", var[17])
	RunConsoleCommand("tm_hud_health_color_mid_g", var[18])
	RunConsoleCommand("tm_hud_health_color_mid_b", var[19])
	RunConsoleCommand("tm_hud_health_color_low_r", var[20])
	RunConsoleCommand("tm_hud_health_color_low_g", var[21])
	RunConsoleCommand("tm_hud_health_color_low_b", var[22])
	RunConsoleCommand("tm_hud_equipment_anchor", var[23])
	RunConsoleCommand("tm_hud_equipment_offset_x", var[24])
	RunConsoleCommand("tm_hud_equipment_offset_y", var[25])
	RunConsoleCommand("tm_hud_enablekillfeed", var[26])
	RunConsoleCommand("tm_hud_killfeed_style", var[27])
	RunConsoleCommand("tm_hud_killfeed_limit", var[28])
	RunConsoleCommand("tm_hud_killfeed_offset_x", var[29])
	RunConsoleCommand("tm_hud_killfeed_offset_y", var[30])
	RunConsoleCommand("tm_hud_killfeed_opacity", var[31])
	RunConsoleCommand("tm_hud_killdeath_offset_x", var[32])
	RunConsoleCommand("tm_hud_killdeath_offset_y", var[33])
	RunConsoleCommand("tm_hud_kill_iconcolor_r", var[34])
	RunConsoleCommand("tm_hud_kill_iconcolor_g", var[35])
	RunConsoleCommand("tm_hud_kill_iconcolor_b", var[36])
	RunConsoleCommand("tm_hud_obj_scale", var[37])
	RunConsoleCommand("tm_hud_obj_color_empty_r", var[38])
	RunConsoleCommand("tm_hud_obj_color_empty_g", var[39])
	RunConsoleCommand("tm_hud_obj_color_empty_b", var[40])
	RunConsoleCommand("tm_hud_obj_color_occupied_r", var[41])
	RunConsoleCommand("tm_hud_obj_color_occupied_g", var[42])
	RunConsoleCommand("tm_hud_obj_color_occupied_b", var[43])
	RunConsoleCommand("tm_hud_obj_color_contested_r", var[44])
	RunConsoleCommand("tm_hud_obj_color_contested_g", var[45])
	RunConsoleCommand("tm_hud_obj_color_contested_b", var[46])
	RunConsoleCommand("tm_hud_dmgindicator_color_r", var[47])
	RunConsoleCommand("tm_hud_dmgindicator_color_g", var[48])
	RunConsoleCommand("tm_hud_dmgindicator_color_b", var[49])
	RunConsoleCommand("tm_hud_dmgindicator_opacity", var[50])
	RunConsoleCommand("tm_hud_keypressoverlay_x", var[51])
	RunConsoleCommand("tm_hud_keypressoverlay_y", var[52])
	RunConsoleCommand("tm_hud_keypressoverlay_inactive_r", var[53])
	RunConsoleCommand("tm_hud_keypressoverlay_inactive_g", var[54])
	RunConsoleCommand("tm_hud_keypressoverlay_inactive_b", var[55])
	RunConsoleCommand("tm_hud_keypressoverlay_actuated_r", var[56])
	RunConsoleCommand("tm_hud_keypressoverlay_actuated_g", var[57])
	RunConsoleCommand("tm_hud_keypressoverlay_actuated_b", var[58])
	RunConsoleCommand("tm_hud_velocitycounter_x", var[59])
	RunConsoleCommand("tm_hud_velocitycounter_y", var[60])
end
concommand.Add("tm_importhudcode_cannotbeundone", ImportHUDCode)