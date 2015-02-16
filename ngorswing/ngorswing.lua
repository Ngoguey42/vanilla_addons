	------------------------------------------------
	----------------	CONSTANTES	----------------
	------------------------------------------------
local framewidth = 272

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------
local autorepeat_status;
local self
local prevswing
local tab = {
	["ITEM_LOCK_CHANGED"] = 0,
	["BAG_UPDATE"] = 0,
	["UNIT_INVENTORY_CHANGED"] = 0,
	["UPDATE_INVENTORY_ALERTS"] = 0,
	["SPELLCAST_STOP"] = 0,
	["ACTIONBAR_UPDATE_COOLDOWN"] = 0,
	["SPELL_UPDATE_COOLDOWN"] = 0
};

local onupdate;
	------------------------------------------------
	----------------	OnLoad		----------------
	------------------------------------------------
local function setframesmeta()
	self.f.bar:SetPoint("CENTER", -86, -224)
	-- self.f.bar:SetBackdropColor(0.5, 0.5, 0.5, 0)
	-- self.f.bar:SetBackdrop( { bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	  -- edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = false, tileSize = 16, edgeSize = 10,
	  -- insets = { left = 3, right = 3, top = 3, bottom = 3}
	-- })
	self.f.bar:SetWidth(framewidth);
	self.f.bar:SetHeight(18);

	-- self.f.bar:SetAlpha(0.45);
	
	-- for k, v in pairs (self.f.bar) do
		-- print(tostring(k).."("..tostring(v)..")");
	-- end
	
	return ;
end

local function settextfuncs()
	function self:SetAutorepeatStateON()
		autorepeat_status = true;
		self.f.bar:SetStatusBarColor(0.1, 0.7, 0., 0.6);
	end
	function self:SetAutorepeatStateOFF()
		autorepeat_status = false;
		self.f.bar:SetStatusBarColor(0.7, 0.1, 0., 0.6);
	end
end

local function setfuncs()
	return ;
end

function ngorswing_onload()
	self = ngorswing;

	if (self == nil) then
		print("ngorswing frame not found ! :'(");
	end

	setframesmeta()
	settextfuncs()
	setfuncs()
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ITEM_LOCK_CHANGED")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	self:RegisterEvent("UPDATE_INVENTORY_ALERTS")
	self:RegisterEvent("SPELLCAST_STOP")
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	-- self:RegisterAllEvents()
end

local function onPLAYER_ENTERING_WORLD()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD");
	prevswing = GetTime();
	self:SetScript("OnUpdate", onupdate);
	self:Show();
	autorepeat_status = false;
	self:SetAutorepeatStateOFF();
	-- for k, v in pairs (self.f.bg) do
		-- print(tostring(k).."("..tostring(v)..")");
	-- end
end
	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------

local function all_proced()
	local t = GetTime();
	for k, v in pairs(tab) do
		if (GetTime() - v > 0.015) then
			return (false);
		end
	end
	return (true);
end

local function is_swing()
	for i = 1, 100 do
		start, duration, enabled = GetActionCooldown(i);
		if (math.abs(start - GetTime()) <= 0.16) then
			return (false);
		end
	end
	return (true);
end

function ngorswing_onevent(event, arg1, arg2, ...)
	if (event == "BAG_UPDATE" or event == "SPELLCAST_STOP" or event == "ITEM_LOCK_CHANGED"
		or event == "UPDATE_INVENTORY_ALERTS" or event == "UNIT_INVENTORY_CHANGED"
		or event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_COOLDOWN") then
		tab[event] = GetTime();
		if (all_proced()) then
			if (is_swing()) then
				prevswing = GetTime();
			end
		end
	end
	
	if (event == "PLAYER_ENTERING_WORLD") then
		onPLAYER_ENTERING_WORLD()
	end
end

	------------------------------------------------
	-------------	Fonctions Générales	------------
	------------------------------------------------
function ngorswing_setDoubleParentKey(child, parent)
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
function onupdate()
	self.f.bar:SetMinMaxValues(prevswing, prevswing + UnitRangedDamage("player"));
	self.f.bar:SetValue(GetTime())
	if (IsAutoRepeatAction(26)) then
		if (not autorepeat_status) then
			self:SetAutorepeatStateON()
		end
	else
		if (autorepeat_status) then
			self:SetAutorepeatStateOFF()
		end
	end
	
end
