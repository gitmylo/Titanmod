--Color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local gameEnded = false
local feedArray = {}
local health

local healthHUD = {
    ["size"] = GetConVar("tm_hud_health_size"):GetInt(),
    ["x"] = GetConVar("tm_hud_health_offset_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_health_offset_y"):GetInt(),
    ["text_r"] = GetConVar("tm_hud_health_text_color_r"):GetInt(),
    ["text_g"] = GetConVar("tm_hud_health_text_color_g"):GetInt(),
    ["text_b"] = GetConVar("tm_hud_health_text_color_b"):GetInt(),
    ["barhigh_r"] = GetConVar("tm_hud_health_color_high_r"):GetInt(),
    ["barhigh_g"] = GetConVar("tm_hud_health_color_high_g"):GetInt(),
    ["barhigh_b"] = GetConVar("tm_hud_health_color_high_b"):GetInt(),
    ["barmid_r"] = GetConVar("tm_hud_health_color_mid_r"):GetInt(),
    ["barmid_g"] = GetConVar("tm_hud_health_color_mid_g"):GetInt(),
    ["barmid_b"] = GetConVar("tm_hud_health_color_mid_b"):GetInt(),
    ["barmid_r"] = GetConVar("tm_hud_health_color_low_r"):GetInt(),
    ["barmid_g"] = GetConVar("tm_hud_health_color_low_g"):GetInt(),
    ["barmid_b"] = GetConVar("tm_hud_health_color_low_b"):GetInt()
}

local weaponHUD = {
    ["weptext_r"] = GetConVar("tm_hud_ammo_wep_text_color_r"):GetInt(),
    ["weptext_g"] = GetConVar("tm_hud_ammo_wep_text_color_g"):GetInt(),
    ["weptext_b"] = GetConVar("tm_hud_ammo_wep_text_color_b"):GetInt(),
    ["ammobar_r"] = GetConVar("tm_hud_ammo_bar_color_r"):GetInt(),
    ["ammobar_g"] = GetConVar("tm_hud_ammo_bar_color_g"):GetInt(),
    ["ammobar_b"] = GetConVar("tm_hud_ammo_bar_color_b"):GetInt(),
    ["ammotext_r"] = GetConVar("tm_hud_ammo_text_color_r"):GetInt(),
    ["ammotext_g"] = GetConVar("tm_hud_ammo_text_color_g"):GetInt(),
    ["ammotext_b"] = GetConVar("tm_hud_ammo_text_color_b"):GetInt()
}

local equipmentHUD = {
    ["x"] = GetConVar("tm_hud_equipment_offset_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_equipment_offset_y"):GetInt()
}

local feedHUD = {
    ["x"] = GetConVar("tm_hud_killfeed_offset_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_killfeed_offset_y"):GetInt(),
    ["opacity"] = GetConVar("tm_hud_killfeed_opacity"):GetInt()
}

local killdeathHUD = {
    ["x"] = GetConVar("tm_hud_killdeath_offset_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_killdeath_offset_y"):GetInt(),
    ["killicon_r"] = GetConVar("tm_hud_kill_iconcolor_r"):GetInt(),
    ["killicon_g"] = GetConVar("tm_hud_kill_iconcolor_g"):GetInt(),
    ["killicon_b"] = GetConVar("tm_hud_kill_iconcolor_b"):GetInt()
}

local kpoHUD = {
    ["x"] = GetConVar("tm_hud_keypressoverlay_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_keypressoverlay_y"):GetInt(),
    ["inactive_r"] = GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt(),
    ["inactive_g"] = GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt(),
    ["inactive_b"] = GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt(),
    ["actuated_r"] = GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt(),
    ["actuated_g"] = GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt(),
    ["actuated_b"] = GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt()
}

local fpsHUD = {
    ["x"] = GetConVar("tm_hud_fpscounter_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_fpscounter_y"):GetInt(),
    ["r"] = GetConVar("tm_hud_fpscounter_r"):GetInt(),
    ["g"] = GetConVar("tm_hud_fpscounter_g"):GetInt(),
    ["b"] = GetConVar("tm_hud_fpscounter_b"):GetInt()
}

local velocityHUD = {
    ["x"] = GetConVar("tm_hud_velocitycounter_x"):GetInt(),
    ["y"] = GetConVar("tm_hud_velocitycounter_y"):GetInt(),
    ["r"] = GetConVar("tm_hud_velocitycounter_r"):GetInt(),
    ["g"] = GetConVar("tm_hud_velocitycounter_g"):GetInt(),
    ["b"] = GetConVar("tm_hud_velocitycounter_b"):GetInt()
}

local sounds = {
    ["hit_enabled"] = GetConVar("tm_hitsounds"):GetInt(),
    ["kill_enabled"] = GetConVar("tm_killsound"):GetInt(),
    ["hit"] = GetConVar("tm_hitsoundtype"):GetInt(),
    ["kill"] = GetConVar("tm_killsoundtype"):GetInt()
}

local StreakFont = "StreakText"
local NameFont = "PlayerNotiName"
local ArialFont = "Arial18"
local DeathFont = "PlayerDeathName"
local WepFont = "WepNameKill"

if GetConVar("tm_hud_font_kill"):GetInt() == 1 then
    StreakFont = "HUD_StreakText"
    NameFont = "HUD_PlayerNotiName"
end

if GetConVar("tm_hud_font_death"):GetInt() == 1 then
    ArialFont = "HUD_Arial18"
    DeathFont = "HUD_PlayerDeathName"
    WepFont = "HUD_WepNameKill"
end

if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then feedEntryPadding = -20 else feedEntryPadding = 20 end
if GetConVar("tm_hud_equipment_anchor"):GetInt() == 0 then equipAnchor = "left" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 1 then equipAnchor = "center" elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 2 then equipAnchor = "right" end

local keyMat = Material("icons/keyicon.png")
local keyMatMed = Material("icons/keyiconmedium.png")
local keyMatLong = Material("icons/keyiconlong.png")

local fColor = Color(255, 255, 255)
local lColor = Color(255, 255, 255)
local bColor = Color(255, 255, 255)
local rColor = Color(255, 255, 255)
local jColor = Color(255, 255, 255)
local sColor = Color(255, 255, 255)
local cColor = Color(255, 255, 255)

local actuatedColor = Color(kpoHUD["actuated_r"], kpoHUD["actuated_g"], kpoHUD["actuated_b"])
local inactiveColor = Color(kpoHUD["inactive_r"], kpoHUD["inactive_g"], kpoHUD["inactive_b"])

local LocalPly
local clientFPS = 0
local ping = 0
local updateRate = 0.66

local activeGamemode = GetGlobal2String("ActiveGamemode", "FFA")
local timeUntilSelfDestruct = 0

function HUD()
    if LocalPly == nil then LocalPly = LocalPlayer() end
    --Disables the HUD if the player has it disabled in Options.
    if GetConVar("tm_hud_enable"):GetInt() == 0 then return end
    if !LocalPly:Alive() or LocalPly:GetNWBool("mainmenu") == true or gameEnded == true then return end

    if GetConVar("tm_hud_fpscounter"):GetInt() == 1 and !timer.Exists("CounterUpdate") then
        timer.Create("CounterUpdate", updateRate, 0, function()
            clientFPS = tostring(math.floor(1 / RealFrameTime()))
            ping = LocalPly:Ping()
        end)
    end

    --Remaining match time.
    local timeText = " ∞"
    timeText = string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i")
    draw.SimpleText(activeGamemode .. " |" .. timeText, "HUD_Health", ScrW() / 2, 5, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    if activeGamemode == "Gun Game" then draw.SimpleText(ggLadderSize - LocalPly:GetNWInt("ladderPosition") .. " kills left", "HUD_Health", ScrW() / 2, 35, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) elseif activeGamemode == "Fiesta" and (GetGlobal2Int("FiestaTime", 0) - CurTime()) > 0 then draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("FiestaTime", 0) - CurTime()), "%2i:%02i"), "HUD_Health", ScrW() / 2, 35, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) elseif activeGamemode == "Cranked" and timeUntilSelfDestruct != 0 then draw.SimpleText(timeUntilSelfDestruct, "HUD_Health", ScrW() / 2, 35, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP) end

    --Kill feed
    for k, v in pairs(feedArray) do
        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, feedHUD["opacity"]) else surface.SetDrawColor(50, 50, 50, feedHUD["opacity"]) end
        local nameLength = select(1, surface.GetTextSize(v[1]))

        surface.DrawRect(10 + feedHUD["x"], ScrH() - 20 + ((k - 1) * feedEntryPadding) - feedHUD["y"], nameLength + 5, 20)
        draw.SimpleText(v[1], "HUD_StreakText", 12.5 + feedHUD["x"], ScrH() - 10 + ((k - 1) * feedEntryPadding) - feedHUD["y"], Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    --FPS and ping counter
    if GetConVar("tm_hud_fpscounter"):GetInt() == 1 then
        draw.SimpleText(clientFPS .. " FPS", "HUD_Health", ScrW() - fpsHUD["x"], fpsHUD["y"], Color(fpsHUD["r"], fpsHUD["g"], fpsHUD["b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
        draw.SimpleText(ping .. " PING", "HUD_Health", ScrW() - fpsHUD["x"], fpsHUD["y"] + 25, Color(fpsHUD["r"], fpsHUD["g"], fpsHUD["b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
    end

    --Shows the players ammo and weapon depending on the style they have selected in Options.
    if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
        --Numeric Style
        if (LocalPly:GetActiveWeapon():IsValid()) and (LocalPly:GetActiveWeapon():GetPrintName() != nil) then
            draw.SimpleText(LocalPly:GetActiveWeapon():GetPrintName(), "HUD_GunPrintName", ScrW() - 15, ScrH() - 30, Color(weaponHUD["weptext_r"], weaponHUD["weptext_g"], weaponHUD["weptext_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0)
            if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(LocalPly:GetNWInt("killsWith_" .. LocalPly:GetActiveWeapon():GetClass()) .. " kills", "HUD_StreakText", ScrW() - 25, ScrH() - 155, Color(weaponHUD["weptext_r"], weaponHUD["weptext_g"], weaponHUD["weptext_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) end
        end

        if (LocalPly:GetActiveWeapon():IsValid()) and (LocalPly:GetActiveWeapon():Clip1() == 0) then draw.SimpleText("0", "HUD_AmmoCount", ScrW() - 15, ScrH() - 100, red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) elseif (LocalPly:GetActiveWeapon():IsValid()) and (LocalPly:GetActiveWeapon():Clip1() >= 0) then draw.SimpleText(LocalPly:GetActiveWeapon():Clip1(), "HUD_AmmoCount", ScrW() - 15, ScrH() - 100, Color(weaponHUD["ammotext_r"], weaponHUD["ammotext_g"], weaponHUD["ammotext_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) end
    else
        --Bar Style
        if (LocalPly:GetActiveWeapon():IsValid()) and (LocalPly:GetActiveWeapon():GetPrintName() != nil) then
            draw.SimpleText(LocalPly:GetActiveWeapon():GetPrintName(), "HUD_GunPrintName", ScrW() - 15, ScrH() - 70, Color(weaponHUD["weptext_r"], weaponHUD["weptext_g"], weaponHUD["weptext_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0)
            if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(LocalPly:GetNWInt("killsWith_" .. LocalPly:GetActiveWeapon():GetClass()) .. " kills", "HUD_StreakText", ScrW() - 18, ScrH() - 100, Color(weaponHUD["weptext_r"], weaponHUD["weptext_g"], weaponHUD["weptext_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0) end
        end

        if (LocalPly:GetActiveWeapon():IsValid()) then
            if (LocalPly:GetActiveWeapon():Clip1() != 0) then
                surface.SetDrawColor(weaponHUD["ammobar_r"] - 205, weaponHUD["ammobar_g"] - 205, weaponHUD["ammobar_b"] - 205, 80)
                surface.DrawRect(ScrW() - 415, ScrH() - 38, 400, 30)
            else
                surface.SetDrawColor(255, 0, 0, 80)
                surface.DrawRect(ScrW() - 415, ScrH() - 38, 400, 30)
            end

            surface.SetDrawColor(weaponHUD["ammobar_r"], weaponHUD["ammobar_g"], weaponHUD["ammobar_b"], 175)
            surface.DrawRect(ScrW() - 415, ScrH() - 38, 400 * (math.Clamp(LocalPly:GetActiveWeapon():Clip1() / LocalPly:GetActiveWeapon():GetMaxClip1(), 0, 1)), 30)
            if (LocalPly:GetActiveWeapon():Clip1() >= 0) then draw.SimpleText(LocalPly:GetActiveWeapon():Clip1(), "HUD_Health", ScrW() - 410, ScrH() - 24, Color(weaponHUD["ammotext_r"], weaponHUD["ammotext_g"], weaponHUD["ammotext_b"], 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0) else draw.SimpleText("∞", "HUD_Health", ScrW() - 410, ScrH() - 24, Color(weaponHUD["ammotext_r"], weaponHUD["ammotext_g"], weaponHUD["ammotext_b"], 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 0) end
        end
    end

    --Displays a reload hint when the player is out of ammo.
    if GetConVar("tm_hud_reloadhint"):GetInt() == 1 and (LocalPly:GetActiveWeapon():IsValid()) and (LocalPly:GetActiveWeapon():Clip1() == 0) then draw.SimpleText("[RELOAD]", "HUD_WepNameKill", ScrW() / 2, ScrH() / 2 + 200, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0) end

    --Shows the players health depending on the style they have selected in Options.
    if LocalPly:Health() <= 0 then health = 0 else health = LocalPly:Health() end
    surface.SetDrawColor(50, 50, 50, 80)
    surface.DrawRect(10 + healthHUD["x"], ScrH() - 38 - healthHUD["y"], healthHUD["size"], 30)

    if LocalPly:Health() <= 66 then
        if LocalPly:Health() <= 33 then
            surface.SetDrawColor(healthHUD["barmid_r"], healthHUD["barmid_g"], healthHUD["barmid_b"], 120)
        else
            surface.SetDrawColor(healthHUD["barmid_r"], healthHUD["barmid_g"], healthHUD["barmid_b"], 120)
        end
    else
        surface.SetDrawColor(healthHUD["barhigh_r"], healthHUD["barhigh_g"], healthHUD["barhigh_b"], 120)
    end

    surface.DrawRect(10 + healthHUD["x"], ScrH() - 38 - healthHUD["y"], healthHUD["size"] * (LocalPly:Health() / LocalPly:GetMaxHealth()), 30)
    draw.SimpleText(health, "HUD_Health", healthHUD["size"] + healthHUD["x"], ScrH() - 24 - healthHUD["y"], Color(healthHUD["text_r"], healthHUD["text_g"], healthHUD["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 0)

    --Grappling hook disclaimer.
    if (LocalPly:GetActiveWeapon():IsValid()) and LocalPly:GetActiveWeapon():GetPrintName() == "Grappling Hook" then draw.SimpleText("Press [" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "] to use your grappling hook.", "HUD_Health", ScrW() / 2, ScrH() / 2 + 75, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0) end

    --Equipment
    local grappleMat = Material("icons/grapplehudicon.png")
    local nadeMat = Material("icons/grenadehudicon.png")
    local grappleText

    if LocalPly:HasWeapon("fres_grapple") and LocalPly:GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(grappleMat)
        if Lerp((LocalPly:GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(LocalPly:SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = "[" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "]"
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor((LocalPly:GetNWFloat("linat",CurTime()) - CurTime()) + 0,5)
        end
        surface.DrawTexturedRect(equipmentHUD["x"] - 45, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
        draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] - 27.5, ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)

        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(equipmentHUD["x"] + 10, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
        draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipmentHUD["x"] + 27.5, ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
    elseif LocalPly:HasWeapon("fres_grapple") then
        surface.SetMaterial(grappleMat)
        if Lerp((LocalPly:GetNWFloat("linat",CurTime()) - CurTime()) * 0.2,0,500) == 0 and !IsValid(LocalPly:SetNWEntity("lina",stando)) then
            surface.SetDrawColor(255,255,255,255)
            grappleText = "[" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "]"
        else
            surface.SetDrawColor(255,200,200,100)
            grappleText = math.floor((LocalPly:GetNWFloat("linat",CurTime()) - CurTime()) + 0,5)
        end
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 45, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] - 27.5, ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 17.5, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"], ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
        else
            surface.DrawTexturedRect(equipmentHUD["x"] + 10, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
            draw.SimpleText(grappleText, "HUD_StreakText", equipmentHUD["x"] + 27.5, ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
        end
    elseif LocalPly:GetAmmoCount("Grenade") > 0 then
        surface.SetMaterial(nadeMat)
        surface.SetDrawColor(255,255,255,255)
        if equipAnchor == "left" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 45, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipmentHUD["x"] - 27.5, ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
        elseif equipAnchor == "center" then
            surface.DrawTexturedRect(equipmentHUD["x"] - 17.5, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipmentHUD["x"], ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
        else
            surface.DrawTexturedRect(equipmentHUD["x"] + 10, ScrH() - 47.5 - equipmentHUD["y"], 35, 40)
            draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", equipmentHUD["x"] + 27.5, ScrH() - 75 - equipmentHUD["y"], color_white, TEXT_ALIGN_CENTER)
        end
    end

    --Keypress Overlay
    if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then
        hook.Add("Tick", "KeyOverlayTracking", function()
            if LocalPly:KeyDown(IN_FORWARD) then fColor = actuatedColor else fColor = inactiveColor end
            if LocalPly:KeyDown(IN_MOVELEFT) then lColor = actuatedColor else lColor = inactiveColor end
            if LocalPly:KeyDown(IN_BACK) then bColor = actuatedColor else bColor = inactiveColor end
            if LocalPly:KeyDown(IN_MOVERIGHT) then rColor = actuatedColor else rColor = inactiveColor end
            if LocalPly:KeyDown(IN_JUMP) then jColor = actuatedColor else jColor = inactiveColor end
            if LocalPly:KeyDown(IN_SPEED) then sColor = actuatedColor else sColor = inactiveColor end
            if LocalPly:KeyDown(IN_DUCK) then cColor = actuatedColor else cColor = inactiveColor end
        end )

        surface.SetMaterial(keyMat)
        surface.SetDrawColor(fColor)
        surface.DrawTexturedRect(48 + kpoHUD["x"], 0 + kpoHUD["y"], 42, 42)
        surface.SetDrawColor(lColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], 48 + kpoHUD["y"], 42, 42)
        surface.SetDrawColor(bColor)
        surface.DrawTexturedRect(48 + kpoHUD["x"], 48 + kpoHUD["y"], 42, 42)
        surface.SetDrawColor(rColor)
        surface.DrawTexturedRect(96 + kpoHUD["x"], 48 + kpoHUD["y"], 42, 42)
        surface.SetMaterial(keyMatLong)
        surface.SetDrawColor(jColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], 96 + kpoHUD["y"], 138, 42)
        surface.SetMaterial(keyMatMed)
        surface.SetDrawColor(sColor)
        surface.DrawTexturedRect(0 + kpoHUD["x"], 144 + kpoHUD["y"], 66, 42)
        surface.SetDrawColor(cColor)
        surface.DrawTexturedRect(72 + kpoHUD["x"], 144 + kpoHUD["y"], 66, 42)

        draw.SimpleText("W", "HUD_StreakText", 69 + kpoHUD["x"], 21 + kpoHUD["y"], fColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("A", "HUD_StreakText", 21 + kpoHUD["x"], 69 + kpoHUD["y"], lColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("S", "HUD_StreakText", 69 + kpoHUD["x"], 69 + kpoHUD["y"], bColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("D", "HUD_StreakText", 117 + kpoHUD["x"], 69 + kpoHUD["y"], rColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("JUMP", "HUD_StreakText", 69 + kpoHUD["x"], 117 + kpoHUD["y"], jColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("RUN", "HUD_StreakText", 33 + kpoHUD["x"], 165 + kpoHUD["y"], sColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("DUCK", "HUD_StreakText", 105 + kpoHUD["x"], 165 + kpoHUD["y"], cColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    --Velocity counter
    if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then draw.SimpleText(tostring(math.Round(LocalPlayer():GetVelocity():Length())) .. " u/s", "HUD_Health", velocityHUD["x"], velocityHUD["y"], Color(velocityHUD["r"], velocityHUD["g"], velocityHUD["b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP) end

    --Disclaimer for players connecting during an active gamemode and map vote.
    if GetGlobal2Bool("tm_matchended") == true then
        draw.SimpleText("Match has ended", "HUD_GunPrintName", ScrW() / 2, ScrH() / 2 - 160, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0)
        draw.SimpleText("Sit tight, another match is about to begin!", "HUD_Health", ScrW() / 2, ScrH() / 2 - 120, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0)
    end

    --Cranked bar
    if activeGamemode == "Cranked" and timeUntilSelfDestruct != 0 then
        surface.SetDrawColor(50, 50, 50, 80)
        surface.DrawRect(ScrW() / 2 - 75, 70, 150, 10)

        surface.SetDrawColor(255, 0, 0, 80)
        surface.DrawRect(ScrW() / 2 - 75, 70, 150 * (timeUntilSelfDestruct / crankedSelfDestructTime), 10)
    end
end
hook.Add("HUDPaint", "TestHud", HUD)

--Hides the players info that shows up when aiming at another player.
function DrawTarget()
    return false
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

function DrawAmmoInfo()
    return false
end
hook.Add("HUDAmmoPickedUp", "AmmoPickedUp", DrawAmmoInfo)

function DrawWeaponInfo()
    return false
end
hook.Add("HUDWeaponPickedUp", "WeaponPickedUp", DrawWeaponInfo)

function DrawItemInfo()
    return false
end
hook.Add("HUDItemPickedUp", "ItemPickedUp", DrawItemInfo)

--Hides default HL2 HUD elements.
function HideHud(name)
    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus", "CHudDamageIndicator", "CHUDQuickInfo"}) do
        if name == v then return false end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

--Hides the default voice chat HUD and shows a custom message.
function GM:PlayerStartVoice(ply)
    voiceActive = true
    return
end

function GM:PlayerEndVoice(ply)
    voiceActive = false
end

--Plays the received hitsound if a player hits another player.
net.Receive("PlayHitsound", function(len, pl)
    if sounds["hit_enabled"] == 0 then return end
    local hit_reg = "hitsound/hit_" .. sounds["hit"] .. ".wav"
    local hit_reg_head = "hitsound/hit_head_" .. sounds["hit"] .. ".wav"

    local hitgroup = net.ReadUInt(4)
    local soundfile = hit_reg

    if (hitgroup == HITGROUP_HEAD) then soundfile = hit_reg_head end
    surface.PlaySound(soundfile)
end )

net.Receive("KillFeedUpdate", function(len, ply)
    if GetConVar("tm_hud_enablekillfeed"):GetInt() == 0 then return end
    local playersInAction = net.ReadString()
    local victimLastHitIn = net.ReadInt(5)
    local attacker = net.ReadString()
    local streak = net.ReadInt(10)

    table.insert(feedArray, {playersInAction, victimLastHitIn})
    if table.Count(feedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(feedArray, 1) end
    timer.Create(playersInAction .. math.Round(CurTime()), 8, 1, function()
        table.remove(feedArray, 1)
    end)

    if streak == 5 or streak == 10 or streak == 15 or streak == 20 or streak == 25 or streak == 30 then
        table.insert(feedArray, {attacker .. " is on a " .. streak .. " killstreak", 0})
        if table.Count(feedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(feedArray, 1) end
        timer.Create(attacker .. streak .. math.Round(CurTime()), 8, 1, function()
            table.remove(feedArray, 1)
        end)
    end
end )

--Displays after a player kills another player.
net.Receive("NotifyKill", function(len, ply)
    if GetConVar("tm_hud_enable"):GetInt() == 0 then return end
    if gameEnded then return end
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local killStreak = net.ReadInt(10)

    local seperator = ""

    if IsValid(KillNotif) then KillNotif:Remove() end

    if IsValid(DeathNotif) then DeathNotif:Remove() end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(ScrW(), 200)
    KillNotif:SetX(killdeathHUD["x"])
    KillNotif:SetY(ScrH() - killdeathHUD["y"])
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(ScrW() / 2 - 25, 50)
    KillIcon:SetSize(50, 50)
    KillIcon:SetImage("icons/killicon.png")

    --Displays the Accolades that the player accomplished during the kill, this is a very bad system, and I don't plan on reworking it, gg.
    if LocalPly:Health() <= 15 then
        clutch = "Clutch +20 | "
        seperator = "| "
    else
        clutch = ""
    end

    if killedFrom >= 40 then
        marksman = "Longshot +" .. killedFrom .. " | "
        seperator = "| "
    else
        marksman = ""
    end

    if killedFrom <= 3 then
        pointblank = "Point Blank +20 | "
        seperator = "| "
    else
        pointblank = ""
    end

    if killedWith == "Tanto" or killedWith == "Mace" or killedWith == "KM-2000" then
        smackdown = "Smackdown +20 |"
        seperator = "| "
    else
        smackdown = ""
    end

    if killStreak >= 3 then
        onstreakScore = 10 * killStreak
        onstreak = "On Streak +" .. onstreakScore .. " | "
        seperator = "| "
    else
        onstreakScore = ""
        onstreak = ""
    end

    if killedPlayer:GetNWInt("killStreak") >= 3 then
        buzzkillScore = 10 * killedPlayer:GetNWInt("killStreak")
        buzzkill = "Buzz Kill +" .. buzzkillScore .. " | "
        seperator = "| "
    else
        buzzkillScore = ""
        buzzkill = ""
    end

    if lastHitIn == 1 then
        headshot = "Headshot +20 | "
        seperator = "| "
        KillIcon:SetImageColor(red)
    else
        headshot = ""
        KillIcon:SetImageColor(Color(killdeathHUD["killicon_r"], killdeathHUD["killicon_g"], killdeathHUD["killicon_b"]))
    end

    --Setting up variables related to colors, mostly for animations or dynamic text color.
    local streakColor
    local orangeColor = Color(255, 200, 100)
    local redColor = Color(255, 50, 50)
    local rainbowSpeed = 160
    local rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

    --Dynamic text color depending on the killstreak of the player.
    if killStreak <= 2 then
        streakColor = white
    elseif killStreak <= 4 then
        streakColor = orangeColor
    elseif killStreak <= 6 then
        streakColor = redColor
    end

    KillNotif.Paint = function(self, w, h)
        if !IsValid(killedPlayer) then KillNotif:Remove() return end
        if killStreak >= 7 then streakColor = rainbowColor end
        rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

        --Displays information about the player you killed, as well as the Accolades you achived.
        if killStreak > 1 then draw.SimpleText(killStreak .. " Kills", StreakFont, w / 2, 35, streakColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
        draw.SimpleText(killedPlayer:GetName(), NameFont, w / 2, 125, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(seperator .. headshot .. onstreak .. clutch .. buzzkill .. marksman .. pointblank .. smackdown, StreakFont, w / 2, 160, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    if sounds["kill_enabled"] == 1 then surface.PlaySound("hitsound/kill_" .. sounds["kill"] .. ".wav") end

    --Creates a countdown for the kill UI, having it disappear after 3.5 seconds.
    timer.Create("killNotification", 3.5, 1, function()
        if IsValid(KillNotif) then
            KillNotif:MoveTo(killdeathHUD["x"], ScrH(), 1, 0, 0.25, function()
                KillNotif:Remove()
            end)
        end
    end)
end )

--Displays after a player dies to another player
net.Receive("NotifyDeath", function(len, ply)
    hook.Remove("Tick", "KeyOverlayTracking")
    if timer.Exists("CounterUpdate") then timer.Remove("CounterUpdate") end
    if timer.Exists("CrankedTimeUntilDeath") then hook.Remove("Think", "CrankedTimeLeft") end
    timeUntilSelfDestruct = 0
    if GetConVar("tm_hud_enable"):GetInt() == 0 then return end
    if gameEnded then return end

    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()
    local lastHitIn = net.ReadInt(5)
    local respawnTimeLeft = playerRespawnTime

    if IsValid(KillNotif) then KillNotif:Remove() end
    if IsValid(DeathNotif) then DeathNotif:Remove() end

    --Creates a cooldown for the death UI, having it disappear after 4 seconds.
    timer.Create("respawnTimeHideHud", playerRespawnTime, 1, function()
        DeathNotif:Remove()
        hook.Remove("Think", "ShowRespawnTime")
    end)

    --Gets the remaining respawn countdown, and sets it as a variable for later use.
    hook.Add("Think", "ShowRespawnTime", function()
        if timer.Exists("respawnTimeHideHud") then respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1) end
    end)

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(ScrW(), 300)
    DeathNotif:SetX(killdeathHUD["x"])
    DeathNotif:SetY(ScrH() - killdeathHUD["y"])
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function(self, w, h)
        if !IsValid(killedBy) then DeathNotif:Remove() return end
        if lastHitIn == 1 then
            draw.SimpleText(killedFrom .. "m" .. " HS", WepFont, w / 2 + 10, 165, red, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(killedFrom .. "m", WepFont, w / 2 + 10, 165, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end

        --Information about the cause of your death, hopefully it wasn't too embarrising.
        draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 0))
        draw.SimpleText("Killed by", ArialFont, w / 2, 8, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", DeathFont, w / 2, 135.5, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("|", DeathFont, w / 2, 160, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedBy:GetName(), DeathFont, w / 2 - 10, 137.5, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedWith, DeathFont, w / 2 + 10, 137.5, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if killedBy:Health() <= 0 then
            draw.SimpleText("DEAD", WepFont, w / 2 - 10, 165, red, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText(killedBy:Health() .. "HP", WepFont, w / 2 - 10, 165, white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end

        draw.SimpleText("Respawning in " .. respawnTimeLeft .. "s", ArialFont, w / 2 - 10, 200, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Press [" .. input.GetKeyName(GetConVar("tm_mainmenubind"):GetInt()) .. "] to open the menu", WepFont, w / 2, 220, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    KilledByCallingCard = vgui.Create("DImage", DeathNotif)
    KilledByCallingCard:SetPos(ScrW() / 2 - 120, 20)
    KilledByCallingCard:SetSize(240, 80)
    if IsValid(killedBy) then KilledByCallingCard:SetImage(killedBy:GetNWString("chosenPlayercard"), "cards/color/black.png") end

    KilledByPlayerProfilePicture = vgui.Create("AvatarImage", KilledByCallingCard)
    KilledByPlayerProfilePicture:SetPos(5, 5)
    KilledByPlayerProfilePicture:SetSize(70, 70)
    KilledByPlayerProfilePicture:SetPlayer(killedBy, 184)

    if GetConVar("tm_screenflashes"):GetInt() == 1 then LocalPly:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 45), 0.3, 0) end

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )

--Displays to all players when a map vote begins.
net.Receive("EndOfGame", function(len, ply)
    gameEnded = true
    local dof
    local winningPlayer
    local wonMatch = false
    local votedOnMap = false
    local votedOnGamemode = false
    local mapPicked
    local gamemodePicked
    local mapDecided = false
    local gamemodeDecided = false
    local VOIPActive = false
    local bonusXP = 750

    if IsValid(KillNotif) then KillNotif:Remove() end
    if IsValid(DeathNotif) then DeathNotif:Remove() end
    if IsValid(EndOfGameUI) then EndOfGameUI:Remove() end

    if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

    local firstMap = net.ReadString()
    local secondMap = net.ReadString()
    local firstMode = net.ReadInt(4)
    local secondMode = net.ReadInt(4)

    local firstMapName
    local firstMapThumb
    local secondMapName
    local secondMapThumb
    local decidedMapName
    local decidedMapThumb
    local firstModeName
    local secondModeName
    local decidedModeName

    for m, t in pairs(mapArray) do
        if game.GetMap() == t[1] then
            mapPlayedOn = t[2]
        end

        if firstMap == t[1] then
            firstMapName = t[2]
            firstMapThumb = t[3]
        end

        if secondMap == t[1] then
            secondMapName = t[2]
            secondMapThumb = t[3]
        end
    end

    for g, t in pairs(gamemodeArray) do
        if firstMode == t[1] then
            firstModeName = tostring(t[2])
            firstModeDesc = tostring(t[3])
        end

        if secondMode == t[1] then
            secondModeName = tostring(t[2])
            secondModeDesc = tostring(t[3])
        end
    end

    local timeUntilNextMatch = 33
    local VotingActive = false

    local connectedPlayers = player.GetHumans()
    if activeGamemode == "FFA" or activeGamemode == "Fiesta" or activeGamemode == "Shotty Snipers" or activeGamemode == "Cranked" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("playerScoreMatch") > b:GetNWInt("playerScoreMatch") end) elseif activeGamemode == "Gun Game" then table.sort(connectedPlayers, function(a, b) return a:GetNWInt("ladderPosition") > b:GetNWInt("ladderPosition") end) end

    --Creates a timer so players can see how long it will be until the next match starts.
    timer.Create("timeUntilNextMatch", 33, 1, function()
    end)

    timer.Create("ShowVotingMenu", 8, 1, function()
        StartVotingPhase()
    end)
    --Determine who won the match.
    for k, v in pairs(connectedPlayers) do
        if k == 1 then winningPlayer = v end
    end

    if winningPlayer == LocalPly then
        wonMatch = true
        bonusXP = 1500
    end

    local expandTime = 4

    local anchorAnim = ScrH() / 2 - 110
    timer.Create("ExpandDetails", expandTime, 1, function()
        anchorAnim = ScrH() / 2 - 220
        ExpandDetails()
    end)

    function HideHudPostGame(name)
        for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus", "CHudDamageIndicator", "CHUDQuickInfo", "CHudCrosshair"}) do
            if name == v then return false end
        end
    end
    hook.Add("HUDShouldDraw", "HideDefaultHudPostGame", HideHudPostGame)

    local MatchEndMusic
    local textAnim = ScrH()
    local textAnimTwo = ScrH()
    local levelAnim = 0
    local xpCountUp = 0
    local quote = quoteArray[math.random(#quoteArray)]

    if wonMatch == true then
        LocalPly:ScreenFade(SCREENFADE.OUT, Color(50, 50, 0, 190), 1, 7)
        MatchEndMusic = CreateSound(LocalPly, "music/ui/matchvictory.mp3")
        MatchEndMusic:Play()
        MatchEndMusic:ChangeVolume(1)

        MatchWinLoseText = vgui.Create("DPanel")
        MatchWinLoseText:SetSize(800, 220)
        MatchWinLoseText:SetPos(ScrW() / 2 - 400, ScrH())
        MatchWinLoseText:MakePopup()
        MatchWinLoseText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnim = math.Clamp(textAnim - 1500 * FrameTime(), anchorAnim, ScrH())
            MatchWinLoseText:SetY(textAnim)

            draw.SimpleText("VICTORY", "MatchEndText", w / 2, h / 2 - 90, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(quote, "QuoteText", w / 2, h / 2 + 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    else
        LocalPly:ScreenFade(SCREENFADE.OUT, Color(50, 0, 0, 190), 1, 7)
        MatchEndMusic = CreateSound(LocalPly, "music/ui/matchdefeat.mp3")
        MatchEndMusic:Play()
        MatchEndMusic:ChangeVolume(1)

        MatchWinLoseText = vgui.Create("DPanel")
        MatchWinLoseText:SetSize(800, 220)
        MatchWinLoseText:SetPos(ScrW() / 2 - 400, ScrH())
        MatchWinLoseText:MakePopup()
        MatchWinLoseText.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnim = math.Clamp(textAnim - 1500 * FrameTime(), anchorAnim, ScrH())
            MatchWinLoseText:SetY(textAnim)

            draw.SimpleText("DEFEAT", "MatchEndText", w / 2, h / 2 - 90, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(quote, "QuoteText", w / 2, h / 2 + 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    function ExpandDetails()
        DetailsPanel = vgui.Create("DPanel")
        DetailsPanel:SetSize(800, 220)
        DetailsPanel:SetPos(ScrW() / 2 - 400, ScrH())
        DetailsPanel:MakePopup()
        DetailsPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
            textAnimTwo = math.Clamp(textAnimTwo - 3000 * FrameTime(), ScrH() / 2, ScrH())
            DetailsPanel:SetY(textAnimTwo)
            if LocalPly:GetNWInt("playerLevel") != 60 then
                levelAnim = math.Clamp(levelAnim + (LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel")) * FrameTime(), 0, LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel"))
                xpCountUp = math.Clamp(xpCountUp + LocalPly:GetNWInt("playerXP") * FrameTime(), 0, LocalPly:GetNWInt("playerXP"))

                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(w / 2 - 300, 50, 600, 15)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(w / 2 - 300, 50, levelAnim * 600, 15)
                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "StreakText", w / 2 - 300, 25, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(LocalPly:GetNWInt("playerLevel") + 1, "StreakText", w / 2 + 300, 25, white, TEXT_ALIGN_RIGHT)
                draw.SimpleText(math.Round(xpCountUp) .. " / " .. LocalPly:GetNWInt("playerXPToNextLevel") .. "XP  ^", "StreakText", (w / 2 - 295) + (levelAnim * 600), 75, white, TEXT_ALIGN_RIGHT)
                draw.SimpleText("Earned " .. LocalPly:GetNWInt("playerScoreMatch") .. "XP + " .. bonusXP .. "XP Bonus", "StreakText", w / 2, 100, white, TEXT_ALIGN_CENTER)
            else
                levelAnim = math.Clamp(levelAnim + (1 / 1) * FrameTime(), 0, 1)

                surface.SetDrawColor(30, 30, 30, 150)
                surface.DrawRect(w / 2 - 300, 50, 600, 15)
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(w / 2 - 300, 50, levelAnim * 600, 15)
                draw.SimpleText("MAX LEVEL", "StreakText", w / 2, 25, white, TEXT_ALIGN_CENTER)
                draw.SimpleText("Prestige at the Main Menu", "StreakText", w / 2, 65, white, TEXT_ALIGN_CENTER)
            end
        end
    end

    hook.Add("Think", "VotingTimerUpdate", function()
        if timer.Exists("timeUntilNextMatch") then timeUntilNextMatch = math.Round(timer.TimeLeft("timeUntilNextMatch")) end
    end)

    EndOfGameUI = vgui.Create("DPanel")
    EndOfGameUI:SetSize(ScrW(), ScrH())
    EndOfGameUI:SetPos(0, 0)
    EndOfGameUI:MakePopup()
    EndOfGameUI.Paint = function(self, w, h)
        if VotingActive == false then return end
        if dof == true then DrawBokehDOF(4, 1, 0) end
        draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 225))
        if timeUntilNextMatch > 10 then
            draw.SimpleText("Voting ends in " .. timeUntilNextMatch - 10 .. "s", "MainMenuLoadoutWeapons", 485, ScrH() - 55, white, TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("Match begins in " .. timeUntilNextMatch .. "s", "MainMenuLoadoutWeapons", 485, ScrH() - 55, white, TEXT_ALIGN_LEFT)
        end
        if VOIPActive == true then draw.DrawText("MIC ENABLED", "MainMenuLoadoutWeapons", 485, ScrH() - 235, Color(0, 255, 0), TEXT_ALIGN_LEFT) else draw.DrawText("MIC DISABLED", "MainMenuLoadoutWeapons", 485, ScrH() - 235, Color(255, 0, 0), TEXT_ALIGN_LEFT) end
        draw.SimpleText("Had fun?", "MainMenuLoadoutWeapons", 700, ScrH() - 55, white, TEXT_ALIGN_LEFT)
    end

    function StartVotingPhase()
        if IsValid(MatchWinLoseText) then MatchWinLoseText:Remove() end
        if IsValid(DetailsPanel) then DetailsPanel:Remove() end
        MatchEndMusic:ChangeVolume(0.2)
        VotingActive = true
        local EndOfGamePanel = vgui.Create("DPanel", EndOfGameUI)
        EndOfGamePanel:SetSize(475, ScrH())
        EndOfGamePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
        end

        local MatchInformationPanel = vgui.Create("DPanel", EndOfGamePanel)
        MatchInformationPanel:Dock(TOP)
        MatchInformationPanel:SetSize(0, 50)
        MatchInformationPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            draw.SimpleText("MATCH RESULTS", "GunPrintName", 237.5, -3, white, TEXT_ALIGN_CENTER)
        end

        local VotingPanel = vgui.Create("DPanel", EndOfGamePanel)
        VotingPanel:Dock(BOTTOM)
        VotingPanel:SetSize(0, 275)
        VotingPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            if mapDecided == false then
                if mapPicked == 1 then draw.RoundedBox(0, 10, 70, 175, 175, Color(50, 125, 50, 75)) end
                if mapPicked == 2 then draw.RoundedBox(0, 290, 70, 175, 175, Color(50, 125, 50, 75)) end
                draw.SimpleText("MAP VOTE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)

                draw.SimpleText(firstMapName, "MainMenuLoadoutWeapons", 10, 245, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(secondMapName, "MainMenuLoadoutWeapons", 465, 245, white, TEXT_ALIGN_RIGHT)
                draw.SimpleText(GetGlobal2Int("VotesOnMapOne", 0) .. " | " .. GetGlobal2Int("VotesOnMapTwo"), "MainMenuLoadoutWeapons", w / 2, 245, white, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("NEXT MAP", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                draw.SimpleText(decidedMapName, "MainMenuLoadoutWeapons", w / 2, 245, white, TEXT_ALIGN_CENTER)
            end
        end

        local GamemodePanel = vgui.Create("DPanel", EndOfGamePanel)
        GamemodePanel:Dock(BOTTOM)
        GamemodePanel:SetSize(0, 100)
        GamemodePanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25, 100))
            if gamemodeDecided == false then
                if gamemodePicked == 1 then draw.RoundedBox(0, 10, 62.5, 175, 20, Color(50, 125, 50, 75)) end
                if gamemodePicked == 2 then draw.RoundedBox(0, 290, 62.5, 175, 20, Color(50, 125, 50, 75)) end
                draw.SimpleText("GAMEMODE VOTE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                draw.SimpleText(GetGlobal2Int("VotesOnModeOne", 0) .. " | " .. GetGlobal2Int("VotesOnModeTwo"), "MainMenuLoadoutWeapons", w / 2, 70, white, TEXT_ALIGN_CENTER)
            else
                draw.SimpleText("NEXT MODE", "GunPrintName", w / 2, 5, white, TEXT_ALIGN_CENTER)
                draw.SimpleText(decidedModeName, "MainMenuLoadoutWeapons", w / 2, 65, white, TEXT_ALIGN_CENTER)
            end
        end

        local MapChoice = vgui.Create("DImageButton", VotingPanel)
        local MapChoiceTwo = vgui.Create("DImageButton", VotingPanel)
        local ModeChoice = vgui.Create("DButton", GamemodePanel)
        local ModeChoiceTwo = vgui.Create("DButton", GamemodePanel)

        MapChoice:SetPos(10, 70)
        MapChoice:SetText("")
        MapChoice:SetSize(175, 175)
        MapChoice:SetImage(firstMapThumb)
        MapChoice.DoClick = function()
            net.Start("ReceiveMapVote")
            net.WriteString(firstMap)
            net.WriteUInt(1, 2)
            net.SendToServer()
            votedOnMap = true
            mapPicked = 1
            surface.PlaySound("buttons/button15.wav")

            MapChoice:SetPos(20, 80)
            MapChoice:SetSize(155, 155)
            MapChoice:SetEnabled(false)
            MapChoiceTwo:SetEnabled(false)
        end

        MapChoiceTwo:SetPos(290, 70)
        MapChoiceTwo:SetText("")
        MapChoiceTwo:SetSize(175, 175)
        MapChoiceTwo:SetImage(secondMapThumb)
        MapChoiceTwo.DoClick = function()
            net.Start("ReceiveMapVote")
            net.WriteString(secondMap)
            net.WriteUInt(2, 2)
            net.SendToServer()
            votedOnMap = true
            mapPicked = 2
            surface.PlaySound("buttons/button15.wav")

            MapChoiceTwo:SetPos(300, 80)
            MapChoiceTwo:SetSize(155, 155)
            MapChoice:SetEnabled(false)
            MapChoiceTwo:SetEnabled(false)
        end

        ModeChoice:SetPos(10, 70)
        ModeChoice:SetText(firstModeName)
        ModeChoice:SetSize(175, 30)
        ModeChoice:SetTooltip(firstModeDesc)
        ModeChoice.DoClick = function()
            net.Start("ReceiveModeVote")
            net.WriteInt(firstMode, 4)
            net.WriteUInt(1, 2)
            net.SendToServer()
            votedOnGamemode = true
            gamemodePicked = 1
            surface.PlaySound("buttons/button15.wav")

            ModeChoice:SetEnabled(false)
            ModeChoiceTwo:SetEnabled(false)
        end

        ModeChoiceTwo:SetPos(290, 70)
        ModeChoiceTwo:SetText(secondModeName)
        ModeChoiceTwo:SetSize(175, 30)
        ModeChoiceTwo:SetTooltip(secondModeDesc)
        ModeChoiceTwo.DoClick = function()
            net.Start("ReceiveModeVote")
            net.WriteInt(secondMode, 4)
            net.WriteUInt(2, 2)
            net.SendToServer()
            votedOnGamemode = true
            gamemodePicked = 2
            surface.PlaySound("buttons/button15.wav")

            ModeChoice:SetEnabled(false)
            ModeChoiceTwo:SetEnabled(false)
        end

        net.Receive("MapVoteCompleted", function(len, ply)
            local decidedMap = net.ReadString()
            local decidedMode = net.ReadInt(4)
            for u, p in pairs(mapArray) do
                if decidedMap == p[1] then
                    decidedMapName = p[2]
                    decidedMapThumb = p[3]
                end
            end

            for u, m in pairs(gamemodeArray) do
                if decidedMode == m[1] then
                    decidedModeName = m[2]
                end
            end

            mapDecided = true
            gamemodeDecided = true
            MapChoice:Remove()
            MapChoiceTwo:Remove()
            ModeChoice:Remove()
            ModeChoiceTwo:Remove()

            local DecidedMapThumb = vgui.Create("DImage", VotingPanel)
            DecidedMapThumb:SetPos(150, 70)
            DecidedMapThumb:SetText("")
            DecidedMapThumb:SetSize(175, 175)
            DecidedMapThumb:SetImage(decidedMapThumb)
        end )

        local ExitButton = vgui.Create("DButton", EndOfGameUI)
        ExitButton:SetPos(485, ScrH() - 35)
        ExitButton:SetText("")
        ExitButton:SetSize(185, 100)
        local textAnim = 0
        local disconnectConfirm = 0
        ExitButton.Paint = function()
            if ExitButton:IsHovered() then
                textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
            else
                textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
            end
            if (disconnectConfirm == 0) then
                draw.DrawText("LEAVE GAME", "MainMenuLoadoutWeapons", textAnim, 5, white, TEXT_ALIGN_LEFT)
            else
                draw.DrawText("CONFIRM?", "MainMenuLoadoutWeapons", textAnim, 5, Color(255, 0, 0), TEXT_ALIGN_LEFT)
            end
        end
        ExitButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            if (disconnectConfirm == 0) then
                disconnectConfirm = 1
            else
                RunConsoleCommand("disconnect")
            end

            timer.Simple(1, function() disconnectConfirm = 0 end)
        end

        local DiscordButton = vgui.Create("DButton", EndOfGameUI)
        DiscordButton:SetPos(700, ScrH() - 35)
        DiscordButton:SetText("")
        DiscordButton:SetSize(255, 100)
        local textAnim = 0
        DiscordButton.Paint = function()
            if DiscordButton:IsHovered() then
                textAnim = math.Clamp(textAnim + 200 * FrameTime(), 0, 20)
            else
                textAnim = math.Clamp(textAnim - 200 * FrameTime(), 0, 20)
            end
            draw.DrawText("JOIN OUR DISCORD", "MainMenuLoadoutWeapons", textAnim, 5, Color(114, 137, 218), TEXT_ALIGN_LEFT)
        end
        DiscordButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            gui.OpenURL("https://discord.gg/GRfvt27uGF")
        end

        local VOIPButton = vgui.Create("DImageButton", EndOfGameUI)
        VOIPButton:SetPos(485, ScrH() - 205)
        VOIPButton:SetImage("icons/mutedmicrophoneicon.png")
        VOIPButton:SetSize(80, 80)
        VOIPButton:SetTooltip("Toggle Microphone")
        VOIPButton.DoClick = function()
            surface.PlaySound("tmui/buttonclick.wav")
            if permissions.IsGranted("voicerecord") == true then
                if (VOIPActive == false) then
                    VOIPActive = true
                    VOIPButton:SetImage("icons/microphoneicon.png")
                    permissions.EnableVoiceChat(true)
                else
                    VOIPActive = false
                    VOIPButton:SetImage("icons/mutedmicrophoneicon.png")
                    permissions.EnableVoiceChat(false)
                end
            else
                permissions.EnableVoiceChat(true)
            end
        end

        local PlayerScrollPanel = vgui.Create("DScrollPanel", EndOfGamePanel)
        PlayerScrollPanel:Dock(FILL)
        PlayerScrollPanel:SetSize(EndOfGamePanel:GetWide(), 0)
        PlayerScrollPanel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
        end

        local sbar = PlayerScrollPanel:GetVBar()
        function sbar:Paint(w, h)
            draw.RoundedBox(5, 0, 0, w, h, Color(0, 0, 0, 150))
        end
        function sbar.btnUp:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
        end
        function sbar.btnDown:Paint(w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 155))
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
        end

        PlayerList = vgui.Create("DListLayout", PlayerScrollPanel)
        PlayerList:SetSize(PlayerScrollPanel:GetWide(), PlayerScrollPanel:GetTall())

        for k, v in pairs(connectedPlayers) do
            --Constants for basic player information, much more optimized than checking every frame.
            if !IsValid(v) then return end
            local name = v:GetName()
            local prestige = v:GetNWInt("playerPrestige")
            local level = v:GetNWInt("playerLevel")
            local frags = v:Frags()
            local deaths = v:Deaths()
            local ratio
            local score = v:GetNWInt("playerScoreMatch")

            --Used to format the K/D Ratio of a player, stops it from displaying INF when the player has gotten a kill, but has also not died yet.
            if v:Frags() <= 0 then
                ratio = 0
            elseif v:Frags() >= 1 and v:Deaths() == 0 then
                ratio = v:Frags()
            else
                ratio = v:Frags() / v:Deaths()
            end

            local ratioRounded = math.Round(ratio, 2)

            local PlayerPanel = vgui.Create("DPanel", PlayerList)
            PlayerPanel:SetSize(PlayerList:GetWide(), 125)
            PlayerPanel:SetPos(0, 0)
            PlayerPanel.Paint = function(self, w, h)
                if !IsValid(v) then return end
                if k == 1 then draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 35, 40)) else draw.RoundedBox(0, 0, 0, w, h, Color(35, 35, 35, 40)) end

                draw.SimpleText(name .. " | " .. "P" .. prestige .. " L" .. level, "Health", 10, 0, white, TEXT_ALIGN_LEFT)
                draw.SimpleText(frags, "Health", 285, 35, Color(0, 255, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(deaths, "Health", 285, 60, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(ratioRounded .. "", "Health", 285, 85, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                draw.SimpleText(score, "Health", 427, 85, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            end

            local KillsIcon = vgui.Create("DImage", PlayerPanel)
            KillsIcon:SetPos(260, 42)
            KillsIcon:SetSize(20, 20)
            KillsIcon:SetImage("icons/killicon.png")

            local DeathsIcon = vgui.Create("DImage", PlayerPanel)
            DeathsIcon:SetPos(260, 67)
            DeathsIcon:SetSize(20, 20)
            DeathsIcon:SetImage("icons/deathicon.png")

            local KDIcon = vgui.Create("DImage", PlayerPanel)
            KDIcon:SetPos(260, 92)
            KDIcon:SetSize(20, 20)
            KDIcon:SetImage("icons/ratioicon.png")

            local ScoreIcon = vgui.Create("DImage", PlayerPanel)
            ScoreIcon:SetPos(432, 92)
            ScoreIcon:SetSize(20, 20)
            ScoreIcon:SetImage("icons/scoreicon.png")

            --Displays a players calling card and profile picture.
            local PlayerCallingCard = vgui.Create("DImage", PlayerPanel)
            PlayerCallingCard:SetPos(10, 35)
            PlayerCallingCard:SetSize(240, 80)

            if IsValid(v) then PlayerCallingCard:SetImage(v:GetNWString("chosenPlayercard"), "cards/color/black.png") end

            local PlayerProfilePicture = vgui.Create("AvatarImage", PlayerCallingCard)
            PlayerProfilePicture:SetPos(5, 5)
            PlayerProfilePicture:SetSize(70, 70)
            PlayerProfilePicture:SetPlayer(v, 184)
        end
    end

    EndOfGameUI:Show()
    gui.EnableScreenClicker(true)
end )

--Displays after a player levels up.
net.Receive("NotifyLevelUp", function(len, ply)
    if IsValid(LevelNotif) then LevelNotif:Remove() end
    local previousLevel = net.ReadInt(8)

    LevelNotif = vgui.Create("DFrame")
    LevelNotif:SetSize(600, 100)
    LevelNotif:SetX(ScrW() / 2 - 300)
    LevelNotif:SetY(ScrH())
    LevelNotif:SetTitle("")
    LevelNotif:SetDraggable(false)
    LevelNotif:ShowCloseButton(false)
    LevelNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 110, 0.5, 0, 0.25)

    LevelNotif.Paint = function(self, w, h)
        draw.SimpleText("LEVEL UP", "HUD_PlayerNotiName", 300, 25, Color(255, 255, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(previousLevel .. "  > " .. previousLevel + 1, "HUD_PlayerNotiName", 300, 80, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    LevelNotif:Show()
    LevelNotif:MakePopup()
    LevelNotif:SetMouseInputEnabled(false)
    LevelNotif:SetKeyboardInputEnabled(false)

    if GetConVar("tm_screenflashes"):GetInt() == 1 then LocalPly:ScreenFade(SCREENFADE.IN, Color(255, 255, 0, 45), 0.3, 0) end
    surface.PlaySound("tmui/levelup.wav")

    timer.Create("LevelNotif", 6, 1, function()
        LevelNotif:MoveTo(ScrW() / 2 - 300, ScrH(), 1, 0, 0.25, function()
            LevelNotif:Remove()
        end)
    end)
end )

--Displays after a player levels up.
net.Receive("NotifyMatchTime", function(len, ply)
    if IsValid(TimeNotif) then TimeNotif:Remove() end
    matchTime = math.Round(net.ReadInt(16))
    matchTimeFormatted = string.FormattedTime(matchTime, "%i:%02i")

    if matchTime > 10 then
        TimeNotif = vgui.Create("DFrame")
        TimeNotif:SetSize(600, 100)
        TimeNotif:SetX(ScrW() / 2 - 300)
        TimeNotif:SetY(ScrH())
        TimeNotif:SetTitle("")
        TimeNotif:SetDraggable(false)
        TimeNotif:ShowCloseButton(false)
        TimeNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 400, 0.5, 0, 0.25)

        TimeNotif.Paint = function(self, w, h)
            draw.SimpleText(matchTimeFormatted, "HUD_PlayerNotiName", 300, 25, Color(255, 0, 0, 241), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Remaining", "HUD_WepNameKill", 300, 60, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        TimeNotif:Show()
        TimeNotif:MakePopup()
        TimeNotif:SetMouseInputEnabled(false)
        TimeNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("tmui/timenotif.wav")

        timer.Create("TimeNotif", 4, 1, function()
            TimeNotif:MoveTo(ScrW() / 2 - 300, ScrH(), 1, 0, 0.25, function()
                TimeNotif:Remove()
            end)
        end)
    else
        TimeNotif = vgui.Create("DFrame")
        TimeNotif:SetSize(600, 100)
        TimeNotif:SetX(ScrW() / 2 - 300)
        TimeNotif:SetY(ScrH())
        TimeNotif:SetTitle("")
        TimeNotif:SetDraggable(false)
        TimeNotif:ShowCloseButton(false)
        TimeNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 400, 0.5, 0, 0.25)

        TimeNotif.Paint = function(self, w, h)
            draw.SimpleText(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "HUD_AmmoCount", 300, 45, Color(255, 0, 0, 241), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        TimeNotif:Show()
        TimeNotif:MakePopup()
        TimeNotif:SetMouseInputEnabled(false)
        TimeNotif:SetKeyboardInputEnabled(false)

        surface.PlaySound("tmui/timenotif.wav")

        timer.Create("TimeNotif", 10, 1, function()
            TimeNotif:Remove()
        end)
    end
end )

--Displays after a player reaches the final weapon in Gun Game.
net.Receive("NotifyGGThreat", function(len, ply)
    if IsValid(GGThreatNotif) then GGThreatNotif:Remove() end
    playerName = net.ReadString()

    GGThreatNotif = vgui.Create("DFrame")
    GGThreatNotif:SetSize(600, 100)
    GGThreatNotif:SetX(ScrW() / 2 - 300)
    GGThreatNotif:SetY(ScrH())
    GGThreatNotif:SetTitle("")
    GGThreatNotif:SetDraggable(false)
    GGThreatNotif:ShowCloseButton(false)
    GGThreatNotif:MoveTo(ScrW() / 2 - 300, ScrH() - 400, 0.5, 0, 0.25)

    GGThreatNotif.Paint = function(self, w, h)
        draw.SimpleText(playerName, "HUD_PlayerNotiName", 300, 25, Color(255, 255, 0, 241), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("has reached the Knife", "HUD_WepNameKill", 300, 60, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    GGThreatNotif:Show()
    GGThreatNotif:MakePopup()
    GGThreatNotif:SetMouseInputEnabled(false)
    GGThreatNotif:SetKeyboardInputEnabled(false)

    surface.PlaySound("tmui/timenotif.wav")

    timer.Create("GGThreatNotif", 3, 1, function()
        GGThreatNotif:MoveTo(ScrW() / 2 - 300, ScrH(), 1, 0, 0.25, function()
            GGThreatNotif:Remove()
        end)
    end)
end )

--Displays after a player reaches the final weapon in Gun Game.
net.Receive("NotifyCranked", function(len, ply)
    timeUntilSelfDestruct = crankedSelfDestructTime
    timer.Create("CrankedTimeUntilDeath", crankedSelfDestructTime, 1, function()
        hook.Remove("Think", "CrankedTimeLeft")
    end)

    hook.Add("Think", "CrankedTimeLeft", function()
        if timer.Exists("CrankedTimeUntilDeath") then timeUntilSelfDestruct = math.Round(timer.TimeLeft("CrankedTimeUntilDeath")) end
    end)
end )

--Shows the players loadout on the bottom left hand side of their screen.
function ShowLoadoutOnSpawn()
    if LocalPly == nil then LocalPly = LocalPlayer() end
    local primaryWeapon = ""
    local secondaryWeapon = ""
    local meleeWeapon = ""
    for k, v in pairs(weaponArray) do
        if v[1] == LocalPly:GetNWString("loadoutPrimary") and usePrimary then primaryWeapon = v[2] end
        if v[1] == LocalPly:GetNWString("loadoutSecondary") and useSecondary then secondaryWeapon = v[2] end
        if v[1] == LocalPly:GetNWString("loadoutMelee") and useMelee then meleeWeapon = v[2] end
    end
    notification.AddProgress("LoadoutText", "Current Loadout:\n" .. primaryWeapon .. "\n" .. secondaryWeapon .. "\n" .. meleeWeapon)
    timer.Simple(2.5, function()
        notification.Kill("LoadoutText")
    end)
end
concommand.Add("tm_showloadout", ShowLoadoutOnSpawn)

--ConVar callbacks related to HUD editing, much more optimized and cleaner looking than repeadetly checking the players settings.
cvars.AddChangeCallback("tm_hud_health_size", function(convar_name, value_old, value_new)
    healthHUD["size"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_offset_x", function(convar_name, value_old, value_new)
    healthHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_offset_y", function(convar_name, value_old, value_new)
    healthHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_wep_text_color_r", function(convar_name, value_old, value_new)
    weaponHUD["weptext_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_wep_text_color_g", function(convar_name, value_old, value_new)
    weaponHUD["weptext_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_wep_text_color_b", function(convar_name, value_old, value_new)
    weaponHUD["weptext_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_r", function(convar_name, value_old, value_new)
    weaponHUD["ammobar_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_g", function(convar_name, value_old, value_new)
    weaponHUD["ammobar_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_bar_color_b", function(convar_name, value_old, value_new)
    weaponHUD["ammobar_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_text_color_r", function(convar_name, value_old, value_new)
    weaponHUD["ammotext_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_text_color_g", function(convar_name, value_old, value_new)
    weaponHUD["ammotext_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_ammo_text_color_b", function(convar_name, value_old, value_new)
    weaponHUD["ammotext_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_text_color_r", function(convar_name, value_old, value_new)
    healthHUD["text_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_text_color_g", function(convar_name, value_old, value_new)
    healthHUD["text_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_text_color_b", function(convar_name, value_old, value_new)
    healthHUD["text_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_high_r", function(convar_name, value_old, value_new)
    healthHUD["barhigh_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_high_g", function(convar_name, value_old, value_new)
    healthHUD["barhigh_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_high_b", function(convar_name, value_old, value_new)
    healthHUD["barhigh_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_r", function(convar_name, value_old, value_new)
    healthHUD["barmid_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_g", function(convar_name, value_old, value_new)
    healthHUD["barmid_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_mid_b", function(convar_name, value_old, value_new)
    healthHUD["barmid_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_low_r", function(convar_name, value_old, value_new)
    healthHUD["barmid_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_low_g", function(convar_name, value_old, value_new)
    healthHUD["barmid_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_health_color_low_b", function(convar_name, value_old, value_new)
    healthHUD["barmid_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_equipment_offset_x", function(convar_name, value_old, value_new)
    equipmentHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_equipment_offset_y", function(convar_name, value_old, value_new)
    equipmentHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_killfeed_offset_x", function(convar_name, value_old, value_new)
    feedHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_killfeed_offset_y", function(convar_name, value_old, value_new)
    feedHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_killfeed_opacity", function(convar_name, value_old, value_new)
    feedHUD["opacity"] = value_new
end)
cvars.AddChangeCallback("tm_hud_killdeath_offset_x", function(convar_name, value_old, value_new)
    killdeathHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_killdeath_offset_y", function(convar_name, value_old, value_new)
    killdeathHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_r", function(convar_name, value_old, value_new)
    killdeathHUD["killicon_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_g", function(convar_name, value_old, value_new)
    killdeathHUD["killicon_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_kill_iconcolor_b", function(convar_name, value_old, value_new)
    killdeathHUD["killicon_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_x", function(convar_name, value_old, value_new)
    kpoHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_y", function(convar_name, value_old, value_new)
    kpoHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_inactive_r", function(convar_name, value_old, value_new)
    kpoHUD["inactive_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_inactive_g", function(convar_name, value_old, value_new)
    kpoHUD["inactive_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_inactive_b", function(convar_name, value_old, value_new)
    kpoHUD["inactive_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_actuated_r", function(convar_name, value_old, value_new)
    kpoHUD["actuated_r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_actuated_g", function(convar_name, value_old, value_new)
    kpoHUD["actuated_g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_keypressoverlay_actuated_b", function(convar_name, value_old, value_new)
    kpoHUD["actuated_b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_fpscounter_x", function(convar_name, value_old, value_new)
    fpsHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_fpscounter_y", function(convar_name, value_old, value_new)
    fpsHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_fpscounter_r", function(convar_name, value_old, value_new)
    fpsHUD["r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_fpscounter_g", function(convar_name, value_old, value_new)
    fpsHUD["g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_fpscounter_b", function(convar_name, value_old, value_new)
    fpsHUD["b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_x", function(convar_name, value_old, value_new)
    velocityHUD["x"] = value_new
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_y", function(convar_name, value_old, value_new)
    velocityHUD["y"] = value_new
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_r", function(convar_name, value_old, value_new)
    velocityHUD["r"] = value_new
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_g", function(convar_name, value_old, value_new)
    velocityHUD["g"] = value_new
end)
cvars.AddChangeCallback("tm_hud_velocitycounter_b", function(convar_name, value_old, value_new)
    velocityHUD["b"] = value_new
end)
cvars.AddChangeCallback("tm_hud_font_kill", function(convar_name, value_old, value_new)
    if value_new == "1" then
        StreakFont = "HUD_StreakText"
        NameFont = "HUD_PlayerNotiName"
    else
        StreakFont = "StreakText"
        NameFont = "PlayerNotiName"
    end
end)
cvars.AddChangeCallback("tm_hud_font_death", function(convar_name, value_old, value_new)
    if value_new == "1" then
        ArialFont = "HUD_Arial18"
        DeathFont = "HUD_PlayerDeathName"
        WepFont = "HUD_WepNameKill"
    else
        ArialFont = "Arial18"
        DeathFont = "PlayerDeathName"
        WepFont = "WepNameKill"
    end
end)
cvars.AddChangeCallback("tm_hud_killfeed_style", function(convar_name, value_old, value_new)
    if value_new == 0 then
        feedEntryPadding = -20
    else
        feedEntryPadding = 20
    end
end)
cvars.AddChangeCallback("tm_hud_equipment_anchor", function(convar_name, value_old, value_new)
    if value_new == 0 then
        equipAnchor = "left"
    elseif value_new == 1 then
        equipAnchor = "center"
    elseif value_new == 2 then
        equipAnchor = "right"
    end
end)
cvars.AddChangeCallback("tm_hitsounds", function(convar_name, value_old, value_new)
    sounds["hit_enabled"] = value_new
end)
cvars.AddChangeCallback("tm_killsound", function(convar_name, value_old, value_new)
    sounds["kill_enabled"] = value_new
end)
cvars.AddChangeCallback("tm_hitsoundtype", function(convar_name, value_old, value_new)
    sounds["hit"] = value_new
end)
cvars.AddChangeCallback("tm_killsoundtype", function(convar_name, value_old, value_new)
    sounds["kill"] = value_new
end)