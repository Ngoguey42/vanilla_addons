------------------------------------------------
----------------  CONSTANTES  ----------------
------------------------------------------------

------------------------------------------------
----------------  VARIABLES  ----------------
------------------------------------------------

local self
local _G = getfenv() or {}


local ngoconfig_onupdate;
------------------------------------------------
----------------  OnLoad    ----------------
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
----------------  OnEvent    ----------------
------------------------------------------------
function ngoconfig_onevent(event, arg1, arg2, ...)

  if (event == "UI_INFO_MESSAGE" and GetNumPartyMembers() > 0) then
    SendChatMessage(arg1, "PARTY");
  end
  if (event == "PLAYER_ENTERING_WORLD") then
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")

    local slots_to_clean = {
      1, 2, 3, 4, 5, 6
    }
    local spells = {
      ["Berserking"] =          60 + 6, --TROLL
      ["Attack"] =               0 + 11,

      ["Auto Shot"] =           24 + 2, -- for range 35
      ["Raptor Strike"] =        0 + 12,
      ["Track Beasts"] =        24 + 3,
      ["Aspect of the Monkey"] =60 + 1,
      ["Serpent Sting"] =        0 + 3,
      ["Arcane Shot"] =          0 + 2,
      ["Hunter's Mark"] =        0 + 7,
      ["Concussive Shot"] =      0 + 4,
      ["Beast Training"] =      36 + 8,
      ["Call Pet"] =            60 + 11,
      ["Dismiss Pet"] =         48 + 8,
      ["Feed Pet"] =            48 + 3,
      ["Revive Pet"] =          36 + 9,
      ["Tame Beast"] =          24 + 8,
      ["Aspect of the Hawk"] =  60 + 3,
      ["Track Humanoids"] =     36 + 4,
      -- ["Distracting Shot"] = ,
      ["Mend Pet"] =            60 + 9,
      ["Wing Clip"] =            0 + 10, -- for range 5
      -- ["Eagle Eye"] = ,
      -- ["Eyes of the Beast"] = ,
      ["Scare Beast"] =         24 + 1, -- for range 10
      -- ["Mongoose Bite"] = ,
      ["Immolation Trap"] =      0 + 6,
      -- ["Multi-Shot"] = ,
      -- ["Track Undead"] = ,
      ["Aspect of the Cheetah"] =60+ 2,
      -- ["Disengage"] = ,
      ["Freezing Trap"] =       48 + 6,
      -- ["Scorpid Sting"] = ,
      ["Beast Lore"] =          36 + 2, -- for range 40
      -- ["Track Hidden"] = ,
      ["Rapid Fire"] =          60 + 7,
      -- ["Track Elementals"] = ,
      -- ["Frost Trap"] = ,
      -- ["Aspect of the Beast"] = ,
      ["Feign Death"] =         60 + 10,
      ["Flare"] =               48 + 7,
      -- ["Track Demons"] = ,
      -- ["Explosive Trap"] = ,
      -- ["Viper Sting"] = ,
      ["Aspect of the Pack"] = 60 + 2, -- overlap with Cheetah
      -- ["Track Giants"] = ,
      -- ["Volley"] = ,
      -- ["Aspect of the Wild"] = ,
      -- ["Track Dragonkin"] = ,
      -- ["Tranquilizing Shot"] = ,
      ["Intimidation"] =        48 + 2,
      ["Bestial Wrath"] =       60 + 5,

    }
    local macroes = {
      ["autoshoot"] = 0 + 1,
      ["/ezq"] = 28,
      ["relui"] = 40,

      ["asspe"] = 48 + 10,
      ["togta"] = 48 + 11,
      ["togcl"] = 48 + 12,
    }
    local items = {
      ["Hearthstone"] = 36 + 3,
      ["Forest Mushroom Cap"] = 72,
      ["Cactus Apple Surprise"] = 48 + 4,
      ["Really Sticky Glue"] = 36 + 1, -- for range 30
    }

    local function spellbookIter() --Spellbook iterator
      local i = 1

      return function ()
	local spellName, _ = GetSpellBookItemName(i, BOOKTYPE_SPELL)

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

      print("    Cleaning shits");
      for _, v in pairs(slots_to_clean) do --Clean requested bar slots
	PickupAction(v)
	ClearCursor()
      end

      print("    Placing spells");
      for sId, sName in spellbookIter() do --Place requested spells
        local spellSlot = spells[sName]
	-- print(sId, sName, spellSlot);

        if spellSlot ~= nil then
	  PickupSpellBookItem(sId, BOOKTYPE_SPELL)
	  PlaceAction(spellSlot)
	  ClearCursor()
        end
      end

      print("    Placing macroes");
      for mId, mName in macroIter() do --Place requested macroes
        local spellSlot = macroes[mName]

        if spellSlot ~= nil then
          PickupMacro(mId)
          PlaceAction(spellSlot)
          ClearCursor()
        end
      end

      print("    Placing items");
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

    function setConfig()

      print("Welcome to setConfig");

      print("  Showing the 4bars...");
      SetActionBarToggles(1, 1, 1, 1);
      SHOW_MULTI_ACTIONBAR_1 = 1;
      SHOW_MULTI_ACTIONBAR_2 = 1;
      SHOW_MULTI_ACTIONBAR_3 = 1;
      SHOW_MULTI_ACTIONBAR_4 = 1;
      MultiActionBar_Update();

      -- SetCVar("targetNearestDistance", 50);
      -- SetCVar("targetNearestDistanceRadius", 10); -- Does not really work on small values
      -- SetCVar("cameraDistanceMax", 50);
      -- SetCVar("cameraDistanceMaxFactor", 1); -- Not really usefull
      -- SetCVar("cameraDistanceMoveSpeed", 50);

      print("  Updating cvars...");


      SetCVar("autoLootDefault", 0);
      SetCVar("activeCUFProfile", "Primary");
      SetCVar("cameraSavedDistance", 30.000000);
      SetCVar("nameplateShowEnemies", 1);
      SetCVar("nameplateShowEnemyMinions", 1);
      SetCVar("nameplateShowEnemyPets", 1);
      SetCVar("nameplateShowEnemyGuardians", 1);
      SetCVar("nameplateShowEnemyTotems", 1);
      SetCVar("EJLootClass", 3);

      -- -- Those might not work
      -- SetCVar("autoQuestPopUps", "v");
      -- SetCVar("trackedQuests", "v#+O");
      -- SetCVar("hardTrackedQuests", "v");
      -- SetCVar("trackedWorldQuests", "v");
      -- SetCVar("hardTrackedWorldQuests", "v");
      -- SetCVar("trackedAchievements", "v");
      -- SetCVar("currencyCategoriesCollapsed", "v");
      -- SetCVar("minimapShapeshiftTracking", "v");
      -- SetCVar("reputationsCollapsed", "v##$");

      print("  Updating the 4bars content...");
      placeSpells();

    end
    _G["sc"] = setConfig
    print('/script sc()')

  end
end

------------------------------------------------
-------------  Fonctions Générales  ------------
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
----------------  OnUpdate  ----------------
------------------------------------------------
function ngoconfig_onupdate()

end
