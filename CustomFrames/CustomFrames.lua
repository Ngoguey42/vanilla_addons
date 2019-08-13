	------------------------------------------------
	----------------	CONSTANTES	----------------
	------------------------------------------------
-- Theorycrafting Constantes
-- Damage Spells
local HSbonus = 111
local RendDuration = 21
local RendDamage = (168+175)/2/RendDuration*3
local EXECbonus = 450
local EXECmulti = 12
local OverpowerBonus = 25
local MSbonus = 110
-- Bonus stuff
local BonusCrit = (0) / 100   --sur le stuff
local BonusHit = (0) / 100 -- sur le stuff
-- Couleurs spells
local ColorAuto = "FFFFFF"
local ColorHero = "EFD807"
local ColorRend = "ED0000"
local ColorMort = "8080FF"
local ColorExec = "E67E30"

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------
-- OnUpdate Variables
local TSLU1 = 0
local TSLU2 = 0
local TSLU3 = 0

-- Portait Variables
CF_rendTime = 0
CF_HSTime = 0

-- XP Variables
local XPCats = {{1*60}, {2*60}, {3*60}, {5*60}, {10*60}, {15*60}, {20*60}, {30*60}, {45*60}, {60*60}, {90*60}, {120*60}}
-- local XPCats = {{1*10}, {2*10}, {3*10}, {4*10}, {5*10}, {6*10}, {20*60}, {30*60}, {45*60}, {60*60}, {90*60}, {120*60}}
-- local XPCats = {{1*5}, {2*12}, {3*12}, {4*12}}
-- local LoginTime = GetTime()
-- Ouvertures de Cat
CF_nextCatNumberToOpen = 1
CF_lastCatNumberOpened = nil
local VeryLastCatTable = XPCats[getn(XPCats)]
local VeryFirstCatTable = XPCats[1]
-- Textes par Cat
local OpenedCatsXPTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local OpenedCatsXPPercTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local OpenedCatsXPHourTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local OpenedCatsXPMobAndRatioTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local OpenedCatsXPQuestTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
-- test talents
local WeaponSpec
-- swing
local previousSwing = GetTime() - 10


-- table
local catsTableTextVar = {{}, {}, {}, {}, {}, {}, {}}

	------------------------------------------------
	----------------	OnLoad		----------------
	------------------------------------------------
function CustomFrames_OnLoad()
	-- Main Frame
	-- Main Frame
	MyCFframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	MyCFframe:SetPoint("CENTER", 0, 0)	
	
	-- Portaits 
	-- Portaits 
	do
	-- Portaits -- HP target %
	customHPframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customHPframeText:SetTextColor(1,1,1,0.85)	
	customHPframeText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")	
	customHPframeText:SetText("")	
	customHPframe:SetPoint("CENTER", 91, 20)
	
	-- Portaits -- HP target Max
	customHPmaxframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customHPmaxframeText:SetTextColor(1,1,1,0.75)	
	customHPmaxframeText:SetFont("Fonts\\FRIZQT__.TTF", 11)	
	customHPmaxframeText:SetText("")	
	customHPmaxframe:SetPoint("CENTER", 80, -15)
	
	-- Portaits -- Rage self
	customRageframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customRageframeText:SetTextColor(1,0,0,1)	
	customRageframeText:SetFont("Fonts\\FRIZQT__.TTF", 17, "OUTLINE")	
	customRageframeText:SetText(UnitMana("player"))		
	customRageframe:SetPoint("CENTER", -0, -0)
	
	-- Portaits -- Rend Timer
	customRendframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customRendframeText:SetTextColor(1,0,0,1)	
	customRendframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customRendframeText:SetText("")		
	customRendframe:SetPoint("RIGHT", -70, 50)
	
	-- Portaits -- Harmstring Timer
	customHSframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customHSframeText:SetTextColor(1,1,0,1)	
	customHSframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customHSframeText:SetText("")		
	customHSframe:SetPoint("RIGHT", -70, 50)
	end
	
	-- Therycrafting -- Normal DMG
	-- Therycrafting -- Normal DMG 
	do
	-- Therycrafting -- Normal DMG -- Value
	customDamageframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamageframeText:SetTextColor(1,1,1,0.75)	
	customDamageframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamageframeText:SetText("")		
	customDamageframe:SetPoint("RIGHT", 20, 50)
	customDamageframeText:SetJustifyH("LEFT")
	customDamageframeText:SetJustifyV("TOP")
	
	-- Therycrafting -- Normal DMG -- Percent
	customDamagePercframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamagePercframeText:SetTextColor(1,1,1,0.75)	
	customDamagePercframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamagePercframeText:SetText("")		
	customDamagePercframe:SetPoint("RIGHT", 40, 50)--73
	customDamagePercframeText:SetJustifyH("RIGHT")
	customDamagePercframeText:SetJustifyV("TOP")
	
	-- Therycrafting -- Normal DMG -- Names
	customDamageNameframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamageNameframeText:SetTextColor(1,1,1,0.75)	
	customDamageNameframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamageNameframeText:SetText("|CFF"..ColorAuto.."Auto".."|CFF"..ColorHero.."\nHeroic".."|CFF"..ColorRend.."\nRend".."|CFF"..ColorMort.."\nMS".."|CFF"..ColorExec.."\nExec")
	customDamageNameframe:SetPoint("RIGHT", 100, 50)
	customDamageNameframeText:SetJustifyH("LEFT")
	customDamageNameframeText:SetJustifyV("TOP")
	
	-- Therycrafting -- Normal DMG -- Per Rage
	customDamageRentabframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamageRentabframeText:SetTextColor(1,1,1,0.75)	
	customDamageRentabframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamageRentabframeText:SetText("salut")		
	customDamageRentabframe:SetPoint("RIGHT", 208, 50)--73
	customDamageRentabframeText:SetJustifyH("LEFT")
	customDamageRentabframeText:SetJustifyV("TOP")
	end
	
	-- Therycrafting -- Theoric DMG
	-- Therycrafting -- Theoric DMG
	do
	-- Therycrafting -- Theoric DMG -- Value
	customDamageREALframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamageREALframeText:SetTextColor(1,1,1,0.75)	
	customDamageREALframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamageREALframeText:SetText("")		
	customDamageREALframe:SetPoint("TOPRIGHT", 20, 80)
	customDamageREALframeText:SetJustifyH("LEFT")
	customDamageREALframeText:SetJustifyV("TOP")
	
	-- Therycrafting -- Theoric DMG -- Percent
	customDamagePercREALframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamagePercREALframeText:SetTextColor(1,1,1,0.75)	
	customDamagePercREALframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamagePercREALframeText:SetText("")		
	customDamagePercREALframe:SetPoint("TOPRIGHT", 40, 80)--73
	customDamagePercREALframeText:SetJustifyH("RIGHT")
	customDamagePercREALframeText:SetJustifyV("TOP")
	
	-- Therycrafting -- Theoric DMG -- Per Rage
	customDamageRentabREALframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customDamageRentabREALframeText:SetTextColor(1,1,1,0.75)	
	customDamageRentabREALframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customDamageRentabREALframeText:SetText("salut")		
	customDamageRentabREALframe:SetPoint("TOPRIGHT", 160, 80)--73
	customDamageRentabREALframeText:SetJustifyH("LEFT")
	customDamageRentabREALframeText:SetJustifyV("TOP")
	end
	
	-- PEXE
	-- PEXE
	do
	-- PEXE -- Noms
	customXPCatsframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customXPCatsframeText:SetTextColor(1,1,1,0.30)	
	customXPCatsframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customXPCatsframeText:SetText("")		
	customXPCatsframe:SetPoint("BOTTOMRIGHT", -400, -10)--73
	customXPCatsframeText:SetJustifyH("RIGHT")
	customXPCatsframeText:SetJustifyV("TOP")
	customXPCatsframeText:SetSpacing(2)

	-- PEXE -- Values
	customXPValsframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customXPValsframeText:SetTextColor(1,1,1,0.30)	
	customXPValsframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customXPValsframeText:SetText("")		
	customXPValsframe:SetPoint("TOPLEFT", 71, 0)--73
	customXPValsframeText:SetJustifyH("LEFT")
	customXPValsframeText:SetJustifyV("TOP")
	customXPValsframeText:SetSpacing(2)
	
	-- PEXE -- Percent
	customXPPercframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customXPPercframeText:SetTextColor(1,1,1,0.30)	
	customXPPercframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customXPPercframeText:SetText("")		
	customXPPercframe:SetPoint("TOPLEFT", 83, 0)--73
	customXPPercframeText:SetJustifyH("LEFT")
	customXPPercframeText:SetJustifyV("TOP")
	customXPPercframeText:SetSpacing(2)
	
	-- PEXE -- Per Hour
	customXPHourframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customXPHourframeText:SetTextColor(1,1,1,0.30)	
	customXPHourframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customXPHourframeText:SetText("")		
	customXPHourframe:SetPoint("TOPLEFT", 56, 0)--73
	customXPHourframeText:SetJustifyH("LEFT")
	customXPHourframeText:SetJustifyV("TOP")
	customXPHourframeText:SetSpacing(2)
	
	-- PEXE -- Ratio
	customXPRatioframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customXPRatioframeText:SetTextColor(1,1,1,0.30)	
	customXPRatioframeText:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
	customXPRatioframeText:SetText("")		
	customXPRatioframe:SetPoint("TOPLEFT", 71, 0)--73
	customXPRatioframeText:SetJustifyH("LEFT")
	customXPRatioframeText:SetJustifyV("TOP")
	customXPRatioframeText:SetSpacing(2)

	-- PEXE - Vals
	customXPvalsframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customXPvalsframeText:SetTextColor(0.5,1,0.5,0.90)	
	customXPvalsframeText:SetFont("Fonts\\FRIZQT__.TTF", 14)	
	customXPvalsframe:SetPoint("CENTER", 0, 2)
	
	-- GOLD - Vals
	customMoneyframe:SetBackdropColor(0.5, 0.5, 0.5, 0)	
	customMoneyframeText:SetTextColor(0.5,1,0.5,0.90)	
	customMoneyframeText:SetFont("Fonts\\FRIZQT__.TTF", 13)	
	customMoneyframe:SetPoint("CENTER", 0, 26)
	end
	
	
	-- EVENTS
	-- EVENTS
	do
	MyCFframe:SetScript("OnUpdate", CustomFrames_OnUpdate)
	MyCFframe:RegisterEvent("PLAYER_ENTERING_WORLD") -- PLAYER_ENTERING_WORLD puis unregister (et pas autre chose!) car UnitXPMax("player") return nil auparavant. (PLAYER_ALIVE fonctionne pas au reloadui)
	MyCFframe:RegisterEvent("PLAYER_LOGOUT")
	
	-- mob hp
	MyCFframe:RegisterEvent("PLAYER_TARGET_CHANGED")
	
	-- TC
	MyCFframe:RegisterEvent("UNIT_INVENTORY_CHANGED")
	MyCFframe:RegisterEvent("CHAT_MSG_SKILL")
	MyCFframe:RegisterEvent("PLAYER_TALENT_UPDATE")
	
	-- pexe
	MyCFframe:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
	MyCFframe:RegisterEvent("COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED")

	-- rend harmstring
	MyCFframe:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
	
	-- swing
	MyCFframe:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
	MyCFframe:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
	
	-- gold
	MyCFframe:RegisterEvent("LOOT_ITEM_SELF")
	MyCFframe:RegisterEvent("BAG_UPDATE")
	end
	
	-- TEST
	-- do
		-- local test = _G; --/run print(_G[1]);
		-- local i = 0;
		-- while _G[i] != nil do
			-- print(test[i]);
			-- i = i + 1;
		-- end
	
	
	-- end
	
	-- local x, y = GetPlayerMapPosition("player");
	-- print(x..y);
	

	
end



function CreateChancesFrames()


		customChances1frame:SetBackdropColor(0.5, 0.5, 0.5, 0)
		customChances1frame:SetPoint("TOPLEFT", 125, -92)
		local catsTable = {{}, {}, {}, {}, {}, {}, {}}

		catsTable[1] = customChances1frame
		
		local cats = {"Hit", "Crit", "Glan", "Dod", "Parr", "Miss"}
		for i = 2, 7 do
			local j = i - 1
			local f = CreateFrame("frame", "customChances"..i.."frame", catsTable[j])
			f:SetFrameStrata("BACKGROUND")
			f:SetWidth(53) -- Set these to whatever height/width is needed 
			f:SetHeight(16) -- for your Texture

			
			local t = f:CreateFontString("customChances"..i.."frameText" , "BACKGROUND" , "GameFontNormalLarge")
			t:SetAllPoints(f)
			t:SetText(cats[j])	
			t:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
			t:SetTextColor(1,1,1,0.30)
			t:SetJustifyH("MIDDLE")
			t:SetJustifyV("TOP")
			
			
			f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
			f:SetBackdropColor(1, 1, 0, 0)	
			f:SetPoint("TOPLEFT", catsTable[j], "TOPRIGHT", -5, 0);
			f:Show()
			catsTable[i] = f
			
		end
			
		local catsTableVar = {{}, {}, {}, {}, {}, {}, {}}
		
		for i = 2, 7 do
			local j = i - 1
			local f = CreateFrame("frame", "customChances"..i.."Varframe", catsTable[i])
			f:SetFrameStrata("BACKGROUND")
			f:SetWidth(53) -- Set these to whatever height/width is needed 
			f:SetHeight(60) -- for your Texture
			
			local t = f:CreateFontString("customChances"..i.."frameText" , "BACKGROUND" , "GameFontNormalLarge")
			t:SetAllPoints(f)
			t:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")	
			t:SetTextColor(1,1,1,0.80)
			t:SetJustifyH("MIDDLE")
			t:SetJustifyV("TOP")
			
			catsTableTextVar[i] = t
			
			f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
			f:SetBackdropColor(0, 1, 1, 0)	
			f:SetPoint("TOPLEFT", catsTable[i], "BOTTOMLEFT", 0, 3);
			f:Show()
			catsTableVar[i] = f
		end
		
	local test = catsTableTextVar[2]
	test:SetText("salut")	


end


local UpdateHP

	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------
function CustomFrames_OnEvent(event, arg1, arg2)
	--- PLAYER_TARGET_CHANGED
	--- PLAYER_TARGET_CHANGED
	--- PLAYER_TARGET_CHANGED

	
	
	if event == "PLAYER_TARGET_CHANGED" then
		local text = ComputeNumber(UnitHealthMax("target"))
		customHPmaxframeText:SetText(text)
	end
	
	if event == "PLAYER_TALENT_UPDATE" then
	print("talent update")
	print("talent update")
	print("talent update")
	print("talent update")
	print("talent update")
	print("talent update")
	end
	
	if event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		CF_GetWeaponSkill()
		CF_GetWeaponSpec()
	end
	
	if event == "CHAT_MSG_SKILL" then
		CF_GetWeaponSkill()
	end
	
	if event == "talent" then
		CF_UpdateTalents()
		CF_GetWeaponSpec()
	end

	
	
	--- PLAYER_ENTERING_WORLD
	--- PLAYER_ENTERING_WORLD
	--- PLAYER_ENTERING_WORLD
	if event == "PLAYER_ENTERING_WORLD" then
		MyCFframe:UnregisterEvent("PLAYER_ENTERING_WORLD")
	
		-- MyCFframe:RegisterEvent("PLAYER_XP_UPDATE")
		CF_PreviousXPMax = UnitXPMax("player")
		-- CF_PreviousXP = UnitXP("player")
		
		
		-- format text basic timers
		local tempText1 = ""
		for i = 1, getn(XPCats) do
			local tempTable = XPCats[i]
			tempText1 = tempText1..string.format("%.0f", (tempTable[1]/60)).." min\n"
		end
		

		-- parse text
		customXPCatsframeText:SetText(tempText1.."Session\n")	
		
		if not (CF_LogStartTime) then
			CF_LogStartTime = time()
			CF_MySessionXP = {0, 0, 0, 0}
		elseif (time() - CF_OfflineTime) > 1800 then
			CF_LogStartTime = time()
			CF_MySessionXP = {0, 0, 0, 0}
			print("session auto-reset")
		end
		
		if not CF_MySessionXP then
			CF_MySessionXP = {0, 0, 0, 0}
		end
		
		CF_GetWeaponSkill()
		CF_GetWeaponSpec()
		CF_UpdateTalents()
		CreateChancesFrames()
		-- customXPvalsframe:UpdateText()
		customMoneyframe:UpdateText();
		customXPvalsframe:UpdateText(UnitXP("player"))
		MainMenuExpBar:SetScript("OnValueChanged", function(self, value)
			customXPvalsframe:UpdateText(MainMenuExpBar:GetValue())
		end)
		TargetFrameHealthBar:SetScript("OnValueChanged", function(self, value)
			UpdateHP()
		end)
	end
	
	
	
	-- PLAYER_LOGOUT
	-- PLAYER_LOGOUT
	-- PLAYER_LOGOUT
	if event =="PLAYER_LOGOUT" then
		CF_OfflineTime = time()
	end
	
	
	if event == "CHAT_MSG_COMBAT_XP_GAIN" then
		local _,_,mob,_  = string.find(arg1, "meurt, vous gagnez (%d+)")
		if mob then
			mob = true
		else
			mob = false
		end
		local _,_,xp,_ = string.find(arg1, "ous gagnez (%d+)")
		UpdateXP(xp, mob)
		
	end
	
	-- if event == "CHAT_MSG_COMBAT_XP_GAIN" or event == "COMBATLOG_XPGAIN_FIRSTPERSON_UNNAMED" then
		-- print(event);
		-- customXPvalsframe:UpdateText()
	-- end
	--PLAYER_XP_UPDATE
	--PLAYER_XP_UPDATE
	--PLAYER_XP_UPDATE
	-- if event == "PLAYER_XP_UPDATE" then
		-- UpdateXP()
	-- end
	
	if event == "LOOT_ITEM_SELF" or event == "BAG_UPDATE" then
		customMoneyframe:UpdateText();
		
	end
	
	-- CHAT_MSG_SPELL_SELF_DAMAGE
	-- CHAT_MSG_SPELL_SELF_DAMAGE
	-- CHAT_MSG_SPELL_SELF_DAMAGE
	
	if event == "CHAT_MSG_COMBAT_SELF_HITS" or event == "CHAT_MSG_COMBAT_SELF_MISSES" then
		previousSwing = GetTime()
	end
	
		
	if event == "CHAT_MSG_SPELL_SELF_DAMAGE" and strsub(arg1, 16, -2) == "Pourfendre" then
		CF_rendTime = GetTime()
	elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" and strsub(arg1, 7, 17) == "Brise-genou" then
		CF_HSTime = GetTime()
	end
	
end




function UpdateSwingBar()

	customSwingBar:SetMinMaxValues(previousSwing, previousSwing + UnitAttackSpeed("player"));
	customSwingBar:SetValue(GetTime())
	-- 

end









	------------------------------------------------
	-------------	Fonctions Portraits	------------
	------------------------------------------------
local function UpdateRend()
	if not (CF_rendTime == 0) and (GetTime() - CF_rendTime) <= RendDuration then
		local timeleft = RendDuration - (GetTime() - CF_rendTime)
		customRendframeText:SetText(string.format("%.0f", timeleft).."s")	
	elseif not (CF_rendTime == 0) then
		CF_rendTime = 0
		customRendframeText:SetText("")	
	end
end

local function UpdateHS()
	if not (CF_HSTime == 0) and (GetTime() - CF_HSTime) <= 18 then
		local timeleft = 18 - (GetTime() - CF_HSTime)
		customHSframeText:SetText(string.format("%.0f", timeleft).."s")	 -- HPperc = string.format("%.1f", CF_HSTime)
	elseif not (CF_HSTime == 0) then
		CF_HSTime = 0
		customHSframeText:SetText("")	
	end
end

function UpdateHP()
	local HPperc = (UnitHealth("target")/UnitHealthMax("target")*100)
	if HPperc < 21 and HPperc > 19 then
		HPperc = string.format("%.1f", HPperc).."%"
	else 
		HPperc = string.format("%.0f", HPperc).."%"
	end
	customHPframeText:SetText(HPperc)
	customRageframeText:SetText(UnitMana("player"))	
end

	------------------------------------------------
	----------	Fonctions Theorycrafting	--------
	------------------------------------------------
function CF_GetWeaponSkill()

	local itemLink, itemType
	if GetInventoryItemLink("player", 16) then
		itemLink = GetInventoryItemLink("player", 16)
		_,_,_,_,_,itemType = GetItemInfo(strsub(itemLink, strfind(itemLink, "Hitem:")+ 6, strfind(itemLink, ":", strfind(itemLink, "Hitem:") + 6) - 1))
		if itemType ~= nil and strsub(itemType, -11) == "à une main" then
			itemType = strsub(itemType, 1, -13)
		end
	else
		itemType = "Mains nues"
	end
	for i = 1, GetNumSkillLines() do
		if GetSkillLineInfo(i) == itemType then
			_, _, _, CF_WeaponSkill= GetSkillLineInfo(i)
		end
	end
end

function CF_GetWeaponSpec()
	if GetInventoryItemLink("player", 16) then
		local itemLink = GetInventoryItemLink("player", 16)
		local _,_,_,_,_,itemType = GetItemInfo(strsub(itemLink, strfind(itemLink, "Hitem:")+ 6, strfind(itemLink, ":", strfind(itemLink, "Hitem:") + 6) - 1))
		if itemType == "Epées à une main" then
			local _, _, _, _, ImpSwordRank = GetTalentInfo(1, 15)
			WeaponSpec = {0, (ImpSwordRank / 100), 1}
		
		elseif itemType == "Epées à deux mains" then
			local _, _, _, _, ImpSwordRank = GetTalentInfo(1, 15)
			local _, _, _, _, Imp2HRank = GetTalentInfo(1, 10)
			WeaponSpec = {0, (ImpSwordRank / 100), (Imp2HRank / 100 + 1)}
			
		elseif itemType == "Haches à une main" then
			local _, _, _, _, ImpAxeRank = GetTalentInfo(1, 12)
			WeaponSpec = {ImpAxeRank, 0, 1}
			
		elseif itemType == "Haches à deux mains" then
			local _, _, _, _, ImpAxeRank = GetTalentInfo(1, 12)
			local _, _, _, _, Imp2HRank = GetTalentInfo(1, 10)
			WeaponSpec = {ImpAxeRank, 0, (Imp2HRank / 100 + 1)}
			
		elseif itemType == "Armes d'hast" then
			local _, _, _, _, ImpPolearmRank = GetTalentInfo(1, 16)
			local _, _, _, _, Imp2HRank = GetTalentInfo(1, 10)
			WeaponSpec = {ImpPolearmRank, 0, (Imp2HRank / 100 + 1)}
			
		elseif itemType == "Bâtons" then
			local _, _, _, _, Imp2HRank = GetTalentInfo(1, 10)
			WeaponSpec = {0, 0, (Imp2HRank / 100 + 1)}
		else
			WeaponSpec = {0, 0, 1}
		end
		
	else
		WeaponSpec = {0, 0, 1}
	end
end


function CF_UpdateTalents()
	
end

	
function UpdateDamages()
	-- Call un CF_WeaponSkill si il n'existe pas
	if not CF_WeaponSkill then
		CF_GetWeaponSkill()
	end
	
	-- talents
	local _, _, _, _, ImpHSRank = GetTalentInfo(1, 1) -- (15 - ImpHSRank)
	local _, _, _, _, ImpOPRank = GetTalentInfo(1, 7) -- (ImpOPRank/4)
	local _, _, _, _, DWRank = GetTalentInfo(1, 9) -- *(DWRank/3)
	local _, _, _, _, ImpaleRank = GetTalentInfo(1, 11) -- 
	local _, _, _, _, CrueltyRank = GetTalentInfo(2, 2)
	local _, _, _, _, ImpExecRank = GetTalentInfo(2, 10) -- 

	-- local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player");
	
	-- print(lowDmg)
	-- print(hiDmg)
	-- print(offlowDmg)
	-- print(offhiDmg)
	-- print(posBuff)
	-- print(negBuff)
	-- print(percentmod)
	-- print("tfgxftg")
	
	-- Stats paperdoll
	local lowDmg, hiDmg = UnitDamage("player") 
	local speed = UnitAttackSpeed("player")
	-- print(lowDmg) print(hiDmg)
	
	local moyDmg = (lowDmg + hiDmg) / 2
	local _, agi = UnitStat("player", 2)
	local CritMultiplicator = 1.5 +(ImpaleRank/10)
	
	--Mobs
	local HPmob = UnitHealthMax("target") or 0
	local lvlMob = UnitLevel("target")
	if lvlMob == 0 then
		lvlMob = UnitLevel("player")
	end
	
	--Execute, je set la rage au coup de l'exec, si current rage inférieure
	local currentRage = UnitMana("player")
	local ExecBaseCost = (15 - floor(ImpExecRank*2.5))
	local ExecTotalCost, ExecRageLeftForBonus
	
	if currentRage >= ExecBaseCost then
		ExecTotalCost = currentRage
		ExecRageLeftForBonus = currentRage - ExecBaseCost
	else
		ExecTotalCost = ExecBaseCost
		ExecRageLeftForBonus = 0
	end
	
	-- Armor modifier -- /run local _, targetArmor = UnitArmor("target") print(targetArmor)
	local targetArmor = UnitArmor("target")
	local armorModifier = 1 - targetArmor / (targetArmor + 400 + 85 * UnitLevel("player"))


	-- Stances
	local StanceBonus = {}
	if GetBonusBarOffset() == 1 then
		StanceBonus = {1.05, 0}
	elseif GetBonusBarOffset() == 2 then
		StanceBonus = {0.95, 0}
	elseif GetBonusBarOffset() == 3 then
		StanceBonus = {1.05, 3}
	else 
		StanceBonus = {1, 0}
	end
	
	-- Damages Normal
	local autoDMGregular, hsIncreaseDMGregular, msDMGregular, execDMGregular
	
	autoDMGregular = moyDmg * armorModifier * WeaponSpec[3]
	hsIncreaseDMGregular = HSbonus * armorModifier * WeaponSpec[3] * StanceBonus[1]
	msDMGregular = (MSbonus * StanceBonus[1] + moyDmg) * armorModifier * WeaponSpec[3]
	execDMGregular = (EXECbonus + EXECmulti * ExecRageLeftForBonus  * StanceBonus[1])* armorModifier * WeaponSpec[3] + 0.0001 -- plus epsilon pour eviter =0
	
	
	-- print(floor(EXECbonus * armorModifier).."    "..floor(EXECmulti * ExecRageLeftForBonus * armorModifier * 1.05).."    "..floor(execDMGregular*1.05))
	
	
	-- CALCULATE : Chances to Hit, Dodge, Miss, Parry, Crit
	local TargetDef = lvlMob * 5

	local SkillDiff = CF_WeaponSkill - TargetDef
	local MissChance, ParryChance, DodgeChance, GlancingChance, GlancingCoef, CritChance
	
	
	if (TargetDef - CF_WeaponSkill) > 10 then --J'ai moins
		MissChance = (6 + (TargetDef - CF_WeaponSkill - 10)*0.4)/100 - BonusHit
		CritChance = (5 - (TargetDef - CF_WeaponSkill)*0.04)/100 + BonusCrit + agi / 2000 + CrueltyRank / 100 + WeaponSpec[1] / 100 + StanceBonus[2] / 100 --same
		DodgeChance = (5 + (TargetDef - CF_WeaponSkill)*0.1)/100 --same
		ParryChance = (5 + (TargetDef - CF_WeaponSkill)*0.5)/100 --approx
		-- print("1  "..(TargetDef - CF_WeaponSkill))
	elseif (TargetDef - CF_WeaponSkill) >=0 then --J'ai autant ou moins
		MissChance = (5 + (TargetDef - CF_WeaponSkill)*0.1)/100 - BonusHit
		CritChance = (5 - (TargetDef - CF_WeaponSkill)*0.04)/100 + BonusCrit + agi / 2000 + CrueltyRank / 100 + WeaponSpec[1] / 100 + StanceBonus[2] / 100 --same
		DodgeChance = (5 + (TargetDef - CF_WeaponSkill)*0.1)/100 --same
		ParryChance = (5 + (TargetDef - CF_WeaponSkill)*0.1)/100
		-- print("2  "..(TargetDef - CF_WeaponSkill))
	else -- j'ai plusss
		MissChance = (5 - (CF_WeaponSkill - TargetDef)*0.4)/100 - BonusHit
		CritChance = (5 + (CF_WeaponSkill - TargetDef)*0.4)/100 + BonusCrit + agi / 2000 + CrueltyRank / 100 + WeaponSpec[1] / 100 + StanceBonus[2] / 100
		DodgeChance = (5 - (CF_WeaponSkill - TargetDef)*0.4)/100
		ParryChance = (5 - (CF_WeaponSkill - TargetDef)*0.4)/100
		-- print("3  "..(TargetDef - CF_WeaponSkill))
	end

	
	-- CALCULATE : Chances to Glancing, Glancing DMG
	GlancingChance = (10 + (TargetDef - CF_WeaponSkill)*2)/100
	local minVal = (130 - (TargetDef - CF_WeaponSkill)*5)/100
	local maxVal = (120 - (TargetDef - CF_WeaponSkill)*3)/100
	if minVal > 0.91 then minVal = 0.91 end
	if minVal < 0.01 then minVal = 0.01 end
	if maxVal > 0.99 then maxVal = 0.99 end
	if maxVal < 0.2 then maxVal = 0.2 end
	local GlancingCoef = minVal/2 + maxVal/2
	
	-- rééquilibrages si valeur inférieure à 0
	if CritChance < 0 then CritChance = 0 end
	if GlancingChance < 0 then GlancingChance = 0 end
	if MissChance < 0 then MissChance = 0 end
	if ParryChance < 0 then ParryChance = 0 end
	if DodgeChance < 0 then DodgeChance = 0 end
	
	-- rééquilibrages si somme supérieure à 1
	if MissChance > 1 then
		MissChance = 1
		ParryChance = 0
		DodgeChance = 0
		CritChance = 0
		GlancingChance = 0
	elseif (MissChance+ParryChance) > 1 then
		ParryChance = 1 - MissChance
		DodgeChance = 0
		CritChance = 0
		GlancingChance = 0
	elseif (MissChance+ParryChance+DodgeChance) > 1 then
		DodgeChance = 1 - MissChance - ParryChance
		CritChance = 0
		GlancingChance = 0
	elseif (MissChance+ParryChance+DodgeChance+CritChance) > 1 then
		CritChance = 1 - MissChance - ParryChance - DodgeChance
		GlancingChance = 0
	elseif (MissChance+ParryChance+DodgeChance+CritChance+GlancingChance) > 1 then
		GlancingChance = 1 - MissChance - ParryChance - DodgeChance - CritChance
	else
	end
	
	
	-- display percents
	local chancesTable = {
	"", 
	string.format("%.1f", (1-CritChance-GlancingChance-DodgeChance-ParryChance-MissChance)*100).."%\n"..floor(armorModifier * 100).."%", 
	string.format("%.1f", CritChance * 100).."%\n200%", 
	string.format("%.1f", GlancingChance * 100).."%\n"..string.format("%.1f", GlancingCoef * 100).."%", 
	string.format("%.1f", DodgeChance * 100).."%", 
	string.format("%.1f", ParryChance * 100).."%", 
	string.format("%.1f", MissChance * 100).."%"
	}
	-- string.format("%.1f", )
	
	
		-- local test = catsTableTextVar[2]
	-- test:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")	
	--catsTableTextVar
	for i = 2, 7 do
		-- print(chancesTable[i])
		catsTableTextVar[i]:SetText(chancesTable[i])
	end
	-- print("miss:"..(MissChance * 100).."% Parry:"..(ParryChance * 100).."% Dodge:"..(DodgeChance * 100).."% Glancing:"..(GlancingChance * 100).."% glancing:"..(GlancingCoef * 100).."% Crit:"..(CritChance * 100).."%")
	
	
	-- DeepWound
	local DeepWoundDMG
	DeepWoundDMG = (moyDmg * 0.6) * (DWRank/3) * 0.5 -- je compte que la moitier de deep wound
	

	-- Overpower et sword spec en meme temps
	-- Sword spec proc (j'intégre l'overpower manuellement dans la sword spec, mais je néglige les chances de sword spec sur l'overpower résultant de la sword spec dodged -_-")
	local opDMGregular, opDMGaverage
	opDMGregular = (OverpowerBonus * StanceBonus[1] + moyDmg) * armorModifier * ceil(ImpOPRank/2) * WeaponSpec[3]
	local SwordSpecDMGaverage = WeaponSpec[2] * (autoDMGregular*CritChance*CritMultiplicator + autoDMGregular*GlancingChance*GlancingCoef + autoDMGregular*(1-CritChance-GlancingChance-DodgeChance-ParryChance-MissChance)*1 + CritChance*DeepWoundDMG + DodgeChance * (opDMGregular*(CritChance+(ImpOPRank/4))*CritMultiplicator + opDMGregular*(1-CritChance-50/100-MissChance)*1 + (CritChance+50/100) * DeepWoundDMG)) 
	opDMGaverage = opDMGregular*(CritChance+(ImpOPRank/4))*CritMultiplicator + opDMGregular*(1-CritChance-50/100-MissChance)*1 + (CritChance+50/100) * DeepWoundDMG + SwordSpecDMGaverage

	-- CALCULATE : Damages average
	local autoDMGaverage, hsIncreaseDMGaverage, rendDMGaverage, msDMGaverage, execDMGaverage
	
	autoDMGaverage = autoDMGregular*CritChance*CritMultiplicator + autoDMGregular*GlancingChance*GlancingCoef + autoDMGregular*(1-CritChance-GlancingChance-DodgeChance-ParryChance-MissChance)*1 + CritChance*DeepWoundDMG + DodgeChance*opDMGaverage + SwordSpecDMGaverage
	hsIncreaseDMGaverage = hsIncreaseDMGregular*CritChance*CritMultiplicator + hsIncreaseDMGregular*(1-CritChance-DodgeChance-ParryChance-MissChance)*1 + SwordSpecDMGaverage
	rendDMGaverage = RendDamage*(1-DodgeChance-ParryChance-MissChance)*1*RendDuration/3 + DodgeChance*opDMGaverage
	msDMGaverage = msDMGregular*CritChance*CritMultiplicator + msDMGregular*(1-CritChance-DodgeChance-ParryChance-MissChance)*1 + CritChance*DeepWoundDMG + DodgeChance*opDMGaverage + SwordSpecDMGaverage
	execDMGaverage = execDMGregular*CritChance*CritMultiplicator + execDMGregular*(1-CritChance-DodgeChance-ParryChance-MissChance)*1 + CritChance*DeepWoundDMG + DodgeChance*opDMGaverage + SwordSpecDMGaverage
	
	
	
	-- Format Texts
	local PercAuto = "|C80"..ColorAuto..string.format("%.0f", autoDMGregular/HPmob*100).."%"
	local PercHero = "|C80"..ColorHero..string.format("%.0f", (hsIncreaseDMGregular+autoDMGregular)/HPmob*100).."%"
	local PercRend = "|C80"..ColorRend..string.format("%.0f", RendDamage/HPmob*100).."%"
	local PercMort = "|C80"..ColorMort..string.format("%.0f", msDMGregular/HPmob*100).."%"
	local PercExec = "|C80".."FF0000"..string.format("%.1f", execDMGregular/HPmob*100).."%"
	
	local ValueAuto = "|C80"..ColorAuto..string.format("%.0f", autoDMGregular)
	local ValueHero = "|C80"..ColorHero..string.format("%.0f", hsIncreaseDMGregular+autoDMGregular)
	local ValueRend = "|C80"..ColorRend..string.format("%.0f", RendDamage)
	local ValueMort = "|C80"..ColorMort..string.format("%.0f", msDMGregular)
	local ValueExec = "|C80"..ColorExec..string.format("%.0f", execDMGregular)
	
	local RentabHero = "|C80"..ColorHero..string.format("%.1f", hsIncreaseDMGregular/(15 - ImpHSRank)).."dmg/rage"
	local RentabRend = "|C80"..ColorRend..string.format("%.1f", RendDamage/10*RendDuration/3).."dmg/rage"
	local RentabMort = "|C80"..ColorMort..string.format("%.1f", msDMGregular/30).."dmg/rage"
	local RentabExec = "|C80"..ColorExec..string.format("%.1f", execDMGregular/ExecTotalCost).."dmg/rage"

	
	local autoDMGaverageTEXT = "|C80"..ColorAuto..string.format("%.0f", autoDMGaverage)
	local hsIncreaseDMGaverageTEXT = "|C80"..ColorHero..string.format("%.0f", hsIncreaseDMGaverage+autoDMGaverage)
	local rendDMGaverageTEXT = "|C80"..ColorRend..string.format("%.0f", rendDMGaverage)
	local msDMGaverageTEXT = "|C80"..ColorMort..string.format("%.0f", msDMGaverage)
	local execDMGaverageTEXT = "|C80"..ColorExec..string.format("%.0f", execDMGaverage)	
	
	local autoDMGaveragePERC = "|C80"..ColorAuto..string.format("%.0f", autoDMGaverage/HPmob*100).."%"
	local hsIncreaseDMGaveragePERC = "|C80"..ColorHero..string.format("%.0f", (hsIncreaseDMGaverage+autoDMGaverage)/HPmob*100).."%"
	local rendDMGaveragePERC = "|C80"..ColorRend..string.format("%.0f", rendDMGaverage/HPmob*100).."%"
	local msDMGaveragePERC = "|C80"..ColorMort..string.format("%.0f", msDMGaverage/HPmob*100).."%"
	local execDMGaveragePERC = "|C80"..ColorExec..string.format("%.0f", execDMGaverage/HPmob*100).."%"

	local hsIncreaseDMGaverageRENTA = "|C80"..ColorHero..string.format("%.1f", hsIncreaseDMGaverage/(15 - ImpHSRank)).."dmg/rage"
	local rendDMGaverageRENTA = "|C80"..ColorRend..string.format("%.1f", rendDMGaverage/10).."dmg/rage"
	local msDMGaverageRENTA = "|C80"..ColorMort..string.format("%.1f", msDMGaverage/30).."dmg/rage"
	local execDMGaverageRENTA = "|C80"..ColorExec..string.format("%.1f", execDMGaverage/ExecTotalCost).."dmg/rage"
	
	
	--Text Update
	customDamagePercframeText:SetText(PercAuto.."\n"..PercHero.."\n"..PercRend.."\n"..PercMort.."\n"..PercExec)
	customDamageframeText:SetText(ValueAuto.."\n"..ValueHero.."\n"..ValueRend.."\n"..ValueMort.."\n"..ValueExec)
	customDamageRentabframeText:SetText(" ".."\n"..RentabHero.."\n"..RentabRend.."\n"..RentabMort.."\n"..RentabExec)
	
	customDamagePercREALframeText:SetText(autoDMGaveragePERC.."\n"..hsIncreaseDMGaveragePERC.."\n"..rendDMGaveragePERC.."\n"..msDMGaveragePERC.."\n"..execDMGaveragePERC)
	customDamageREALframeText:SetText(autoDMGaverageTEXT.."\n"..hsIncreaseDMGaverageTEXT.."\n"..rendDMGaverageTEXT.."\n"..msDMGaverageTEXT.."\n"..execDMGaverageTEXT)
	customDamageRentabREALframeText:SetText(" ".."\n"..hsIncreaseDMGaverageRENTA.."\n"..rendDMGaverageRENTA.."\n"..msDMGaverageRENTA.."\n"..execDMGaverageRENTA)	
end

	------------------------------------------------
	-------------		Fonctions XP	------------
	------------------------------------------------
function UpdateXP(XPGain, IsMob)

	local CurXP = UnitXP("player")
	local MaxXP = UnitXPMax("player")
	local XPGainPercent
	
	if not (MaxXP == CF_PreviousXPMax) then
		XPGainPercent = (CurXP / MaxXP + (XPGain - CurXP)/CF_PreviousXPMax)*100
		print(XPGainPercent.."%")
		print(XPGainPercent.."%")
		print(XPGainPercent.."%")
		print(XPGainPercent.."%")
	else
		XPGainPercent = (XPGain / MaxXP) * 100
	end
	
	if not CF_XPGainsTable then 
		CF_XPGainsTable = {}
	end
	
	tinsert(CF_XPGainsTable, {time(), XPGain, XPGainPercent, IsMob})
	CF_MySessionXP[1] = CF_MySessionXP[1] + XPGain
	CF_MySessionXP[2] = CF_MySessionXP[2] + XPGainPercent
	if IsMob then
		CF_MySessionXP[3] = CF_MySessionXP[3] + XPGainPercent
	else
		CF_MySessionXP[4] = CF_MySessionXP[4] + XPGainPercent
	end
	-- /run t = CF_XPGainsTable[1] print(t[1].."   "..t[2].."   "..t[3])
	
	CF_PreviousXPMax = MaxXP
end

local function UpdateXPframe()

	local curTime = time()
	local LogTime = curTime - CF_LogStartTime
	-- local SessionTime = curTime - LoginTime
	
	
	
	-- Open Cat if needed
	local nextCatTableToOpen = XPCats[CF_nextCatNumberToOpen]
	local lastCatTableOpened = XPCats[CF_lastCatNumberOpened]
	
	if LogTime < VeryFirstCatTable[1] or CF_lastCatNumberOpened == getn(XPCats) then -- rien faire
		-- print("trop tot, ou tout ouvert"..LogTime)
	elseif nextCatTableToOpen and LogTime >= nextCatTableToOpen[1] then -- open une new caté
		CF_lastCatNumberOpened = CF_nextCatNumberToOpen
		CF_nextCatNumberToOpen = CF_nextCatNumberToOpen + 1
		nextCatTableToOpen = XPCats[CF_nextCatNumberToOpen]
		lastCatTableOpened = XPCats[CF_lastCatNumberOpened]
		-- print(CF_lastCatNumberOpened.." lastCatTableOpened")
	end
	
	
	
	-- Ajouter l'xp aux cats ouvertes
	if CF_lastCatNumberOpened and CF_XPGainsTable then
		for i = 1, CF_lastCatNumberOpened do
			local tempXPCats = XPCats[i]
			
			for j = 1, getn(CF_XPGainsTable) do
				local tempXPGainsTable = CF_XPGainsTable[j]
				
				if (curTime - tempXPGainsTable[1]) <= tempXPCats[1] then
					OpenedCatsXPTable[i] = OpenedCatsXPTable[i] + tempXPGainsTable[2]
					OpenedCatsXPPercTable[i] = OpenedCatsXPPercTable[i] + tempXPGainsTable[3]
					if tempXPGainsTable[4] then
						OpenedCatsXPMobAndRatioTable[i] = OpenedCatsXPMobAndRatioTable[i] + tempXPGainsTable[3]
						-- print("ajout comme mob  "..ComputeNumber(tempXPGainsTable[3], 2).."%")
					else
						OpenedCatsXPQuestTable[i] = OpenedCatsXPQuestTable[i] + tempXPGainsTable[3]
						-- print("ajout comme quest  "..ComputeNumber(tempXPGainsTable[3], 2).."%")
					end
				end
			end
		end
	end
	
	
	
	-- Supprimer l'entrée des entrées plus vielles que VeryLastCatTable
	--undone
	--undone
	--undone
	
	
	
	--Formater le texte des Tables
	for i = 1, getn(XPCats) do
		local temppTable = XPCats[i]
		local temppVal = (ComputeNumber(OpenedCatsXPPercTable[i]/temppTable[1]*3600, 0).."%/h")
		local tempSomme = OpenedCatsXPMobAndRatioTable[i] + OpenedCatsXPQuestTable[i]
		-- print(ComputeNumber(OpenedCatsXPPercTable[i]/tempTable[1]*3600).."%/heure")
		OpenedCatsXPTable[i] = ComputeNumber(OpenedCatsXPTable[i], 0).."xp"
		OpenedCatsXPPercTable[i] = ComputeNumber(OpenedCatsXPPercTable[i], 1).."%"
		OpenedCatsXPHourTable[i] = temppVal
		
		if tempSomme == 0 then
			OpenedCatsXPMobAndRatioTable[i] = "0/0"
		else
			OpenedCatsXPMobAndRatioTable[i] = ComputeNumber(OpenedCatsXPMobAndRatioTable[i] / tempSomme * 100, 0).."/"..ComputeNumber(OpenedCatsXPQuestTable[i] / tempSomme * 100, 0)
		end
	end
	

	--Assembler les tables et set le texte
	if CF_lastCatNumberOpened then
		-- assemblage texte main timers
		local tempText1 = ""
		local tempText2 = ""
		local tempText3 = ""
		local tempText7 = ""

		for i = 1, CF_lastCatNumberOpened do
			tempText1 = tempText1..OpenedCatsXPTable[i].."\n"
			tempText2 = tempText2..OpenedCatsXPPercTable[i].."\n"
			tempText3 = tempText3..OpenedCatsXPHourTable[i].."\n"
			tempText7 = tempText7..OpenedCatsXPMobAndRatioTable[i].."\n"
		end
		
		-- assemblage texte session
		local tempSomme = CF_MySessionXP[3] + CF_MySessionXP[4]
		local tempText8
		
		local tempText4 = ComputeNumber((CF_MySessionXP[1]), 0).."xp\n"
		local tempText5 = ComputeNumber((CF_MySessionXP[2]), 1).."%\n"
		local tempText6 = ComputeNumber((CF_MySessionXP[2]/LogTime*3600), 0).."%/h\n"
		local tempText8 = ComputeNumber(CF_MySessionXP[3] / tempSomme * 100, 0).."/"..ComputeNumber(CF_MySessionXP[4] / tempSomme * 100, 0)
		
		if tempSomme == 0 then
			tempText8 = "0/0"
		else
			tempText8 = ComputeNumber(CF_MySessionXP[3] / tempSomme * 100, 0).."/"..ComputeNumber(CF_MySessionXP[4] / tempSomme * 100, 0)
		end
		
		--text spacers
		local spacer = strrep("\n", (getn(XPCats) - CF_lastCatNumberOpened))
		
		-- set text
		customXPValsframeText:SetText(tempText1..spacer..tempText4)
		customXPPercframeText:SetText(tempText2..spacer..tempText5)
		customXPHourframeText:SetText(tempText3..spacer..tempText6)
		customXPRatioframeText:SetText(tempText7..spacer..tempText8)
	end
	
	
	-- print("1: "..OpenedCatsXPTable[1].."("..OpenedCatsXPPercTable[1]..")   2: "..OpenedCatsXPTable[2].."("..OpenedCatsXPPercTable[2]..")   3: "..OpenedCatsXPTable[3].."("..OpenedCatsXPPercTable[3]..")   4: "..OpenedCatsXPTable[4].."("..OpenedCatsXPPercTable[4]..")")
	-- reset ce qu'il faut
	OpenedCatsXPTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	OpenedCatsXPPercTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	OpenedCatsXPHourTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	OpenedCatsXPMobAndRatioTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	OpenedCatsXPQuestTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

end

	------------------------------------------------
	-------------	Fonctions Générales	------------
	------------------------------------------------
function ComputeNumber(num, decim)
	num = tonumber(num)
	
	local decim2
	if not (decim) then
		decim = 2
		decim2 = 1
	end
	decim2 = decim
	tonumber(decim)
	
	if num >= 1000000 then
		num = string.format("%.0f", num)
		return (strsub(tostring(num), 1, -7)..","..strsub(tostring(num), -6, -4).."m")
	elseif num >= 10000 then
		num = string.format("%.0f", num)
		return strsub(tostring(num), 1, -4).." "..strsub(tostring(num), -3)
	elseif num >= 10 and num < 100 then
		return string.format("%."..decim2.."f", num)
	elseif num < 10 then

		return string.format("%."..decim.."f", num)
	else
		return tostring(string.format("%.0f", num))
	end
end

function print(text)
	DEFAULT_CHAT_FRAME:AddMessage(text)
end

	------------------------------------------------
	----------------	OnUpdate	----------------
	------------------------------------------------
function CustomFrames_OnUpdate()
	TSLU1 = TSLU1 + 1
	TSLU2 = TSLU2 + 1
	-- TSLU3 = TSLU3 + 1
		if (TSLU1 > 40) then
			
			-- UpdateDamages()
			UpdateXPframe()
			TSLU1 = 0
		end	
		
		if (TSLU2 > 10) then
			-- UpdateRend()
			-- UpdateHS()
			TSLU2 = 0
		end
		
	-- if UnitAffectingCombat("player") == 1 and (previousSwing + UnitAttackSpeed("player")) < GetTime() then
	if UnitAffectingCombat("player") == 1 then
		customSwingBar:Show();
		UpdateSwingBar()
	else
		-- customSwingBar:Hide();
	end
		-- if (TSLU3 > 100) then
			
			-- TSLU3 = 0
		-- end
end


