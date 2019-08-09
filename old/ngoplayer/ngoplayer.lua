	------------------------------------------------/run print(tostring(PlayerHitIndicator:GetValue()))
	----------------	CONSTANTES	----------------/run PlayerHitIndicator:Hide()
	------------------------------------------------/run print(tostring(PlayerHitIndicator))

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------
local ComputeNumber;

local self
local pf = PlayerFrame;
local pfhb = PlayerFrameHealthBar;
local pfmb = PlayerFrameManaBar;

local FadeTime = 5;
local Mp5Time = 6;
local MaxAlpha = 1
-- local tslu = 0;
local lu;

local ngoplayer_onupdate;
	------------------------------------------------
	----------------	OnLoad		----------------
	------------------------------------------------
local function setframesmeta()
	self.f.hpa:SetPoint("CENTER", 91, 19)
	self.f.hpat:SetTextColor(1,1,1,0.75)
	self.f.hpat:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	self.f.hpat:SetText("lol")
	
	self.f.hpp:SetPoint("CENTER", 14, 18)
	self.f.hppt:SetTextColor(1,1,1,0.6)
	self.f.hppt:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	
	self.f.hpn:SetPoint("CENTER", -33, 20)
	self.f.hpnt:SetTextColor(1,1,0,0.83)
	self.f.hpnt:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
	
	self.f.hpl:SetPoint("CENTER", -37, 0)
	self.f.hplt:SetTextColor(1,1,0,0.83)
	self.f.hplt:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
	
	self.f.maa:SetPoint("CENTER", 91, -12)
	self.f.maat:SetTextColor(0,0.65,1,0.83)
	self.f.maat:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
	
	self.f.map:SetPoint("CENTER", 14, -13)
	self.f.mapt:SetTextColor(0,0.65,1,0.83)
	self.f.mapt:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	
	self.f.mat:SetPoint("RIGHT", 7, -13)
	self.f.matt:SetTextColor(0.15,0.75,1.,0.95)
	self.f.matt:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	
	self.f.man:SetPoint("RIGHT", 7, -13)
	self.f.mant:SetTextColor(0.15,0.75,1.,0.95)
	self.f.mant:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	
	return ;
end

local function settextfuncs()
	function self.f.hpa.UpdateText() -- HP absolute text
		if (self.hpa) then
			self.f.hpat:SetText(ComputeNumber(self.hpa, 0));
		end
	end
	
	function self.f.hpp.UpdateText() -- HP percent text
		if (self.hpm and self.hpa) then
			self.f.hppt:SetText(ComputeNumber(self.hpa * 100 / self.hpm , 1).."%");
		end
	end
	
	function self.f.hpn.UpdateText(delta) -- HP loss left text
		if (delta > 0 and self.hpa) then
			self.f.hpnt:SetText("x"..tostring(ceil(self.hpa / delta)));
		end
	end
	
	function self.f.hpl.UpdateText(delta) -- HP loss text
		if (delta > 0) then
			self.f.hplt:SetText("-"..tostring(delta));
		end
	end
	
	function self.f.maa.UpdateText() -- Mana absolute text
		if (self.maa) then
			self.f.maat:SetText(ComputeNumber(self.maa, 0));
		end
	end
	
	function self.f.map.UpdateText() -- Mana percent text
		if (self.mam and self.maa) then
			self.f.mapt:SetText(ComputeNumber(self.maa * 100 / self.mam , 0).."%");
		end
	end
	
	function self.f.mat.UpdateText() -- Mp5 time left text
		if (self.mp5 and self.mp5 > 0) then
			self.f.matt:SetText("-"..ComputeNumber(self.mp5 , 1));
		end
	end
	
	function self.f.man.UpdateText(delta) -- Mana tick left text
		if (self.mam and self.maa and delta > 0) then
			if (self.mam == self.maa) then
				self:DisableMananum()
			else
				self.f.man:Show();
				self.f.mant:SetText("x"..tostring(ceil((self.mam - self.maa) / delta)));
			end
		end
	end
end

local function setfuncs()
	-- HP absolute change events function
	function self:OnHpaChanged(old, new)
		self.f.hpa.UpdateText();
		self.f.hpp.UpdateText();
		if (old and new and old < new) then
			self.f.hpn.UpdateText(new - old);
			self.f.hpl.UpdateText(new - old);
			self:FadeLossInit(value);
		end
	end
	function self:SetHpa(value)
		local old = self.hpa;
		self.hpa = value;
		if (old ~= value) then
			self:OnHpaChanged(value, old);
			return 1;
		else 
			return 0;
		end
	end
	-- HP max change events function
	function self:OnHpmChanged(old, new)
		if (self:SetHpa(pfhb:GetValue()) == 0) then
			self.f.hpp.UpdateText()
		end
	end
	function self:SetHpm(value)
		local old = self.hpm;
		self.hpm = value;
		if (old ~= value) then
			self:OnHpmChanged(old, value);
			return 1;
		else 
			return 0;
		end
	end
	-- Hp loss events function
	function self:FadeLossInit()
		self.fade = FadeTime;
		self.f.hpn:SetAlpha(MaxAlpha);
		self.f.hpl:SetAlpha(MaxAlpha);
	end
	
	function self:FadeLoss(elapsed)
		self.fade = self.fade - elapsed;
		self.f.hpn:SetAlpha(MaxAlpha * self.fade / FadeTime);
		self.f.hpl:SetAlpha(MaxAlpha * self.fade / FadeTime);
	end
	-- Mana absolute change events function
	function self:OnMaaChanged(old, new)
		self.f.maa.UpdateText();
		self.f.map.UpdateText();
		if (old and new) then
			if (old > new) then
				self:DisableMananum()
				self:Mp5Init()
			elseif (old < new) then
				self:Mp5Disable()
				self:SetMananum(new - old)
			end
		end
	end
	function self:SetMaa(value)
		local old = self.maa;
		self.maa = value;
		if (old ~= value) then
			self:OnMaaChanged(old, value);
			return 1;
		else 
			return 0;
		end
	end
	-- Mana max change events function
	function self:OnMamChanged(old, new)
		if (self:SetMaa(pfmb:GetValue()) == 0) then
			self.f.map.UpdateText()
		end
	end
	function self:SetMam(value)
		local old = self.mam;
		self.mam = value;
		if (old ~= value) then
			self:OnMamChanged(old, value);
			return 1;
		else 
			return 0;
		end
	end
	-- Mp5 events function
	function self:Mp5Init()
		self.mp5 = Mp5Time;
		self.f.mat:Show()
		self.f.mat.UpdateText()
	end
	function self:Mp5Do(elapsed)
		self.mp5 = self.mp5 - elapsed;
		self.f.mat.UpdateText()
	end
	function self:Mp5Disable()
		self.mp5 = 0;
		self.f.mat:Hide()
	end
	-- Mana gain events function
	function self:SetMananum(elapsed)
		self.f.man.UpdateText(elapsed)
	end
	function self:DisableMananum()
		self.f.man:Hide()
	end
	return ;
end

function ngoplayer_onload()
	self = ngoplayer;

	if (self == nil) then
		print("ngoplayer frame not found ! :'(");
	end
	self:SetPoint("CENTER", 0, 0);
	setframesmeta()
	settextfuncs()
	setfuncs()
	
	
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_LEVEL_UP")
	self:RegisterEvent("BAG_UPDATE")
	self:RegisterEvent("UNIT_AURA")
end

	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------
function ngoplayer_onevent(event, arg1, arg2, ...)

	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		
		pfhb:SetScript("OnValueChanged", function()
			self:SetHpa(pfhb:GetValue())
		end)
		pfmb:SetScript("OnValueChanged", function()
			self:SetMaa(pfmb:GetValue())
		end)
		self:SetHpa(pfhb:GetValue())
		self:SetMaa(pfmb:GetValue())
		
		lu = GetTime()
		self:SetScript("OnUpdate", ngoplayer_onupdate);
		pf.name:Hide()
		PlayerHitIndicator.Show = function() end
		-- for k, v in pairs (self.f) do
			-- print(tostring(k).."("..tostring(v)..")");
		-- end
		-- local i = 0;
		-- for k, v in pairs (getfenv()) do
			-- print(tostring(k).."("..tostring(v)..")");
			-- i = i + 10;
			-- if (i > 100) then
				-- return ;
			-- end
		-- end
	end
	
	if (event == "PLAYER_LEVEL_UP") then
		self:SetHpm(UnitHealthMax("player"))
		self:SetMam(UnitManaMax("player"))
	end
	
	if (event == "BAG_UPDATE") then
		self:SetHpm(UnitHealthMax("player"))
		self:SetMam(UnitManaMax("player"))
	end
	
	if (event == "UNIT_AURA" and arg1 == "player") then
		self:SetHpm(UnitHealthMax("player"))
		self:SetMam(UnitManaMax("player"))
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

function ngoplayer_setDoubleParentKey(child, parent)
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
function ngoplayer_onupdate()
	local elapsed = GetTime() - lu;
	lu = GetTime();
	if (self.fade and self.fade > 0) then
		self:FadeLoss(elapsed)
	end
	if (self.mp5 and self.mp5 > 0) then
		self:Mp5Do(elapsed)
	end
end
