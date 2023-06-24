--Allows the player to save their local stats to the sv.db file without having to leave the server.
function ForceSave(ply, cmd, args)
	if GetConVar("tm_developermode"):GetInt() == 1 then return end
	if game.GetMap() == "tm_firingrange" then return end
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
	RunConsoleCommand("tm_hud_enable", 1)
	RunConsoleCommand("tm_hud_font", "Arial")
	RunConsoleCommand("tm_hud_font_scale", 1)
	RunConsoleCommand("tm_hud_font_kill", 0)
	RunConsoleCommand("tm_hud_font_death", 0)
	RunConsoleCommand("tm_hud_ammo_style", 0)
	RunConsoleCommand("tm_hud_ammo_wep_text_color_r", 255)
	RunConsoleCommand("tm_hud_ammo_wep_text_color_g", 255)
	RunConsoleCommand("tm_hud_ammo_wep_text_color_b", 255)
	RunConsoleCommand("tm_hud_ammo_bar_color_r", 150)
	RunConsoleCommand("tm_hud_ammo_bar_color_g", 100)
	RunConsoleCommand("tm_hud_ammo_bar_color_b", 50)
	RunConsoleCommand("tm_hud_ammo_text_color_r", 255)
	RunConsoleCommand("tm_hud_ammo_text_color_g", 255)
	RunConsoleCommand("tm_hud_ammo_text_color_b", 255)
	RunConsoleCommand("tm_hud_health_size", 450)
	RunConsoleCommand("tm_hud_health_offset_x", 0)
	RunConsoleCommand("tm_hud_health_offset_y", 0)
	RunConsoleCommand("tm_hud_health_text_color_r", 255)
	RunConsoleCommand("tm_hud_health_text_color_g", 255)
	RunConsoleCommand("tm_hud_health_text_color_b", 255)
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
	RunConsoleCommand("tm_hud_killfeed_limit", 4)
	RunConsoleCommand("tm_hud_killfeed_offset_x", 0)
	RunConsoleCommand("tm_hud_killfeed_offset_y", 45)
	RunConsoleCommand("tm_hud_killfeed_opacity", 80)
	RunConsoleCommand("tm_hud_killdeath_offset_x", 0)
	RunConsoleCommand("tm_hud_killdeath_offset_y", 335)
	RunConsoleCommand("tm_hud_kill_iconcolor_r", 255)
	RunConsoleCommand("tm_hud_kill_iconcolor_g", 255)
	RunConsoleCommand("tm_hud_kill_iconcolor_b", 255)
	RunConsoleCommand("tm_hud_reloadhint", 1)
	RunConsoleCommand("tm_hud_loadouthint", 1)
end
concommand.Add("tm_resethudtodefault_cannotbeundone", PlayerHUDReset)

function Cheating(ply, cmd, args)
	ply:SetNWInt("playerXP", ply:GetNWInt("playerXP") + 3000)
	ply:CheckForPlayerLevel()
end
concommand.Add("tm_cheating", Cheating)