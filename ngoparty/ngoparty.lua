	------------------------------------------------/run print(tostring(PlayerHitIndicator:GetValue()))
	----------------	CONSTANTES	----------------/run PlayerHitIndicator:Hide()
	------------------------------------------------/run print(tostring(PlayerHitIndicator))

	------------------------------------------------
	----------------	VARIABLES	----------------
	------------------------------------------------

local self


local ngoparty_onupdate;
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

function ngoparty_onload()
	self = ngoparty;

	if (self == nil) then
		print("ngoparty frame not found ! :'(");
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
function ngoparty_onevent(event, arg1, arg2, ...)

	if (event == "UI_INFO_MESSAGE" and GetNumPartyMembers() > 0) then
		SendChatMessage(arg1, "PARTY");
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")

		-- self:SetScript("OnUpdate", ngoparty_onupdate);
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

function ngoparty_setDoubleParentKey(child, parent)
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
function ngoparty_onupdate()

end
