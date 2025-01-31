# Unreleased Upate
**>GAMEPLAY**   

**>MAPS**   

**>BALANCE**    

**>QOL & BUG FIXES**    
- Overhauled the card cuztomization screen

- Removed motion blur that would be triggered while sliding

- Adjusted various calling card names and descriptions


# November 8th, 2023 (11/8/23)
**>GAMEPLAY**   
- Reverted new custom bullet tracers due to visual bugs, will return in the future

**>QOL & BUG FIXES**    
- Fixed locked mastery cards not showing progress bars

- Adjusted various menu UI objects that wouldn't trigger a UI sound

- Slightly adjusted death and level popup text



# November 4th, 2023 (11/4/23)
**>GAMEPLAY**   
*MOVEMENT ADDITIONS/CHANGES*    
- Added Slide Cancelling (new settings determines which input cancels a slide)
- Sliding speed is now affected by velocity (if the player is moving at a decent speed)
- Canceling a Slide will dynamically impact the Slide cooldown
- Your character will no longer lose velocity at the end of a Slide
- Landing on the ground while inputting a SPRINT and a CROUCH will initiate a Slide immediately upon landing
- Crouch transition speed increased by 20%
- Slide duration increased by 25%
- Removed Jump Sliding (was very powerful, but was only used by a handful of players, giving them a big advantage)

*GUN TRACERS OVERHAUL*  
- Tracers have been completely redesigned and are now gun dependent (a SMG will have a smaller and less visible tracer compared to a Sniper)

*AMMO CONVERSIONS*  
- Added experimental attachment options to the **KRISS Vector** and the **Mac 10** that rework the guns stats

*NEW SETTINGS*  
- Slide Cancel type (Release, Jump, or Sprint)
- Dynamic Crosshair type

**>BALANCE**    
- Removed **Magnum Ammunition** from all weapons (was a free damage upgrade, couldn't tell when it was being used, new players who didn't learn to equip it were at a big disadvantage)
- Removed **Match Ammunition** from all weapons (wasn't very useful, was basically a free recoil reduction)
- All Secondaries (excluding hand cannons/revolvers) now have point fire as an attachment option
- Point Fire no longer requires a laser sight to be attached to a weapon

*FN 2000*   
- Reduced damage to 27 (previously 31)

*M249*  
- Increased spread to 50 (previously 40)

*M3 Grease Gun* 
- Reduced damage to 30 (previously 32)
- Reduced vertical recoil to 20 (previously 32)
- Reduced horizontal recoil to 5 (previously 12)

*PKP*   
- Increased spread to 59 (previously 29)

*PM-9*  
- Gas Port Adjustment now decreases recoil by 50% and increases damage by 10%

*Sten Gun*  
- Increased damage to 32 (previously 30)

*StG 44*    
- Reduced damage to 35 (previously 40)
- Increased vertical recoil to 45 (previously 32)
- Increased horizontal recoil to 20 (previously 12)

*VHS-D2*    
- Reduced vertical recoil to 45 (previously 65)
- Reduced horizontal recoil to 20 (previously 30)

**>QOL & BUG FIXES**    
- Official Servers now run on 60hz again (previously 30hz) (will monitor server performance to see if this runs smoothly)

- All sniper scopes are now set to the same FOV

- Health and Ammo bars now smoothly scale instead of instantly changing size

- Crosshair now fades away while sprinting

- Added progress bars to player models/cards that you do not have unlocked in the customization menu

- Heavy optimization for many movement related functions

- Decreased volume of sliding related sound effects

- The pitch of sliding related sound effects now slightly vary on each slide

- Adjusted visual effect of mantling

- Adjusted default crosshair settings for new players

- Adjusted penetration system to stop bullet after passing 3 objects

- Fixed some secondaries not firing underwater

- Fixed health bar color not correctly updating on a customized player health

- Fixed PKP having spread while aiming down sights

- Fixed PzB 39 ADS sensitivity

- Removed Gun Chambering

- Removed Show Crosshair while aimed down sights setting due to it being powerful when used with point firing



# October 25th, 2023 (10/25/23)
**>QOL & BUG FIXES**    
- Fixed KOTH from, literally not functioning at all

- New end of match quotes from community members



# October 19th, 2023 (10/19/23)
**>GAMEPLAY**   
*CROSSHAIR OVERHAUL*    
- I ditched the TFA crosshair and created my own crosshair system with even more customization options, a preview while editing the settings, and more

*HUD CODES* 
- You can now export your HUD customization settings as a code and can import other codes sent to you in the HUD editor

*NEW SETTING*   
- Render Body toggle

**>QOL & BUG FIXES**    
- All text color based HUD settings were combined into one universal setting

- Added various crosshair settings

- Adjusted animation for the kill notification

- Fixed the first kill feed entry always being inaccurate in size

- Fixed XP Multiplier not affecting XP granted from match end bonuses

- Potential fix for gamemode desync between server and clients

- Various improvements to the look and feel of the UI and menus

- Removed obsolete fonts to improve performance



# October 16th, 2023 (10/16/23)
**>QOL & BUG FIXES**    
- Added Score as a leaderboard category

- Increased strength of the Main Menu background gradient

- Adjusted transparency values across different Main Menu screens

- Leaderboard cooldown is no longer applied until you manually switch categories

- Fixed lua error when exiting the Main Menu after recently switching a Leaderboard category

- Main Menu gradient can now flip coloring randomly



# October 8th, 2023 (10/8/23)
**DISCLAIMER!!!**   
- Default HUD settings now differ GREATLY as of this update, I recommend reverting to default through the HUD Editor, or at the very least, resetting all of your 'offset' settings due to the new HUD edge bound settings.

**>GAMEPLAY**   
*NEW SETTINGS*  
- HUD Edge Bounds X
- HUD Edge Bounds Y
- Damage Indicator toggle
- Damage Indicator color
- Damage indicator opacity

**>MAPS**   
*Legacy*    
- Added additional player spawns
- Fixed missing tree model

**>BALANCE**    
*Beretta Mx4*
- Reduced damage to 27 (previously 28)
- Increased vertical recoil to 35 (previously 30)
*Gun was very powerful, even beyond CQC, this should put it in a healthy spot.*

*Dual Skorpions*
- Increased RPM to 2400 (previously 1800)

*FAMAS*
- Now fires in Full Auto with 1100 RPM
- Reduced damage to 27 (previously 31)
*I get it, you guys aren't fans of a burst fire mode being forced.*

*Glock 18*
- Increased Burst RPM to 1200 (previously 900)
- Renamed to 'Glock 18' (previously 'Glock 17') as the weapon better fits this firearm IRL

*KRISS Vector*
- Recoil has been flipped, requiring you to now pull up to control the weapon

*Mac 10*
- Increased damage to 22 (previously 21)
*The Mac 10 can be seen as being 1:1 with the Uzi, but due to it being much harder to control, this change should make it more diverse.*

*MTs255*
- Increased RPM to 190 (previously 130)

*Stevens 620*
- Increased rechambering speed by 50%
*The Stevens has been seen as the weakest shotgun for quite a while, this should make it much more capable of killing targets.*

*UMP9*
- Reduced vertical recoil to 17 (previously 25)
- Reduced horizontal recoil to 7 (previously 15)
*While the gun was never hard to control, its DPS is still pretty low, this change should help it stand out.*

**>QOL & BUG FIXES**    
- Garry's Mod Pause Menu/Console is now accessible while in the Titanmod Main Menu/EOR Menu

- Added gamemode specific HUD elements to the HUD editor preview

- Added Gravity font as a option in the HUD editor

- Added subtle gradient to the background of the Main Menu

- Increased the speed of hint text fly-by in the Main Menu

- Cranked HUD element now is colored using the OBJ Contested color setting

- Fixed 'User Interface' setting not disabling the HUD when toggled off

- Fixed rounded edges on scoreboard

- Fixed HUD still rendering while in the Main Menu

- Fixed missing textures on Hunk player model

- Fixed potential errors due to KOTH/VIP HUD elements being initialized early

- Optimized HUD, Main Menu, and damage indicators

- Increased responsiveness of KOTH/VIP HUD elements

- Removed Astolfo player model (replaced by Homelander)

- Removed Font Scale setting

- Removed most Menu tooltips

- Removed the PAUSE MENU and LEAVE GAME buttons across the Main Menu/EOR Menu as they are now useless

- New end of match quotes from community members



# September 24th, 2023 (9/24/23)
**>GAMEPLAY**   
*HUD IMPROVMENTS*
- Many HUD elements like the match time, kill feed, and gamemode specific information are now shown while waiting to respawn

**>QOL & BUG FIXES**    
- Potential fix for Engine Error crashes related to model preloading

- Complete icon overhaul across the Menu/UI for more consistency and a cleaner look

- New order for categories in settings

- Renamed many settings to improve naming consistency across said settings

- Improved loading speed across various menu subsections

- Changed the style of locked calling cards in the menu (it doesn't look very good but I plan on revamping the menu)

- Adjusted art on a few calling cards

- Decreased gamemode file size



# September 3rd, 2023 (9/3/23)
**>BALANCE**    
*Webley*
- Increased damage to 80 (previously 75)

**>QOL & BUG FIXES**    
- Removed TCo Stim Pistol from Quickdraw rotation

- Removed XP from objective based score (was too easy to farm lmao)

- Fixed HUD displaying while dead

- Fixed Kill Tracker not displaying

- Fixed various Lua errors

- Explosive Jumping is now possible with grenades (if they don't one shot you lol)

- Optimized various server-related functions

- Removed FPS/Ping counter and related options (most people already have FPS counters through GMOD or external means, this was kinda useless)

- Temporarily removed Level, K/D Ratio, and W/L Ratio leaderboard options due to extreme server lag



# September 2nd, 2023 (9/2/23)
**>GAMEPLAY**   
*NEW WEAPONS*
- **KAC ChainSAW** (Primary, LMG)
- **PKP** (Primary, LMG)

*NEW GAMEMODES*
- **KOTH**, fight for control over a specific part of the map to gain score
- **VIP**, typical FFA but one player is designated as a VIP and gets gains score every second, kill them to take the status for yourself
- **Quickdraw**, typical FFA but with only secondary weapons

*MOVEMENT CHANGES*
- Wall running no longer requires the player to be holding a forward input
- Wall running cooldown was lowered to 1.25s (previously 1.5s)

*QUICK WEAPON SWITCHING*
- A new setting (that is **ON** by default) that allows you to change to your Primary, Secondary, and Melee weapons with keybinds that you can set in Settings

*CUSTOM FOV SYSTEM*
- A new setting (that is **OFF** by default) that allows you to change your FOV beyond the 100 FOV maximum in Garry's Mod, with the max being **125 FOV** with this setting enabled.

*MAP VOTING REWORK*
- Map and mode voting has been rewritten to have more variety and to be more applicable to player counts
- The first map will always be a map suitable for the player count (small map if less than 6 players are playing, large if more than 6)
- The second map can be any map in the game, allowing for small maps to rarely be playable on full lobbies (chaotic but fun)
- Votes are now shown in percentages instead of amount of votes on said map/mode

*MODE VOTING REWORK*
- The first mode will always be a simplistic gamemode (FFA, FFA with loadout variations, etc.)
- The second mode will always be a complicated gamemode (Objective modes, gun game, etc.)

*NEW HITSOUND OPTIONS*
- Apex Legends
- Call Of Duty

*NEW KILLSOUND OPTIONS*
- Apex Legends

**>MAPS**   
*NEW MAPS*
- Shoot House

**>QOL & BUG FIXES**    
- The order of weapons on the weapon selector have been reversed to better represent the new quick switch setting (Primary > Secondary > Melee)

- Gun Game weapon ladder has been increased to 26 weapons (previously 24)

- Increased health regeneration speed by 20%

- Added Mute button to the Post Game UI that disables the voice chat

- Added HUD indicator when transmitting your microphone

- Main Menu has brand new sound and visual effects

- Added Enable Menu Sounds option

- Added various HUD editor options related to the new gamemodes

- Music Volume setting now affects End Of Match music

- New end of match quotes from community members

- Fixed Cranked self destruct not triggering an explosion

- Optimized HUD, gamemode checks, FPS/Ping counter, main menu, voice chat, leaderboards, health regeneration, and ConVar updating

- Removed HL2 suit zoom (was not intended)

- Removed Main Menu music (was disliked by players)

- Removed custom font options for Kill/Death UI, they are now both on by default

- Removed ADS Vignette option

- Removed obsolete gamemode code

- Adjusted various ConVar descriptions

- Players save data can no longer be wiped via the console while not in Main Menu

- Adjusted order of gamemodes when changing the gamemode ConVar



# August 7th, 2023 (8/7/23)
**>QOL & BUG FIXES**    
- Added player cards for levels 185 - 240

- Reduced strength of weapon bobbing while jumping/mid air

- Slightly increased breathing animation while walking and aimed down sights

- Grenades now explode prematurely after taking damage (allows for chain reactions and shooting grenades)

- Fixed Titanmod Content Packs not working properly on gamemodes other than Titanmod



# August 6th, 2023 (8/6/23)
**>GAMEPLAY**   
*WEAPON BOB/SWAY*
- Weapon bob and weapon sway have been completely redesigned to be much more consistent and more grounded

**>MAPS**   
*Disequilibrium*
- Reduced brightness of the sun

*Mall*
- Removed outdoor spawns
- Added additional interior spawns

*Mephitic*
- Removed spawn that was exposed to acid
- Added additional player spawns

**>BALANCE**    
*Crossbow*
- Increased reload speed

*FAMAS*
- Improved burst consistency

*Glock 17*
- Improved burst consistency

*Howa Type 64*
- Increased reload speed

*M1 Garand*
- Increased reload speed

*M1918*
- Increased reload speed

*XM8*
- Reduced damage to 29 (previously 31)
- Increased mobility to 85% (previously 84%)

**>QOL & BUG FIXES**
- Tightened firing animations across multiple weapons

- Player cards for levels 155 - 180

- Removed Spike X1S from Shotty Snipers weapon rotation

- Adjusted some Leveling player cards

- Precacher is now skipped if Developer Mode is on



# August 5th, 2023 (8/5/23)
**>GAMEPLAY**   
*KNOCKBACK ADDITION*
- Sawed Off now has an attachment (Gust) that allows you to shotgun jump (may be added to more shotguns in the future)
- RPG-7 now knocks the player back after shooting, performing a rocket jump also has extra upwards velocity due to this change

*GRENADE CHANGES*
- Grenades now do **significantly** more damage, being able to one shot if a player is close enough to the impact
- The animation for throwing a grenade has been improved

*ANIMATION CHANGES*
- Increased reload speed across many different weapons (mostly on secondaries)
- Reduced bounciness on certain guns when being fired with iron sights (mostly on secondaries)

**>BALANCE**    
*CZ 75*
- Now fires in automatic
- Reduced damage to 30 (previously 31)

*FN 2000*
- Reduced damage to 31 (previously 32)

*MP5*
- Reduced damage to 28 (previously 33)

*MP5K*
- Reduced vertical recoil to 30 (previously 40)

*PM-9*
- Moved weapon to the Secondary weapons category
- Reduced damage to 21 (previously 24)

*Spike X1S*
- Now is classified as a Sniper (previously a Shotgun)
- Added high magnification optics

*Tariq*
- Removed Extended Magazine attachment

**>QOL & BUG FIXES**    
- Adjusted text on the Velocity counter

- Fixed Health Bar coloring not matching the proper color settings

- Added Flechette attachment to every shotgun that did not have it

- Removed Shotgun Ammunition attachments that closely matched already existing attachments



# August 1st, 2023 (8/1/23)
**>QOL & BUG FIXES**    
- Server ConVars for every Config option is now available ("sv_tm" with 30+ changeable options available)

- Removed obsolete Config values



# July 31st, 2023 (7/31/23)
**>QOL & BUG FIXES**    
- Added a visual progress bar that counts down the players Cranked timer

- Players now explode once their Cranked timer ends

- Removed Bow and Crossbow from Gun Game weapon rotation

- Fixed bug with player levels not being calculated on match end



# July 22nd, 2023 (7/22/23)
**>BALANCE**    
- Increased reload speed across all revolver-based weapons

**>QOL & BUG FIXES**    
- On match end, the played gamemode will no longer appear in the next gamemode vote

- HUD functions have been refactored

- Optimized hit and kill sounds

- Reset HUD To Default now resets new HUD element settings

- New end of match quotes from community members



# July 20th, 2023 (7/20/23)
**>GAMEPLAY**   
*ANIMATION CHANGES*
- Deploy animations sped up on all weapons by 200-400%
- Draw/switching animations sped up on all secondaries by 150-250%

*MOVEMENT CHANGES*
- Grapple cooldown reduced to 15 seconds (previously 18)

**>BALANCE**    
*AUG A3*
- Increased mobility to 93% (previously 87%)

*Barrett M98B*
- Increased mobility to 80% (previously 60%)

*FAMAS*
- Increased damage to 31 (previously 28)

*Glock 17*
- Increased mobility to 95% (previously 85%)

*OTs-14 Groza*
- Reduced horizontal recoil to 20 (previously 30)

*PzB 39*
- Gun now has perfect hip fire accuracy
- Drastically increased rechambering speed
- Drastically increased reload speed

**>QOL & BUG FIXES**    
- 7 new Accolade unlock-able player models (1 per accolade)

- Leveling calling cards are now unlocked every 5 levels (previously 10)

- Adjusted unlock requirements for Accolade player models

- Added Velocity Counter setting

- Added Velocity Counter X offset, Y offset, and RGB HUD settings

- Added Compensate Sensitivity w/ FOV setting

- New end of match quotes from community members

- c_hands on CS:S player models have been changed to c_hands of higher fidelity

- Fixed ADS sensitivity scaling on AUG A3, Barrett M98B, M249 and PzB 39

- Optimized HUD

- Replaced some leveling calling cards

- Increased radius of spawn point checks by 128 units

- Adjusted XP requirement curve on player levels 55-60



# July 17th, 2023 (7/17/23)
**>QOL & BUG FIXES**    
- Added Precaching on models, materials, sounds, and particles (slightly longer load times, but far less stuttering)

- Fixed Cranked time on the HUD not resetting properly on death

- Optimized functions related to player spawning/kills/deaths

- Fixed Scoring and match result desync on client when playing the Cranked gamemode

- Fixed S&W 500 Bore Ammunition spawning unloaded



# July 15th, 2023 (7/15/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Cranked is now in Titanmod! Once getting a kill, you will receive a 30% buff to your mobility, but at a cost, if you do not kill another player within 25 seconds, you will die. Getting a kill resets this timer back to 25 seconds.

*WEAPON ADJUSTMENTS*
- Renamed Japanese Ararebo to Mace

**>BALANCE**    
*FN FAL*
- Removed 30 round magazine attachment

*M249*
- Reduced damage to 26 (previously 28)
- Reduced mobility to 70% (previously 80%)

*Mare's Leg*
- Gun now has perfect hip fire accuracy

*Mk 14 EBR*
- Removed 30 round magazine attachment

*Nova*
- Increased damage to 13 (previously 12)

*SCAR-H*
- Reduced horizontal recoil to 33 (previously 60)

*Scorpion Evo*
- Reduced damage to 19 (previously 20)

**>QOL & BUG FIXES**    
- Reduced volume of sliding

- Fixed rare cases where certain guns w/ specific attachments would not come loaded when first equipped

- Adjusted name for the Titanmod dedicated server

- Fixed reload animation on AS-VAL while having the foregrip equipped

- Removed YOU / FOE counter from death UI (reducing clutter)



# July 14th, 2023 (7/14/23)
**>GAMEPLAY**   
*GUNPLAY CHANGES*
- Mechanical and visual recoil has been reduced by 5% across all weapons

*MOVEMENT CHANGES*
- Mantling can now be performed while crouching

**>MAPS**   
*Initial*
- Added additional player spawns
- Adjusted lighting
- Removed fog

*Rig*
- Increased the speed of the elevator by 400%
- Increased map brightness
- Removed fog
- Halved the amount of rain particles
- Improved performance

**>BALANCE**    
*AS-VAL*
- Increased default magazine capacity to 30 (previously 20)
- Reduced horizontal recoil to 15 (previously 18)
- Removed 10 & 40 Round Magazine attachments

*Bow*
- Increased damage to 200 (previously 85)

*Crossbow*
- Increased damage to 200 (previously 105)

*MTs225*
- Increased damage to 12 (previously 11.5)
- Reduced vertical recoil to 75 (previously 125)
- Reduced intensity of visual kick when firing

*P90*
- Reduced horizontal recoil to 20 (previously 30)

*PP-19 Bizon*
- Reduced damage to 28 (previously 29)
- Reduced vertical recoil to 30 (previously 42)

*PPSH*
- Reduced damage to 27 (previously 29)
- Reduced vertical recoil to 18 (previously 42)
- Increased horizontal recoil to 12 (previously 7)

*Sawed Off*
- Increased vertical recoil to 370 (previously 270)
- Reduced intensity of visual kick when firing

*UZK-BR99*
- Reduced vertical recoil to 115 (previously 255)
- Reduced intensity of visual kick when firing

**>QOL & BUG FIXES**    
- Optimized HUD

- Added Credits button on the Main Menu

- Player models are now pre-cached

- Removed weapons from the Gun Game ladder generation that have bugged sounds while playing Gun Game

- Fixed oddities in weapon priority (no longer spawning with melee equipped instead of a weapon) 

- Pause Menu button now properly stops the Menu Music

- Kill Feed Item Limit is now 6 for new players (previously 4)

- Default Menu Music volume is now 66% for new players (previously 100%)

- Fixed console errors when launching Garry's Mod with the gamemode installed



# July 11th, 2023 (7/11/23) (Steam Workshop Release)
**>GAMEPLAY**   
*WEAPON ADJUSTMENTS*
- Renamed MTs225-12 to MTs225
- Renamed PINDAD SS2-V1 to PINDAD SS2
- Renamed PPSH-41 to PPSH
- Renamed SR-2M Veresk to SR-2

**>QOL & BUG FIXES**    
- Max Player Count is now 12 on official dedicated servers

- 14 new Accolade unlockable calling cards (2 per accolade)

- Adjusted unlock requirements for Accolade calling cards

- Reordered the categories in the calling card menu

- Renamed some calling cards

- Horizontally flipped some calling cards for better visibility when equipped

- Added button SFX to randomize card/model buttons

- Updated Workshop ID/Links



# July 1st, 2023 (7/1/23)
**>GAMEPLAY**   
*GUNPLAY CHANGES*
- Hip fire spread has been reduced globally by 20%
- Standardized knife damage profiles (read **BALANCE** for more details)

*MOVEMENT CHANGES*
- Sliding now has a cooldown of 0.9 seconds, said player not being grounded will remove this cooldown, allowing for consecutive jump slides
- Reduced crouch enter/exit time by 7.5%

*LEADERBOARD ADJUSTMENT*
- Added all Accolades as selectable options
- Visual overhaul of the Leaderboard menu

**>MAPS**   
*NEW MAPS*
- Legacy
- Oxide

*REMOVED MAPS*
- Devtown

**>BALANCE**    
*Colt 9mm*
- Reduced vertical recoil to 20 (previously 35)
- Reduced horizontal recoil to 8 (previously 16)

*Glock 17*
- Reduced spread to 6 (previously 15)

*SCAR-H*
- Reduced damage to 45 (previously 52)

*KM-2000 & Tanto*
- Both knifes now have the same stats, and have both seen a buff to their damage (66 primary, 125 secondary)

**>QOL & BUG FIXES**    
- A player will now always spawn with their primary equipped

- A player will now always spawn with their sniper equipped when playing the Shotty Snipers gamemode

- Canceling a Grappling Hook shot now resets your cooldown

- Playermodel and Playercard menus have been improved visually

- Improved visual for scroll bars

- Reduced intensity of sliding blur when Motion Blur is enabled

- Fixed End Of Game stage breaking if a player leaves the match before the voting phase begins

- Actually fixed players steam names not being correctly set in the save database, resulting in player names being NULL on the Leaderboard

- NULL names on Leaderboards are now shown as the players SteamID

- Decreased Depth Of Field strength on scoreboard

- Fixed various bugs with Grappling Hook



# June 24st, 2023 (6/24/23)
**>GAMEPLAY**   
*MOVEMENT*
- A missed grapple shot will no longer trigger a grappling hook cooldown

**>MAPS**   
*NEW MAPS*
- Wreck

*REMOVED MAPS*
- Hydro

**>BALANCE**    
*Mac 10*
- Reduced horizontal recoil to 10 (previously 30)

*Mare's Leg*
- Increased damage to 99 (previously 95)
- Removed Ammunition attachments

**>QOL & BUG FIXES**    
*END OF MATCH REWORK*
- The end of match and voting process has been overhauled to be more visually appealing and to provide more functionality

*MUSIC REWORK*
- The backend for music in the Main Menu has been completely overhauled
- Music will now be paused and resumed when toggling the setting in the menu
- Music now dynamically changes volume when navigating to different parts of the menu
- Music now properly loops again

*OTHER ADJUSTMENTS*

- A bunch of optimization has been implemented, expect more consistent frame rates

- Added SFX after a successful prestige

- Added new gamemode backgrounds

- Menu Music Volume setting now maxes out at a 2x multiplier (previously 1x)

- Fixed ammo bar going out of bounds when chambering a extra round into a weapon

- Players who are on a respawn timer when the End Of Game phase begin no longer respawn

- Servers with hibernation enabled no longer get stuck on the same map and gamemode if all players disconnect during the End Of Match phase

- Players that connect to the server during the End Of Game phase will now have a disclaimer shown on their HUD

- Potentially fixed players steam names not being correctly set in the save database, resulting in player names being NULL on the Leaderboard

- Functions that gather all player entities no longer grab bots (I don't know why bots would be on a Titanmod server but this is just in case someone does something funky)

- Removed Firing Range map and the special functions that accompanied it

- A Hatsune Miku player model is no longer installed when joining a server running the gamemode (lmao)



# June 20th, 2023 (6/20/23)
**>GAMEPLAY**   
*LEADERBOARD ADJUSTMENTS*
- Three new stats are now viewable from the Leaderboard menu
- Level, K/D Ratio, and W/L Ratio are now selectable options

*WEAPON ADJUSTMENTS*
- Renamed CZ 75 B to CZ 75
- Renamed FAMAS F1 to FAMAS

**>MAPS**   
*Disequilibrium*
- Complete rework of the map layout
- Improved performance
- Reduced overall brightness
- Fixed skybox bug when CS:GO is not mounted
- Updated map thumbnail

*Mall*
- Removed fog
- Improved performance

*Mephitic*
- Removed player spawns that are prone to acid
- Adjusted range of fog

*Villa*
- Removed fog
- Fixed invisible walls in some interiors
- Restricted out-of-bounds areas from being accessed (for real this time)

**>BALANCE**    
*FAMAS*
- Now fires in a forced 3 Round Burst with 1100 RPM
- Increased vertical recoil to 80 (previously 50)
- Increased horizontal recoil to 30 (previously 15)

*HK53*
- Reduced spread to 21 (previously 45)
- Reduced spread multiplier to 3x (previously 3.5x)

*M14*
- Reduced vertical recoil to 60 (previously 100)
- Removed Extended Magazine attachment

*M1918*
- Reduced damage to 45 (previously 50)

*M1919*
- Reduced damage to 40 (previously 45)
- Increased horizontal recoil to 35 (previously 25)

*M249*
- Increased damage to 28 (previously 26)
- Reduced vertical recoil to 38 (previously 50)
- Reduced horizontal recoil to 20 (previously 50)

*Mk 14 EBR*
- Reduced vertical recoil to 80 (previously 100)

*Colt M1911*
- Increased damage to 41 (previously 38)

*Colt M45A1*
- Reduced damage to 40 (previously 45)
- Removed Magnum Ammunition attachment

*CZ 75*
- Increased damage to 31 (previously 28)
- Reduced vertical recoil to 40 (previously 60)

*FNP-45*
- Removed Magnum Ammunition attachment
- Removed Extended Magazine attachment

*Glock 17*
- Now fires in a forced 3 Round Burst with 900 RPM
- Reduced damage to 25 (previously 26)
- Increased vertical recoil to 28 (previously 20)

*GSH-18*
- Reduced spread to 12 (previously 16)
- Reduced vertical recoil to 26 (previously 43)

*M9*
- Reduced vertical recoil to 30 (previously 35)

*Model 10*
- Increased vertical recoil to 120 (previously 80)
- Removed Speed Loader attachment
- Snub Nose attachment has increased vertical recoil by 100% (previously 15%)

*MR-96*
- Removed Speed Loader attachment

*OSP-18*
- Increased damage to 38 (previously 33)

*OTs-33 Pernach*
- Reduced damage to 24 (previously 25)
- Increased vertical recoil to 37 (previously 32)

**>QOL & BUG FIXES**    
- Hints are now shown in the Main Menu via a bar that slowly scrolls through all available hints

- Removed built-in flashlights from all weapons due to interference with the custom server-side flashlight system

- Matches played and Matches won are no longer updates on player saves if there is only 1 player logged onto a server

- Disabling the Screen Flashing Effects setting now actually disables screen flashes



# June 11th, 2023 (6/11/23)
**>GAMEPLAY**   
*LEADERBOARDS*
- There are now Leaderboards for all basic statistics + kills on specific weapons
- Leaderboards can be accessed from the Main Menu via the button on the top left and will show the top 50 players of a selected stat
- Players that are offline can still be seen on Leaderboards
- K/D, W/L%, and Player Level will have Leaderboards in the near future

*GUNPLAY CHANGES*
- Recoil has been reduced globally by 20%
- Hip fire spread has been increased globally by 30%

*SNIPER REWORK*
- Snipers now consist of two damage profile categories, 1 shot, and 1 shot torso/head with 2 shot limb
- Removed Ammunition attachments from snipers
- Snipers have been given view punch again when firing to be more satisfying to use

**>BALANCE**    
*AWM*
- Reduced damage to 117 (previously 165)

*AX-308*
- Reduced damage to 115 (previously 134)

*Barrett M98B*
- Reduced damage to 175 (previously 180)
- Reduced mobility to 64% (previously 90%)
- Increased vertical recoil to 275 (previously 75)

*CheyTac M200*
- Reduced damage to 170 (previously 250)
- Increased vertical recoil to 200 (previously 169)

*DSR-1*
- Reduced damage to 139 (previously 172)

*Lee Enfield*
- Reduced damage to 102 (previously 125)

*Mosin Nagant*
- Reduced damage to 111 (previously 145)

*Remington MSR*
- Reduced damage to 113 (previously 184)

*SV-98*
- Increased damage to 110 (previously 94)

*T-5000*
- Reduced damage to 116 (previously 180)

**>QOL & BUG FIXES**    
- Voice chat is now available in the map/mode voting menu (players can push a button to enable/disable their microphone input, a prompt will be shown asking for microphone permission when pressing it for the first time)

- Proximity voice chat range increased by 25%

- Added Source Sans Pro Semibold as a built-in custom HUD Font option

- Fixed Highest Kill Game only updating on a match win

- Separated Color and Pride calling cards into seperate categorires

- Fixed mastery calling card panel size

- Fixed T-5000 mastery calling card texture

- Tweaked Zedo pride calling card description

- Reduced time on button conformations to deter accidental confirmations

- Removed dynamic panel sizing for calling card categories that come pre-unlocked

- Removed Toggle ADS setting (was on by default due to TFA base default settings and it confused new players)



# June 8th, 2023 (6/8/23)
**>DISCLAIMER** 
- All player data/stats/unlocks/levels have been **RESET** as of this update, this is a massive inconvenience, but it was required in order to switch to a safer and stable saving system, a data wipe should never have to occur ever again, and I am sorry for doing this so suddenly.

**>QOL & BUG FIXES**    
- Player statistics and how they are saved after playing have been completely reworked to avoid future problems

- New player statistics have been added (Highest Kill Game and W/L Ratio)

- Removed some player statistics that were not necessary and bloated the database (Times killed by specific weapon and Times you have used a specific weapon)

- Another attempt at fixing the Main Menu not always opening up on server connect

- Correctly named some incorrect calling card names

- Updated text of some statistics when viewing player stats through the scoreboard

- Removed the function of the Main Menu statistics button, will be replaced with Leaderboards soon



# June 7th, 2023 (6/7/23)
**>GAMEPLAY**   
*COMPLETE GUNPLAY OVERHAUL*
- Gunplay as a whole has been completely altered for a much more consistent and skill based experience, here are a few notable changes:
- Weapons no longer have any spread when aiming down sights and bullets will always follow your reticle
- Visual recoil is now much less floaty, and bullets no longer fire under/above the sight
- Shotguns now have view punch, it looks really satisfying

*WEAPON ADJUSTMENTS*
- Renamed AKMS to AK-47
- Renamed B&T MP9 to MP9
- Renamed MP7A1 to MP7
- Renamed Lee-Enfield No. 4 to Lee Enfield
- Renamed Orsis T-5000 to T-5000
- Renamed Owen Mk.I to Owen Gun
- Renamed Sten Mk.II to Sten Gun
- Removed the DDM4V5, FB MSBS-B, KSVK 12.7, RK62, and the Type 81 from the weapon pool (either similar to other, more prominent weapons, or too low quality)

**>MAPS**   
*Nuketown*
- Fixed players spawning into brushes

*Shipment*
- Reduced amount of vegetation
- Improved lighting and shadows
- Added additional player spawns

*Villa*
- Added additional player spawns
- Improved performance
- Restricted access to unintended parts of the map

**>BALANCE**    
*Bow*
- Increased projectile velocity to 6000 (previously 3000)

*Crossbow*
- Increased projectile velocity to 8000 (previously 4000)
- Can no longer be fired while underwater

*Dual Skorpions*
- Reduced damage to 18 (previously 23)

*KRISS Vector*
- Reduced damage to 21 (previously 24)
- Increased horizontal recoil to 15 (previously 10)

*MP9*
- Reduced damage to 26 (previously 30)
- Reduced horizontal recoil to 9.5 (previously 13.5)

*Remington MSR*
- Aim down sight time reduced to 0.23 (previously 0.43)

*Scorpion Evo*
- Reduced damage to 20 (previously 22)

**>QOL & BUG FIXES**    
- Weapons now properly deal their intended damage to specific limbs

- Three new music tracks, two of which being tracks suggested or created by the community

- Adjusted the OPTIONS button to function similarly to the CUSTOMIZE button, having two drop down options for Settings and for HUD settings

- Adjusted the leveling text on the Main Menu

- Switched Steam profile links from vanity URLs to permanent SteamID URLs

- Decluttered death UI to be more readable

- Fixed faults in the alphabetical sorting for cosmetics

- Removed VM FOV multiplier setting

- Removed various HUD related settings and combined them into already existing settings



# May 27th, 2023 (5/27/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Shotty Snipers is now in Titanmod! Players will always spawn with a sniper and a shotgun when playing on this gamemode.

**>QOL & BUG FIXES**    
- New logo and banner art

- Reduced gamemode size by 150~ MB

- Added match status above the Spawn Button in the Main Menu

- Added gamemode tooltips when hovering over a selection in the gamemode vote

- Added brand new music tracks, while removing a few old ones

- Added a music link button beside the quick mute button that opens a YouTube link to the song being played

- Suiciding now demotes your level in Gun Game

- Changed default value of music volume from 0.9 to 1

- Standardized and increased amplitude globally across all music tracks

- Added additional tooltips to Main Menu buttons

- Fixed suicides not randomizing loadouts on FFA

- Fixed bug when quick muting or unmuting music from the Main Menu

- Fixed the keypress overlay Y offset being affected by the X offset convar

- Removed unused/obsolete PData entries

- Removed Main Menu side panel

- Removed Map thumbnail preview from Main Menu



# May 19th, 2023 (5/19/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Fiesta is the third Titanmod gamemode. Every player has the same shuffled loadout, and this loadout is changed every 30 seconds.

*TUTORIAL*
- Players who join a server running Titanmod for the first time will be shown a basic Tutorial. This is meant to improve the new-player experience. The tutorial can be opened up by anyone through a new button in the Main Menu

**>BALANCE**    
*KRISS Vector*
- Reduced aim spread to 20 (previously 50)
- Reduced spread growth to 3 (previously 4)

*Uzi*
- Increased damage to 20 (previously 18)

*G28*
- Increased vertical recoil to 114 (previously 44)

**>QOL & BUG FIXES**    
- Changing your calling card now updates the calling card in the Main Menu instantly

- Fixed a error when unmuting Main Menu music through the quick mute button

- Fixed centering on the XP counter on the scoreboard

- Fixed gamemode desync between server and client

- Potential fix for the Main Menu not always opening on server connect



# April 30th, 2023 (4/30/23)
**>QOL & BUG FIXES**    
- Players can no longer get soft locked if they get demoted without getting a kill first in Gun Game

- Gun audio should no longer loop on rare occasions in Gun Game

- Scoreboard scaling has been fixed



# April 29th, 2023 (4/29/23)
**>GAMEPLAY**   
*NEW GAMEMODE*
- Gun Game is now in Titanmod! Players can now vote for a gamemode during the usual map vote, expect more gamemodes to come in the future

**>MAPS**   
*NEW MAPS*
- Corrugated

*REMOVED MAPS*
- Station

**>BALANCE**    
- **Muzzle Brake** has a spread penalty of 25% (previously 30%)
- Removed **Flash Hider** from all weapons
- Removed **Heavy Barrel** from all weapons
- Removed **GIB Ammo** from all weapons
- Removed **Flashlight** from all weapons (was useless)

*ARC-C*
- Reduced damage to 30 (previously 32)

*AEK-971*
- Increased vertical recoil to 33 (previously 25)

*AK-12*
- Reduced damage to 34 (previously 35)
- Increased vertical recoil to 70 (previously 40)

*AK-400*
- Reduced damage to 34 (previously 36)
- Increased vertical recoil to 55 (previously 35)
- Increased horizontal recoil to 25 (previously 20)

*FN 2000*
- Reduced damage to 32 (previously 35)
- Increased vertical recoil to 50 (previously 30)
- Increased horizontal recoil to 25 (previously 15)

*Honey Badger*
- Increased vertical recoil to 65 (previously 50)
- Increased horizontal recoil to 30 (previously 15)

*SA80*
- Increased vertical recoil 44 (previously 37)

*AR-57*
- Smoothened recoil pattern

*KRISS Vector*
- Reduced damage to 24 (previously 27)
- Reduced aim spread to 5 (previously 10)

*MP5*
- Recoil pattern more accurately follows the sight

*P90*
- Increased mobility to 90% (previously 85%)
- Reduced aim spread to 54.5 (previously 69.5)
- Increased vertical recoil to 25 (previously 22.5)
- Increased horizontal recoil to 30 (previously 15)

*Scorpion Evo*
- Reduced damage to 22 (previously 24)

*AA-12*
- Reduced damage to 9x10 (previously 11x10)

*Remington M870*
- Reduced damage to 11x12 (previously 15x12)

*SPAS-12*
- Reduced damage to 9x12 (previously 12x12)
- Increased vertical recoil to 160 (previously 80)

*Stevens 620*
- Increased damage to 16x7 (previously 13x7)

*Typhoon F12*
- Reduced damage to 12x10 (previously 13x10)
- Reduced magazine size to 12 (previously 15)

*Desert Eagle*
- Removed Extended Magazine
- Removed Magnum ammo

*MR-96*
- Removed Magnum ammo

*S&W 500*
- Increased vertical recoil to 272 (previously 232)

*MG 34*
- Reduced damage to 27 (previously 32)

*MG 42*
- Reduced damage to 27 (previously 32)

*RPK-74M*
- Reduced damage to 33 (previously 40)

*RPG-7*
- Removed all attachments from the RPG-7
- Drastically increased RPG-7 recoil

*Bow*
- Increased damage to 85 (previously 65)

*Crossbow*
- Increased damage to 105 (previously 85)

**>QOL & BUG FIXES**    
- Health regeneration begins instantly upon getting a kill
- Disabled default HL2 ammo and weapon pickup notifications
- Removed 'tm_endless' server option due to incompatibility with new gamemode
- Being hit by a syringe now flashes your screen green instead of blue
- Laser attachments that also triggered a flashlight no longer trigger a flashlight (just like the standalone flashlight attachment, this is useless bc of Titanmod's custom lights)



# April 26th, 2023 (4/26/23)
**>GAMEPLAY**   
*NEW WEAPONS*
- **USP** (Secondary, Pistol)
- **Webley** (Secondary, Pistol)

*NEW SETTINGS*
- Keypress Overlay
- FPS and Ping counter

**>QOL & BUG FIXES**    
- Added countless HUD options for both of the new settings

- Added audio cues for match time warnings

- Optimized UI

- Removed the kill streak notification when a player only has 1 kill

- Under the hood work for new future gamemodes



# April 15th, 2023 (4/15/23)
**>GAMEPLAY**   
*MATCH TIME WARNING*
- Warnings show up periodically throughout matches (5:00, 1:00, and 0:10) that remind the player of the remaining match time

**>MAPS**   
*NEW MAPS*
- Hydro
- Villa

**>QOL & BUG FIXES**    
- Refactored how proximity voice chat is handled to eventually allow global voice chat during map voting

- Replaced most of the gamemode backgrounds for new ones



# April 10th, 2023 (4/10/23)
**>MAPS**   
*NEW MAPS*
- Mephitic (adjusted since removal for better visibility and performance)
- Sanctuary

**>BALANCE**    
*G36A1*
- Reduced damage to 31 (previously 33)
    
*PM-9*
- Reduced damage to 24 (previously 25)

*AEK-971*
- Reduced damage to 28 (previously 30)

*CZ 805*
- Reduced damage to 31 (previously 32)

*OTs-33 Pernach*
- Reduced damagae to 25 (previously 27)

*SCAR-H*
- Increased vertical recoil to 115 (previously 95)
- Increased horizontal recoil to 60 (previously 45)

*Dual Skorpions*
- Reduced damage to 27 (previously 33)
- Increased horizontal recoil to 25 (previously 10)

*Honey Badger*
- Reduced damage to 30 (previously 31)
- Increased vertical recoil to 50 (previously 30)

*FNP-45*
- Reduced damage to 38 (previously 42)

*OTs-14 Groza*
- Reduced hip spread to 11 (previously 14)
- Reduced aim spread to 3 (previously 5)

*SR-2M Veresk*
- Increased vertical recoil to 30 (previously 22)

**>QOL & BUG FIXES**    
- Added player tags to the scoreboard (shows if a player is a Developer, Moderator, etc)



# April 9th, 2023 (4/9/23)
**>GAMEPLAY**   
*DAMAGE ADJUSTMENT*
- Headshot damage multiplier reduced to 130% (previously 140%)

**>QOL & BUG FIXES**    
- Fixed players not properly installing the required content automatically upon joining for the first time

- Pick Random option in the model and card customization menus

- 4 new, free calling cards

- Preparation for a new map



# April 8th, 2023 (4/8/23)
**>QOL & BUG FIXES**    
- Fixed softlock in main menu after a level change



# April 7th, 2023 (4/7/23)
**>GAMEPLAY**   
*NEW WEAPONS*
- **Bow** (Secondary, Sniper)
- **Crossbow** (Primary, Sniper)

**>QOL & BUG FIXES**    
- Added 7 new unlockable playermodels (one new model for each accolade)

- Adjusted unlock requirements for certain playermodels to be more consistent

- Removed playermodel and calling card descriptions (they were kinda cheesy and im too stupid to make nice sounding ones)

- Added a spawn countdown to the spawn button on the main menu

- Replaced the Exit Game button with a button to open the Garry's Mod main menu.

- Fixed applying new playermodels and calling cards



# April 6th, 2023 (4/6/23)
**>GAMEPLAY**   
*ANIMATION CHANGES*
- Other than for a few exceptions, all animations have been increased in speed by 40% (this applies to reloads, switching to and from weapons, bolting/pumping, and more)

**>BALANCE**    
- Removed UBGLs (underbarrel grenade launchers) from being equipped on weapons

**>QOL & BUG FIXES**    
- Removed muzzle flash (improved visibilty and FPS)



# April 4th, 2023 (4/4/23)
**>GAMEPLAY**   
*DAMAGE ADJUSTMENTS*
- Updated Damage multiplers (Head = 140%, Torso/Stomach = 100%, Arms/Legs = 80%)
- Wallbang/penetration damage increased by 25%

*SPAWN PROTECTION*
- Players can no longer spawn if near another player in a 1024 unit radius

*MOVEMENT CHANGES*
- Increased crouch transition speed by 7.5%
- Increased crouch movement speed by 10%

**>BALANCE**    
*AUG A3*
- Increased mobility to 87% (previously 80%)
- Reduced hip spread to 16 (previously 20)

*MP18*
- Reduced ADS spread to 54 (previously 74)

*M4A1*
- Reduced damage to 32 (previously 35)
        
*MP40*
- Reduced ADS spread to 20 (previously 25)

*UMP .45*
- Reduced damage to 33 (previously 34)
    
*SCAR-H*
- Reduced damage to 57 (previously 61)



# April 3rd, 2023 (4/3/23) (Public Playtest Began)
**>GAMEPLAY**   
*MAP VOTE ADJUSTMENTS*
- Small maps no longer appear in the map vote when there are more than 5 players connected (this applies to Nuketown, Shipment, and the new Initial map)

**>MAPS**   
*NEW MAPS*
- Devtown
- Initial

*REMOVED MAPS*
- Mephetic (will return after adjustments)

**>BALANCE**    
*Dual Skorpions*
- Reduced damage to 24 (previously 25)

*RFB*
- Reduced horizontal recoil

- Adjusted reload speed on the AS Val and M4A1

**>QOL & BUG FIXES**    
- Mute button beside music name to quickly disable/enable menu music without navigating to options

- Discord button added to the social tray in the Main Menu

- Fixed main menu net msg error

- Fixed "transmitting voice" showing up while other users were using proximity voice chat nearby

- Fixed jamming on RFB reload