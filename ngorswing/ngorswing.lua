	------------------------------------------------
	----------------	CONSTANTES	----------------
	------------------------------------------------
local framewidth = 272

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------

local tslu = 0;
local deltaup = 0.10;
local tslu2 = 0;
local deltaup2 = 1.0;
local indicator_len = 0.5;
local lasttime = 0;
local autorepeat_status;
local self
local prevswing
local tab = {
	["ITEM_LOCK_CHANGED"] = 0,
	["BAG_UPDATE"] = 0,
	["UNIT_INVENTORY_CHANGED"] = 0,
	["UPDATE_INVENTORY_ALERTS"] = 0,
	-- ["SPELLCAST_STOP"] = 0,
	["ACTIONBAR_UPDATE_COOLDOWN"] = 0,
	["SPELL_UPDATE_COOLDOWN"] = 0
};

local onupdate;
	------------------------------------------------
	----------------	OnLoad		----------------
	------------------------------------------------
local function setframesmeta()
	self.f.bar:SetPoint("CENTER", -86, -224)
	self.f.bar:SetWidth(framewidth);
	self.f.bar:SetHeight(18);
	
	-- self.f.overshoot:SetPoint("LEFT", self.f.bar, "RIGHT", 0, 0);
	-- self.f.overshoot:SetWidth(0);
	-- self.f.overshoot:SetHeight(18);
	-- self.f.overshoot:SetStatusBarColor(0.6, 0.0, 0.4, 0.75);
	
	self.f.overshoot:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	})
	self.f.overshoot:SetBackdropColor(1, 0.0, 0.4, 0.75);
	self.f.overshoot:SetHeight(18);
	self.f.overshoot:SetPoint("LEFT", self.f.bar, "RIGHT", 0, 0);
	self.f.overshoot:Show();
	
	self.f.lag:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	})
	self.f.lag:SetBackdropColor(0.0, 0.0, 1, 0.6);
	self.f.lag:SetHeight(18);
	self.f.lag:SetPoint("RIGHT", self.f.bar, "RIGHT", 0, 0);
	self.f.lag:Show();
	
	self.f.indicator:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
	})
	self.f.indicator:SetBackdropColor(0.5, 0.5, 0.5, 1);
	self.f.indicator:SetHeight(18 / 2.5);
	self.f.indicator:SetPoint("TOPRIGHT", self.f.bar, "TOPRIGHT", 0, 0);
	self.f.indicator:Show();
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
	-- self:RegisterEvent("SPELLCAST_STOP")
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

	lasttime = GetTime();
	tslu = 0;
	tslu2 = 0;
	self:SetAutorepeatStateOFF();
	self.f.bar:SetValue(GetTime())
	self.f.bar:SetMinMaxValues(prevswing, prevswing + UnitRangedDamage("player"));
	local _, _, lag = GetNetStats();
	self.f.lag:SetWidth(lag / (UnitRangedDamage("player") * 1000) * self.f.bar:GetWidth());
	-- for k, v in pairs (self.f.bg) do
		-- print(tostring(k).."("..tostring(v)..")");
	-- end
end
	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------

local function all_proced()
	local t = GetTime();
	-- local str= "";
	-- local i = 0;
	-- for k, v in pairs(tab) do
		-- if (GetTime() - v > 0.035) then
			-- i = i +1;
			-- str = str.."["..k.."]="..tostring(GetTime() - v).." "
		-- end
	-- end
	-- if (i < 2) then
		-- print(str);
	-- end
	for k, v in pairs(tab) do
		if (GetTime() - v > 0.025) then
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
				-- print("Swing");
				prevswing = GetTime();
			-- else
			-- print("spells");
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
	local curtime = GetTime();
	local diff = curtime - prevswing - UnitRangedDamage("player");

	tslu = tslu + (curtime - lasttime);
	tslu2 = tslu2 + (curtime - lasttime);
	lasttime = curtime;
	if (diff < 0) then
		self.f.bar:SetValue(curtime);
		if ((- diff) < indicator_len) then
			self.f.overshoot:Hide();
		end
	elseif (diff < 0.5) then
		self.f.overshoot:Show();
		self.f.overshoot:SetWidth((curtime - prevswing - UnitRangedDamage("player")) / UnitRangedDamage("player") * self.f.bar:GetWidth());
	end
	if (tslu > deltaup) then
		tslu = 0;
		self.f.bar:SetMinMaxValues(prevswing, prevswing + UnitRangedDamage("player"));
	end
	if (tslu2 > deltaup2) then
		tslu2 = 0;
		local _, _, lag = GetNetStats();
		self.f.lag:SetWidth(lag / (UnitRangedDamage("player") * 1000) * self.f.bar:GetWidth());
		self.f.indicator:SetWidth(indicator_len / UnitRangedDamage("player") * self.f.bar:GetWidth()); 
	end
	-- print(lag / (UnitRangedDamage("player") * 1000) * self.f.bar:GetWidth());
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
