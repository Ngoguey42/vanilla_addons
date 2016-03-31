	------------------------------------------------
	----------------	CONSTANTES	----------------
	------------------------------------------------
local MaxDist = 43
local IntFact = 100
local startcolor = {0, 0, 255}
local endcolor = {255, 0, 0}
local framewidth = 272
local BeastString = "Bête"

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------
local self
local lu;

local ngorange_onupdate;
	------------------------------------------------
	----------------	OnLoad		----------------
	------------------------------------------------
local function setframesmeta()
	self.f.bar:SetPoint("CENTER", -86, -254)
	self.f.bar:SetBackdropColor(0.5, 0.5, 0.5, 0)
	self.f.bar:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		tile = false, tileSize = 16, edgeSize = 15,
		insets = { left = 2, right = 2, top = 2, bottom = 2}
	})
	self.f.bar:SetWidth(framewidth);
	self.f.bar:SetHeight(28);
	self.f.bar:SetAlpha(0.45);

	self.f.bart:ClearAllPoints();
	self.f.bart:SetTextColor(1, 1, 1, 0.65)
	self.f.bart:SetFont("Fonts\\FRIZQT__.TTF", 11)
	self.f.bart:SetText("0");

	self.f.cursor:SetParent(self.f.bar);
	self.f.cursor:SetHeight(18);
	self.f.cursor:SetAlpha(0.65);
	self.f.cursor:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = false, tileSize = 16, edgeSize = 15,
		insets = { left = 3, right =3, top = 3, bottom = 3}
	})
	self.f.cursort:SetPoint("TOP", self.f.cursor, "TOP", 0, 4);
	self.f.cursort:SetTextColor(1, 1, 1, 0.65)
	self.f.cursort:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
	
	return ;
end

local function settextfuncs()


end

local function setfuncs()
	function self:UpdateTables()
		self.minRangeActions = {}
		self.arrayRangeActions = {}
		self.BreakPoints = {};
		if (not UnitExists("target") or UnitIsDead("target")) then
			self.f.bar:SetAlpha(0);
			return
		end
		if (UnitIsFriend("player", "target") == nil) then
			if (HasAction(10)) then --wing clip /run print(HasAction(68));
				tinsert(self.minRangeActions, {68, 5})
			end
			if (HasAction(37)) then --sticky truc
				tinsert(self.minRangeActions, {37, 30})
			end
			if (UnitCreatureType("target") == BeastString) then
				if (HasAction(25)) then --beast fear
					tinsert(self.minRangeActions, {25, 10})
				end
				if (HasAction(38)) then --beast lore
					tinsert(self.minRangeActions, {38, 40})
				end
			end
			if (HasAction(26)) then --autoshoot
				tinsert(self.arrayRangeActions, {26, 8, 35})
			end
			self.f.bar:SetAlpha(1);
		else
			self.f.bar:SetAlpha(0.5);
		end
		for k, v in ipairs (self.interactDistances) do
			tinsert(self.BreakPoints, {v[2], 1, v[1]});
		end
		for k, v in ipairs (self.minRangeActions) do
			tinsert(self.BreakPoints, {v[2], 2, v[1]});
		end
		for k, v in ipairs (self.arrayRangeActions) do
			tinsert(self.BreakPoints, {v[2], 3, v[1]});
			tinsert(self.BreakPoints, {v[3], 4, v[1]});
		end
		sort(self.BreakPoints, function (a, b) return a[1] < b[1];end)
		for k, v in ipairs (self.BreakPoints) do
			local str;
			if (v[2] == 2) then
				str = tostring(GetActionTexture(v[3]));
			else
				str = "";
			end
		end
	end

	function self:DetermineRangeArray()
		local maxpossible = MaxDist;
		local minpossible = 0;
		local test;
		for k, v in ipairs (self.BreakPoints) do
			if (v[2] <= 2) then
				if (v[2] == 1) then
					test = CheckInteractDistance("target", v[3]);
				elseif (v[2] == 2) then
					test = IsActionInRange(v[3]);
				end
				if (test and test == 1) then
					maxpossible = v[1];
					break ;
				else
					minpossible = v[1];
				end
			end
		end
		for k, v in ipairs (self.BreakPoints) do
			if (v[2] >= 3 and minpossible < v[1] and maxpossible > v[1]) then
				test = IsActionInRange(v[3]);
				if (v[2] == 3) then
					if (test) then
						minpossible = v[1];
					else
						maxpossible = v[1];
					end
				elseif (v[2] == 4) then
					if (test and test == 1) then
						maxpossible = v[1];
					else
						minpossible = v[1];
					end
				end
			end
		end
		if (self.minv ~= minpossible or self.maxv ~= maxpossible) then
			self.minv = minpossible;
			self.maxv = maxpossible;
			return (1);
		end
		return (0);
	end

	function self.f.bar.setpane(pane, minv, maxv, leftanchor)
		local percent;
		local color;

		pane.minv = minv;
		pane.maxv = maxv;
		percent = (maxv - minv) / MaxDist;
		pane:SetWidth(percent * (framewidth - 6));
		percent = (maxv / 2 + minv / 2) / MaxDist;
		color = {};
		for i = 1, 3, 1 do
			color[i] = (startcolor[i] + percent * (endcolor[i] - startcolor[i])) / 255;
		end
		color[4] = 1;
		pane:SetBackdropColor(unpack(color))
		if (leftanchor == nil) then
			pane:SetPoint("LEFT", self.f.bar, "LEFT", 3, 0);
		else
			pane:SetPoint("LEFT", leftanchor, "RIGHT");
		end
		pane.t:SetText(maxv);
		pane:Show()
	end

	function self.f.bar.updateBackground()
		local pane;
		local minv, maxv = 0, 0;
		local percent;
		local color;
		local leftanchor = nil

		for k, v in ipairs (self.BreakPoints) do
			maxv = v[1];
			pane = self.f.bg[k];
			self.f.bar.setpane(pane, minv, maxv, leftanchor);
			leftanchor = pane;
			minv = maxv;
		end
		self.f.bar.setpane(self.f.bg[getn(self.BreakPoints) + 1], minv, MaxDist, leftanchor);
		for k = getn(self.BreakPoints) + 2, getn(self.f.bg), 1 do
			-- print("hiding pane"..k)
			pane = self.f.bg[k];
			pane:Hide()
		end
		if (rawget(self.f.bg, 1)) then
			self.f.bart:SetPoint("TOP", self.f.bg[1], "BOTTOMLEFT", 0, 11);
		else
			self.f.bart:ClearAllPoints();
		end
	end

	function self:SetCursor()
		for k, v in ipairs (self.f.bg) do
			if (not v:IsShown(v)) then
				break ;
			end
			if (v.minv == self.minv) then
				local lap = 33 - v:GetWidth();
				if (lap > 0) then
					self.f.cursor:SetPoint("BOTTOMLEFT", v, "TOPLEFT", - lap / 2, -12);
					self.f.cursor:SetPoint("BOTTOMRIGHT", v, "TOPRIGHT",  lap / 2, -12);
				else
					self.f.cursor:SetPoint("BOTTOMLEFT", v, "TOPLEFT", 0, -12);
					self.f.cursor:SetPoint("BOTTOMRIGHT", v, "TOPRIGHT", 0, -12);
				end
				self.f.cursor:SetFrameStrata("MEDIUM");
				self.f.cursort:SetText(self.minv.."+");
				break ;
			end
		end
	end
	return ;
end

function ngorange_onload()
	self = ngorange;

	if (self == nil) then
		print("ngorange frame not found ! :'(");
	end
	self.min = 0;
	self.max = MaxDist;
	self.minRangeActions = {};
	self.arrayRangeActions = {};
	self.interactDistances = {};
	self.BreakPoints = {};
	tinsert(self.interactDistances, {4, 28});
	self:SetPoint("CENTER", 0, 0);
	self.f.bg = {};
	
	setmetatable(self.f.bg, {__index = function(t, k)
		local parent = self.f.bar;
		local pane = CreateFrame("Frame", (parent:GetName().."Pane"..k), parent, "ngorangevirtual")
		local text = getfenv()[pane:GetName().."t"];
		
		pane:SetHeight(parent:GetHeight());
		pane:SetBackdrop( { bgFile = "Interface/Tooltips/UI-Tooltip-Background",
			tile = false, tileSize = 16, edgeSize = 0,
			insets = { left = 0, right = 0, top = 3, bottom = 3}
		})
		pane.t = text;
		text:ClearAllPoints();
		text:SetPoint("TOP", pane, "BOTTOMRIGHT", 0, 11);
		text:SetTextColor(1, 1, 1, 0.65)
		text:SetFont("Fonts\\FRIZQT__.TTF", 11)
		text:SetText("0");
		rawset(t, k, pane)
		return pane
	end})
	
	setframesmeta()
	settextfuncs()
	setfuncs()

	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

	------------------------------------------------
	----------------	OnEvent		----------------
	------------------------------------------------
function ngorange_onevent(event, arg1, arg2, ...)

	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		lu = GetTime()
		self:SetScript("OnUpdate", ngorange_onupdate);
		self:UpdateTables()
		-- for k, v in pairs (self.f.bg) do
			-- print(tostring(k).."("..tostring(v)..")");
		-- end
	end

	if (event == "PLAYER_TARGET_CHANGED") then
		self:UpdateTables()
		self.f.bar.updateBackground()
	end
end
	------------------------------------------------
	-------------	Fonctions Générales	------------
	------------------------------------------------

function ngorange_setDoubleParentKey(child, parent)
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
function ngorange_onupdate()
	local elapsed = GetTime() - lu;

	lu = GetTime();
	if (self:DetermineRangeArray()) then
		self:SetCursor()
	end
end




