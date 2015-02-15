	------------------------------------------------
	----------------	CONSTANTES	----------------
	------------------------------------------------

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------
local ComputeNumber;
local self
local prevswing
local framewidth = 272
local last_UNIT_INVENTORY_CHANGED = 0
local lu;
local ngorswing_onupdate;
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
	-- self.f.bar:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Border", edgeSize = 15})
	self.f.bar:SetWidth(framewidth);
	self.f.bar:SetHeight(18);
	-- self.f.bar:SetAlpha(0.45);

	return ;
end

local function settextfuncs()

	
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

	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------
	
tab = {
	["ITEM_LOCK_CHANGED"] = 0,
	["BAG_UPDATE"] = 0,
	["UNIT_INVENTORY_CHANGED"] = 0,
	["UPDATE_INVENTORY_ALERTS"] = 0,
	["SPELLCAST_STOP"] = 0,
	["ACTIONBAR_UPDATE_COOLDOWN"] = 0,
	["SPELL_UPDATE_COOLDOWN"] = 0
};

local function all_proced()
	local t = GetTime();
	for k, v in pairs(tab) do
		if (GetTime() - v > 0.015) then
			return (false);
		end
	end
	return (true);
end

function print_tab()
	print("["..
	string.format("%3.1f", GetTime() - tab["BAG_UPDATE"]).." "..
	string.format("%3.1f", GetTime() - tab["SPELLCAST_STOP"]).." "..
	string.format("%3.1f", GetTime() - tab["ITEM_LOCK_CHANGED"]).." "..
	string.format("%3.1f", GetTime() - tab["UPDATE_INVENTORY_ALERTS"]).." "..
	string.format("%3.1f", GetTime() - tab["UNIT_INVENTORY_CHANGED"]).." "..
	string.format("%3.1f", GetTime() - tab["ACTIONBAR_UPDATE_COOLDOWN"]).." "..
	string.format("%3.1f", GetTime() - tab["SPELL_UPDATE_COOLDOWN"]).."]");
end

local function is_swing()
	for i = 1, 100 do
		start, duration, enabled = GetActionCooldown(i);
		if (start and math.abs(start - GetTime()) < 10) then
			print(i.." "..start.." "..duration.." "..enabled);
			print(GetTime()..math.abs(start - GetTime()));
		end
		if (math.abs(start - GetTime()) <= 0.16) then
		
			
			return (false);
		end
	end
	return (true);
end

function ngorswing_onevent(event, arg1, arg2, ...)

	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		lu = GetTime()
		prevswing = GetTime();
		self:SetScript("OnUpdate", ngorswing_onupdate);
		self:Show();
		-- for k, v in pairs (self.f.bg) do
			-- print(tostring(k).."("..tostring(v)..")");
		-- end
	end
	if (event == "BAG_UPDATE" or event == "SPELLCAST_STOP" or event == "ITEM_LOCK_CHANGED"
		or event == "UPDATE_INVENTORY_ALERTS" or event == "UNIT_INVENTORY_CHANGED"
		or event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_COOLDOWN") then
		tab[event] = GetTime();
		if (all_proced()) then
			if (is_swing()) then
				print("LOL swing !!");
				prevswing = GetTime();
			else
				print("LOL proc !!");
			end
		end
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
function ngorswing_onupdate()
	local elapsed = GetTime() - lu;

	lu = GetTime();
	self.f.bar:SetMinMaxValues(prevswing, prevswing + UnitRangedDamage("player"));
	self.f.bar:SetValue(GetTime())
end
