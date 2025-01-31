local white = Color(255, 255, 255, 255)
local gray = Color(50, 50, 50, 185)
local lightGray = Color(40, 40, 40, 200)
local solidGreen = Color(0, 255, 0, 255)
local solidRed = Color(255, 0, 0, 255)
local transparent = Color(0, 0, 0, 0)

local gradientL = Material("overlay/gradient_c.png")
local gradientR = Material("overlay/gradient_c2.png")

local gradLColor
local gradRColor
if math.random(0, 1) == 0 then
    gradLColor = Color(100, 0, 255, 6)
    gradRColor = Color(100, 255, 255, 12)
else
    gradLColor = Color(100, 255, 255, 6)
    gradRColor = Color(100, 0, 255, 12)
end

local MainMenu

net.Receive("OpenMainMenu", function(len, ply)
    local LocalPly = LocalPlayer()
    local respawnTimeLeft = net.ReadFloat()
    if respawnTimeLeft != 0 then timer.Create("respawnTimeLeft", respawnTimeLeft, 1, function()
    end) end

    hook.Add("Think", "RenderBehindPauseMenu", function()
        if !IsValid(MainMenu) then return end
        if !gui.IsGameUIVisible() then MainMenu:Show() else MainMenu:Hide() end
    end)

    DeleteHUDHook()

    local dof
    local mapID
    local mapName

    local canPrestige
    if LocalPly:GetNWInt("playerLevel") != 60 then canPrestige = false else canPrestige = true end
    if scrW < 1024 and scrH < 768 then belowMinimumRes = true else belowMinimumRes = false end
    if GetConVar("tm_menudof"):GetInt() == 1 then dof = true end

    local hintList = hintArray
    table.Shuffle(hintList)
    local hintText = table.concat(hintList, " / ")

    local function TriggerSound(type)
        if GetConVar("tm_menusounds"):GetInt() == 0 then return end
        if type == "click" then surface.PlaySound("tmui/click" .. math.random(1, 3) .. ".wav") end
        if type == "forward" then surface.PlaySound("tmui/clickforward.wav") end
        if type == "back" then surface.PlaySound("tmui/clickback.wav") end
    end

    if !IsValid(MainMenu) then
        MainMenu = vgui.Create("DFrame")
        MainMenu:SetSize(scrW, scrH)
        MainMenu:Center()
        MainMenu:SetTitle("")
        MainMenu:SetDraggable(false)
        MainMenu:ShowCloseButton(false)
        MainMenu:SetDeleteOnClose(false)
        MainMenu:MakePopup()

        for m, t in pairs(mapArray) do
            if game.GetMap() == t[1] then
                mapID = t[1]
                mapName = t[2]
            end
        end

        MainMenu.Paint = function()
            if dof == true then DrawBokehDOF(4, 1, 0) end
            surface.SetDrawColor(35, 35, 35, 165)
            surface.DrawRect(0, 0, MainMenu:GetWide(), MainMenu:GetTall())

            surface.SetMaterial(gradientL)
            surface.SetDrawColor(gradLColor)
            surface.DrawTexturedRect(0, 0, scrW, scrH)

            surface.SetMaterial(gradientR)
            surface.SetDrawColor(gradRColor)
            surface.DrawTexturedRect(0, 0, scrW, scrH)
        end

        gui.EnableScreenClicker(true)

        local MainPanel = MainMenu:Add("MainPanel")
            local pushSpawnItems = 100
            local pushExitItems = -100
            local spawnTextAnim = 0
            local hintTextAnim = 0

            MainPanel.Paint = function()
                draw.SimpleText(LocalPly:GetNWInt("playerLevel"), "AmmoCountSmall", 440, -5, white, TEXT_ALIGN_LEFT)

                if LocalPly:GetNWInt("playerPrestige") != 0 and LocalPly:GetNWInt("playerLevel") != 60 then
                    draw.SimpleText("Prestige " .. LocalPly:GetNWInt("playerPrestige"), "StreakText", 660, 37.5, white, TEXT_ALIGN_RIGHT)
                elseif LocalPly:GetNWInt("playerPrestige") != 0 and LocalPly:GetNWInt("playerLevel") == 60 then
                    draw.SimpleText("Prestige " .. LocalPly:GetNWInt("playerPrestige"), "StreakText", 535, 37.5, white, TEXT_ALIGN_LEFT)
                end

                if LocalPly:GetNWInt("playerLevel") != 60 then
                    draw.SimpleText(math.Round(LocalPly:GetNWInt("playerXP"), 0) .. " / " .. math.Round(LocalPly:GetNWInt("playerXPToNextLevel"), 0) .. "XP", "StreakText", 660, 57.5, white, TEXT_ALIGN_RIGHT)
                    draw.SimpleText(LocalPly:GetNWInt("playerLevel") + 1, "StreakText", 665, 72.5, white, TEXT_ALIGN_LEFT)

                    surface.SetDrawColor(30, 30, 30, 125)
                    surface.DrawRect(440, 80, 220, 10)

                    surface.SetDrawColor(200, 200, 0, 130)
                    surface.DrawRect(440, 80, (LocalPly:GetNWInt("playerXP") / LocalPly:GetNWInt("playerXPToNextLevel")) * 220, 10)
                else
                    draw.SimpleText("+ " .. math.Round(LocalPly:GetNWInt("playerXP"), 0) .. "XP", "StreakText", 535, 55, white, TEXT_ALIGN_LEFT)
                end

                if mapID == nil then draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i" .. " / " .. activeGamemode .. ", " .. game.GetMap()), "StreakText", 5 + spawnTextAnim, scrH / 2 - 60 - pushSpawnItems, white, TEXT_ALIGN_LEFT) else draw.SimpleText(string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i" .. " / " .. activeGamemode .. ", " .. mapName), "StreakText", 10 + spawnTextAnim, scrH / 2 - 60 - pushSpawnItems, white, TEXT_ALIGN_LEFT) end

                hintTextAnim = math.Clamp(hintTextAnim + 50 * RealFrameTime(), 0, 10000)
                surface.SetDrawColor(30, 30, 30, 125)
                surface.DrawRect(0, scrH - 24, scrW, 24)
                draw.SimpleText(hintText, "StreakText", 5 - hintTextAnim, scrH - 13, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            if canPrestige == true then
                local PrestigeButton = vgui.Create("DButton", MainPanel)
                PrestigeButton:SetPos(437.5, 67.5)
                PrestigeButton:SetText("")
                PrestigeButton:SetSize(180, 30)
                local textAnim = 0
                local prestigeConfirm = 0
                PrestigeButton.Paint = function()
                    if PrestigeButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                    end

                    if prestigeConfirm == 0 then
                        draw.DrawText("PRESTIGE TO P" .. LocalPly:GetNWInt("playerPrestige") + 1, "StreakText", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "StreakText", 5 + textAnim, 5, solidRed, TEXT_ALIGN_LEFT)
                    end
                end
                PrestigeButton.DoClick = function()
                    if (prestigeConfirm == 0) then
                        TriggerSound("click")
                        prestigeConfirm = 1
                    else
                        surface.PlaySound("tmui/prestige.wav")
                        LocalPly:ConCommand("tm_prestige")
                        PrestigeButton:Hide()
                    end

                    timer.Simple(3, function() prestigeConfirm = 0 end)
                end
            end

            plyCallingCard = vgui.Create("DImage", MainPanel)
            plyCallingCard:SetPos(190, 10)
            plyCallingCard:SetSize(240, 80)
            plyCallingCard:SetImage(LocalPly:GetNWString("chosenPlayercard"), "cards/color/black.png")

            playerProfilePicture = vgui.Create("AvatarImage", MainPanel)
            playerProfilePicture:SetPos(195, 15)
            playerProfilePicture:SetSize(70, 70)
            playerProfilePicture:SetPlayer(LocalPly, 184)

            local SelectedBoard
            local SelectedBoardName
            local LeaderboardButton = vgui.Create("DImageButton", MainPanel)
            LeaderboardButton:SetPos(10, 10)
            LeaderboardButton:SetImage("icons/leaderboardicon.png")
            LeaderboardButton:SetSize(80, 80)
            LeaderboardButton:SetTooltip("Leaderboards")
            LeaderboardButton.DoClick = function()
                TriggerSound("click")
                MainPanel:Hide()

                if !IsValid(LeaderboardPanel) then
                    local LeaderboardPanel = MainMenu:Add("LeaderboardPanel")
                    local LeaderboardSlideoutPanel = MainMenu:Add("LeaderboardSlideoutPanel")

                    local LeaderboardQuickjumpHolder = vgui.Create("DPanel", LeaderboardSlideoutPanel)
                    LeaderboardQuickjumpHolder:Dock(TOP)
                    LeaderboardQuickjumpHolder:SetSize(0, scrH)

                    LeaderboardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local LeaderboardScroller = vgui.Create("DScrollPanel", LeaderboardPanel)
                    LeaderboardScroller:Dock(FILL)

                    local sbar = LeaderboardScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local LeaderboardTextHolder = vgui.Create("DPanel", LeaderboardPanel)
                    LeaderboardTextHolder:Dock(TOP)
                    LeaderboardTextHolder:SetSize(0, 210)

                    LeaderboardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("LEADERBOARDS", "AmmoCountSmall", 20, 20, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Entries update on match start/player disconnect | Only top 50 are shown", "StreakText", 25, 100, white, TEXT_ALIGN_LEFT)

                        if SelectedBoardName != nil then draw.SimpleText(SelectedBoardName, "OptionsHeader", 85, 156, white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER) end
                        draw.SimpleText("#", "StreakText", 20, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Name", "StreakText", 85, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Stat", "StreakText", 710, 185, white, TEXT_ALIGN_RIGHT)
                    end

                    local LeaderboardPickerButton
                    local firstSelection = true
                    function LeaderboardSelected(text, data)
                        if SelectedBoardName == text then return end
                        if !firstSelection then
                            LeaderboardPickerButton:Hide()
                            timer.Create("SendBoardDataRequestCooldown", 3, 1, function() if !LocalPly:Alive() then LeaderboardPickerButton:Show() end end)
                        end
                        TriggerSound("click")
                        net.Start("GrabLeaderboardData")
                        net.WriteString(data)
                        net.WriteBool(true)
                        net.SendToServer()
                        SelectedBoardName = text
                    end

                    LeaderboardPickerButton = vgui.Create("DImageButton", LeaderboardTextHolder)
                    LeaderboardPickerButton:SetPos(25, 140)
                    LeaderboardPickerButton:SetSize(32, 32)
                    LeaderboardPickerButton:SetTooltip("Switch shown Leaderboard")
                    LeaderboardPickerButton:SetImage("icons/changeicon.png")
                    LeaderboardPickerButton.DoClick = function()
                        TriggerSound("click")
                        local BoardSelection = DermaMenu()
                        local statistics = BoardSelection:AddSubMenu("Statistics")
                        statistics:AddOption("Score", function() LeaderboardSelected("Score", "playerScore") end)
                        statistics:AddOption("Kills", function() LeaderboardSelected("Kills", "playerKills") end)
                        statistics:AddOption("Deaths", function() LeaderboardSelected("Deaths", "playerDeaths") end)
                        -- statistics:AddOption("K/D Ratio", function() LeaderboardSelected("K/D Ratio", "kd") end)
                        statistics:AddOption("Matches Played", function() LeaderboardSelected("Matches Played", "matchesPlayed") end)
                        statistics:AddOption("Matches Won", function() LeaderboardSelected("Matches Won", "matchesWon") end)
                        -- statistics:AddOption("W/L Ratio", function() LeaderboardSelected("W/L Ratio", "wl") end)
                        statistics:AddOption("Highest Killstreak", function() LeaderboardSelected("Highest Killstreak", "highestKillStreak") end)
                        statistics:AddOption("Highest Kill Game", function() LeaderboardSelected("Highest Kill Game", "highestKillGame") end)
                        statistics:AddOption("Farthest Kill", function() LeaderboardSelected("Farthest Kill", "farthestKill") end)

                        local accolades = BoardSelection:AddSubMenu("Accolades")
                        accolades:AddOption("Headshot Kills", function() LeaderboardSelected("Headshot Kills", "playerAccoladeHeadshot") end)
                        accolades:AddOption("Melee Kills", function() LeaderboardSelected("Melee Kills", "playerAccoladeSmackdown") end)
                        accolades:AddOption("Longshot Kills", function() LeaderboardSelected("Longshot Kills", "playerAccoladeLongshot") end)
                        accolades:AddOption("Point Blank Kills", function() LeaderboardSelected("Point Blank Kills", "playerAccoladePointblank") end)
                        accolades:AddOption("Clutches", function() LeaderboardSelected("Clutches", "playerAccoladeClutch") end)
                        accolades:AddOption("Kill Streaks Started", function() LeaderboardSelected("Kill Streaks Started", "playerAccoladeOnStreak") end)
                        accolades:AddOption("Kill Streaks Ended", function() LeaderboardSelected("Kill Streaks Ended", "playerAccoladeBuzzkill") end)

                        local weaponstatistics = BoardSelection:AddSubMenu("Weapons")
                        weaponstatistics:SetMaxHeight(scrH / 2)
                        for p, t in pairs(weaponArray) do
                            weaponstatistics:AddOption("Kills w/ " .. t[2], function() LeaderboardSelected("Kills w/ " .. t[2], "killsWith_" .. t[1]) end)
                        end

                        BoardSelection:Open()
                    end

                    local StatsIcon = vgui.Create("DImage", LeaderboardQuickjumpHolder)
                    StatsIcon:SetPos(12, 12)
                    StatsIcon:SetSize(32, 32)
                    StatsIcon:SetImage("icons/leaderboardslideouticon.png")

                    local BackButtonSlideout = vgui.Create("DImageButton", LeaderboardQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, scrH - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        MainPanel:Show()
                        LeaderboardPanel:Hide()
                        LeaderboardSlideoutPanel:Hide()
                    end

                    local LeaderboardContents = vgui.Create("DPanel", LeaderboardScroller)
                    LeaderboardContents:Dock(TOP)
                    LeaderboardContents:SetSize(0, 2082.5)

                    LeaderboardContents.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)

                        if SelectedBoard == nil then return end
                        for p, t in pairs(SelectedBoard) do
                            if t.Value == "NULL" then return end
                            if t.SteamName != LocalPly:GetName() then
                                draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT)
                                if t.SteamName != "NULL" then draw.SimpleText(string.sub(t.SteamName, 1, 21), "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) else draw.SimpleText(t.SteamID, "SettingsLabel", 85, (p - 1) * 41.25, white, TEXT_ALIGN_LEFT) end
                            else
                                draw.SimpleText(p, "SettingsLabel", 20, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                                draw.SimpleText(string.sub(t.SteamName, 1, 21), "SettingsLabel", 85, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_LEFT)
                            end

                            if SelectedBoardName == "W/L Ratio" then
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(math.Round(t.Value) .. "%", "SettingsLabel", 710, (p - 1) * 41.25, white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(math.Round(t.Value) .. "%", "SettingsLabel", 710, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            elseif SelectedBoardName == "Farthest Kill" then
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(math.Round(t.Value, 2) .. "m", "SettingsLabel", 710, (p - 1) * 41.25, white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(math.Round(t.Value, 2) .. "m", "SettingsLabel", 710, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            else
                                if t.SteamName != LocalPly:GetName() then
                                    draw.SimpleText(math.Round(t.Value, 2), "SettingsLabel", 710, (p - 1) * 41.25, white, TEXT_ALIGN_RIGHT)
                                else
                                    draw.SimpleText(math.Round(t.Value, 2), "SettingsLabel", 710, (p - 1) * 41.25, Color(255, 255, 0), TEXT_ALIGN_RIGHT)
                                end
                            end
                        end
                    end

                    net.Start("GrabLeaderboardData")
                    net.WriteString("playerKills")
                    net.WriteBool(false)
                    net.SendToServer()
                    SelectedBoardName = "Kills"
                    firstSelection = false
                end
            end

            net.Receive("SendLeaderboardData", function(len, ply)
                SelectedBoard = net.ReadTable()
            end )

            local SpectatePanel = vgui.Create("DPanel", MainPanel)
            SpectatePanel:SetSize(170, 0)
            SpectatePanel:SetPos(10, 100)
            SpectatePanel.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, gray)
            end

            local SpectateTextHeader = vgui.Create("DPanel", SpectatePanel)
            SpectateTextHeader:Dock(TOP)
            SpectateTextHeader:SetSize(0, 70)
            SpectateTextHeader.Paint = function(self, w, h)
                draw.SimpleText("SPECTATE", "MainMenuDescription", w / 2, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            local SpectatePicker = SpectateTextHeader:Add("DComboBox")
            SpectatePicker:SetPos(0, 40)
            SpectatePicker:SetSize(170, 30)
            SpectatePicker:SetValue("Spectate...")
            SpectatePicker:AddChoice("Freecam")
            SpectatePicker.OnSelect = function(_, _, value, id)
                net.Start("BeginSpectate")
                net.SendToServer()
                MainMenu:Remove(false)
                gui.EnableScreenClicker(false)
            end

            local SpectateButton = vgui.Create("DImageButton", MainPanel)
            SpectateButton:SetPos(100, 10)
            SpectateButton:SetImage("icons/spectateicon.png")
            SpectateButton:SetSize(80, 80)
            SpectateButton:SetTooltip("Spectate")
            local spectatePanelOpen = 0
            SpectateButton.DoClick = function()
                TriggerSound("click")
                if (spectatePanelOpen == 0) then
                    spectatePanelOpen = 1
                    SpectatePanel:SizeTo(-1, 70, 1, 0, 0.1)
                else
                    spectatePanelOpen = 0
                    SpectatePanel:SizeTo(-1, 0, 1, 0, 0.1)
                end
            end

            local function ShowTutorial()
                local ContextBind = "Context Menu Bind"
                if input.LookupBinding("+menu_context") != nil then ContextBind = input.LookupBinding("+menu_context") end

                local TutorialPanel = vgui.Create("DFrame", MainMenu)
                TutorialPanel:SetSize(864, 768)
                TutorialPanel:MakePopup()
                TutorialPanel:SetTitle("Titanmod Tutorial")
                TutorialPanel:Center()
                TutorialPanel:SetScreenLock(true)
                TutorialPanel:GetBackgroundBlur(false)
                TutorialPanel:SetDraggable(false)
                TutorialPanel:SetDeleteOnClose(true)
                MainMenu:SetMouseInputEnabled(false)
                TutorialPanel.Paint = function(self, w, h)
                    DrawBokehDOF(4, 1, 0)
                    draw.RoundedBox(0, 0, 0, w, h, Color(30, 30, 30, 100))
                end
                TutorialPanel.OnClose = function()
                    TriggerSound("click")
                    MainMenu:SetMouseInputEnabled(true)
                end

                local TutorialScroller = vgui.Create("DScrollPanel", TutorialPanel)
                TutorialScroller:Dock(FILL)

                local sbar = TutorialScroller:GetVBar()
                function sbar:Paint(w, h)
                    draw.RoundedBox(5, 0, 0, w, h, gray)
                end
                function sbar.btnUp:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                end
                function sbar.btnDown:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, gray)
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                end

                local TitleText = vgui.Create("DPanel", TutorialScroller)
                TitleText:Dock(TOP)
                TitleText:SetSize(0, 175)
                TitleText.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("Welcome to", "SettingsLabel", w / 2, 10, white, TEXT_ALIGN_CENTER)
                    draw.SimpleText("Titanmod", "OptionsHeader", w / 2, 40, Color(165, 55, 155), TEXT_ALIGN_CENTER)
                    draw.SimpleText("Here are some things you should know before jumping in:", "SettingsLabel", w / 2, 110, white, TEXT_ALIGN_CENTER)
                end

                local WeaponrySection = vgui.Create("DPanel", TutorialScroller)
                WeaponrySection:Dock(TOP)
                WeaponrySection:SetSize(0, 280)
                WeaponrySection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("WEAPONS", "OptionsHeader", 280, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local WeaponryLabel = vgui.Create("DLabel", WeaponrySection)
                WeaponryLabel:SetPos(280, 30)
                WeaponryLabel:SetSize(554, 230)
                WeaponryLabel:SetFont("GModNotify")
                WeaponryLabel:SetText([[There are 130+ unique weapons to master in Titanmod!
You can use your Context Menu key []] .. ContextBind .. [[] to adjust attachments on your weapons, and to view weapon statistics. Attachments that you select are saved throughout play sessions, so you only have to customize a gun to your liking once.
Each weapon has its own unique recoil pattern to learn.
Bullets are hitscan and can penetrate through surfaces.
]])
                WeaponryLabel:SetWrap(true)

                local WeaponryImage = vgui.Create("DImage", WeaponrySection)
                WeaponryImage:SetPos(10, 10)
                WeaponryImage:SetSize(260, 260)
                WeaponryImage:SetImage("images/attach.png")

                local MovementSection = vgui.Create("DPanel", TutorialScroller)
                MovementSection:Dock(TOP)
                MovementSection:SetSize(0, 280)
                MovementSection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("MOVEMENT", "OptionsHeader", 280, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local MovementLabel = vgui.Create("DLabel", MovementSection)
                MovementLabel:SetPos(280, 35)
                MovementLabel:SetSize(554, 230)
                MovementLabel:SetFont("GModNotify")
                MovementLabel:SetText([[Titanmod has an assortment of movement mechanics to learn and use on your opponents!
Here are a few things to look out for:
Sliding                     Air Strafing
Wall Running          Wall Jumping
Rocket Jumping      Grappling
+ More to discover on your own
]])
                MovementLabel:SetWrap(true)

                local MovementImage = vgui.Create("DImage", MovementSection)
                MovementImage:SetPos(10, 10)
                MovementImage:SetSize(260, 260)
                MovementImage:SetImage("images/movement.png")

                local PersonalizeSection = vgui.Create("DPanel", TutorialScroller)
                PersonalizeSection:Dock(TOP)
                PersonalizeSection:SetSize(0, 280)
                PersonalizeSection.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("CUSTOMIZATION", "OptionsHeader", 280, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                end

                local PersonalizeLabel = vgui.Create("DLabel", PersonalizeSection)
                PersonalizeLabel:SetPos(280, 45)
                PersonalizeLabel:SetSize(554, 230)
                PersonalizeLabel:SetFont("GModNotify")
                PersonalizeLabel:SetText([[There are over 250+ items to unlock in Titanmod!
There are an assortment of player models and calling cards to express yourself with. Some are unlocked for you already, while some require you to complete specific challenges.
Check out the CUSTOMIZE page to see what is on offer.
Head to the OPTIONS page to tailor the experience to your needs. There is an extensive list of settings to change, and well as a robust HUD editor.
]])
                PersonalizeLabel:SetWrap(true)

                local PersonalizeImage = vgui.Create("DImage", PersonalizeSection)
                PersonalizeImage:SetPos(10, 10)
                PersonalizeImage:SetSize(260, 260)
                PersonalizeImage:SetImage("images/personalize.png")

                local EndingLabel = vgui.Create("DPanel", TutorialScroller)
                EndingLabel:Dock(TOP)
                EndingLabel:SetSize(0, 115)
                EndingLabel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 50))
                    draw.SimpleText("Join our Discord server!", "SettingsLabel", 90, 8, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Find people to play with or keep up wtih new updates and leaks", "GModNotify", 90, 48, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("^   click me please :)", "GModNotify", 44, 80, white, TEXT_ALIGN_LEFT)
                end

                local DiscordButton = vgui.Create("DImageButton", EndingLabel)
                DiscordButton:SetPos(15, 8)
                DiscordButton:SetImage("icons/discordicon.png")
                DiscordButton:SetSize(64, 64)
                DiscordButton:SetTooltip("Discord")
                DiscordButton.DoClick = function()
                    TriggerSound("click")
                    gui.OpenURL("https://discord.gg/GRfvt27uGF")
                end
            end

            if LocalPly:GetNWInt("playerDeaths") == 0 then ShowTutorial() end -- Force shows the Tutorial is a player joins for the first time

            local TutorialButton = vgui.Create("DImageButton", MainPanel)
            TutorialButton:SetPos(8, scrH - 96)
            TutorialButton:SetImage("icons/tutorialicon.png")
            TutorialButton:SetSize(64, 64)
            TutorialButton:SetTooltip("Tutorial")
            TutorialButton.DoClick = function()
                TriggerSound("click")
                ShowTutorial()
            end

            local DiscordButton = vgui.Create("DImageButton", MainPanel)
            DiscordButton:SetPos(108, scrH - 96)
            DiscordButton:SetImage("icons/discordicon.png")
            DiscordButton:SetSize(64, 64)
            DiscordButton:SetTooltip("Discord")
            DiscordButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://discord.gg/GRfvt27uGF")
            end

            local WorkshopButton = vgui.Create("DImageButton", MainPanel)
            WorkshopButton:SetPos(180, scrH - 96)
            WorkshopButton:SetImage("icons/workshopicon.png")
            WorkshopButton:SetSize(64, 64)
            WorkshopButton:SetTooltip("Steam Workshop")
            WorkshopButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3002938569")
            end

            local YouTubeButton = vgui.Create("DImageButton", MainPanel)
            YouTubeButton:SetPos(252, scrH - 96)
            YouTubeButton:SetImage("icons/youtubeicon.png")
            YouTubeButton:SetSize(64, 64)
            YouTubeButton:SetTooltip("YouTube")
            YouTubeButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://youtu.be/OPH7Tm9ngRI?si=9X9bO9IGbuiEZaz8")
            end

            local GithubButton = vgui.Create("DImageButton", MainPanel)
            GithubButton:SetPos(324, scrH - 96)
            GithubButton:SetImage("icons/githubicon.png")
            GithubButton:SetSize(64, 64)
            GithubButton:SetTooltip("GitHub")
            GithubButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod")
            end

            local SpawnButton = vgui.Create("DButton", MainPanel)
            SpawnButton:SetPos(0, scrH / 2 - 50 - pushSpawnItems)
            SpawnButton:SetText("")
            SpawnButton:SetSize(535, 100)
            SpawnButton.Paint = function()
                SpawnButton:SetPos(0, scrH / 2 - 50 - pushSpawnItems)
                if not timer.Exists("respawnTimeLeft") then
                    if SpawnButton:IsHovered() then
                        spawnTextAnim = math.Clamp(spawnTextAnim + 200 * RealFrameTime(), 0, 20)
                    else
                        spawnTextAnim = math.Clamp(spawnTextAnim - 200 * RealFrameTime(), 0, 20)
                    end

                    draw.DrawText("SPAWN", "AmmoCountSmall", 5 + spawnTextAnim, 5, white, TEXT_ALIGN_LEFT)
                    for k, v in pairs(weaponArray) do
                        if activeGamemode == "Gun Game" then
                            draw.SimpleText(LocalPly:GetNWInt("ladderPosition") .. " / " .. ggLadderSize .. " kills", "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 15, white, TEXT_ALIGN_LEFT)
                        else
                            if v[1] == LocalPly:GetNWString("loadoutPrimary") and usePrimary then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 15, white, TEXT_ALIGN_LEFT) end
                            if v[1] == LocalPly:GetNWString("loadoutSecondary") and useSecondary then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 40 , white, TEXT_ALIGN_LEFT) end
                            if v[1] == LocalPly:GetNWString("loadoutMelee") and useMelee then draw.SimpleText(v[2], "MainMenuLoadoutWeapons", 325 + spawnTextAnim, 65, white, TEXT_ALIGN_LEFT) end
                        end
                    end
                else
                    draw.DrawText("SPAWN", "AmmoCountSmall", 5 + spawnTextAnim, 5, Color(250, 100, 100, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("" .. math.Round(timer.TimeLeft("respawnTimeLeft"), 2), "AmmoCountSmall", 350 + spawnTextAnim, 5, white, TEXT_ALIGN_LEFT)
                end
            end
            SpawnButton.DoClick = function()
                if timer.Exists("respawnTimeLeft") then return end
                TriggerSound("click")
                CreateHUDHook()
                MainMenu:Remove()
                gui.EnableScreenClicker(false)
                hook.Remove("Think", "RenderBehindPauseMenu")
                net.Start("CloseMainMenu")
                net.SendToServer()
            end

            local CustomizeButton = vgui.Create("DButton", MainPanel)
            local CustomizeModelButton = vgui.Create("DButton", CustomizeButton)
            local CustomizeCardButton = vgui.Create("DButton", CustomizeButton)
            CustomizeButton:SetPos(0, scrH / 2 + 50)
            CustomizeButton:SetText("")
            CustomizeButton:SetSize(530, 100)
            local textAnim = 0
            CustomizeButton.Paint = function()
                if CustomizeButton:IsHovered() or CustomizeModelButton:IsHovered() or CustomizeCardButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                    pushSpawnItems = math.Clamp(pushSpawnItems + 600 * RealFrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, scrH / 2 + 50 - pushSpawnItems)
                    CustomizeButton:SizeTo(-1, 200, 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                    pushSpawnItems = math.Clamp(pushSpawnItems - 600 * RealFrameTime(), 100, 150)
                    CustomizeButton:SetPos(0, scrH / 2 + 50 - pushSpawnItems)
                    CustomizeButton:SizeTo(-1, 100, 0, 0, 1)
                end
                draw.DrawText("CUSTOMIZE", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            CustomizeModelButton:SetPos(0, 100)
            CustomizeModelButton:SetText("")
            CustomizeModelButton:SetSize(180, 100)
            CustomizeModelButton.Paint = function()
                draw.DrawText("MODEL", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton:SetPos(180, 100)
            CustomizeCardButton:SetText("")
            CustomizeCardButton:SetSize(160, 100)
            CustomizeCardButton.Paint = function()
                draw.DrawText("CARD", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            CustomizeCardButton.DoClick = function()
                TriggerSound("click")
                MainPanel:Hide()
                local currentCard = LocalPly:GetNWString("chosenPlayercard")

                if not IsValid(CardPanel) then
                    local CardPanel = vgui.Create("DPanel", MainMenu)
                    CardPanel:SetSize(745, scrH)
                    CardPanel:SetPos(56, 0)
                    CardPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local CardSlideoutPanel = vgui.Create("DPanel", MainMenu)
                    CardSlideoutPanel:SetSize(56, scrH)
                    CardSlideoutPanel:SetPos(0, 0)
                    CardSlideoutPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local CardQuickjumpHolder = vgui.Create("DPanel", CardSlideoutPanel)
                    CardQuickjumpHolder:Dock(TOP)
                    CardQuickjumpHolder:SetSize(0, scrH)
                    CardQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local newCard
                    local newCardName
                    local newCardDesc
                    local newCardUnlockType
                    local newCardUnlockValue

                    local totalCards = table.Count(cardArray)
                    local cardsUnlocked = 0

                    local defaultCardsTotal = 0
                    local defaultCardsUnlocked = 0

                    local statCardsTotal = 0
                    local statCardsUnlocked = 0

                    local accoladeCardsTotal = 0
                    local accoladeCardsUnlocked = 0

                    local levelCardsTotal = 0
                    local levelCardsUnlocked = 0

                    local masteryCardsTotal = 0
                    local masteryCardsUnlocked = 0

                    local colorCardsTotal = 0
                    local colorCardsUnlocked = 0

                    local prideCardsTotal = 0
                    local prideCardsUnlocked = 0

                    local playerTotalLevel = (LocalPly:GetNWInt("playerPrestige") * 60) + LocalPly:GetNWInt("playerLevel")

                    -- Checking for the players currently equipped card
                    for k, v in pairs(cardArray) do
                        if v[1] == currentCard then
                            newCard = v[1]
                            newCardName = v[2]
                            newCardDesc = v[3]
                            newCardUnlockType = v[4]
                            newCardUnlockValue = v[5]
                        end
                    end

                    local CardScroller = vgui.Create("DScrollPanel", CardPanel)
                    CardScroller:Dock(FILL)

                    local sbar = CardScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local CardTextHolder = vgui.Create("DPanel", CardPanel)
                    CardTextHolder:Dock(TOP)
                    CardTextHolder:SetSize(0, 160)

                    CardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CARDS", "AmmoCountSmall", w / 2, 5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(cardsUnlocked .. " / " .. totalCards .. " unlocked", "MainMenuDescription", w / 2, 85, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Hide locked playercards", "StreakText", w / 2 + 20, 120, white, TEXT_ALIGN_CENTER)
                    end

                    local CardPreviewPanel = vgui.Create("DPanel", CardPanel)
                    CardPreviewPanel:Dock(TOP)
                    CardPreviewPanel:SetSize(0, 100)
                    CardPreviewPanel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local HideLockedCards = CardTextHolder:Add("DCheckBox")
                    HideLockedCards:SetPos(268, 122.5)
                    HideLockedCards:SetSize(20, 20)
                    function HideLockedCards:OnChange() TriggerSound("click") end

                    -- Default Playercards
                    local TextDefault = vgui.Create("DPanel", CardScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, 85)

                    local DockDefaultCards = vgui.Create("DPanel", CardScroller)
                    DockDefaultCards:Dock(TOP)
                    DockDefaultCards:SetSize(0, 340)

                    -- Leveling related Playercards
                    local TextLevel = vgui.Create("DPanel", CardScroller)
                    TextLevel:Dock(TOP)
                    TextLevel:SetSize(0, 85)

                    local DockLevelCards = vgui.Create("DPanel", CardScroller)
                    DockLevelCards:Dock(TOP)
                    DockLevelCards:SetSize(0, 1360)

                    -- Kill related Playercards
                    local TextStats = vgui.Create("DPanel", CardScroller)
                    TextStats:Dock(TOP)
                    TextStats:SetSize(0, 85)

                    local DockStatCards = vgui.Create("DPanel", CardScroller)
                    DockStatCards:Dock(TOP)
                    DockStatCards:SetSize(0, 180)

                    -- Accolade related Playercards
                    local TextAccolade = vgui.Create("DPanel", CardScroller)
                    TextAccolade:Dock(TOP)
                    TextAccolade:SetSize(0, 85)

                    local DockAccoladeCards = vgui.Create("DPanel", CardScroller)
                    DockAccoladeCards:Dock(TOP)
                    DockAccoladeCards:SetSize(0, 850)

                    -- Mastery related Playercards
                    local TextMastery = vgui.Create("DPanel", CardScroller)
                    TextMastery:Dock(TOP)
                    TextMastery:SetSize(0, 85)

                    local DockMasteryCards = vgui.Create("DPanel", CardScroller)
                    DockMasteryCards:Dock(TOP)
                    DockMasteryCards:SetSize(0, 3570)

                    -- Color related Playercards
                    local TextColor = vgui.Create("DPanel", CardScroller)
                    TextColor:Dock(TOP)
                    TextColor:SetSize(0, 85)

                    local DockColorCards = vgui.Create("DPanel", CardScroller)
                    DockColorCards:Dock(TOP)
                    DockColorCards:SetSize(0, 340)

                    -- Pride related Playercards
                    local TextPride = vgui.Create("DPanel", CardScroller)
                    TextPride:Dock(TOP)
                    TextPride:SetSize(0, 85)

                    local DockPrideCards = vgui.Create("DPanel", CardScroller)
                    DockPrideCards:Dock(TOP)
                    DockPrideCards:SetSize(0, 335)

                    -- Creating playercard lists
                    local DefaultCardList = vgui.Create("DIconLayout", DockDefaultCards)
                    DefaultCardList:Dock(TOP)
                    DefaultCardList:SetSpaceY(5)
                    DefaultCardList:SetSpaceX(5)

                    local StatCardList = vgui.Create("DIconLayout", DockStatCards)
                    StatCardList:Dock(TOP)
                    StatCardList:SetSpaceY(5)
                    StatCardList:SetSpaceX(5)

                    local AccoladeCardList = vgui.Create("DIconLayout", DockAccoladeCards)
                    AccoladeCardList:Dock(TOP)
                    AccoladeCardList:SetSpaceY(5)
                    AccoladeCardList:SetSpaceX(5)

                    local LevelCardList = vgui.Create("DIconLayout", DockLevelCards)
                    LevelCardList:Dock(TOP)
                    LevelCardList:SetSpaceY(5)
                    LevelCardList:SetSpaceX(5)

                    local MasteryCardList = vgui.Create("DIconLayout", DockMasteryCards)
                    MasteryCardList:Dock(TOP)
                    MasteryCardList:SetSpaceY(5)
                    MasteryCardList:SetSpaceX(5)

                    local ColorCardList = vgui.Create("DIconLayout", DockColorCards)
                    ColorCardList:Dock(TOP)
                    ColorCardList:SetSpaceY(5)
                    ColorCardList:SetSpaceX(5)

                    local PrideCardList = vgui.Create("DIconLayout", DockPrideCards)
                    PrideCardList:Dock(TOP)
                    PrideCardList:SetSpaceY(5)
                    PrideCardList:SetSpaceX(5)

                    DefaultCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    StatCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    AccoladeCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    LevelCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    MasteryCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    ColorCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    PrideCardList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local PreviewCardTextHolder = vgui.Create("DPanel", CardPreviewPanel)
                    PreviewCardTextHolder:Dock(FILL)
                    PreviewCardTextHolder:SetSize(0, 100)

                    CallingCard = vgui.Create("DImage", PreviewCardTextHolder)
                    CallingCard:SetPos(245, 10)
                    CallingCard:SetSize(240, 80)
                    CallingCard:SetImage(newCard)

                    ProfilePicture = vgui.Create("AvatarImage", CallingCard)
                    ProfilePicture:SetPos(5, 5)
                    ProfilePicture:SetSize(70, 70)
                    ProfilePicture:SetPlayer(LocalPly, 184)

                    local previewRed = Color(255, 0, 0, 5)
                    local previewGreen = Color(0, 255, 0, 5)
                    local previewColor = previewGreen

                    PreviewCardTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                        draw.RoundedBox(0, 0, 0, w, h, previewColor)

                        if currentCard != nil then
                            draw.SimpleText(newCardName, "PlayerNotiName", 240, 5, white, TEXT_ALIGN_RIGHT)
                            draw.SimpleText(newCardDesc, "MainMenuDescription", 240, 65, white, TEXT_ALIGN_RIGHT)
                        end

                        if newCardUnlockType == "default" or newCardUnlockType == "color" or newCardUnlockType == "pride" then
                            draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                        elseif newCardUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills: " .. LocalPly:GetNWInt("playerKills") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Highest Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Melee Kills: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "level" then
                            if playerTotalLevel < newCardUnlockValue then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Total Levels: " .. playerTotalLevel .. "/" .. newCardUnlockValue, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        elseif newCardUnlockType == "mastery" then
                            if LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) < 50 then
                                draw.SimpleText("Locked", "PlayerNotiName", 490, 5, solidRed, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "MainMenuDescription", 490, 65, solidRed, TEXT_ALIGN_LEFT)
                                previewColor = previewRed
                            else
                                draw.SimpleText("Unlocked", "PlayerNotiName", 490, 5, solidGreen, TEXT_ALIGN_LEFT)
                                draw.SimpleText("Kills w/ gun: " .. LocalPly:GetNWInt("killsWith_" .. newCardUnlockValue) .. "/" .. 50, "MainMenuDescription", 490, 65, solidGreen, TEXT_ALIGN_LEFT)
                                previewColor = previewGreen
                            end
                        end

                        CallingCard:SetImage(newCard)
                    end

                    local function FillCardListsAll()
                        for k, v in pairs(cardArray) do
                            if v[4] == "default" then
                                local card = vgui.Create("DImageButton", DockDefaultCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                DefaultCardList:Add(card)

                                defaultCardsTotal = defaultCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                defaultCardsUnlocked = defaultCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "kills" or v[4] == "streak" then
                                local card = vgui.Create("DImageButton", DockStatCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                StatCardList:Add(card)

                                statCardsTotal = statCardsTotal + 1

                                if v[4] == "kills" and LocalPly:GetNWInt("playerKills") < v[5] or v[4] == "streak" and LocalPly:GetNWInt("highestKillStreak") < v[5] then
                                    card:SetColor(Color(100, 100, 100, 150))
                                    card.Paint = function(self, w, h)
                                        surface.SetDrawColor(35, 35, 35, 255)
                                        surface.DrawRect(0, h - 5, 240, 5)

                                        surface.SetDrawColor(255, 255, 0, 100)
                                        if v[4] == "kills" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerKills") / v[5]) * 240, 5) elseif v[4] == "streak" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("highestKillStreak") / v[5]) * 240, 5) end
                                    end
                                    local lockIndicator = vgui.Create("DImage", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    statCardsUnlocked = statCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" then
                                local card = vgui.Create("DImageButton", DockAccoladeCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                AccoladeCardList:Add(card)

                                accoladeCardsTotal = accoladeCardsTotal + 1

                                if v[4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < v[5] or v[4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < v[5] or v[4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < v[5] or v[4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < v[5] or v[4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < v[5] or v[4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < v[5] or v[4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < v[5] then
                                    card:SetColor(Color(100, 100, 100, 150))
                                    card.Paint = function(self, w, h)
                                        surface.SetDrawColor(35, 35, 35, 255)
                                        surface.DrawRect(0, h - 5, 240, 5)

                                        surface.SetDrawColor(255, 255, 0, 100)
                                        if v[4] == "headshot" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladeHeadshot") / v[5]) * 240, 5) elseif v[4] == "smackdown" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladeSmackdown") / v[5]) * 240, 5) elseif v[4] == "clutch" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladeClutch") / v[5]) * 240, 5) elseif v[4] == "longshot" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladeLongshot") / v[5]) * 240, 5) elseif v[4] == "pointblank" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladePointblank") / v[5]) * 240, 5) elseif v[4] == "killstreaks" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladeOnStreak") / v[5]) * 240, 5) elseif v[4] == "buzzkills" then surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("playerAccoladeBuzzkill") / v[5]) * 240, 5) end
                                    end
                                    local lockIndicator = vgui.Create("DImage", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    accoladeCardsUnlocked = accoladeCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "color" then
                                local card = vgui.Create("DImageButton", DockColorCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                ColorCardList:Add(card)

                                colorCardsTotal = colorCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                colorCardsUnlocked = colorCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "pride" then
                                local card = vgui.Create("DImageButton", DockPrideCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                PrideCardList:Add(card)

                                prideCardsTotal = prideCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                prideCardsUnlocked = prideCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "level" then
                                local card = vgui.Create("DImageButton", DockLevelCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                LevelCardList:Add(card)

                                levelCardsTotal = levelCardsTotal + 1

                                if v[4] == "level" and playerTotalLevel < v[5] then
                                    card:SetColor(Color(100, 100, 100, 150))
                                    card.Paint = function(self, w, h)
                                        surface.SetDrawColor(35, 35, 35, 255)
                                        surface.DrawRect(0, h - 5, 240, 5)

                                        surface.SetDrawColor(255, 255, 0, 100)
                                        surface.DrawRect(0, h - 5, (playerTotalLevel / v[5]) * 240, 5)
                                    end
                                    local lockIndicator = vgui.Create("DImage", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    levelCardsUnlocked = levelCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "mastery" then
                                local card = vgui.Create("DImageButton", DockMasteryCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                MasteryCardList:Add(card)

                                masteryCardsTotal = masteryCardsTotal + 1

                                if v[4] == "mastery" and LocalPly:GetNWInt("killsWith_" .. v[5]) < 50 then
                                    card:SetColor(Color(100, 100, 100, 150))
                                    card.Paint = function(self, w, h)
                                        surface.SetDrawColor(35, 35, 35, 255)
                                        surface.DrawRect(0, h - 5, 240, 5)

                                        surface.SetDrawColor(255, 255, 0, 100)
                                        surface.DrawRect(0, h - 5, (LocalPly:GetNWInt("killsWith_" .. v[5]) / 50    ) * 240, 5)
                                    end
                                    local lockIndicator = vgui.Create("DImage", card)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(48, 48)
                                    lockIndicator:Center()
                                else
                                    cardsUnlocked = cardsUnlocked + 1
                                    masteryCardsUnlocked = masteryCardsUnlocked + 1
                                end

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            end
                        end
                    end

                    local function FillCardListsUnlocked()
                        for k, v in pairs(cardArray) do
                            if v[4] == "default" then
                                local card = vgui.Create("DImageButton", DockDefaultCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                DefaultCardList:Add(card)

                                defaultCardsTotal = defaultCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                defaultCardsUnlocked = defaultCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "kills" or v[4] == "streak" then
                                statCardsTotal = statCardsTotal + 1
                                if v[4] == "kills" and LocalPly:GetNWInt("playerKills") >= v[5] or v[4] == "streak" and LocalPly:GetNWInt("highestKillStreak") >= v[5] then
                                    local card = vgui.Create("DImageButton", DockStatCards)
                                    card:SetImage(v[1])
                                    card:SetSize(240, 80)
                                    StatCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    statCardsUnlocked = statCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        TriggerSound("click")
                                    end
                                end
                            elseif v[4] == "headshot" or v[4] == "smackdown" or v[4] == "clutch" or v[4] == "longshot" or v[4] == "pointblank" or v[4] == "killstreaks" or v[4] == "buzzkills" then
                                accoladeCardsTotal = accoladeCardsTotal + 1
                                if v[4] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= v[5] or v[4] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= v[5] or v[4] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= v[5] or v[4] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= v[5] or v[4] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= v[5] or v[4] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= v[5] or v[4] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= v[5] then
                                    local card = vgui.Create("DImageButton", DockAccoladeCards)
                                    card:SetImage(v[1])
                                    card:SetSize(240, 80)
                                    AccoladeCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    accoladeCardsUnlocked = accoladeCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        TriggerSound("click")
                                    end
                                end
                            elseif v[4] == "color" then
                                local card = vgui.Create("DImageButton", DockColorCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                ColorCardList:Add(card)

                                colorCardsTotal = colorCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                colorCardsUnlocked = colorCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "pride" then
                                local card = vgui.Create("DImageButton", DockPrideCards)
                                card:SetImage(v[1])
                                card:SetSize(240, 80)
                                PrideCardList:Add(card)

                                prideCardsTotal = prideCardsTotal + 1
                                cardsUnlocked = cardsUnlocked + 1
                                prideCardsUnlocked = prideCardsUnlocked + 1

                                card.DoClick = function(card)
                                    newCard = v[1]
                                    newCardName = v[2]
                                    newCardDesc = v[3]
                                    newCardUnlockType = v[4]
                                    newCardUnlockValue = v[5]
                                    TriggerSound("click")
                                end
                            elseif v[4] == "level" then
                                levelCardsTotal = levelCardsTotal + 1
                                if v[4] == "level" and playerTotalLevel >= v[5] then
                                    local card = vgui.Create("DImageButton", DockLevelCards)
                                    card:SetImage(v[1])
                                    card:SetSize(240, 80)
                                    LevelCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    levelCardsUnlocked = levelCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        TriggerSound("click")
                                    end
                                end
                            elseif v[4] == "mastery" then
                                masteryCardsTotal = masteryCardsTotal + 1
                                if v[4] == "mastery" and LocalPly:GetNWInt("killsWith_" .. v[5]) >= 50 then
                                    local card = vgui.Create("DImageButton", DockMasteryCards)
                                    card:SetImage(v[1])
                                    card:SetSize(240, 80)
                                    MasteryCardList:Add(card)

                                    cardsUnlocked = cardsUnlocked + 1
                                    masteryCardsUnlocked = masteryCardsUnlocked + 1

                                    card.DoClick = function(card)
                                        newCard = v[1]
                                        newCardName = v[2]
                                        newCardDesc = v[3]
                                        newCardUnlockType = v[4]
                                        newCardUnlockValue = v[5]
                                        TriggerSound("click")
                                    end
                                end
                            end
                        end
                    end

                    FillCardListsAll()

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Default", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultCardsUnlocked .. " / " .. defaultCardsUnlocked, "MainMenuDescription", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextStats.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Stats", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)

                        if statCardsUnlocked == statCardsTotal then
                            draw.SimpleText(statCardsUnlocked .. " / " .. statCardsTotal, "Health", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(statCardsUnlocked .. " / " .. statCardsTotal, "Health", w / 2, 50, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Accolades", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)

                        if accoladeCardsUnlocked == accoladeCardsTotal then
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeCardsUnlocked .. " / " .. accoladeCardsTotal, "Health", w / 2, 50, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextLevel.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Leveling", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)

                        if levelCardsUnlocked == levelCardsTotal then
                            draw.SimpleText(levelCardsUnlocked .. " / " .. levelCardsTotal, "Health", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(levelCardsUnlocked .. " / " .. levelCardsTotal, "Health", w / 2, 50, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextMastery.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Mastery", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)

                        if masteryCardsUnlocked == masteryCardsTotal then
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(masteryCardsUnlocked .. " / " .. masteryCardsTotal, "Health", w / 2, 50, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextColor.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Colors", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(colorCardsUnlocked .. " / " .. colorCardsTotal, "Health", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextPride.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Pride", "OptionsHeader", w / 2, -5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(prideCardsUnlocked .. " / " .. prideCardsTotal, "Health", w / 2, 50, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    DockDefaultCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockStatCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockAccoladeCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockLevelCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockMasteryCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockColorCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockPrideCards.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    function HideLockedCards:OnChange(bVal)
                        if (bVal) then
                            DefaultCardList:Clear()
                            StatCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
                            PrideCardList:Clear()
                            cardsUnlocked = 0
                            defaultCardsTotal = 0
                            defaultCardsUnlocked = 0
                            statCardsTotal = 0
                            statCardsUnlocked = 0
                            accoladeCardsTotal = 0
                            accoladeCardsUnlocked = 0
                            levelCardsTotal = 0
                            levelCardsUnlocked = 0
                            masteryCardsTotal = 0
                            masteryCardsUnlocked = 0
                            colorCardsTotal = 0
                            colorCardsUnlocked = 0
                            prideCardsTotal = 0
                            prideCardsUnlocked = 0
                            FillCardListsUnlocked()
                            DockDefaultCards:SetSize(0, 340)
                            DockStatCards:SetSize(0, (statCardsUnlocked * 28.34) + 28.34)
                            DockAccoladeCards:SetSize(0, (accoladeCardsUnlocked * 28.34) + 28.34)
                            DockLevelCards:SetSize(0, (levelCardsUnlocked * 28.34) + 28.34)
                            DockMasteryCards:SetSize(0, (masteryCardsUnlocked * 28.34) + 28.34)
                            DockColorCards:SetSize(0, 340)
                            DockPrideCards:SetSize(0, 355)
                        else
                            DefaultCardList:Clear()
                            StatCardList:Clear()
                            AccoladeCardList:Clear()
                            LevelCardList:Clear()
                            MasteryCardList:Clear()
                            ColorCardList:Clear()
                            PrideCardList:Clear()
                            cardsUnlocked = 0
                            defaultCardsTotal = 0
                            defaultCardsUnlocked = 0
                            statCardsTotal = 0
                            statCardsUnlocked = 0
                            accoladeCardsTotal = 0
                            accoladeCardsUnlocked = 0
                            levelCardsTotal = 0
                            levelCardsUnlocked = 0
                            masteryCardsTotal = 0
                            masteryCardsUnlocked = 0
                            colorCardsTotal = 0
                            colorCardsUnlocked = 0
                            prideCardsTotal = 0
                            prideCardsUnlocked = 0
                            FillCardListsAll()
                            DockDefaultCards:SetSize(0, 340)
                            DockStatCards:SetSize(0, 180)
                            DockAccoladeCards:SetSize(0, 850)
                            DockLevelCards:SetSize(0, 1360)
                            DockMasteryCards:SetSize(0, 3570)
                            DockColorCards:SetSize(0, 340)
                            DockPrideCards:SetSize(0, 335)
                        end
                    end

                    local CardIcon = vgui.Create("DImage", CardQuickjumpHolder)
                    CardIcon:SetPos(12, 12)
                    CardIcon:SetSize(32, 32)
                    CardIcon:SetImage("icons/cardicon.png")

                    local DefaultJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    DefaultJump:SetPos(4, 100)
                    DefaultJump:SetSize(48, 48)
                    DefaultJump:SetImage("icons/unlockedicon.png")
                    DefaultJump:SetTooltip("Default")
                    DefaultJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextDefault)
                    end

                    local LevelJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    LevelJump:SetPos(4, 152)
                    LevelJump:SetSize(48, 48)
                    LevelJump:SetImage("icons/performanceicon.png")
                    LevelJump:SetTooltip("Leveling")
                    LevelJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextLevel)
                    end

                    local StatsJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    StatsJump:SetPos(4, 204)
                    StatsJump:SetSize(48, 48)
                    StatsJump:SetImage("icons/uikillicon.png")
                    StatsJump:SetTooltip("Stats")
                    StatsJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextStats)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    AccoladeJump:SetPos(4, 256)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextAccolade)
                    end

                    local WeaponJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    WeaponJump:SetPos(4, 308)
                    WeaponJump:SetSize(48, 48)
                    WeaponJump:SetImage("icons/weaponicon.png")
                    WeaponJump:SetTooltip("Mastery")
                    WeaponJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextMastery)
                    end

                    local ColorJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    ColorJump:SetPos(4, 360)
                    ColorJump:SetSize(48, 48)
                    ColorJump:SetImage("icons/paletteicon.png")
                    ColorJump:SetTooltip("Colors")
                    ColorJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextColor)
                    end

                    local PrideJump = vgui.Create("DImageButton", CardQuickjumpHolder)
                    PrideJump:SetPos(4, 412)
                    PrideJump:SetSize(48, 48)
                    PrideJump:SetImage("icons/hearticon.png")
                    PrideJump:SetTooltip("Pride")
                    PrideJump.DoClick = function()
                        TriggerSound("click")
                        CardScroller:ScrollToChild(TextPride)
                    end

                    local RandomizeButton = vgui.Create("DImageButton", CardQuickjumpHolder)
                    RandomizeButton:SetPos(12, scrH - 96)
                    RandomizeButton:SetSize(32, 32)
                    RandomizeButton:SetImage("icons/diceicon.png")
                    RandomizeButton:SetTooltip("Choose random card")
                    RandomizeButton.DoClick = function()
                        TriggerSound("click")
                        local rand = math.random(1, totalCards)

                        for k, v in pairs(cardArray) do
                            if k == rand then
                                newCard = v[1]
                                newCardName = v[2]
                                newCardDesc = v[3]
                                newCardUnlockType = v[4]
                                newCardUnlockValue = v[5]
                            end
                        end
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", CardQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, scrH - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        MainPanel:Show()
                        CardPanel:Hide()
                        CardPreviewPanel:Hide()
                        CardSlideoutPanel:Hide()
                    end
                end
            end

            CustomizeModelButton.DoClick = function()
                TriggerSound("click")
                MainPanel:Hide()

                local currentModel = LocalPly:GetNWString("chosenPlayermodel")

                if not IsValid(CustomizePanel) then
                    local CustomizePanel = MainMenu:Add("CustomizePanel")
                    local CustomizeSlideoutPanel = MainMenu:Add("CustomizeSlideoutPanel")

                    local newModel
                    local newModelName
                    local newModelUnlockType
                    local newModelUnlockValue

                    local totalModels = table.Count(modelArray)
                    local modelsUnlocked = 0

                    local defaultModelsTotal = 0
                    local defaultModelsUnlocked = 0

                    local killModelsTotal = 0
                    local killModelsUnlocked = 0

                    local streakModelsTotal = 0
                    local streakModelsUnlocked = 0

                    local accoladeModelsTotal = 0
                    local accoladeModelsUnlocked = 0

                    -- Checking for the players currently equipped model
                    for k, v in pairs(modelArray) do
                        if v[1] == currentModel then
                            newModel = v[1]
                            newModelName = v[2]
                            newModelUnlockType = v[3]
                            newModelUnlockValue = v[4]
                        end
                    end

                    local ModelQuickjumpHolder = vgui.Create("DPanel", CustomizeSlideoutPanel)
                    ModelQuickjumpHolder:Dock(TOP)
                    ModelQuickjumpHolder:SetSize(0, scrH)

                    ModelQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local CustomizeScroller = vgui.Create("DScrollPanel", CustomizePanel)
                    CustomizeScroller:Dock(FILL)

                    local sbar = CustomizeScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local CustomizeTextHolder = vgui.Create("DPanel", CustomizePanel)
                    CustomizeTextHolder:Dock(TOP)
                    CustomizeTextHolder:SetSize(0, 160)

                    CustomizeTextHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("MODELS", "AmmoCountSmall", w / 2, 5, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(modelsUnlocked .. " / " .. totalModels .. " unlocked", "Health", w / 2, 85, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText("Hide locked playermodels", "StreakText", w / 2 + 20, 120, white, TEXT_ALIGN_CENTER)
                    end

                    local HideLockedModels = CustomizeTextHolder:Add("DCheckBox")
                    HideLockedModels:SetPos(120, 122.5)
                    HideLockedModels:SetSize(20, 20)
                    function HideLockedModels:OnChange() TriggerSound("click") end

                    -- Default Playermodels
                    local TextDefault = vgui.Create("DPanel", CustomizeScroller)
                    TextDefault:Dock(TOP)
                    TextDefault:SetSize(0, 90)

                    local DockModels = vgui.Create("DPanel", CustomizeScroller)
                    DockModels:Dock(TOP)
                    DockModels:SetSize(0, 465)

                    -- Kills Playermodels
                    local TextKills = vgui.Create("DPanel", CustomizeScroller)
                    TextKills:Dock(TOP)
                    TextKills:SetSize(0, 90)

                    local DockModelsKills = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsKills:Dock(TOP)
                    DockModelsKills:SetSize(0, 310)

                    -- Streak Playermodels
                    local TextStreak = vgui.Create("DPanel", CustomizeScroller)
                    TextStreak:Dock(TOP)
                    TextStreak:SetSize(0, 90)

                    local DockModelsStreak = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsStreak:Dock(TOP)
                    DockModelsStreak:SetSize(0, 310)

                    -- Accolade Playermodels
                    local TextAccolade = vgui.Create("DPanel", CustomizeScroller)
                    TextAccolade:Dock(TOP)
                    TextAccolade:SetSize(0, 90)

                    local DockModelsAccolade = vgui.Create("DPanel", CustomizeScroller)
                    DockModelsAccolade:Dock(TOP)
                    DockModelsAccolade:SetSize(0, 1550)

                    -- Creating playermodel lists
                    local DefaultModelList = vgui.Create("DIconLayout", DockModels)
                    DefaultModelList:Dock(TOP)
                    DefaultModelList:SetSpaceY(5)
                    DefaultModelList:SetSpaceX(5)

                    DefaultModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local KillsModelList = vgui.Create("DIconLayout", DockModelsKills)
                    KillsModelList:Dock(TOP)
                    KillsModelList:SetSpaceY(5)
                    KillsModelList:SetSpaceX(5)

                    KillsModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local StreakModelList = vgui.Create("DIconLayout", DockModelsStreak)
                    StreakModelList:Dock(TOP)
                    StreakModelList:SetSpaceY(5)
                    StreakModelList:SetSpaceX(5)

                    StreakModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local AccoladeModelList = vgui.Create("DIconLayout", DockModelsAccolade)
                    AccoladeModelList:Dock(TOP)
                    AccoladeModelList:SetSpaceY(5)
                    AccoladeModelList:SetSpaceX(5)

                    AccoladeModelList.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, transparent)
                    end

                    local PreviewPanel = MainMenu:Add("CustomizePreviewPanel")

                    local PreviewScroller = vgui.Create("DScrollPanel", PreviewPanel)
                    PreviewScroller:Dock(FILL)

                    local sbar = PreviewScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local SelectedModelHolder = vgui.Create("DPanel", PreviewScroller)
                    SelectedModelHolder:Dock(TOP)
                    if scrH >= 1080 then SelectedModelHolder:SetSize(0, PreviewPanel:GetTall() - 100) else SelectedModelHolder:SetSize(0, PreviewPanel:GetTall()) end

                    SelectedModelHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)

                        if newModel != nil then
                            draw.SimpleText(newModelName, "PlayerNotiName", w / 2, 2.5, white, TEXT_ALIGN_CENTER)
                        end

                        if newModelUnlockType == "default" then
                            draw.SimpleText("Unlocked", "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                        elseif newModelUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newModelUnlockValue then
                                draw.SimpleText("Total Kills: " .. LocalPly:GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Total Kills: " .. LocalPly:GetNWInt("playerKills") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newModelUnlockValue then
                                draw.SimpleText("Longest Kill Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longest Kill Streak: " .. LocalPly:GetNWInt("highestKillStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Headshots: " .. LocalPly:GetNWInt("playerAccoladeHeadshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                draw.SimpleText("Smackdowns: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Smackdowns: " .. LocalPly:GetNWInt("playerAccoladeSmackdown") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Clutches: " .. LocalPly:GetNWInt("playerAccoladeClutch") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Longshots: " .. LocalPly:GetNWInt("playerAccoladeLongshot") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Point Blanks: " .. LocalPly:GetNWInt("playerAccoladePointblank") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Killstreaks Started: " .. LocalPly:GetNWInt("playerAccoladeOnStreak") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        elseif newModelUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidRed, TEXT_ALIGN_CENTER)
                            else
                                draw.SimpleText("Buzzkills: " .. LocalPly:GetNWInt("playerAccoladeBuzzkill") .. " / " .. newModelUnlockValue, "Health", w / 2, 52.5, solidGreen, TEXT_ALIGN_CENTER)
                            end
                        end
                    end

                    local SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                    SelectedModelDisplay:SetSize(475, 337.5)
                    SelectedModelDisplay:SetPos(0, 120)
                    SelectedModelDisplay:SetModel(newModel)

                    local function FillModelListsAll()
                        for k, v in pairs(modelArray) do
                            if v[3] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    TriggerSound("click")
                                end
                            elseif v[3] == "kills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsKills)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                KillsModelList:Add(icon)

                                killModelsTotal = killModelsTotal + 1

                                if LocalPly:GetNWInt("playerKills") < v[4] then
                                    local lockIndicator = vgui.Create("DImage", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                else
                                    killModelsUnlocked = killModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1
                                end

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    TriggerSound("click")
                                end
                            elseif v[3] == "streak" then
                                local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                StreakModelList:Add(icon)

                                streakModelsTotal = streakModelsTotal + 1

                                if LocalPly:GetNWInt("highestKillStreak") < v[4] then
                                    local lockIndicator = vgui.Create("DImage", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                else
                                    streakModelsUnlocked = streakModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1
                                end

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    TriggerSound("click")
                                end
                            elseif v[3] == "headshot" or v[3] == "smackdown" or v[3] == "clutch" or v[3] == "longshot" or v[3] == "pointblank" or v[3] == "killstreaks" or v[3] == "buzzkills" then
                                local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                AccoladeModelList:Add(icon)

                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if v[3] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") < v[4] or v[3] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") < v[4] or v[3] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") < v[4] or v[3] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") < v[4] or v[3] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") < v[4] or v[3] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") < v[4] or v[3] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") < v[4] then
                                    local lockIndicator = vgui.Create("DImage", icon)
                                    lockIndicator:SetImage("icons/lockicon.png")
                                    lockIndicator:SetSize(96, 96)
                                    lockIndicator:Center()
                                else
                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1
                                end

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    TriggerSound("click")
                                end
                            end
                        end
                    end

                    local function FillModelListsUnlocked()
                        for k, v in pairs(modelArray) do
                            if v[3] == "default" then
                                local icon = vgui.Create("SpawnIcon", DockModels)
                                icon:SetModel(v[1])
                                icon:SetTooltip(v[2])
                                icon:SetSize(150, 150)
                                DefaultModelList:Add(icon)

                                defaultModelsTotal = defaultModelsTotal + 1
                                modelsUnlocked = modelsUnlocked + 1
                                defaultModelsUnlocked = defaultModelsUnlocked + 1

                                icon.DoClick = function(icon)
                                    newModel = v[1]
                                    newModelName = v[2]
                                    newModelUnlockType = v[3]
                                    newModelUnlockValue = v[4]

                                    SelectedModelDisplay:Remove()

                                    SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                    SelectedModelDisplay:SetSize(475, 337.5)
                                    SelectedModelDisplay:SetPos(0, 120)
                                    SelectedModelDisplay:SetModel(newModel)

                                    TriggerSound("click")
                                end
                            elseif v[3] == "kills" then
                                killModelsTotal = killModelsTotal + 1
                                if LocalPly:GetNWInt("playerKills") >= v[4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsKills)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2])
                                    icon:SetSize(150, 150)
                                    KillsModelList:Add(icon)

                                    killModelsUnlocked = killModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        TriggerSound("click")
                                    end
                                end
                            elseif v[3] == "streak" then
                                streakModelsTotal = streakModelsTotal + 1

                                if LocalPly:GetNWInt("highestKillStreak") >= v[4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsStreak)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2])
                                    icon:SetSize(150, 150)
                                    StreakModelList:Add(icon)

                                    streakModelsUnlocked = streakModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        TriggerSound("click")
                                    end
                                end
                            elseif v[3] == "headshot" or v[3] == "smackdown" or v[3] == "clutch" or v[3] == "longshot" or v[3] == "pointblank" or v[3] == "killstreaks" or v[3] == "buzzkills" then
                                accoladeModelsTotal = accoladeModelsTotal + 1

                                if v[3] == "headshot" and LocalPly:GetNWInt("playerAccoladeHeadshot") >= v[4] or v[3] == "smackdown" and LocalPly:GetNWInt("playerAccoladeSmackdown") >= v[4] or v[3] == "clutch" and LocalPly:GetNWInt("playerAccoladeClutch") >= v[4] or v[3] == "longshot" and LocalPly:GetNWInt("playerAccoladeLongshot") >= v[4] or v[3] == "pointblank" and LocalPly:GetNWInt("playerAccoladePointblank") >= v[4] or v[3] == "killstreaks" and LocalPly:GetNWInt("playerAccoladeOnStreak") >= v[4] or v[3] == "buzzkills" and LocalPly:GetNWInt("playerAccoladeBuzzkill") >= v[4] then
                                    local icon = vgui.Create("SpawnIcon", DockModelsAccolade)
                                    icon:SetModel(v[1])
                                    icon:SetTooltip(v[2])
                                    icon:SetSize(150, 150)
                                    AccoladeModelList:Add(icon)

                                    accoladeModelsUnlocked = accoladeModelsUnlocked + 1
                                    modelsUnlocked = modelsUnlocked + 1

                                    icon.DoClick = function(icon)
                                        newModel = v[1]
                                        newModelName = v[2]
                                        newModelUnlockType = v[3]
                                        newModelUnlockValue = v[4]

                                        SelectedModelDisplay:Remove()

                                        SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                        SelectedModelDisplay:SetSize(475, 337.5)
                                        SelectedModelDisplay:SetPos(0, 120)
                                        SelectedModelDisplay:SetModel(newModel)

                                        TriggerSound("click")
                                    end
                                end
                            end
                        end
                    end

                    FillModelListsAll()

                    TextDefault.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Default", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)
                        draw.SimpleText(defaultModelsUnlocked .. " / " .. defaultModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                    end

                    TextKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Kills", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if killModelsUnlocked == killModelsTotal then
                            draw.SimpleText(killModelsUnlocked .. " / " .. killModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(killModelsUnlocked .. " / " .. killModelsTotal, "Health", w / 2, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Streaks", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if streakModelsUnlocked == streakModelsTotal then
                            draw.SimpleText(streakModelsUnlocked .. " / " .. streakModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(streakModelsUnlocked .. " / " .. streakModelsTotal, "Health", w / 2, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    TextAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("Accolades", "OptionsHeader", w / 2, 0, white, TEXT_ALIGN_CENTER)

                        if accoladeModelsUnlocked == accoladeModelsTotal then
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, 55, solidGreen, TEXT_ALIGN_CENTER)
                        else
                            draw.SimpleText(accoladeModelsUnlocked .. " / " .. accoladeModelsTotal, "Health", w / 2, 55, white, TEXT_ALIGN_CENTER)
                        end
                    end

                    DockModels.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsKills.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsStreak.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    DockModelsAccolade.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end

                    local ApplyButtonHolder = vgui.Create("DPanel", PreviewScroller)
                    ApplyButtonHolder:Dock(TOP)
                    ApplyButtonHolder:SetSize(0, 100)

                    ApplyButtonHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, Color(50, 80, 50, 200))
                    end

                    local ApplyModelButton = vgui.Create("DButton", ApplyButtonHolder)
                    ApplyModelButton:SetText("APPLY NEW PLAYERMODEL")
                    ApplyModelButton:SetPos(62.5, 25)
                    ApplyModelButton:SetSize(350, 50)
                    ApplyModelButton.DoClick = function()
                        if newModelUnlockType == "default" then
                            surface.PlaySound("tmui/uisuccess.wav")
                            net.Start("PlayerModelChange")
                            net.WriteString(newModel)
                            net.SendToServer()
                            MainPanel:Show()
                            CustomizeSlideoutPanel:Hide()
                            CustomizePanel:Hide()
                            PreviewPanel:Hide()
                        elseif newModelUnlockType == "kills" then
                            if LocalPly:GetNWInt("playerKills") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "streak" then
                            if LocalPly:GetNWInt("highestKillStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "headshot" then
                            if LocalPly:GetNWInt("playerAccoladeHeadshot") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "smackdown" then
                            if LocalPly:GetNWInt("playerAccoladeSmackdown") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "clutch" then
                            if LocalPly:GetNWInt("playerAccoladeClutch") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "longshot" then
                            if LocalPly:GetNWInt("playerAccoladeLongshot") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "pointblank" then
                            if LocalPly:GetNWInt("playerAccoladePointblank") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "killstreaks" then
                            if LocalPly:GetNWInt("playerAccoladeOnStreak") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        elseif newModelUnlockType == "buzzkills" then
                            if LocalPly:GetNWInt("playerAccoladeBuzzkill") < newModelUnlockValue then
                                surface.PlaySound("common/wpn_denyselect.wav")
                            else
                                surface.PlaySound("tmui/uisuccess.wav")
                                net.Start("PlayerModelChange")
                                net.WriteString(newModel)
                                net.SendToServer()
                                MainPanel:Show()
                                CustomizeSlideoutPanel:Hide()
                                CustomizePanel:Hide()
                                PreviewPanel:Hide()
                            end
                        end
                    end

                    function HideLockedModels:OnChange(bVal)
                        if (bVal) then
                            DefaultModelList:Clear()
                            KillsModelList:Clear()
                            StreakModelList:Clear()
                            AccoladeModelList:Clear()
                            modelsUnlocked = 0
                            defaultModelsTotal = 0
                            defaultModelsUnlocked = 0
                            killModelsTotal = 0
                            killModelsUnlocked = 0
                            streakModelsTotal = 0
                            streakModelsUnlocked = 0
                            accoladeModelsTotal = 0
                            accoladeModelsUnlocked = 0
                            FillModelListsUnlocked()
                            DockModels:SetSize(0, 465)
                            DockModelsKills:SetSize(0, (killModelsUnlocked * 51.6) + 103.2)
                            DockModelsStreak:SetSize(0, (streakModelsUnlocked * 51.6) + 103.2)
                            DockModelsAccolade:SetSize(0, (accoladeModelsUnlocked * 51.6) + 103.2)
                        else
                            DefaultModelList:Clear()
                            KillsModelList:Clear()
                            StreakModelList:Clear()
                            AccoladeModelList:Clear()
                            modelsUnlocked = 0
                            defaultModelsTotal = 0
                            defaultModelsUnlocked = 0
                            killModelsTotal = 0
                            killModelsUnlocked = 0
                            streakModelsTotal = 0
                            streakModelsUnlocked = 0
                            accoladeModelsTotal = 0
                            accoladeModelsUnlocked = 0
                            FillModelListsAll()
                            DockModels:SetSize(0, 465)
                            DockModelsKills:SetSize(0, 310)
                            DockModelsStreak:SetSize(0, 310)
                            DockModelsAccolade:SetSize(0, 1550)
                        end
                    end

                    local ModelIcon = vgui.Create("DImage", ModelQuickjumpHolder)
                    ModelIcon:SetPos(12, 12)
                    ModelIcon:SetSize(32, 32)
                    ModelIcon:SetImage("icons/modelicon.png")

                    local DefaultJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    DefaultJump:SetPos(4, 100)
                    DefaultJump:SetSize(48, 48)
                    DefaultJump:SetImage("icons/unlockedicon.png")
                    DefaultJump:SetTooltip("Default")
                    DefaultJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextDefault)
                    end

                    local KillsJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    KillsJump:SetPos(4, 152)
                    KillsJump:SetSize(48, 48)
                    KillsJump:SetImage("icons/uikillicon.png")
                    KillsJump:SetTooltip("Kills")
                    KillsJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextKills)
                    end

                    local StreaksJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    StreaksJump:SetPos(4, 204)
                    StreaksJump:SetSize(48, 48)
                    StreaksJump:SetImage("icons/streakicon.png")
                    StreaksJump:SetTooltip("Streaks")
                    StreaksJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextStreak)
                    end

                    local AccoladeJump = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    AccoladeJump:SetPos(4, 256)
                    AccoladeJump:SetSize(48, 48)
                    AccoladeJump:SetImage("icons/accoladeicon.png")
                    AccoladeJump:SetTooltip("Accolades")
                    AccoladeJump.DoClick = function()
                        TriggerSound("click")
                        CustomizeScroller:ScrollToChild(TextAccolade)
                    end

                    local RandomizeButton = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    RandomizeButton:SetPos(12, scrH - 96)
                    RandomizeButton:SetSize(32, 32)
                    RandomizeButton:SetImage("icons/diceicon.png")
                    RandomizeButton:SetTooltip("Choose random model")
                    RandomizeButton.DoClick = function()
                        TriggerSound("click")
                        local rand = math.random(1, totalModels)

                        for k, v in pairs(modelArray) do
                            if k == rand then
                                newModel = v[1]
                                newModelName = v[2]
                                newModelUnlockType = v[3]
                                newModelUnlockValue = v[4]

                                SelectedModelDisplay:Remove()

                                SelectedModelDisplay = vgui.Create("DModelPanel", SelectedModelHolder)
                                SelectedModelDisplay:SetSize(475, 337.5)
                                SelectedModelDisplay:SetPos(0, 120)
                                SelectedModelDisplay:SetModel(newModel)
                            end
                        end
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", ModelQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, scrH - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        MainPanel:Show()
                        CustomizeSlideoutPanel:Hide()
                        CustomizePanel:Hide()
                        PreviewPanel:Hide()
                    end
                end
            end

            local OptionsButton = vgui.Create("DButton", MainPanel)
            local OptionsSettingsButton = vgui.Create("DButton", OptionsButton)
            local OptionsHUDButton = vgui.Create("DButton", OptionsButton)
            OptionsButton:SetPos(0, scrH / 2 + 50)
            OptionsButton:SetText("")
            OptionsButton:SetSize(415, 100)
            local textAnim = 0
            OptionsButton.Paint = function()
                if OptionsButton:IsHovered() or OptionsSettingsButton:IsHovered() or OptionsHUDButton:IsHovered() then
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                    pushExitItems = math.Clamp(pushExitItems + 600 * RealFrameTime(), 100, 150)
                    OptionsButton:SizeTo(-1, 200, 0, 0, 1)
                else
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                    pushExitItems = math.Clamp(pushExitItems - 600 * RealFrameTime(), 100, 150)
                    OptionsButton:SizeTo(-1, 100, 0, 0, 1)
                end
                draw.DrawText("OPTIONS", "AmmoCountSmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            OptionsSettingsButton:SetPos(0, 100)
            OptionsSettingsButton:SetText("")
            OptionsSettingsButton:SetSize(235, 100)
            OptionsSettingsButton.Paint = function()
                draw.DrawText("SETTINGS", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            OptionsHUDButton:SetPos(240, 100)
            OptionsHUDButton:SetText("")
            OptionsHUDButton:SetSize(245, 100)
            OptionsHUDButton.Paint = function()
                draw.DrawText("HUD", "AmmoCountESmall", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
            end

            OptionsSettingsButton.DoClick = function()
                MainPanel:Hide()

                if not IsValid(OptionsPanel) then
                    local OptionsPanel = MainMenu:Add("OptionsPanel")
                    local OptionsSlideoutPanel = MainMenu:Add("OptionsSlideoutPanel")

                    local OptionsQuickjumpHolder = vgui.Create("DPanel", OptionsSlideoutPanel)
                    OptionsQuickjumpHolder:Dock(TOP)
                    OptionsQuickjumpHolder:SetSize(0, scrH)

                    OptionsQuickjumpHolder.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, lightGray)
                    end

                    local OptionsScroller = vgui.Create("DScrollPanel", OptionsPanel)
                    OptionsScroller:Dock(FILL)

                    local sbar = OptionsScroller:GetVBar()
                    function sbar:Paint(w, h)
                        draw.RoundedBox(5, 0, 0, w, h, gray)
                    end
                    function sbar.btnUp:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnDown:Paint(w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                    end
                    function sbar.btnGrip:Paint(w, h)
                        draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                    end

                    local DockAccount = vgui.Create("DPanel", OptionsScroller)
                    DockAccount:Dock(TOP)
                    DockAccount:SetSize(0, 110)

                    local DockInputs = vgui.Create("DPanel", OptionsScroller)
                    DockInputs:Dock(TOP)
                    DockInputs:SetSize(0, 480)

                    local DockGameplay = vgui.Create("DPanel", OptionsScroller)
                    DockGameplay:Dock(TOP)
                    DockGameplay:SetSize(0, 315)

                    local DockUI = vgui.Create("DPanel", OptionsScroller)
                    DockUI:Dock(TOP)
                    DockUI:SetSize(0, 355)

                    local DockAudio = vgui.Create("DPanel", OptionsScroller)
                    DockAudio:Dock(TOP)
                    DockAudio:SetSize(0, 320)

                    local DockCrosshair = vgui.Create("DPanel", OptionsScroller)
                    DockCrosshair:Dock(TOP)
                    DockCrosshair:SetSize(0, 630)

                    local DockHitmarker = vgui.Create("DPanel", OptionsScroller)
                    DockHitmarker:Dock(TOP)
                    DockHitmarker:SetSize(0, 315)

                    local DockPerformance = vgui.Create("DPanel", OptionsScroller)
                    DockPerformance:Dock(TOP)
                    DockPerformance:SetSize(0, 360)

                    local SettingsCog = vgui.Create("DImage", OptionsQuickjumpHolder)
                    SettingsCog:SetPos(12, 12)
                    SettingsCog:SetSize(32, 32)
                    SettingsCog:SetImage("icons/settingsicon.png")

                    local AccountJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AccountJump:SetPos(4, 100)
                    AccountJump:SetSize(48, 48)
                    AccountJump:SetTooltip("Account")
                    AccountJump:SetImage("icons/accounticon.png")
                    AccountJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockAccount)
                    end

                    local InputsJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    InputsJump:SetPos(4, 152)
                    InputsJump:SetSize(48, 48)
                    InputsJump:SetTooltip("Input")
                    InputsJump:SetImage("icons/inputicon.png")
                    InputsJump.DoClick = function()
                        OptionsScroller:ScrollToChild(DockInputs)
                    end

                    local GameplayJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    GameplayJump:SetPos(4, 204)
                    GameplayJump:SetSize(48, 48)
                    GameplayJump:SetTooltip("Gameplay")
                    GameplayJump:SetImage("icons/weaponicon.png")
                    GameplayJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockGameplay)
                    end

                    local UIJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    UIJump:SetPos(4, 256)
                    UIJump:SetSize(48, 48)
                    UIJump:SetTooltip("Interface")
                    UIJump:SetImage("icons/interfaceicon.png")
                    UIJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockUI)
                    end

                    local AudioJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    AudioJump:SetPos(4, 308)
                    AudioJump:SetSize(48, 48)
                    AudioJump:SetTooltip("Audio")
                    AudioJump:SetImage("icons/audioicon.png")
                    AudioJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockAudio)
                    end

                    local CrosshairJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    CrosshairJump:SetPos(4, 360)
                    CrosshairJump:SetSize(48, 48)
                    CrosshairJump:SetTooltip("Crosshair")
                    CrosshairJump:SetImage("icons/crosshairicon.png")
                    CrosshairJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockCrosshair)
                    end

                    local HitmarkerJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    HitmarkerJump:SetPos(4, 412)
                    HitmarkerJump:SetSize(48, 48)
                    HitmarkerJump:SetTooltip("Hitmarkers")
                    HitmarkerJump:SetImage("icons/hitmarkericon.png")
                    HitmarkerJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockHitmarker)
                    end

                    local PerformanceJump = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    PerformanceJump:SetPos(4, 464)
                    PerformanceJump:SetSize(48, 48)
                    PerformanceJump:SetTooltip("Performance")
                    PerformanceJump:SetImage("icons/performanceicon.png")
                    PerformanceJump.DoClick = function()
                        TriggerSound("click")
                        OptionsScroller:ScrollToChild(DockPerformance)
                    end

                    local BackButtonSlideout = vgui.Create("DImageButton", OptionsQuickjumpHolder)
                    BackButtonSlideout:SetPos(12, scrH - 44)
                    BackButtonSlideout:SetSize(32, 32)
                    BackButtonSlideout:SetTooltip("Return to Main Menu")
                    BackButtonSlideout:SetImage("icons/exiticon.png")
                    BackButtonSlideout.DoClick = function()
                        TriggerSound("back")
                        MainPanel:Show()
                        OptionsSlideoutPanel:Hide()
                        OptionsPanel:Hide()
                    end

                    DockAccount.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("ACCOUNT", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Hide Lifetime Stats From Others", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                    end

                    local hideStatsFromOthers = DockAccount:Add("DCheckBox")
                    hideStatsFromOthers:SetPos(20, 70)
                    hideStatsFromOthers:SetConVar("tm_hidestatsfromothers")
                    hideStatsFromOthers:SetSize(30, 30)
                    function hideStatsFromOthers:OnChange() TriggerSound("click") end

                    DockInputs.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INPUT", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("ADS Sensitivity", "SettingsLabel", 155, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Compensate Sensitivity w/ FOV", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Main Menu Bind", "SettingsLabel", 135, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grenade Bind", "SettingsLabel", 135, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Grappling Hook Bind", "SettingsLabel", 135, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Quick Weapon Switching", "SettingsLabel", 55, 265, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Primary Weapon Bind", "SettingsLabel", 135, 305, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Secondary Weapon Bind", "SettingsLabel", 135, 345, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Melee Weapon Bind", "SettingsLabel", 135, 385, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Slide Cancel Type", "SettingsLabel", 135, 425, white, TEXT_ALIGN_LEFT)
                    end

                    local adsSensitivity = DockInputs:Add("DNumSlider")
                    adsSensitivity:SetPos(-85, 70)
                    adsSensitivity:SetSize(250, 30)
                    adsSensitivity:SetConVar("cl_tfa_scope_sensitivity")
                    adsSensitivity:SetMin(0)
                    adsSensitivity:SetMax(100)
                    adsSensitivity:SetDecimals(0)

                    local compensateSensWithFOV = DockInputs:Add("DCheckBox")
                    compensateSensWithFOV:SetPos(20, 110)
                    compensateSensWithFOV:SetConVar("cl_tfa_scope_sensitivity_autoscale")
                    compensateSensWithFOV:SetSize(30, 30)
                    function compensateSensWithFOV:OnChange() TriggerSound("click") end

                    local mainMenuBind = DockInputs:Add("DBinder")
                    mainMenuBind:SetPos(22.5, 150)
                    mainMenuBind:SetSize(100, 30)
                    mainMenuBind:SetSelectedNumber(GetConVar("tm_mainmenubind"):GetInt())
                    function mainMenuBind:OnChange(num)
                        TriggerSound("forward")
                        selectedMenuBind = mainMenuBind:GetSelectedNumber()
                        RunConsoleCommand("tm_mainmenubind", selectedMenuBind)
                    end

                    local grenadeBind = DockInputs:Add("DBinder")
                    grenadeBind:SetPos(22.5, 190)
                    grenadeBind:SetSize(100, 30)
                    grenadeBind:SetSelectedNumber(GetConVar("tm_nadebind"):GetInt())
                    function grenadeBind:OnChange(num)
                        TriggerSound("forward")
                        selectedGrenadeBind = grenadeBind:GetSelectedNumber()
                        RunConsoleCommand("tm_nadebind", selectedGrenadeBind)
                    end

                    local grappleBind = DockInputs:Add("DBinder")
                    grappleBind:SetPos(22.5, 230)
                    grappleBind:SetSize(100, 30)
                    grappleBind:SetSelectedNumber(GetConVar("frest_bindg"):GetInt())
                    function grappleBind:OnChange(num)
                        TriggerSound("forward")
                        selectedGrappleBind = grappleBind:GetSelectedNumber()
                        RunConsoleCommand("frest_bindg", selectedGrappleBind)
                    end

                    local quickWeaponSwitching = DockInputs:Add("DCheckBox")
                    quickWeaponSwitching:SetPos(20, 270)
                    quickWeaponSwitching:SetConVar("tm_quickswitching")
                    quickWeaponSwitching:SetSize(30, 30)
                    function quickWeaponSwitching:OnChange() TriggerSound("click") end

                    local primaryBind = DockInputs:Add("DBinder")
                    primaryBind:SetPos(22.5, 310)
                    primaryBind:SetSize(100, 30)
                    primaryBind:SetSelectedNumber(GetConVar("tm_primarybind"):GetInt())
                    function primaryBind:OnChange(num)
                        TriggerSound("forward")
                        selectedPrimaryBind = primaryBind:GetSelectedNumber()
                        RunConsoleCommand("tm_primarybind", selectedPrimaryBind)
                    end

                    local secondaryBind = DockInputs:Add("DBinder")
                    secondaryBind:SetPos(22.5, 350)
                    secondaryBind:SetSize(100, 30)
                    secondaryBind:SetSelectedNumber(GetConVar("tm_secondarybind"):GetInt())
                    function secondaryBind:OnChange(num)
                        TriggerSound("forward")
                        selectedSecondaryBind = secondaryBind:GetSelectedNumber()
                        RunConsoleCommand("tm_secondarybind", selectedSecondaryBind)
                    end

                    local meleeBind = DockInputs:Add("DBinder")
                    meleeBind:SetPos(22.5, 390)
                    meleeBind:SetSize(100, 30)
                    meleeBind:SetSelectedNumber(GetConVar("tm_meleebind"):GetInt())
                    function meleeBind:OnChange(num)
                        TriggerSound("forward")
                        selectedMeleeBind = meleeBind:GetSelectedNumber()
                        RunConsoleCommand("tm_meleebind", selectedMeleeBind)
                    end

                    local slideCancelType = DockInputs:Add("DComboBox")
                    slideCancelType:SetPos(20, 430)
                    slideCancelType:SetSize(100, 30)
                    if GetConVar("tm_slidecanceltype"):GetInt() == 0 then slideCancelType:SetValue("Release") elseif GetConVar("tm_slidecanceltype"):GetInt() == 1 then slideCancelType:SetValue("Jump") elseif GetConVar("tm_slidecanceltype"):GetInt() == 2 then slideCancelType:SetValue("Sprint") end
                    slideCancelType:AddChoice("Release")
                    slideCancelType:AddChoice("Jump")
                    slideCancelType:AddChoice("Sprint")
                    slideCancelType.OnSelect = function(self, value)
                        RunConsoleCommand("tm_slidecanceltype", value - 1)
                        TriggerSound("forward")
                    end

                    DockGameplay.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("GAMEPLAY", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Increase FOV", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("FOV Value", "SettingsLabel", 155, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Centered Gun", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Optic Reticle Color", "SettingsLabel", 245, 185, white, TEXT_ALIGN_LEFT)
                    end

                    local customFOV = DockGameplay:Add("DCheckBox")
                    customFOV:SetPos(20, 70)
                    customFOV:SetConVar("tm_customfov")
                    customFOV:SetSize(30, 30)
                    function customFOV:OnChange() TriggerSound("click") end

                    local customFOVSlider = DockGameplay:Add("DNumSlider")
                    customFOVSlider:SetPos(-85, 110)
                    customFOVSlider:SetSize(250, 30)
                    customFOVSlider:SetConVar("tm_customfov_value")
                    customFOVSlider:SetMin(100)
                    customFOVSlider:SetMax(125)
                    customFOVSlider:SetDecimals(0)

                    local centeredVM = DockGameplay:Add("DCheckBox")
                    centeredVM:SetPos(20, 150)
                    centeredVM:SetConVar("cl_tfa_viewmodel_centered")
                    centeredVM:SetSize(30, 30)
                    function centeredVM:OnChange() TriggerSound("click") end

                    local reticleMixer = vgui.Create("DColorMixer", DockGameplay)
                    reticleMixer:SetPos(20, 190)
                    reticleMixer:SetSize(215, 110)
                    reticleMixer:SetConVarR("cl_tfa_reticule_color_r")
                    reticleMixer:SetConVarG("cl_tfa_reticule_color_g")
                    reticleMixer:SetConVarB("cl_tfa_reticule_color_b")
                    reticleMixer:SetAlphaBar(false)
                    reticleMixer:SetPalette(false)
                    reticleMixer:SetWangs(true)

                    DockUI.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("INTERFACE", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("HUD", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Damage Indicator", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Reload Hints", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Loadout Hints", "SettingsLabel", 55, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill Tracker", "SettingsLabel", 55, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Keypress Overlay", "SettingsLabel", 55, 265, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Velocity Counter", "SettingsLabel", 55, 305, white, TEXT_ALIGN_LEFT)
                    end

                    local HUDtoggle = DockUI:Add("DCheckBox")
                    HUDtoggle:SetPos(20, 70)
                    HUDtoggle:SetConVar("tm_hud_enable")
                    HUDtoggle:SetSize(30, 30)
                    function HUDtoggle:OnChange() TriggerSound("click") end

                    local dmgIndicatorToggle = DockUI:Add("DCheckBox")
                    dmgIndicatorToggle:SetPos(20, 110)
                    dmgIndicatorToggle:SetConVar("tm_hud_dmgindicator")
                    dmgIndicatorToggle:SetSize(30, 30)
                    function dmgIndicatorToggle:OnChange() TriggerSound("click") end

                    local reloadHintsToggle = DockUI:Add("DCheckBox")
                    reloadHintsToggle:SetPos(20, 150)
                    reloadHintsToggle:SetConVar("tm_hud_reloadhint")
                    reloadHintsToggle:SetSize(30, 30)
                    function reloadHintsToggle:OnChange() TriggerSound("click") end

                    local loadoutHintsToggle = DockUI:Add("DCheckBox")
                    loadoutHintsToggle:SetPos(20, 190)
                    loadoutHintsToggle:SetConVar("tm_hud_loadouthint")
                    loadoutHintsToggle:SetSize(30, 30)
                    function loadoutHintsToggle:OnChange() TriggerSound("click") end

                    local killTrackerToggle = DockUI:Add("DCheckBox")
                    killTrackerToggle:SetPos(20, 230)
                    killTrackerToggle:SetConVar("tm_hud_killtracker")
                    killTrackerToggle:SetSize(30, 30)
                    function killTrackerToggle:OnChange() TriggerSound("click") end

                    local keypressOverlayToggle = DockUI:Add("DCheckBox")
                    keypressOverlayToggle:SetPos(20, 270)
                    keypressOverlayToggle:SetConVar("tm_hud_keypressoverlay")
                    keypressOverlayToggle:SetSize(30, 30)
                    function keypressOverlayToggle:OnChange() TriggerSound("click") end

                    local VelocityCounterToggle = DockUI:Add("DCheckBox")
                    VelocityCounterToggle:SetPos(20, 310)
                    VelocityCounterToggle:SetConVar("tm_hud_velocitycounter")
                    VelocityCounterToggle:SetSize(30, 30)
                    function VelocityCounterToggle:OnChange() TriggerSound("click") end

                    DockAudio.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("AUDIO", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Menu SFX", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Music Volume", "SettingsLabel", 155, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker SFX", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill SFX", "SettingsLabel", 55, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker SFX Style", "SettingsLabel", 125, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Kill SFX Style", "SettingsLabel", 125, 265, white, TEXT_ALIGN_LEFT)
                    end


                    local menuSoundsButton = DockAudio:Add("DCheckBox")
                    menuSoundsButton:SetPos(20, 70)
                    menuSoundsButton:SetConVar("tm_menusounds")
                    menuSoundsButton:SetSize(30, 30)
                    function menuSoundsButton:OnChange() TriggerSound("click") end

                    local musicVolume = DockAudio:Add("DNumSlider")
                    musicVolume:SetPos(-85, 110)
                    musicVolume:SetSize(250, 30)
                    musicVolume:SetConVar("tm_musicvolume")
                    musicVolume:SetMin(0)
                    musicVolume:SetMax(1)
                    musicVolume:SetDecimals(2)

                    local hitSoundsButton = DockAudio:Add("DCheckBox")
                    hitSoundsButton:SetPos(20, 150)
                    hitSoundsButton:SetConVar("tm_hitsounds")
                    hitSoundsButton:SetSize(30, 30)
                    function hitSoundsButton:OnChange() TriggerSound("click") end

                    local killSoundButton = DockAudio:Add("DCheckBox")
                    killSoundButton:SetPos(20, 190)
                    killSoundButton:SetConVar("tm_killsound")
                    killSoundButton:SetSize(30, 30)
                    function killSoundButton:OnChange() TriggerSound("click") end

                    local hitSoundsType = DockAudio:Add("DComboBox")
                    hitSoundsType:SetPos(20, 230)
                    hitSoundsType:SetSize(100, 30)
                    if GetConVar("tm_hitsoundtype"):GetInt() == 0 then hitSoundsType:SetValue("Rust") elseif GetConVar("tm_hitsoundtype"):GetInt() == 1 then hitSoundsType:SetValue("TABG") elseif GetConVar("tm_hitsoundtype"):GetInt() == 2 then hitSoundsType:SetValue("Apex Legends") elseif GetConVar("tm_hitsoundtype"):GetInt() == 3 then hitSoundsType:SetValue("Bad Business") elseif GetConVar("tm_hitsoundtype"):GetInt() == 4 then hitSoundsType:SetValue("Call Of Duty") end
                    hitSoundsType:AddChoice("Rust")
                    hitSoundsType:AddChoice("TABG")
                    hitSoundsType:AddChoice("Apex Legends")
                    hitSoundsType:AddChoice("Bad Business")
                    hitSoundsType:AddChoice("Call Of Duty")
                    hitSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/hit_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_hitsoundtype", value - 1)
                    end

                    local killSoundsType = DockAudio:Add("DComboBox")
                    killSoundsType:SetPos(20, 270)
                    killSoundsType:SetSize(100, 30)
                    if GetConVar("tm_killsoundtype"):GetInt() == 0 then killSoundsType:SetValue("Call Of Duty") elseif GetConVar("tm_killsoundtype"):GetInt() == 1 then killSoundsType:SetValue("TABG") elseif GetConVar("tm_killsoundtype"):GetInt() == 2 then killSoundsType:SetValue("Bad Business") elseif GetConVar("tm_killsoundtype"):GetInt() == 3 then killSoundsType:SetValue("Apex Legends") end
                    killSoundsType:AddChoice("Call Of Duty")
                    killSoundsType:AddChoice("TABG")
                    killSoundsType:AddChoice("Bad Business")
                    killSoundsType:AddChoice("Apex Legends")
                    killSoundsType.OnSelect = function(self, value)
                        surface.PlaySound("hitsound/kill_" .. value - 1 .. ".wav")
                        RunConsoleCommand("tm_killsoundtype", value - 1)
                    end

                    DockCrosshair.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("CROSSHAIR", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Style", "SettingsLabel", 125, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Center Dot", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Length", "SettingsLabel", 145, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Thickness", "SettingsLabel", 145, 225, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Gap", "SettingsLabel", 145, 265, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Color/Opacity", "SettingsLabel", 245 , 305, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline", "SettingsLabel", 55, 425, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Outline Color", "SettingsLabel", 245 , 465, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Top", "SettingsLabel", 55, 585, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Bottom", "SettingsLabel", 155, 585, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Left", "SettingsLabel", 300, 585, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Right", "SettingsLabel", 395, 585, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Click to cycle image", "QuoteText", 475, 210, white, TEXT_ALIGN_CENTER)
                    end

                    local crosshairToggle = DockCrosshair:Add("DCheckBox")
                    crosshairToggle:SetPos(20, 70)
                    crosshairToggle:SetConVar("tm_hud_crosshair")
                    crosshairToggle:SetSize(30, 30)
                    function crosshairToggle:OnChange() TriggerSound("click") end

                    local crosshairStyle = DockCrosshair:Add("DComboBox")
                    crosshairStyle:SetPos(20, 110)
                    crosshairStyle:SetSize(100, 30)
                    if GetConVar("tm_hud_crosshair_style"):GetInt() == 0 then crosshairStyle:SetValue("Static") elseif GetConVar("tm_hud_crosshair_style"):GetInt() == 1 then crosshairStyle:SetValue("Dynamic") end
                    crosshairStyle:AddChoice("Static")
                    crosshairStyle:AddChoice("Dynamic")
                    crosshairStyle.OnSelect = function(self, value) RunConsoleCommand("tm_hud_crosshair_style", value - 1) TriggerSound("forward") end

                    local crosshairDot = DockCrosshair:Add("DCheckBox")
                    crosshairDot:SetPos(20, 150)
                    crosshairDot:SetConVar("tm_hud_crosshair_dot")
                    crosshairDot:SetSize(30, 30)
                    function crosshairDot:OnChange() TriggerSound("click") end

                    local crosshairLength = DockCrosshair:Add("DNumSlider")
                    crosshairLength:SetPos(-85, 190)
                    crosshairLength:SetSize(250, 30)
                    crosshairLength:SetConVar("tm_hud_crosshair_size")
                    crosshairLength:SetMin(1)
                    crosshairLength:SetMax(50)
                    crosshairLength:SetDecimals(0)
                    function crosshairLength:OnValueChanged() end

                    local crosshairThickness = DockCrosshair:Add("DNumSlider")
                    crosshairThickness:SetPos(-85, 230)
                    crosshairThickness:SetSize(250, 30)
                    crosshairThickness:SetConVar("tm_hud_crosshair_thickness")
                    crosshairThickness:SetMin(1)
                    crosshairThickness:SetMax(50)
                    crosshairThickness:SetDecimals(0)
                    function crosshairThickness:OnValueChanged() end

                    local crosshairGap = DockCrosshair:Add("DNumSlider")
                    crosshairGap:SetPos(-85, 270)
                    crosshairGap:SetSize(250, 30)
                    crosshairGap:SetConVar("tm_hud_crosshair_gap")
                    crosshairGap:SetMin(0)
                    crosshairGap:SetMax(50)
                    crosshairGap:SetDecimals(0)
                    function crosshairGap:OnValueChanged() end

                    local crosshairMixer = vgui.Create("DColorMixer", DockCrosshair)
                    crosshairMixer:SetPos(20, 310)
                    crosshairMixer:SetSize(215, 110)
                    crosshairMixer:SetConVarR("tm_hud_crosshair_color_r")
                    crosshairMixer:SetConVarG("tm_hud_crosshair_color_g")
                    crosshairMixer:SetConVarB("tm_hud_crosshair_color_b")
                    crosshairMixer:SetConVarA("tm_hud_crosshair_opacity")
                    crosshairMixer:SetAlphaBar(true)
                    crosshairMixer:SetPalette(false)
                    crosshairMixer:SetWangs(true)

                    local crosshairOutline = DockCrosshair:Add("DCheckBox")
                    crosshairOutline:SetPos(20, 430)
                    crosshairOutline:SetConVar("tm_hud_crosshair_outline")
                    crosshairOutline:SetSize(30, 30)
                    function crosshairOutline:OnChange() TriggerSound("click") end

                    local crosshairOutlineMixer = vgui.Create("DColorMixer", DockCrosshair)
                    crosshairOutlineMixer:SetPos(20, 470)
                    crosshairOutlineMixer:SetSize(215, 110)
                    crosshairOutlineMixer:SetConVarR("tm_hud_crosshair_outline_color_r")
                    crosshairOutlineMixer:SetConVarG("tm_hud_crosshair_outline_color_g")
                    crosshairOutlineMixer:SetConVarB("tm_hud_crosshair_outline_color_b")
                    crosshairOutlineMixer:SetAlphaBar(false)
                    crosshairOutlineMixer:SetPalette(false)
                    crosshairOutlineMixer:SetWangs(true)

                    local crosshairTop = DockCrosshair:Add("DCheckBox")
                    crosshairTop:SetPos(20, 590)
                    crosshairTop:SetConVar("tm_hud_crosshair_show_t")
                    crosshairTop:SetSize(30, 30)
                    function crosshairTop:OnChange() TriggerSound("click") end

                    local crosshairBottom = DockCrosshair:Add("DCheckBox")
                    crosshairBottom:SetPos(120, 590)
                    crosshairBottom:SetConVar("tm_hud_crosshair_show_b")
                    crosshairBottom:SetSize(30, 30)
                    function crosshairBottom:OnChange() TriggerSound("click") end

                    local crosshairLeft = DockCrosshair:Add("DCheckBox")
                    crosshairLeft:SetPos(265, 590)
                    crosshairLeft:SetConVar("tm_hud_crosshair_show_l")
                    crosshairLeft:SetSize(30, 30)
                    function crosshairLeft:OnChange() TriggerSound("click") end

                    local crosshairRight = DockCrosshair:Add("DCheckBox")
                    crosshairRight:SetPos(360, 590)
                    crosshairRight:SetConVar("tm_hud_crosshair_show_r")
                    crosshairRight:SetSize(30, 30)
                    function crosshairRight:OnChange() TriggerSound("click") end

                    local previewPool = {"images/preview/sky.png", "images/preview/sky2.png", "images/preview/metal.png", "images/preview/water.png"}
                    local previewImg = "images/preview/sky.png"

                    local crosshairPreviewImage = DockCrosshair:Add("DImageButton")
                    crosshairPreviewImage:SetPos(375, 10)
                    crosshairPreviewImage:SetSize(200, 200)
                    crosshairPreviewImage:SetImage(previewImg)
                    crosshairPreviewImage.DoClick = function() previewImg = previewPool[math.random(#previewPool)] crosshairPreviewImage:SetImage(previewImg) end

                    local crosshair = {}
                    local function UpdateCrosshair()
                        crosshair = {
                            ["enabled"] = GetConVar("tm_hud_crosshair"):GetInt(),
                            ["style"] = GetConVar("tm_hud_crosshair_style"):GetInt(),
                            ["gap"] = GetConVar("tm_hud_crosshair_gap"):GetInt(),
                            ["size"] = GetConVar("tm_hud_crosshair_size"):GetInt(),
                            ["thickness"] = GetConVar("tm_hud_crosshair_thickness"):GetInt(),
                            ["dot"] = GetConVar("tm_hud_crosshair_dot"):GetInt(),
                            ["outline"] = GetConVar("tm_hud_crosshair_outline"):GetInt(),
                            ["opacity"] = GetConVar("tm_hud_crosshair_opacity"):GetInt(),
                            ["r"] = GetConVar("tm_hud_crosshair_color_r"):GetInt(),
                            ["g"] = GetConVar("tm_hud_crosshair_color_g"):GetInt(),
                            ["b"] = GetConVar("tm_hud_crosshair_color_b"):GetInt(),
                            ["outline_r"] = GetConVar("tm_hud_crosshair_outline_color_r"):GetInt(),
                            ["outline_g"] = GetConVar("tm_hud_crosshair_outline_color_g"):GetInt(),
                            ["outline_b"] = GetConVar("tm_hud_crosshair_outline_color_b"):GetInt(),
                            ["show_t"] = GetConVar("tm_hud_crosshair_show_t"):GetInt(),
                            ["show_b"] = GetConVar("tm_hud_crosshair_show_b"):GetInt(),
                            ["show_l"] = GetConVar("tm_hud_crosshair_show_l"):GetInt(),
                            ["show_r"] = GetConVar("tm_hud_crosshair_show_r"):GetInt()
                        }
                    end

                    CrosshairPreview = vgui.Create("DPanel", DockCrosshair)
                    CrosshairPreview:SetSize(200, 200)
                    CrosshairPreview:SetPos(375, 10)
                    CrosshairPreview:SetMouseInputEnabled(false)
                    CrosshairPreview.Paint = function(self, w, h)
                        UpdateCrosshair()
                        if crosshair["outline"] == 1 then
                            surface.SetDrawColor(Color(crosshair["outline_r"], crosshair["outline_g"], crosshair["outline_b"], crosshair["opacity"]))
                            if crosshair["show_r"] == 1 then surface.DrawRect(w / 2 + crosshair["gap"] - 1, h / 2 - math.floor(crosshair["thickness"] / 2) - 1, crosshair["size"] + 2,  crosshair["thickness"] + 2) end
                            if crosshair["show_l"] == 1 then surface.DrawRect(w / 2 - crosshair["gap"] - crosshair["size"] + crosshair["thickness"] % 2 - 1, h / 2 - math.floor(crosshair["thickness"] / 2) - 1, crosshair["size"] + 2,  crosshair["thickness"] + 2) end
                            if crosshair["show_b"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2) - 1, h / 2 + crosshair["gap"] - 1, crosshair["thickness"] + 2, crosshair["size"] + 2) end
                            if crosshair["show_t"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2) - 1, h / 2 - crosshair["size"] - crosshair["gap"] + crosshair["thickness"] % 2 - 1, crosshair["thickness"] + 2, crosshair["size"] + 2) end
                            if crosshair["dot"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2) - 1, h / 2 - math.floor(crosshair["thickness"] / 2) - 1, crosshair["thickness"] + 2, crosshair["thickness"] + 2) end
                        end
                        surface.SetDrawColor(Color(crosshair["r"], crosshair["g"], crosshair["b"], crosshair["opacity"]))
                        if crosshair["show_r"] == 1 then surface.DrawRect(w / 2 + crosshair["gap"], h / 2 - math.floor(crosshair["thickness"] / 2), crosshair["size"],  crosshair["thickness"]) end
                        if crosshair["show_l"] == 1 then surface.DrawRect(w / 2 - crosshair["gap"] - crosshair["size"] + crosshair["thickness"] % 2, h / 2 - math.floor(crosshair["thickness"] / 2), crosshair["size"],  crosshair["thickness"]) end
                        if crosshair["show_b"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2), h / 2 + crosshair["gap"], crosshair["thickness"], crosshair["size"]) end
                        if crosshair["show_t"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2), h / 2 - crosshair["size"] - crosshair["gap"] + crosshair["thickness"] % 2, crosshair["thickness"], crosshair["size"]) end
                        if crosshair["dot"] == 1 then surface.DrawRect(w / 2 - math.floor(crosshair["thickness"] / 2), h / 2 - math.floor(crosshair["thickness"] / 2), crosshair["thickness"], crosshair["thickness"]) end
                    end

                    DockHitmarker.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("HITMARKERS", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Enable", "SettingsLabel", 55 , 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("3D Hitmarkers", "SettingsLabel", 55 , 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Scale", "SettingsLabel", 155, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Hitmarker Color", "SettingsLabel", 245 , 185, white, TEXT_ALIGN_LEFT)
                    end

                    local hitmarkerToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerToggle:SetPos(20, 70)
                    hitmarkerToggle:SetConVar("cl_tfa_hud_hitmarker_enabled")
                    hitmarkerToggle:SetSize(30, 30)
                    function hitmarkerToggle:OnChange() TriggerSound("click") end

                    local hitmarkerDynamicToggle = DockHitmarker:Add("DCheckBox")
                    hitmarkerDynamicToggle:SetPos(20, 110)
                    hitmarkerDynamicToggle:SetConVar("cl_tfa_hud_hitmarker_3d_all")
                    hitmarkerDynamicToggle:SetSize(30, 30)
                    function hitmarkerDynamicToggle:OnChange() TriggerSound("click") end

                    local hitmarkerScale = DockHitmarker:Add("DNumSlider")
                    hitmarkerScale:SetPos(-85, 150)
                    hitmarkerScale:SetSize(250, 30)
                    hitmarkerScale:SetConVar("cl_tfa_hud_hitmarker_scale")
                    hitmarkerScale:SetMin(0.2)
                    hitmarkerScale:SetMax(2)
                    hitmarkerScale:SetDecimals(1)

                    local hitmarkerMixer = vgui.Create("DColorMixer", DockHitmarker)
                    hitmarkerMixer:SetPos(20, 190)
                    hitmarkerMixer:SetSize(215, 110)
                    hitmarkerMixer:SetConVarR("cl_tfa_hud_hitmarker_color_r")
                    hitmarkerMixer:SetConVarG("cl_tfa_hud_hitmarker_color_g")
                    hitmarkerMixer:SetConVarB("cl_tfa_hud_hitmarker_color_b")
                    hitmarkerMixer:SetConVarA("cl_tfa_hud_hitmarker_color_a")
                    hitmarkerMixer:SetAlphaBar(true)
                    hitmarkerMixer:SetPalette(false)
                    hitmarkerMixer:SetWangs(true)

                    DockPerformance.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, gray)
                        draw.SimpleText("PERFORMANCE", "OptionsHeader", 20, 0, white, TEXT_ALIGN_LEFT)

                        draw.SimpleText("Render Body", "SettingsLabel", 55, 65, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Menu DOF", "SettingsLabel", 55, 105, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("ADS DOF", "SettingsLabel", 55, 145, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Inspection DOF", "SettingsLabel", 55, 185, white, TEXT_ALIGN_LEFT)
                        draw.SimpleText("Screen Flashing Effects", "SettingsLabel", 55, 225, white, TEXT_ALIGN_LEFT)
                    end

                    local renderBody = DockPerformance:Add("DCheckBox")
                    renderBody:SetPos(20, 70)
                    renderBody:SetConVar("cl_ec2_enabled")
                    renderBody:SetSize(30, 30)
                    function renderBody:OnChange() TriggerSound("click") end

                    local menuDOF = DockPerformance:Add("DCheckBox")
                    menuDOF:SetPos(20, 110)
                    menuDOF:SetConVar("tm_menudof")
                    menuDOF:SetSize(30, 30)
                    function menuDOF:OnChange() TriggerSound("click") end

                    local ironSightDOF = DockPerformance:Add("DCheckBox")
                    ironSightDOF:SetPos(20, 150)
                    ironSightDOF:SetConVar("cl_tfa_fx_ads_dof")
                    ironSightDOF:SetSize(30, 30)
                    function ironSightDOF:OnChange() TriggerSound("click") end

                    local inspectionDOF = DockPerformance:Add("DCheckBox")
                    inspectionDOF:SetPos(20, 190)
                    inspectionDOF:SetConVar("cl_tfa_inspection_bokeh")
                    inspectionDOF:SetSize(30, 30)
                    function inspectionDOF:OnChange() TriggerSound("click") end

                    local screenFlashing = DockPerformance:Add("DCheckBox")
                    screenFlashing:SetPos(20, 230)
                    screenFlashing:SetConVar("tm_screenflashes")
                    screenFlashing:SetSize(30, 30)
                    function screenFlashing:OnChange() TriggerSound("click") end

                    local WipeAccountButton = vgui.Create("DButton", DockPerformance)
                    WipeAccountButton:SetPos(17.5, 310)
                    WipeAccountButton:SetText("")
                    WipeAccountButton:SetSize(500, 40)
                    local textAnim = 0
                    local wipeConfirm = 0
                    WipeAccountButton.Paint = function()
                        if WipeAccountButton:IsHovered() then
                            textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                        else
                            textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                        end
                        if (wipeConfirm == 0) then
                            draw.DrawText("WIPE PLAYER ACCOUNT", "SettingsLabel", 5 + textAnim, 5, white, TEXT_ALIGN_LEFT)
                        else
                            draw.DrawText("ARE YOU SURE?", "SettingsLabel", 5 + textAnim, 5, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                        end
                    end
                    WipeAccountButton.DoClick = function()
                        TriggerSound("click")
                        if (wipeConfirm == 0) then
                            wipeConfirm = 1
                        else
                            RunConsoleCommand("tm_wipeplayeraccount_cannotbeundone")
                            wipeConfirm = 0
                        end

                        timer.Simple(1, function() wipeConfirm = 0 end)
                    end
                end
            end

            OptionsHUDButton.DoClick = function()
                MainPanel:Hide()
                TriggerSound("click")

                local ShowHiddenOptions = false
                local modePool = {"FFA", "Cranked", "Gun Game", "KOTH", "VIP"}

                local mode = "FFA"
                local modeTime = "45"
                local modeTimeText = "0:45"
                local ggGuns = ggLadderSize
                local health = 100
                local ammo = 30
                local velocity = 350
                local wep = "KRISS Vector"
                local fakeFeedArray = {}
                local grappleMat = Material("icons/grapplehudicon.png")
                local nadeMat = Material("icons/grenadehudicon.png")
                local hillEmptyMat = Material("icons/kothempty.png")
                local border = Material("overlay/objborder.png")
                local timeText = " ∞"
                local convars = {}
                timer.Create("previewLoop", 1, 0, function()
                    mode = modePool[math.random(#modePool)]
                    modeTime = math.random(1, 45)
                    modeTimeText = "0:" .. modeTime
                    ggGuns = math.random(1, ggLadderSize)
                    health = math.random(1, 100)
                    ammo = math.random(1, 30)
                    velocity = math.random(0, 400)
                end)

                local FakeHUD = MainMenu:Add("HUDEditorPanel")
                MainMenu:SetMouseInputEnabled(false)
                FakeHUD.Paint = function(self, w, h)
                    convars = {
                        ["text_r"] = GetConVar("tm_hud_text_color_r"):GetInt(),
                        ["text_g"] = GetConVar("tm_hud_text_color_g"):GetInt(),
                        ["text_b"] = GetConVar("tm_hud_text_color_b"):GetInt()
                    }
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                    if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
                        draw.SimpleText(wep, "HUD_GunPrintName", scrW - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 20 - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                        if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(health .. " kills", "HUD_StreakText", scrW + 2 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 155 - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
                        draw.SimpleText(ammo, "HUD_AmmoCount", scrW + 2 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 100 - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    elseif GetConVar("tm_hud_ammo_style"):GetInt() == 1 then
                        draw.SimpleText(wep, "HUD_GunPrintName", scrW + 2 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 35 - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
                        if GetConVar("tm_hud_killtracker"):GetInt() == 1 then draw.SimpleText(health .. " kills", "HUD_StreakText", scrW + 2 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 85 - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM) end
                        surface.SetDrawColor(GetConVar("tm_hud_ammo_bar_color_r"):GetInt() - 205, GetConVar("tm_hud_ammo_bar_color_g"):GetInt() - 205, GetConVar("tm_hud_ammo_bar_color_b"):GetInt() - 205, 80)
                        surface.DrawRect(scrW - 400 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 30 - GetConVar("tm_hud_bounds_y"):GetInt(), 400, 30)
                        surface.SetDrawColor(GetConVar("tm_hud_ammo_bar_color_r"):GetInt(), GetConVar("tm_hud_ammo_bar_color_g"):GetInt(), GetConVar("tm_hud_ammo_bar_color_b"):GetInt(), 175)
                        surface.DrawRect(scrW - 400 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 30 - GetConVar("tm_hud_bounds_y"):GetInt(), 400 * (ammo / 30), 30)
                        draw.SimpleText(ammo, "HUD_Health", scrW - 390 - GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 15 - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    surface.SetDrawColor(50, 50, 50, 80)
                    surface.DrawRect(GetConVar("tm_hud_health_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 30 - GetConVar("tm_hud_health_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), GetConVar("tm_hud_health_size"):GetInt(), 30)
                    if health <= 66 then
                        if health <= 33 then
                            surface.SetDrawColor(GetConVar("tm_hud_health_color_low_r"):GetInt(), GetConVar("tm_hud_health_color_low_g"):GetInt(), GetConVar("tm_hud_health_color_low_b"):GetInt(), 120)
                        else
                            surface.SetDrawColor(GetConVar("tm_hud_health_color_mid_r"):GetInt(), GetConVar("tm_hud_health_color_mid_g"):GetInt(), GetConVar("tm_hud_health_color_mid_b"):GetInt(), 120)
                        end
                    else
                        surface.SetDrawColor(GetConVar("tm_hud_health_color_high_r"):GetInt(), GetConVar("tm_hud_health_color_high_g"):GetInt(), GetConVar("tm_hud_health_color_high_b"):GetInt(), 120)
                    end
                    surface.DrawRect(GetConVar("tm_hud_health_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 30 - GetConVar("tm_hud_health_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), GetConVar("tm_hud_health_size"):GetInt() * (health / 100), 30)
                    draw.SimpleText(health, "HUD_Health", GetConVar("tm_hud_health_size"):GetInt() + GetConVar("tm_hud_health_offset_x"):GetInt() - 10 + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 15 - GetConVar("tm_hud_health_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    local feedStyle
                    if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then
                        feedStyle = -20
                    else
                        feedStyle = 20
                    end
                    for k, v in pairs(fakeFeedArray) do
                        if v[2] == 1 and v[2] != nil then surface.SetDrawColor(150, 50, 50, GetConVar("tm_hud_killfeed_opacity"):GetInt()) else surface.SetDrawColor(50, 50, 50, GetConVar("tm_hud_killfeed_opacity"):GetInt()) end
                        local nameLength = select(1, surface.GetTextSize(v[1]))

                        surface.DrawRect(GetConVar("tm_hud_killfeed_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 20 + ((k - 1) * feedStyle) - GetConVar("tm_hud_killfeed_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), nameLength + 5, 20)
                        draw.SimpleText(v[1], "HUD_StreakText", 2.5 + GetConVar("tm_hud_killfeed_offset_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 10 + ((k - 1) * feedStyle) - GetConVar("tm_hud_killfeed_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                    end
                    surface.SetMaterial(grappleMat)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(GetConVar("tm_hud_equipment_offset_x"):GetInt() - 45 + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 40 - GetConVar("tm_hud_equipment_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), 35, 40)
                    draw.SimpleText("[" .. input.GetKeyName(GetConVar("frest_bindg"):GetInt()) .. "]", "HUD_StreakText", GetConVar("tm_hud_equipment_offset_x"):GetInt() - 27.5 + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 42.5 - GetConVar("tm_hud_equipment_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    surface.SetMaterial(nadeMat)
                    surface.SetDrawColor(255,255,255,255)
                    surface.DrawTexturedRect(GetConVar("tm_hud_equipment_offset_x"):GetInt() + 10 + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 40 - GetConVar("tm_hud_equipment_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt(), 35, 40)
                    draw.SimpleText("[" .. input.GetKeyName(GetConVar("tm_nadebind"):GetInt()) .. "]", "HUD_StreakText", GetConVar("tm_hud_equipment_offset_x"):GetInt() + 27.5 + GetConVar("tm_hud_bounds_x"):GetInt(), scrH - 42.5 - GetConVar("tm_hud_equipment_offset_y"):GetInt() - GetConVar("tm_hud_bounds_y"):GetInt() , Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then
                        local keyX = GetConVar("tm_hud_keypressoverlay_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt()
                        local keyY = GetConVar("tm_hud_keypressoverlay_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt()
                        local actuatedColor = Color(GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt(), GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt(), GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt())
                        local inactiveColor = Color(GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt(), GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt(), GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt())
                        local keyMat = Material("icons/keyicon.png")
                        local keyMatMed = Material("icons/keyiconmedium.png")
                        local keyMatLong = Material("icons/keyiconlong.png")
                        surface.SetMaterial(keyMat)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(48 + keyX, 0 + keyY, 42, 42)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(0 + keyX, 48 + keyY, 42, 42)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(48 + keyX, 48 + keyY, 42, 42)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(96 + keyX, 48 + keyY, 42, 42)
                        surface.SetMaterial(keyMatLong)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(0 + keyX, 96 + keyY, 138, 42)
                        surface.SetMaterial(keyMatMed)
                        surface.SetDrawColor(inactiveColor)
                        surface.DrawTexturedRect(0 + keyX, 144 + keyY, 66, 42)
                        surface.SetDrawColor(actuatedColor)
                        surface.DrawTexturedRect(72 + keyX, 144 + keyY, 66, 42)
                        draw.SimpleText("W", "HUD_StreakText", 69 + keyX, 21 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("A", "HUD_StreakText", 21 + keyX, 69 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("S", "HUD_StreakText", 69 + keyX, 69 + keyY, inactiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("D", "HUD_StreakText", 117 + keyX, 69 + keyY, inactiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("JUMP", "HUD_StreakText", 69 + keyX, 117 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("RUN", "HUD_StreakText", 33 + keyX, 165 + keyY, inactiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        draw.SimpleText("DUCK", "HUD_StreakText", 105 + keyX, 165 + keyY, actuatedColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    end
                    if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then
                        draw.SimpleText(velocity .. " u/s", "HUD_Health", GetConVar("tm_hud_velocitycounter_x"):GetInt() + GetConVar("tm_hud_bounds_x"):GetInt(), GetConVar("tm_hud_velocitycounter_y"):GetInt() + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
                    end
                    timeText = string.FormattedTime(math.Round(GetGlobal2Int("tm_matchtime", 0) - CurTime()), "%2i:%02i")
                    draw.SimpleText(mode .. " |" .. timeText, "HUD_Health", scrW / 2, -5 + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

                    if mode == "Gun Game" then
                        draw.SimpleText(ggGuns  .. " kills left", "HUD_Health", scrW / 2, 25 + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    elseif mode == "Fiesta" then
                        draw.SimpleText(modeTimeText, "HUD_Health", scrW / 2, 25 + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    elseif mode == "Cranked" then
                        draw.SimpleText(modeTime, "HUD_Health", scrW / 2, 25 + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(50, 50, 50, 80)
                        surface.DrawRect(scrW / 2 - 75, 60 + GetConVar("tm_hud_bounds_y"):GetInt(), 150, 10)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_contested_r"):GetInt(), GetConVar("tm_hud_obj_color_contested_g"):GetInt(), GetConVar("tm_hud_obj_color_contested_b"):GetInt(), 80)
                        surface.DrawRect(scrW / 2 - 75, 60 + GetConVar("tm_hud_bounds_y"):GetInt(), 150 * (modeTime / 45), 10)
                    elseif mode == "KOTH" then
                        draw.SimpleText("Contested", "HUD_Health", scrW / 2, 25 + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_contested_r"):GetInt(), GetConVar("tm_hud_obj_color_contested_g"):GetInt(), GetConVar("tm_hud_obj_color_contested_b"):GetInt(), 100)
                        surface.SetMaterial(hillEmptyMat)
                        surface.DrawTexturedRect(scrW / 2 - 21, 60 + GetConVar("tm_hud_bounds_y"):GetInt(), 42, 42)
                        surface.SetMaterial(border)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_contested_r"):GetInt(), GetConVar("tm_hud_obj_color_contested_g"):GetInt(), GetConVar("tm_hud_obj_color_contested_b"):GetInt(), 175)
                        surface.DrawTexturedRect(0, 0, scrW, scrH)
                    elseif mode == "VIP" then
                        draw.SimpleText(LocalPly:GetName(), "HUD_Health", scrW / 2, 25 + GetConVar("tm_hud_bounds_y"):GetInt(), Color(convars["text_r"], convars["text_g"], convars["text_b"]), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_occupied_r"):GetInt(), GetConVar("tm_hud_obj_color_occupied_g"):GetInt(), GetConVar("tm_hud_obj_color_occupied_b"):GetInt(), 225)
                        surface.SetMaterial(hillEmptyMat)
                        surface.DrawTexturedRect(scrW / 2 - 24, 57 + GetConVar("tm_hud_bounds_y"):GetInt(), 48, 48)
                        surface.SetMaterial(border)
                        surface.SetDrawColor(GetConVar("tm_hud_obj_color_occupied_r"):GetInt(), GetConVar("tm_hud_obj_color_occupied_g"):GetInt(), GetConVar("tm_hud_obj_color_occupied_b"):GetInt(), 175)
                        surface.DrawTexturedRect(0, 0, scrW, scrH)
                    end
                end

                local EditorPanel = vgui.Create("DFrame", FakeHUD)
                EditorPanel:SetSize(435, scrH * 0.7)
                EditorPanel:MakePopup()
                EditorPanel:SetTitle("HUD Editor")
                EditorPanel:Center()
                EditorPanel:SetScreenLock(true)
                EditorPanel:GetBackgroundBlur(false)
                EditorPanel.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 0))
                end
                EditorPanel.OnClose = function()
                    TriggerSound("back")
                    MainMenu:SetMouseInputEnabled(true)
                    FakeHUD:Hide()
                    MainPanel:Show()
                    timer.Remove("previewLoop")
                    hook.Remove("Tick", "KeyOverlayTracking")
                    UpdateHUD()
                end

                local EditorScroller = vgui.Create("DScrollPanel", EditorPanel)
                EditorScroller:Dock(FILL)

                local sbar = EditorScroller:GetVBar()
                function sbar:Paint(w, h)
                    draw.RoundedBox(5, 0, 0, w, h, lightGray)
                end
                function sbar.btnUp:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, lightGray)
                end
                function sbar.btnDown:Paint(w, h)
                    draw.RoundedBox(0, 0, 0, w, h, lightGray)
                end
                function sbar.btnGrip:Paint(w, h)
                    draw.RoundedBox(15, 0, 0, w, h, Color(155, 155, 155, 155))
                end

                local HiddenOptionsScroller = vgui.Create("DPanel", EditorPanel)
                HiddenOptionsScroller:Dock(FILL)

                HiddenOptionsScroller.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 5))
                end

                local GeneralEditor = vgui.Create("DPanel", EditorScroller)
                GeneralEditor:Dock(TOP)
                GeneralEditor:SetSize(0, 250)
                GeneralEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("GENERAL", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD Font", "Health", 125, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD X Bounds", "Health", 150, 90, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("HUD Y Bounds", "Health", 150, 130, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Text Color", "Health", 210, 165, white, TEXT_ALIGN_LEFT)
                end

                local HUDFont = GeneralEditor:Add("DComboBox")
                HUDFont:SetPos(20, 50)
                HUDFont:SetSize(100, 30)
                HUDFont:SetValue(GetConVar("tm_hud_font"):GetString())
                HUDFont:AddChoice("Arial")
                HUDFont:AddChoice("Comic Sans MS")
                HUDFont:AddChoice("Tahoma")
                HUDFont:AddChoice("Roboto")
                HUDFont:AddChoice("Impact")
                HUDFont:AddChoice("Times New Roman")
                HUDFont:AddChoice("Trebuchet MS")
                HUDFont:AddChoice("VCR OSD Mono")
                HUDFont:AddChoice("Bender")
                HUDFont:AddChoice("Gravity")
                HUDFont.OnSelect = function(self, index, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_font", value)
                    TriggerSound("forward")
                end

                local CustomFontInput = GeneralEditor:Add("DTextEntry")
                CustomFontInput:SetPlaceholderText("Enter a custom font...")
                CustomFontInput:SetPos(275, 50)
                CustomFontInput:SetSize(125, 30)
                CustomFontInput.OnEnter = function(self)
                    RunConsoleCommand("tm_hud_font", self:GetValue())
                    HUDFont:SetValue(self:GetValue())
                    TriggerSound("forward")
                end

                local HUDXBounds = GeneralEditor:Add("DNumSlider")
                HUDXBounds:SetPos(-85, 90)
                HUDXBounds:SetSize(250, 30)
                HUDXBounds:SetConVar("tm_hud_bounds_x")
                HUDXBounds:SetMin(0)
                HUDXBounds:SetMax(scrW / 4)
                HUDXBounds:SetDecimals(0)

                local HUDYBounds = GeneralEditor:Add("DNumSlider")
                HUDYBounds:SetPos(-85, 130)
                HUDYBounds:SetSize(250, 30)
                HUDYBounds:SetConVar("tm_hud_bounds_y")
                HUDYBounds:SetMin(0)
                HUDYBounds:SetMax(scrH / 4)
                HUDYBounds:SetDecimals(0)

                local WepTextColor = vgui.Create("DColorMixer", GeneralEditor)
                WepTextColor:SetPos(20, 170)
                WepTextColor:SetSize(185, 70)
                WepTextColor:SetConVarR("tm_hud_text_color_r")
                WepTextColor:SetConVarG("tm_hud_text_color_g")
                WepTextColor:SetConVarB("tm_hud_text_color_b")
                WepTextColor:SetAlphaBar(false)
                WepTextColor:SetPalette(false)
                WepTextColor:SetWangs(true)

                local AmmoEditor = vgui.Create("DPanel", EditorScroller)
                AmmoEditor:Dock(TOP)
                AmmoEditor:SetSize(0, 170)
                AmmoEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("AMMO", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Style", "Health", 125, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Color", "Health", 210, 85, white, TEXT_ALIGN_LEFT)
                end

                local AmmoStyle = AmmoEditor:Add("DComboBox")
                AmmoStyle:SetPos(20, 50)
                AmmoStyle:SetSize(100, 30)
                if GetConVar("tm_hud_ammo_style"):GetInt() == 0 then
                    AmmoStyle:SetValue("Numeric")
                elseif GetConVar("tm_hud_ammo_style"):GetInt() == 1 then
                    AmmoStyle:SetValue("Bar")
                end
                AmmoStyle:AddChoice("Numeric")
                AmmoStyle:AddChoice("Bar")
                AmmoStyle.OnSelect = function(self, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_ammo_style", value - 1)
                    TriggerSound("forward")
                end

                local AmmoBarColor = vgui.Create("DColorMixer", AmmoEditor)
                AmmoBarColor:SetPos(20, 90)
                AmmoBarColor:SetSize(185, 70)
                AmmoBarColor:SetConVarR("tm_hud_ammo_bar_color_r")
                AmmoBarColor:SetConVarG("tm_hud_ammo_bar_color_g")
                AmmoBarColor:SetConVarB("tm_hud_ammo_bar_color_b")
                AmmoBarColor:SetAlphaBar(false)
                AmmoBarColor:SetPalette(false)
                AmmoBarColor:SetWangs(true)

                local HealthEditor = vgui.Create("DPanel", EditorScroller)
                HealthEditor:Dock(TOP)
                HealthEditor:SetSize(0, 390)
                HealthEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("HEALTH", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Size", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar X Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Bar Y Offset", "Health", 150, 110, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("High HP Color", "Health", 210, 145, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Mid HP Color", "Health", 210, 225, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Low HP Color", "Health", 210, 305, white, TEXT_ALIGN_LEFT)
                end

                local HealthBarSize = HealthEditor:Add("DNumSlider")
                HealthBarSize:SetPos(-85, 50)
                HealthBarSize:SetSize(250, 30)
                HealthBarSize:SetConVar("tm_hud_health_size")
                HealthBarSize:SetMin(100)
                HealthBarSize:SetMax(1000)
                HealthBarSize:SetDecimals(0)

                local HealthBarX = HealthEditor:Add("DNumSlider")
                HealthBarX:SetPos(-85, 80)
                HealthBarX:SetSize(250, 30)
                HealthBarX:SetConVar("tm_hud_health_offset_x")
                HealthBarX:SetMin(0)
                HealthBarX:SetMax(scrW)
                HealthBarX:SetDecimals(0)

                local HealthBarY = HealthEditor:Add("DNumSlider")
                HealthBarY:SetPos(-85, 110)
                HealthBarY:SetSize(250, 30)
                HealthBarY:SetConVar("tm_hud_health_offset_y")
                HealthBarY:SetMin(0)
                HealthBarY:SetMax(scrH)
                HealthBarY:SetDecimals(0)

                local HealthHighColor = vgui.Create("DColorMixer", HealthEditor)
                HealthHighColor:SetPos(20, 150)
                HealthHighColor:SetSize(185, 70)
                HealthHighColor:SetConVarR("tm_hud_health_color_high_r")
                HealthHighColor:SetConVarG("tm_hud_health_color_high_g")
                HealthHighColor:SetConVarB("tm_hud_health_color_high_b")
                HealthHighColor:SetAlphaBar(false)
                HealthHighColor:SetPalette(false)
                HealthHighColor:SetWangs(true)

                local HealthMidColor = vgui.Create("DColorMixer", HealthEditor)
                HealthMidColor:SetPos(20, 230)
                HealthMidColor:SetSize(185, 70)
                HealthMidColor:SetConVarR("tm_hud_health_color_mid_r")
                HealthMidColor:SetConVarG("tm_hud_health_color_mid_g")
                HealthMidColor:SetConVarB("tm_hud_health_color_mid_b")
                HealthMidColor:SetAlphaBar(false)
                HealthMidColor:SetPalette(false)
                HealthMidColor:SetWangs(true)

                local HealthLowColor = vgui.Create("DColorMixer", HealthEditor)
                HealthLowColor:SetPos(20, 310)
                HealthLowColor:SetSize(185, 70)
                HealthLowColor:SetConVarR("tm_hud_health_color_low_r")
                HealthLowColor:SetConVarG("tm_hud_health_color_low_g")
                HealthLowColor:SetConVarB("tm_hud_health_color_low_b")
                HealthLowColor:SetAlphaBar(false)
                HealthLowColor:SetPalette(false)
                HealthLowColor:SetWangs(true)

                local EquipmentEditor = vgui.Create("DPanel", EditorScroller)
                EquipmentEditor:Dock(TOP)
                EquipmentEditor:SetSize(0, 150)
                EquipmentEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("EQUIPMENT UI", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment Anchoring", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment X Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Equipment Y Offset", "Health", 150, 110, white, TEXT_ALIGN_LEFT)
                end

                local EquipmentAnchor = EquipmentEditor:Add("DComboBox")
                EquipmentAnchor:SetPos(20, 50)
                EquipmentAnchor:SetSize(100, 30)
                if GetConVar("tm_hud_equipment_anchor"):GetInt() == 0 then
                    EquipmentAnchor:SetValue("Left")
                elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 1 then
                    EquipmentAnchor:SetValue("Center")
                elseif GetConVar("tm_hud_equipment_anchor"):GetInt() == 2 then
                    EquipmentAnchor:SetValue("Right")
                end
                EquipmentAnchor:AddChoice("Left")
                EquipmentAnchor:AddChoice("Center")
                EquipmentAnchor:AddChoice("Right")
                EquipmentAnchor.OnSelect = function(self, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_equipment_anchor", value - 1)
                    TriggerSound("forward")
                end

                local EquipmentX = EquipmentEditor:Add("DNumSlider")
                EquipmentX:SetPos(-85, 80)
                EquipmentX:SetSize(250, 30)
                EquipmentX:SetConVar("tm_hud_equipment_offset_x")
                EquipmentX:SetMin(0)
                EquipmentX:SetMax(scrW)
                EquipmentX:SetDecimals(0)

                local EquipmentY = EquipmentEditor:Add("DNumSlider")
                EquipmentY:SetPos(-85, 110)
                EquipmentY:SetSize(250, 30)
                EquipmentY:SetConVar("tm_hud_equipment_offset_y")
                EquipmentY:SetMin(0)
                EquipmentY:SetMax(scrH)
                EquipmentY:SetDecimals(0)

                local KillFeedEditor = vgui.Create("DPanel", EditorScroller)
                KillFeedEditor:Dock(TOP)
                KillFeedEditor:SetSize(0, 245)
                KillFeedEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KILL FEED", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Enable Kill Feed", "Health", 55, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Entry Style", "Health", 125, 85, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Item Limit", "Health", 150, 115, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed X Offset", "Health", 150, 145, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Y Offset", "Health", 150, 175, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Feed Opacity", "Health", 150, 205, white, TEXT_ALIGN_LEFT)
                end

                local AddFeedEntryButton = vgui.Create("DButton", KillFeedEditor)
                AddFeedEntryButton:SetPos(190, 17.5)
                AddFeedEntryButton:SetText("")
                AddFeedEntryButton:SetSize(145, 40)
                local textAnim = 0
                AddFeedEntryButton.Paint = function()
                    if AddFeedEntryButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Add Feed Entry", "StreakText", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                AddFeedEntryButton.DoClick = function()
                    if GetConVar("tm_hud_enablekillfeed"):GetInt() == 0 then return end
                    local playersInAction = LocalPly:Name() .. " killed " .. math.random(1, 1000)
                    local victimLastHitIn = math.random(0, 1)

                    table.insert(fakeFeedArray, {playersInAction, victimLastHitIn})
                    if table.Count(fakeFeedArray) >= (GetConVar("tm_hud_killfeed_limit"):GetInt() + 1) then table.remove(fakeFeedArray, 1) end
                end

                local EnableKillFeed = KillFeedEditor:Add("DCheckBox")
                EnableKillFeed:SetPos(20, 50)
                EnableKillFeed:SetConVar("tm_hud_enablekillfeed")
                EnableKillFeed:SetSize(30, 30)
                function EnableKillFeed:OnChange() TriggerSound("click") end

                local KillFeedStyle = KillFeedEditor:Add("DComboBox")
                KillFeedStyle:SetPos(20, 85)
                KillFeedStyle:SetSize(100, 30)
                if GetConVar("tm_hud_killfeed_style"):GetInt() == 0 then
                    KillFeedStyle:SetValue("Ascending")
                elseif GetConVar("tm_hud_killfeed_style"):GetInt() == 1 then
                    KillFeedStyle:SetValue("Descending")
                end
                KillFeedStyle:AddChoice("Ascending")
                KillFeedStyle:AddChoice("Descending")
                KillFeedStyle.OnSelect = function(self, value)
                    surface.PlaySound("tmui/buttonrollover.wav")
                    RunConsoleCommand("tm_hud_killfeed_style", value - 1)
                    TriggerSound("forward")
                end

                local KillFeedItemLimit = KillFeedEditor:Add("DNumSlider")
                KillFeedItemLimit:SetPos(-85, 115)
                KillFeedItemLimit:SetSize(250, 30)
                KillFeedItemLimit:SetConVar("tm_hud_killfeed_limit")
                KillFeedItemLimit:SetMin(1)
                KillFeedItemLimit:SetMax(10)
                KillFeedItemLimit:SetDecimals(0)

                local KillFeedX = KillFeedEditor:Add("DNumSlider")
                KillFeedX:SetPos(-85, 145)
                KillFeedX:SetSize(250, 30)
                KillFeedX:SetConVar("tm_hud_killfeed_offset_x")
                KillFeedX:SetMin(0)
                KillFeedX:SetMax(scrW)
                KillFeedX:SetDecimals(0)

                local KillFeedY = KillFeedEditor:Add("DNumSlider")
                KillFeedY:SetPos(-85, 175)
                KillFeedY:SetSize(250, 30)
                KillFeedY:SetConVar("tm_hud_killfeed_offset_y")
                KillFeedY:SetMin(0)
                KillFeedY:SetMax(scrH)
                KillFeedY:SetDecimals(0)

                local KillFeedOpacity = KillFeedEditor:Add("DNumSlider")
                KillFeedOpacity:SetPos(-85, 205)
                KillFeedOpacity:SetSize(250, 30)
                KillFeedOpacity:SetConVar("tm_hud_killfeed_opacity")
                KillFeedOpacity:SetMin(0)
                KillFeedOpacity:SetMax(255)
                KillFeedOpacity:SetDecimals(0)

                local KillDeathEditor
                KillDeathEditor = vgui.Create("DPanel", EditorScroller)
                KillDeathEditor:Dock(TOP)
                KillDeathEditor:SetSize(0, 200)
                KillDeathEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KILL/DEATH UI", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("UI X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("UI Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Kill Icon Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                end

                local KillDeathX = KillDeathEditor:Add("DNumSlider")
                KillDeathX:SetPos(-85, 50)
                KillDeathX:SetSize(250, 30)
                KillDeathX:SetConVar("tm_hud_killdeath_offset_x")
                KillDeathX:SetMin(scrW / -2)
                KillDeathX:SetMax(scrW / 2)
                KillDeathX:SetDecimals(0)

                local KillDeathY = KillDeathEditor:Add("DNumSlider")
                KillDeathY:SetPos(-85, 80)
                KillDeathY:SetSize(250, 30)
                KillDeathY:SetConVar("tm_hud_killdeath_offset_y")
                KillDeathY:SetMin(0)
                KillDeathY:SetMax(scrH)
                KillDeathY:SetDecimals(0)

                local KillColor = vgui.Create("DColorMixer", KillDeathEditor)
                KillColor:SetPos(20, 120)
                KillColor:SetSize(185, 70)
                KillColor:SetConVarR("tm_hud_kill_iconcolor_r")
                KillColor:SetConVarG("tm_hud_kill_iconcolor_g")
                KillColor:SetConVarB("tm_hud_kill_iconcolor_b")
                KillColor:SetAlphaBar(false)
                KillColor:SetPalette(false)
                KillColor:SetWangs(true)

                local ObjectiveEditor
                ObjectiveEditor = vgui.Create("DPanel", EditorScroller)
                ObjectiveEditor:Dock(TOP)
                ObjectiveEditor:SetSize(0, 330)
                ObjectiveEditor.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("OBJECTIVE UI", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("OBJ Text Scale", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Empty Color", "Health", 210, 85, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Occupied Color", "Health", 210, 165, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Contested Color", "Health", 210, 245, white, TEXT_ALIGN_LEFT)
                end

                local ObjScale = ObjectiveEditor:Add("DNumSlider")
                ObjScale:SetPos(-85, 50)
                ObjScale:SetSize(250, 30)
                ObjScale:SetConVar("tm_hud_obj_scale")
                ObjScale:SetMin(0.5)
                ObjScale:SetMax(3.0)
                ObjScale:SetDecimals(2)

                local ObjEmptyBrushColor = vgui.Create("DColorMixer", ObjectiveEditor)
                ObjEmptyBrushColor:SetPos(20, 90)
                ObjEmptyBrushColor:SetSize(185, 70)
                ObjEmptyBrushColor:SetConVarR("tm_hud_obj_color_empty_r")
                ObjEmptyBrushColor:SetConVarG("tm_hud_obj_color_empty_g")
                ObjEmptyBrushColor:SetConVarB("tm_hud_obj_color_empty_b")
                ObjEmptyBrushColor:SetAlphaBar(false)
                ObjEmptyBrushColor:SetPalette(false)
                ObjEmptyBrushColor:SetWangs(true)

                local ObjOccupiedBrushColor = vgui.Create("DColorMixer", ObjectiveEditor)
                ObjOccupiedBrushColor:SetPos(20, 170)
                ObjOccupiedBrushColor:SetSize(185, 70)
                ObjOccupiedBrushColor:SetConVarR("tm_hud_obj_color_occupied_r")
                ObjOccupiedBrushColor:SetConVarG("tm_hud_obj_color_occupied_g")
                ObjOccupiedBrushColor:SetConVarB("tm_hud_obj_color_occupied_b")
                ObjOccupiedBrushColor:SetAlphaBar(false)
                ObjOccupiedBrushColor:SetPalette(false)
                ObjOccupiedBrushColor:SetWangs(true)

                local ObjContestedBrushColor = vgui.Create("DColorMixer", ObjectiveEditor)
                ObjContestedBrushColor:SetPos(20, 250)
                ObjContestedBrushColor:SetSize(185, 70)
                ObjContestedBrushColor:SetConVarR("tm_hud_obj_color_contested_r")
                ObjContestedBrushColor:SetConVarG("tm_hud_obj_color_contested_g")
                ObjContestedBrushColor:SetConVarB("tm_hud_obj_color_contested_b")
                ObjContestedBrushColor:SetAlphaBar(false)
                ObjContestedBrushColor:SetPalette(false)
                ObjContestedBrushColor:SetWangs(true)

                local DamageIndicatorOverlay
                if GetConVar("tm_hud_dmgindicator"):GetInt() == 1 then DamageIndicatorOverlay = vgui.Create("DPanel", EditorScroller) else
                    DamageIndicatorOverlay = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end

                DamageIndicatorOverlay:Dock(TOP)
                DamageIndicatorOverlay:SetSize(0, 160)
                DamageIndicatorOverlay.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("DAMAGE INDICATOR", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Indicator Color", "Health", 210, 45, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Indicator Opacity", "Health", 150, 130, white, TEXT_ALIGN_LEFT)
                end
                local IndicatorColor = vgui.Create("DColorMixer", DamageIndicatorOverlay)
                IndicatorColor:SetPos(20, 50)
                IndicatorColor:SetSize(185, 70)
                IndicatorColor:SetConVarR("tm_hud_dmgindicator_color_r")
                IndicatorColor:SetConVarG("tm_hud_dmgindicator_color_g")
                IndicatorColor:SetConVarB("tm_hud_dmgindicator_color_b")
                IndicatorColor:SetAlphaBar(false)
                IndicatorColor:SetPalette(false)
                IndicatorColor:SetWangs(true)

                local IndicatorOpaticy = DamageIndicatorOverlay:Add("DNumSlider")
                IndicatorOpaticy:SetPos(-85, 130)
                IndicatorOpaticy:SetSize(250, 30)
                IndicatorOpaticy:SetConVar("tm_hud_dmgindicator_opacity")
                IndicatorOpaticy:SetMin(0)
                IndicatorOpaticy:SetMax(255)
                IndicatorOpaticy:SetDecimals(0)

                local KeypressOverlay
                if GetConVar("tm_hud_keypressoverlay"):GetInt() == 1 then KeypressOverlay = vgui.Create("DPanel", EditorScroller) else
                    KeypressOverlay = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end

                KeypressOverlay:Dock(TOP)
                KeypressOverlay:SetSize(0, 280)
                KeypressOverlay.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("KEYPRESS OVERLAY", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Overlay X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Overlay Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Unpressed Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Actuated Color", "Health", 210, 195, white, TEXT_ALIGN_LEFT)
                end

                local KeypressOverlayX = KeypressOverlay:Add("DNumSlider")
                KeypressOverlayX:SetPos(-85, 50)
                KeypressOverlayX:SetSize(250, 30)
                KeypressOverlayX:SetConVar("tm_hud_keypressoverlay_x")
                KeypressOverlayX:SetMin(0)
                KeypressOverlayX:SetMax(scrW)
                KeypressOverlayX:SetDecimals(0)

                local KeypressOverlayY = KeypressOverlay:Add("DNumSlider")
                KeypressOverlayY:SetPos(-85, 80)
                KeypressOverlayY:SetSize(250, 30)
                KeypressOverlayY:SetConVar("tm_hud_keypressoverlay_y")
                KeypressOverlayY:SetMin(0)
                KeypressOverlayY:SetMax(scrH)
                KeypressOverlayY:SetDecimals(0)

                local KeypressInactiveColor = vgui.Create("DColorMixer", KeypressOverlay)
                KeypressInactiveColor:SetPos(20, 120)
                KeypressInactiveColor:SetSize(185, 70)
                KeypressInactiveColor:SetConVarR("tm_hud_keypressoverlay_inactive_r")
                KeypressInactiveColor:SetConVarG("tm_hud_keypressoverlay_inactive_g")
                KeypressInactiveColor:SetConVarB("tm_hud_keypressoverlay_inactive_b")
                KeypressInactiveColor:SetAlphaBar(false)
                KeypressInactiveColor:SetPalette(false)
                KeypressInactiveColor:SetWangs(true)

                local KeypressActuatedColor = vgui.Create("DColorMixer", KeypressOverlay)
                KeypressActuatedColor:SetPos(20, 200)
                KeypressActuatedColor:SetSize(185, 70)
                KeypressActuatedColor:SetConVarR("tm_hud_keypressoverlay_actuated_r")
                KeypressActuatedColor:SetConVarG("tm_hud_keypressoverlay_actuated_g")
                KeypressActuatedColor:SetConVarB("tm_hud_keypressoverlay_actuated_b")
                KeypressActuatedColor:SetAlphaBar(false)
                KeypressActuatedColor:SetPalette(false)
                KeypressActuatedColor:SetWangs(true)

                local VelocityCounter
                if GetConVar("tm_hud_velocitycounter"):GetInt() == 1 then VelocityCounter = vgui.Create("DPanel", EditorScroller) else
                    VelocityCounter = vgui.Create("DPanel", HiddenOptionsScroller)
                    ShowHiddenOptions = true
                end

                VelocityCounter:Dock(TOP)
                VelocityCounter:SetSize(0, 110)
                VelocityCounter.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                    draw.SimpleText("VELOCITY COUNTER", "SettingsLabel", 20, 10, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter X Offset", "Health", 150, 50, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Counter Y Offset", "Health", 150, 80, white, TEXT_ALIGN_LEFT)
                    draw.SimpleText("Text Color", "Health", 210, 115, white, TEXT_ALIGN_LEFT)
                end

                local VelocityCounterX = VelocityCounter:Add("DNumSlider")
                VelocityCounterX:SetPos(-85, 50)
                VelocityCounterX:SetSize(250, 30)
                VelocityCounterX:SetConVar("tm_hud_velocitycounter_x")
                VelocityCounterX:SetMin(0)
                VelocityCounterX:SetMax(scrW)
                VelocityCounterX:SetDecimals(0)

                local VelocityCounterY = VelocityCounter:Add("DNumSlider")
                VelocityCounterY:SetPos(-85, 80)
                VelocityCounterY:SetSize(250, 30)
                VelocityCounterY:SetConVar("tm_hud_velocitycounter_y")
                VelocityCounterY:SetMin(0)
                VelocityCounterY:SetMax(scrH)
                VelocityCounterY:SetDecimals(0)

                local HiddenOptionsCollapse = vgui.Create("DCollapsibleCategory", EditorScroller)
                HiddenOptionsCollapse:SetLabel("Show options for disabled HUD elements")
                HiddenOptionsCollapse:Dock(TOP)
                HiddenOptionsCollapse:SetSize(250, 200)
                HiddenOptionsCollapse:SetExpanded(false)
                HiddenOptionsCollapse:SetContents(HiddenOptionsScroller)

                if ShowHiddenOptions == false then HiddenOptionsCollapse:Remove() end

                local EditorButtons = vgui.Create("DPanel", EditorScroller)
                EditorButtons:Dock(TOP)
                EditorButtons:SetSize(0, 290)
                EditorButtons.Paint = function(self, w, h)
                    draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 160))
                end

                local TestKillButton = vgui.Create("DButton", EditorButtons)
                TestKillButton:SetPos(20, 30)
                TestKillButton:SetText("")
                TestKillButton:SetSize(145, 40)
                local textAnim = 0
                TestKillButton.Paint = function()
                    if TestKillButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Kill", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                TestKillButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testkill")
                end

                local TestDeathButton = vgui.Create("DButton", EditorButtons)
                TestDeathButton:SetPos(20, 60)
                TestDeathButton:SetText("")
                TestDeathButton:SetSize(165, 40)
                local textAnim = 0
                TestDeathButton.Paint = function()
                    if TestDeathButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Death", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                TestDeathButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testdeath")
                end

                local TestLevelUpButton = vgui.Create("DButton", EditorButtons)
                TestLevelUpButton:SetPos(20, 90)
                TestLevelUpButton:SetText("")
                TestLevelUpButton:SetSize(200, 40)
                local textAnim = 0
                TestLevelUpButton.Paint = function()
                    if TestLevelUpButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Test Level Up", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                TestLevelUpButton.DoClick = function()
                    RunConsoleCommand("tm_hud_testlevelup")
                end

                local ImportCodeInput = EditorButtons:Add("DTextEntry")
                ImportCodeInput:SetPlaceholderText("Enter a HUD code...")
                ImportCodeInput:SetPos(250, 140)
                ImportCodeInput:SetSize(150, 30)

                local ImportCode = vgui.Create("DButton", EditorButtons)
                ImportCode:SetPos(20, 140)
                ImportCode:SetText("")
                ImportCode:SetSize(225, 40)
                local textAnim = 0
                ImportCode.Paint = function()
                    if ImportCode:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Import HUD Code", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                ImportCode.DoClick = function()
                    RunConsoleCommand("tm_importhudcode_cannotbeundone", ImportCodeInput:GetValue())
                    TriggerSound("forward")
                end

                local function CreateExportedCodeEntry(code)
                    if not IsValid(ExportCodeInput) then
                        ExportCodeInput = EditorButtons:Add("DTextEntry")
                        ExportCodeInput:SetPos(250, 170)
                        ExportCodeInput:SetSize(150, 30)
                        ExportCodeInput.AllowInput = function(self, stringValue) return true end
                        ExportCodeInput:SetValue(code)
                    else
                        ExportCodeInput:SetValue(code)
                    end
                end

                local ExportCode = vgui.Create("DButton", EditorButtons)
                ExportCode:SetPos(20, 170)
                ExportCode:SetText("")
                ExportCode:SetSize(225, 40)
                local textAnim = 0
                ExportCode.Paint = function()
                    if ExportCode:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    draw.DrawText("Export HUD Code", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                end
                ExportCode.DoClick = function()
                    CreateExportedCodeEntry(GetConVar("tm_hud_font"):GetString() .. "-" .. GetConVar("tm_hud_bounds_x"):GetInt() .. "-" .. GetConVar("tm_hud_bounds_y"):GetInt() .. "-" .. GetConVar("tm_hud_text_color_r"):GetInt() .. "-" .. GetConVar("tm_hud_text_color_g"):GetInt() .. "-" .. GetConVar("tm_hud_text_color_b"):GetInt() .. "-" .. GetConVar("tm_hud_ammo_style"):GetInt() .. "-" .. GetConVar("tm_hud_ammo_bar_color_r"):GetInt() .. "-" .. GetConVar("tm_hud_ammo_bar_color_g"):GetInt() .. "-"
                    .. GetConVar("tm_hud_ammo_bar_color_b"):GetInt() .. "-" .. GetConVar("tm_hud_health_size"):GetInt() .. "-" .. GetConVar("tm_hud_health_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_health_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_high_r"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_high_g"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_high_b"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_mid_r"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_mid_g"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_mid_b"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_low_r"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_low_g"):GetInt() .. "-" .. GetConVar("tm_hud_health_color_low_b"):GetInt() .. "-" .. GetConVar("tm_hud_equipment_anchor"):GetInt() .. "-"
                    .. GetConVar("tm_hud_equipment_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_equipment_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_enablekillfeed"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_style"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_limit"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_killfeed_opacity"):GetInt() .. "-" .. GetConVar("tm_hud_killdeath_offset_x"):GetInt() .. "-" .. GetConVar("tm_hud_killdeath_offset_y"):GetInt() .. "-" .. GetConVar("tm_hud_kill_iconcolor_r"):GetInt() .. "-" .. GetConVar("tm_hud_kill_iconcolor_g"):GetInt() .. "-" .. GetConVar("tm_hud_kill_iconcolor_b"):GetInt() .. "-" .. GetConVar("tm_hud_obj_scale"):GetInt() .. "-"
                    .. GetConVar("tm_hud_obj_color_empty_r"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_empty_g"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_empty_b"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_occupied_r"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_occupied_g"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_occupied_b"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_contested_r"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_contested_g"):GetInt() .. "-" .. GetConVar("tm_hud_obj_color_contested_b"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_color_r"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_color_g"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_color_b"):GetInt() .. "-" .. GetConVar("tm_hud_dmgindicator_opacity"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_x"):GetInt() .. "-"
                    .. GetConVar("tm_hud_keypressoverlay_y"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_inactive_r"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_inactive_g"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_inactive_b"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_actuated_r"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_actuated_g"):GetInt() .. "-" .. GetConVar("tm_hud_keypressoverlay_actuated_b"):GetInt() .. "-" .. GetConVar("tm_hud_velocitycounter_x"):GetInt() .. "-" .. GetConVar("tm_hud_velocitycounter_y"):GetInt())
                end

                local ResetToDefaultButton = vgui.Create("DButton", EditorButtons)
                ResetToDefaultButton:SetPos(20, 250)
                ResetToDefaultButton:SetText("")
                ResetToDefaultButton:SetSize(360, 40)
                local textAnim = 0
                local ResetToDefaultConfirm = 0
                ResetToDefaultButton.Paint = function()
                    if ResetToDefaultButton:IsHovered() then
                        textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 25)
                    else
                        textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 25)
                    end
                    if (ResetToDefaultConfirm == 0) then
                        draw.DrawText("Reset HUD To Default Options", "Health", 0 + textAnim, 0, white, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("ARE YOU SURE?", "Health", 0 + textAnim, 0, Color(255, 0, 0), TEXT_ALIGN_LEFT)
                    end
                end
                ResetToDefaultButton.DoClick = function()
                    TriggerSound("click")
                    if (ResetToDefaultConfirm == 0) then
                        ResetToDefaultConfirm = 1
                    else
                        RunConsoleCommand("tm_resethudtodefault_cannotbeundone")
                        UpdateHUD()
                        ResetToDefaultConfirm = 0
                    end

                    timer.Simple(3, function() ResetToDefaultConfirm = 0 end)
                end
            end

            local CreditsButton = vgui.Create("DButton", MainPanel)
            CreditsButton:SetPos(scrW - 110, scrH - 52)
            CreditsButton:SetText("")
            CreditsButton:SetSize(110, 32)
            local textAnim = 20
            CreditsButton.Paint = function()
                CreditsButton:SetPos(scrW - 110, scrH - 52)
                if CreditsButton:IsHovered() then
                    textAnim = math.Clamp(textAnim - 200 * RealFrameTime(), 0, 20)
                else
                    textAnim = math.Clamp(textAnim + 200 * RealFrameTime(), 0, 20)
                end
                draw.DrawText("CREDITS", "StreakText", 85 + textAnim, 5, white, TEXT_ALIGN_RIGHT)
            end
            CreditsButton.DoClick = function()
                TriggerSound("click")
                gui.OpenURL("https://github.com/PikachuPenial/Titanmod#credits")
            end
    end

    if belowMinimumRes == true and LocalPly:GetNWBool("seenResWarning") != true then
        local ResWarning = vgui.Create("DPanel")
        ResWarning:SetPos(0, 0)
        ResWarning:SetSize(scrW, scrH)
        ResWarning:MakePopup()

        local ResWarningLabel = vgui.Create("DLabel", ResWarning)
        ResWarningLabel:SetPos(10, 10)
        ResWarningLabel:SetText("You are playing on a resolution lower than 1024x762!" .. "\n" .. "Any problems that arise from your current resolution will not be addressed." .. "\n" .. "This popup will disappear in 8 seconds.")
        ResWarningLabel:SizeToContents()
        ResWarningLabel:SetDark(1)

        LocalPly:SetNWBool("seenResWarning", true)

        timer.Create("removeResWarning", 8, 1, function()
            ResWarning:Remove()
        end)
    end
end )

PANEL = {}
function PANEL:Init()
    self:SetSize(scrW, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("MainPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(600, scrH)
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("OptionsPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizeSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(475, scrH * 0.6)
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(475, scrH * 0.4)
    self:SetPos(56, scrH * 0.6)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("CustomizePreviewPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LeaderboardSlideoutPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(780, scrH)
    self:SetPos(56, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("LeaderboardPanel", PANEL, "Panel")

PANEL = {}
function PANEL:Init()
    self:SetSize(56, scrH)
    self:SetPos(0, 0)
end

PANEL = {}
function PANEL:Init()
    self:SetSize(scrW, scrH)
    self:SetPos(0, 0)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end
vgui.Register("HUDEditorPanel", PANEL, "Panel")