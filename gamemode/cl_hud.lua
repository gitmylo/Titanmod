--Color array, saving space
local white = Color(255, 255, 255, 255)
local red = Color(255, 0, 0, 255)

local scrw = ScrW()
local scrh = ScrH()

local isAnimatingKill

function HUD()
    --Disables the HUD if the player has it disabled in Options.
	if CLIENT and GetConVar("tm_enableui"):GetInt() == 1 then
		local client = LocalPlayer()

		if !client:Alive() then
			return
		end

        --Hides the HUD if the player has the Main Menu open.
        if LocalPlayer():GetNWBool("mainmenu") == true then
            return
        end

        --Shows the players ammo and weapon depending on the style they have selected in Options.
        --Numeric Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 0 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 60, white, TEXT_ALIGN_RIGHT, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "AmmoCount", ScrW() - 15, ScrH() - 170, red, TEXT_ALIGN_RIGHT, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "AmmoCount", ScrW() - 15, ScrH() - 170, white, TEXT_ALIGN_RIGHT, 0)
            end
        end

        --Middle Numeric Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 3 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() / 2, ScrH() - 60, white, TEXT_ALIGN_CENTER, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "AmmoCount", ScrW() / 2, ScrH() - 170, red, TEXT_ALIGN_CENTER, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "AmmoCount", ScrW() / 2, ScrH() - 170, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        --Bar Style
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 1 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 100, white, TEXT_ALIGN_RIGHT, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 175, red, TEXT_ALIGN_CENTER, 0)
            end

            if (client:GetActiveWeapon():IsValid()) then
                if not (client:GetActiveWeapon():Clip1() == 0) then
                    surface.SetDrawColor(50, 50, 50, 150)
                    surface.DrawRect(ScrW() - 415, ScrH() - 39, 400, 30)
                else
                    surface.SetDrawColor(255, 0, 0, 150)
                    surface.DrawRect(ScrW() - 415, ScrH() - 39, 400, 30)
                end

                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(ScrW() - 415, ScrH() - 39, 400 * (client:GetActiveWeapon():Clip1() / client:GetActiveWeapon():GetMaxClip1()), 30)
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "Health", ScrW() - 410, ScrH() - 40, Color(50, 50, 50, 255), TEXT_ALIGN_LEFT, 0)
            end
        end

        --Below Crosshair
        if CLIENT and GetConVar("tm_ammostyle"):GetInt() == 2 then
            if (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():GetPrintName() != nil) then
                draw.SimpleText(client:GetActiveWeapon():GetPrintName(), "GunPrintName", ScrW() - 15, ScrH() - 60, white, TEXT_ALIGN_RIGHT, 0)
            end

            if CLIENT and GetConVar("tm_reloadhints"):GetInt() == 1 and (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() == 0) then
                draw.SimpleText("0", "GunPrintName", ScrW() / 2, ScrH() / 2 + 120, red, TEXT_ALIGN_CENTER, 0)
                draw.SimpleText("RELOAD", "WepNameKill", ScrW() / 2, ScrH() / 2 + 170, red, TEXT_ALIGN_CENTER, 0)
            elseif (client:GetActiveWeapon():IsValid()) and (client:GetActiveWeapon():Clip1() >= 0) then
                draw.SimpleText(client:GetActiveWeapon():Clip1(), "GunPrintName", ScrW() / 2, ScrH() / 2 + 120, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        --Shows the players health depending on the style they have selected in Options.
        --Left Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 0 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(10, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(10, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            if client:Health() <= 0 then
                draw.SimpleText("0", "Health", 450, ScrH() - 39, white, TEXT_ALIGN_RIGHT, 0)
            else
                draw.SimpleText(client:Health(), "Health", 450, ScrH() - 39, white, TEXT_ALIGN_RIGHT, 0)
            end
        end

        --Middle Anchor
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 1 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(ScrW() / 2 - 225, ScrH() - 38, 450 * (client:Health() / client:GetMaxHealth()), 30)
            if client:Health() <= 0 then
                draw.SimpleText("0", "Health", ScrW() / 2, ScrH() - 39, white, TEXT_ALIGN_CENTER, 0)
            else
                draw.SimpleText(client:Health(), "Health", ScrW() / 2, ScrH() - 39, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        if CLIENT and GetConVar("tm_showspeed"):GetInt() == 1 then
            draw.SimpleText(LocalPlayer():GetVelocity(), "Health", ScrW() / 2, 10, white, TEXT_ALIGN_CENTER, 0)
        end

        --Below Crosshair
        if CLIENT and GetConVar("tm_healthanchor"):GetInt() == 2 then
            surface.SetDrawColor(50, 50, 50, 255)
            surface.DrawRect(ScrW() / 2 - 100, ScrH() / 2 + 200, 150 , 30)

            if client:Health() <= 66 then
                if client:Health() <= 33 then
                    surface.SetDrawColor(180, 100, 100)
                else
                    surface.SetDrawColor(180, 180, 100)
                end
            else
                surface.SetDrawColor(100, 180, 100)
            end

            surface.DrawRect(ScrW() / 2 - 100, ScrH() / 2 + 200, 200 * (client:Health() / client:GetMaxHealth()), 30)
            if client:Health() <= 0 then
                draw.SimpleText("0", "Health", ScrW() / 2, ScrH() / 2 + 200, white, TEXT_ALIGN_CENTER, 0)
            else
                draw.SimpleText(client:Health(), "Health", ScrW() / 2, ScrH() / 2 + 200, white, TEXT_ALIGN_CENTER, 0)
            end
        end

        --Velocity Counter
        if CLIENT and GetConVar("tm_showspeed"):GetInt() == 1 then
            draw.SimpleText(LocalPlayer():GetVelocity(), "Health", ScrW() / 2, 10, white, TEXT_ALIGN_CENTER, 0)
        end
    end
end
hook.Add("HUDPaint", "TestHud", HUD)

--Hides the players info that shows up when aiming at another player.
function DrawTarget()
    return false
end
hook.Add("HUDDrawTargetID", "HidePlayerInfo", DrawTarget)

--Hides default HL2 HUD elements.
function HideHud(name)
    for k, v in pairs({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudZoom", "CHudVoiceStatus", "CHudDamageIndicator"}) do
        if name == v then
            return false
        end
    end
end
hook.Add("HUDShouldDraw", "HideDefaultHud", HideHud)

--Hides the default voice chat HUD.
function GM:PlayerStartVoice(ply)
    return
end

--Plays the received hitsound if a player hits another player.
net.Receive("PlayHitsound", function(len, pl)
    if CLIENT and GetConVar("tm_hitsounds"):GetInt() == 1 then
        local hit_reg = "hitsound/hit_reg.wav"
        local hit_reg_head = "hitsound/hit_reg_head.wav"

        local hitgroup = net.ReadUInt(4)
        local soundfile = hit_reg

        if (hitgroup == HITGROUP_HEAD) then
            soundfile = hit_reg_head
        end

        surface.PlaySound(soundfile)
    end
end )

--Displays after a player kills another player.
net.Receive("NotifyKill", function(len, ply)
    local killedPlayer = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()

    local seperator = ""

    if IsValid(KillNotif) then
        KillNotif:Hide()
    end

    KillNotif = vgui.Create("DFrame")
    KillNotif:SetSize(600, 200)
    KillNotif:SetX(ScrW() / 2 - 300)
    if CLIENT and GetConVar("tm_killuianchor"):GetInt() == 0 then
        KillNotif:SetY(ScrH() - 335)
    else
        KillNotif:SetY(115)
    end
    KillNotif:SetTitle("")
    KillNotif:SetDraggable(false)
    KillNotif:ShowCloseButton(false)

    --Displays the Accolades that the player accomplished during the kill, this is a very bad system, and I don't plan on reworking it, gg.
    if LocalPlayer():GetNWInt("killStreak") >= 2 then
        onstreak = "On Streak"
        onstreakScore = 10 * LocalPlayer():GetNWInt("killStreak") + 10
        onstreakIndent = " +"
        onstreakSeperator = " | "
        seperator = "| "
    else
        onstreak = ""
        onstreakScore = ""
        onstreakIndent = ""
        onstreakSeperator = ""
    end

    if LocalPlayer():Health() <= 15 then
        clutch = "Clutch"
        clutchScore = 20
        clutchIndent = " +"
        clutchSeperator = " | "
        seperator = "| "
    else
        clutch = ""
        clutchScore = ""
        clutchIndent = ""
        clutchSeperator = ""
    end

    if killedPlayer:GetNWInt("killStreak") >= 3 then
        buzzkill = "Buzz Kill"
        buzzkillScore = 10 * killedPlayer:GetNWInt("killStreak")
        buzzkillIndent = " +"
        buzzkillSeperator = " | "
        seperator = "| "
    else
        buzzkill = ""
        buzzkillScore = ""
        buzzkillIndent = ""
        buzzkillSeperator = ""
    end

    if killedFrom >= 40 then
        marksman = "Longshot"
        marksmanScore = killedFrom
        marksmanIndent = " +"
        marksmanSeperator = " | "
        seperator = "| "
    else
        marksman = ""
        marksmanScore = ""
        marksmanIndent = ""
        marksmanSeperator = ""
    end

    if killedFrom <= 3 then
        pointblank = "Point Blank"
        pointblankScore = 20
        pointblankIndent = " +"
        pointblankSeperator = " | "
        seperator = "| "
    else
        pointblank = ""
        pointblankScore = ""
        pointblankIndent = ""
        pointblankSeperator = ""
    end

    if killedWith == "Tanto" or killedWith == "Japanese Ararebo" or killedWith == "KM-2000" then
        smackdown = "Smackdown"
        smackdownScore = 20
        smackdownIndent = " +"
        smackdownSeperator = " | "
        seperator = "| "
    else
        smackdown = ""
        smackdownScore = ""
        smackdownIndent = ""
        smackdownSeperator = ""
    end

    if killedPlayer:SteamID() == LocalPlayer():GetNWInt("recentlyKilledBy") and LocalPlayer():GetNWBool("gotRevenge") == false then
        if killedPlayer:SteamID() == LocalPlayer():SteamID() then return end
        revenge = "Revenge"
        revengeScore = 20
        revengeIndent = " +"
        revengeSeperator = " | "
        seperator = "| "
    else
        revenge = ""
        revengeScore = ""
        revengeIndent = ""
        revengeSeperator = ""
    end

    --Setting up variables related to colors, mostly for animations or dynamic text color.
    local streakColor
    local whiteColor = Color(255, 255, 255)
    local orangeColor = Color(255, 200, 100)
    local redColor = Color(255, 50, 50)
    local rainbowColor
    local rainbowSpeed = 160

    KillNotif.Paint = function()
        --Changes the kill icons color if a player got a headshot kill.
        if LocalPlayer():GetNWBool("lastShotHead") == true then
            headshot = "Headshot"
            headshotScore = 20
            headshotIndent = " +"
            headshotSeperator = " | "
            seperator = "| "

            KillIcon:SetImageColor(Color(255, 0, 0))
        else
            headshot = ""
            headshotScore = ""
            headshotIndent = ""
            headshotSeperator = ""

            KillIcon:SetImageColor(Color(255, 255, 255))
        end

        --Dynamic text color depending on the killstreak of the player.
        if LocalPlayer():GetNWInt("killStreak") <= 2 then
            streakColor = whiteColor
        elseif LocalPlayer():GetNWInt("killStreak") <= 4 then
            streakColor = orangeColor
        elseif LocalPlayer():GetNWInt("killStreak") <= 6 then
            streakColor = redColor
        elseif LocalPlayer():GetNWInt("killStreak") >= 7 then
            streakColor = rainbowColor
        end
        rainbowColor = HSVToColor((CurTime() * rainbowSpeed) % 360, 1, 1)

        --Displays information about the player you killed, as well as the Accolades you achived.
        draw.SimpleText(LocalPlayer():GetNWInt("killStreak") .. " Kills", "StreakText", 300, 25, streakColor, TEXT_ALIGN_CENTER)
        draw.SimpleText(killedPlayer:GetName(), "PlayerNotiName", 300, 100, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        if CLIENT and GetConVar("tm_enableaccolades"):GetInt() == 1 then
            --Please ignore the code below, pretend it does not exist.
            draw.SimpleText(seperator .. headshot .. headshotIndent .. headshotScore .. headshotSeperator .. onstreak .. onstreakIndent .. onstreakScore .. onstreakSeperator .. revenge .. revengeIndent .. revengeScore .. revengeSeperator .. clutch .. clutchIndent .. clutchScore .. clutchSeperator .. buzzkill .. buzzkillIndent .. buzzkillScore .. buzzkillSeperator .. marksman .. marksmanIndent .. marksmanScore .. marksmanSeperator .. pointblank .. pointblankIndent .. pointblankScore .. pointblankSeperator .. smackdown .. smackdownIndent .. smackdownScore, "StreakText", 300, 150, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    KillIcon = vgui.Create("DImage", KillNotif)
    KillIcon:SetPos(275, 50)
    KillIcon:SetSize(50, 50)
    KillIcon:SetImage("icons/killicon.png")

    KillNotif:Show()
    KillNotif:MakePopup()
    KillNotif:SetMouseInputEnabled(false)
    KillNotif:SetKeyboardInputEnabled(false)

    surface.PlaySound("hitsound/killsound.wav")

    --Creates a countdown for the kill UI, having it disappear after 3.5 seconds.
    timer.Create("killNotification", 3.5, 1, function()
        KillNotif:SizeTo(0, 200, 1, 0.25, 0.25, function()
            KillNotif:Hide()
        end)
        notiAlreadyActive = false
    end)
end )

--Displays after a player dies to another player
net.Receive("DeathHud", function(len, ply)
    local killedBy = net.ReadEntity()
    local killedWith = net.ReadString()
    local killedFrom = net.ReadFloat()

    if IsValid(KillNotif) then
        KillNotif:Hide()
        notiAlreadyActive = false
    end

    --Creates a cooldown for the death UI, having it disappear after 4 seconds.
    timer.Create("respawnTimeHideHud", 4, 1, function()
        DeathNotif:Hide()
        hook.Remove("PlayerDeathThink", "ShowRespawnTime")
    end)

    --Gets the remaining respawn countdown, and sets it as a variable for later use.
    hook.Add("Think", "ShowRespawnTime", function(ply)
        if timer.Exists("respawnTimeHideHud") then
            respawnTimeLeft = math.Round(timer.TimeLeft("respawnTimeHideHud"), 1)
        end
    end)

    DeathNotif = vgui.Create("DFrame")
    DeathNotif:SetSize(800, 300)
    DeathNotif:SetX(ScrW() / 2 - 400)
    if CLIENT and GetConVar("tm_deathuianchor"):GetInt() == 0 then
        DeathNotif:SetY(ScrH() - 350)
    else
        DeathNotif:SetY(125)
    end
    DeathNotif:SetTitle("")
    DeathNotif:SetDraggable(false)
    DeathNotif:ShowCloseButton(false)

    DeathNotif.Paint = function()
        if killedBy == nil or killedWith == nil or !killedBy:IsPlayer() then
            --This appears if the player died via a suicide.
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 100))
            draw.SimpleText("You commited suicide!", "Trebuchet18", 200, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        else
            --This appears if the player died to another player
            if killedBy:GetNWBool("lastShotHead") == true then
                draw.SimpleText(killedFrom .. "m" .. " HS", "WepNameKill", 410, 130, Color(255, 0, 0), TEXT_ALIGN_LEFT)
            else
                draw.SimpleText(killedFrom .. "m", "WepNameKill", 410, 130, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end

            --Information about the cause of your death, hopefully it wasn't too embarrising.
            draw.RoundedBox(5, 0, 0, DeathNotif:GetWide(), DeathNotif:GetTall(), Color(80, 80, 80, 0))
            draw.SimpleText("Killed by", "Trebuchet18", 400, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 95.5, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 120, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText("|", "PlayerDeathName", 400, 145, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.SimpleText(killedBy:GetName(), "PlayerDeathName", 390, 97.5, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.SimpleText(killedWith, "PlayerDeathName", 410, 97.5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            if killedBy:Health() <= 0 then
                draw.SimpleText("DEAD", "WepNameKill", 390, 130, Color(255, 0, 0), TEXT_ALIGN_RIGHT)
            else
                draw.SimpleText(killedBy:Health() .. "HP", "WepNameKill", 390, 130, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            end
            draw.SimpleText("YOU " .. LocalPlayer():GetNWInt(killedBy:SteamID() .. "youKilled"), "WepNameKill", 390, 155, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.SimpleText(killedBy:GetNWInt(LocalPlayer():SteamID() .. "youKilled") .. " FOE", "WepNameKill", 410, 155, Color(255, 255, 255), TEXT_ALIGN_LEFT)

            draw.SimpleText("Respawning in     ", "WepNameKill", 390, 195, Color(255, 255, 255), TEXT_ALIGN_CENTER)
            if respawnTimeLeft ~= nil or respawnTimeLeft > 5 or respawnTimeLeft < 0 then
                draw.SimpleText(respawnTimeLeft .. "s", "WepNameKill", 465, 195, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            end
            draw.SimpleText("Press [F1 - F4] to open the menu", "WepNameKill", 400, 220, Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end
    end

    KilledByCallingCard = vgui.Create("DImage", DeathNotif)
    KilledByCallingCard:SetPos(280, 20)
    KilledByCallingCard:SetSize(240, 80)
    KilledByCallingCard:SetImage(killedBy:GetNWString("chosenPlayercard"))

    killedByPlayerProfilePicture = vgui.Create("AvatarImage", DeathNotif)
    killedByPlayerProfilePicture:SetPos(285 + LocalPlayer():GetNWInt("cardPictureOffset"), 25)
    killedByPlayerProfilePicture:SetSize(70, 70)
    killedByPlayerProfilePicture:SetPlayer(killedBy, 184)
    killedByPlayerProfilePicture.Paint = function()
        killedByPlayerProfilePicture:SetPos(285 + LocalPlayer():GetNWInt("cardPictureOffset"), 25)
    end

    DeathNotif:Show()
    DeathNotif:MakePopup()
    DeathNotif:SetMouseInputEnabled(false)
    DeathNotif:SetKeyboardInputEnabled(false)
end )