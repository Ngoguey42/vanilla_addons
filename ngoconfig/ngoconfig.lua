	------------------------------------------------
	----------------	CONSTANTES	----------------
	------------------------------------------------

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------

local self
local _G = getfenv() or {}


local ngoconfig_onupdate;
	------------------------------------------------
	----------------	OnLoad		----------------
	------------------------------------------------
local function setframesmeta()

	return ;
end

local function settextfuncs()

end

local function setfuncs()

end

function ngoconfig_onload()
	self = ngoconfig;

	if (self == nil) then
		print("ngoconfig frame not found ! :'(");
	end
	self:SetPoint("CENTER", 0, 0);
	setframesmeta()
	settextfuncs()
	setfuncs()


	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UI_INFO_MESSAGE")
end

	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------
function ngoconfig_onevent(event, arg1, arg2, ...)

	if (event == "UI_INFO_MESSAGE" and GetNumPartyMembers() > 0) then
		SendChatMessage(arg1, "PARTY");
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")



		-- /script SetCVar("targetNearestDistance", 10)
		-- /script GetCVar("cameraDistanceMaxFactor")
		-- /console farclip 100
		-- /script RestartGx()
		-- "showLootSpam" "UberTooltips" "TargetAnim" "shadowLOD" "cameraTerrainTiltAlwaysIdleDelay"

		-- /script SetCVar("cameraSmoothStyle", 10)
		--[[
		-
ActionBar page 1: slots 1 to 12 -- Note exceptions below for other classes
ActionBar page 2: slots 13 to 24
ActionBar page 3 (Right ActionBar): slots 25 to 36
ActionBar page 4 (Right ActionBar 2): slots 37 to 48
ActionBar page 5 (Bottom Right ActionBar): slots 49 to 60
ActionBar page 6 (Bottom Left ActionBar): slots 61 to 72
/script SetActionBarToggles(1,1,1,1); MultiActionBar_Update(); UIParent_ManageFramePositions();

		-- /script print(tostring(string.find("printcvdar", ".*[cC][vV][aA][rR].*")))
		-- /script print(tostring(SetBinding))

/script
	for k, v in pairs (getfenv()) do
		if type(k) == "string"
			and type(v) == "function"
			and string.find(k, ".*GetContainer.*") then
			print(tostring(k).."("..tostring(v)..")");
		end
	end

		SetCVar
/script arr = {"cameraYawSmoothSpeed", "cameraYawMoveSpeed", "cameraTargetSmoothSpeed",
"cameraPitchSmoothSpeed", "cameraPitchMoveSpeed", "cameraHeightSmoothSpeed",
"cameraGroundSmoothSpeed", "cameraFoVSmoothSpeed", "cameraDistanceSmoothSpeed",
"cameraDistanceMoveSpeed", "cameraBobbingSmoothSpeed"}
		for _, v in pairs (string) do
			print(tostring(k).."("..tostring(v)..")");
		end



		/script
		for k, v in pairs (string) do
			print(tostring(k).."("..tostring(v)..")");
		end
		]]--


		-- /script

		local slots_to_clean = {
		      1, 2, 3, 4, 5, 6
		     }
		local spells = {
			["Tir automatique"] = 26,
			["Berserker"] = 66, --TROLL
			["Forme de pierre"] = 66, --DWARF
			["Découverte de trésors"] = 27, --DWARF
			["Attaque"] = 11,
			["Attaque du raptor"] = 12,
		}
		local macroes = {
			["26"] = 1,
			["togti"] = 28,
			["asspe"] = 58,
			["togta"] = 59,
			["relui"] = 40,
			["togcl"] = 60,
		}
		local items = {
			["Pierre de foyer"] = 39,
			["Tête de champignon sylvestre"] = 72,
		}

		local function spellbookIter() --Spellbook iterator
		  local i = 1

		  return function ()
			local spellName, _ = GetSpellName(i, BOOKTYPE_SPELL)

			if spellName == nil then
			  return nil
			end
			i = i + 1
			return i - 1, spellName
		  end
		end

		local function macroIter() --Spellbook iterator
		  local i = 1

		  return function ()
			local name, _, _ = GetMacroInfo(i)

			if name == nil then
			  return nil
			end
			i = i + 1
			return i - 1, name
		  end
		end

		local function inventoryIter() --Inventory iterator
		  local bagId = 0
		  local bagSize = GetContainerNumSlots(bagId) or 0
		  local itemIndex = 1

		  return function ()
			local itemLink = nil
			local itemName

			repeat
			  if itemIndex <= bagSize then
				-- Iter in bag slots, and get item link
				itemLink = GetContainerItemLink(bagId, itemIndex)
				itemIndex = itemIndex + 1
			  elseif bagId < 4 then
				-- Load in next bag, and loop
				bagId = bagId + 1
				bagSize = GetContainerNumSlots(bagId) or 0
				itemIndex = 1
			  else
				-- Iteration done
				return nil
			  end
			until itemLink ~= nil
			itemName = string.gsub(itemLink, "(.+)%[(.-)%](.+)", "%2")
			return bagId, itemIndex - 1, itemName
		  end
		end

		local function placeSpells()

			for _, v in pairs(slots_to_clean) do --Clean requested bar slots
			    PickupAction(v)
			    ClearCursor()
			end

			for sId, sName in spellbookIter() do --Place requested spells
			  local spellSlot = spells[sName]

			  if spellSlot ~= nil then
				PickupSpell(sId, BOOKTYPE_SPELL)
				PlaceAction(spellSlot)
				ClearCursor()
			  end
			end

			for mId, mName in macroIter() do --Place requested macroes
			  local spellSlot = macroes[mName]

				if spellSlot ~= nil then
					PickupMacro(mId)
					PlaceAction(spellSlot)
					ClearCursor()
				end
			end

			for bagId, slotId, iName in inventoryIter() do --Place req. items
			  local spellSlot = items[iName]

			  if spellSlot ~= nil then
				PickupContainerItem(bagId, slotId);
				PlaceAction(spellSlot)
				ClearCursor();
			  end
			end

		end

		_G["placeSpells"] = placeSpells

		-- /script placeSpells()
		-- /script setConfig();

		local function setConfig()

			SetActionBarToggles(1, 1, 1, 1);
			SHOW_MULTI_ACTIONBAR_1 = 1;
			SHOW_MULTI_ACTIONBAR_2 = 1;
			SHOW_MULTI_ACTIONBAR_3 = 1;
			SHOW_MULTI_ACTIONBAR_4 = 1;
			MultiActionBar_Update();

			SetCVar("targetNearestDistance", 50);
			SetCVar("targetNearestDistanceRadius", 10); -- Does not really work on small values
			SetCVar("cameraDistanceMax", 50);
			SetCVar("cameraDistanceMaxFactor", 1); -- Not really usefull
			SetCVar("cameraDistanceMoveSpeed", 50);

			placeSpells();

		end

		_G["sc"] = setConfig

		-- PlaceAction(slot)
		-- CursorHasSpell()
		-- ClearCursor()
		-- PickupMacro("macroName" or index)
		-- ResetCursor()
		-- PickupSpell("spellName" | spellID, "bookType")
		-- /script PickupSpell("Tir automatique")
		-- /script PickupSpell("Auto Shot")
		-- /script PickupSpell(1, BOOKTYPE_SPELL)
		-- /script spellName, spellRank = GetSpellName(42, BOOKTYPE_SPELL); print(tostring(spellName) ..":".. tostring(spellRank));
		-- /script print(tostring(GetSpellName));
		-- /script print(tostring(GetContainerNumSlots));
		-- /script print(tostring(GetContainerNumSlots(2)));
		-- /script print(tostring(GetItemInfo));
		-- /script print(tostring());
		-- /script print(tostring(GetMacroInfo));



		arr = {}
		for _, v in pairs (arr) do
			-- SetCVar(v, GetCVarDefault(v))
			SetCVar(v, 0.5)
			print("SET:"..tostring(v).."("..tostring(GetCVar(v))..")");
		end

		arr = {
		-- "cameraYawMoveSpeed", "cameraPitchMoveSpeed", "cameraYawSmoothSpeed", "cameraTargetSmoothSpeed",
			-- "cameraPitchSmoothSpeed", "cameraHeightSmoothSpeed",
			-- "cameraGroundSmoothSpeed", "cameraFoVSmoothSpeed", "cameraDistanceSmoothSpeed",
			-- "cameraBobbingSmoothSpeed",
			-- "cameraSmoothTimeMax", "cameraTerrainTiltTimeMin", "cameraTerrainTiltTimeMax", "cameraSmoothStyle"
			}
		for _, v in pairs (arr) do
			SetCVar(v, GetCVarDefault(v))
			print("Reset: "..tostring(v).."("..tostring(GetCVar(v))..")");
		end




		-- arr = {"cameraDistanceMax"; "cameraDistanceMaxFactor"; "cameraDistanceMoveSpeed"; "cameraSmoothStyle"; "cameraDistanceSmoothSpeed"};
		-- for _, v in pairs (arr) do
			-- print(tostring(v).."("..tostring(GetCVar(v))..")");


		-- end



		-- self:SetScript("OnUpdate", ngoconfig_onupdate);
	end
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

function ngoconfig_setDoubleParentKey(child, parent)
	local pname, cname, key;

	if (parent.f == nil) then
		parent.f = {};
	end
	pname = parent:GetName();
	cname = child:GetName();
	key = string.sub(cname, string.len(pname) + 1);
	parent.f[key] = child;
	key = key.."t"
	parent.f[key] = getfenv()[pname..key];
end

	------------------------------------------------
	----------------	OnUpdate	----------------
	------------------------------------------------
function ngoconfig_onupdate()

end
