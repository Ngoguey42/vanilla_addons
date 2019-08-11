
local function setChildrenKeys(self)
  if self.GetNumChildren == nil then
    return
  end

  local f, n, m
  n = self:GetName().."_"

  for i = 1, self:GetNumChildren(), 1 do
    f = select(i, self:GetChildren())
    m = f:GetName()
    if m ~= nil then
      m, count = string.gsub(m, n, "")
      if count == 1 then
	rawset(self, m, f)
	setChildrenKeys(f)
      end
    end
  end

  for i = 1, self:GetNumRegions(), 1 do
    f = select(i, self:GetRegions())
    m = f:GetName()
    if m ~= nil then
      m, count = string.gsub(m, n, "")
      if count == 1 then
	rawset(self, m, f)
	setChildrenKeys(f)
      end
    end
  end

end

local function setupFrames(self)

  self:SetParent(UIParent);
  self:SetWidth(272);
  self:SetHeight(28);
  self:SetFrameStrata("HIGH");
  self:SetPoint("CENTER", -86, -254)
  self:SetBackdropColor(1, 0, 0, 0)

  self:SetMovable(true)
  self:EnableMouse(true)
  self:RegisterForDrag("LeftButton")
  self:SetScript("OnDragStart", self.StartMoving)
  self:SetScript("OnDragStop", self.StopMovingOrSizing)

  self.bar:SetParent(self);
  self.bar:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
  self.bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
  self.bar:SetBackdropColor(0.5, 0.5, 0.5, 0)
  self.bar:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background",
      edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
      tile = false, tileSize = 16, edgeSize = 15,
      insets = { left = 2, right = 2, top = 2, bottom = 2}
  })
  self.bar:SetAlpha(0.45);

  self.cursor:SetParent(self);
  self.cursor:ClearAllPoints()
  self.cursor:SetPoint("TOPLEFT", self.bar, "TOPLEFT", 0, 8)
  self.cursor:SetBackdrop({
      bgFile = "Interface/Tooltips/UI-Tooltip-Background",
      edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
      tile = false, tileSize = 16, edgeSize = 15,
      insets = {left = 3, right = 3, top = 3, bottom = 3}
  })
  self.cursor:SetHeight(18);
  self.cursor:SetAlpha(1);
  self.cursor:Hide()

  self.cursor.text:SetPoint("CENTER")
  self.cursor.text:SetTextColor(1, 1, 1, 0.65)
  self.cursor.text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")

end


function moveCursor(self, range)
  local left, right, middle, width, overflow_left, overflow_right

  local barBorder = 4
  local totalWidth = self:GetWidth() - barBorder * 2

  left = range.start / NGORANGEMAXRANGE * totalWidth
  right = range.stop / NGORANGEMAXRANGE * totalWidth
  middle = (left + right) / 2
  width = right - left

  -- Apply a minimal width and a bound constraint
  width = max(33, width)
  left = middle - width / 2
  right = middle + width / 2
  overflow_left = -min(0, left)
  overflow_right = -min(0, totalWidth - right)
  left = left + overflow_left - overflow_right
  right = right - overflow_right + overflow_left
  middle = (left + right) / 2

  self.cursor:ClearAllPoints()
  self.cursor:SetPoint("TOP", self, "TOPLEFT", middle + barBorder, -barBorder);
  self.cursor:SetPoint("BOTTOM", self, "BOTTOMLEFT", middle + barBorder, barBorder);
  self.cursor:SetWidth(width);
  self.cursor.text:SetText(range.start.."+");
end

local function closure()
  local self
  local has_target = UnitExists("target")
  local range_tests

  local function onSlash(msg)
    if msg == 'reset' then
      range_tests = ngorangeCreateRangeTests()
    elseif msg == 'show' then
      for k, v in ipairs(range_tests) do
	print('->', v);
      end
    else
      print("| >>> ngorange, a wow classic addon to approximate the target's distance");
      print('| Works on all targets');
      print('| The 5 sources of distance:');
      print('| - Is the spell in range (works with all spells in your spellbook)');
      print('| - Is the item in range (works with all items in your bags that can be casted on a target)');
      print('| - Is your target close enough to be followed (28 yards) (works with all units)');
      print('| - Is your target close enough to be inspected (10 yards) (works with all units)');
      print('| - Is your target close enough to be healed (40 yards) (works with all units in party/raid)');
      print('|  ');
      print('| /ngorange help -> Print this message');
      print('| /ngorange reset -> Reset the spells and items monitored (useful when new spells or new items)');
      print("| /ngorange show -> Show what is monitored to approximate the target's distance");
      print('|  ');
      print('| Quickly developped by ngo the 11-august-2019 on wow classic 1.13.');
    end
  end

  local function onUpdate()
    local s, r
    if not has_target then
      return
    end
    assert(range_tests ~= nil)
    r = ngorangeCreateRange()
    for k, v in ipairs(range_tests) do
      s = v()
      r = r * s
    end
    moveCursor(self, r)
  end

  local function onEvent(_, event)
    if (event == "PLAYER_ENTERING_WORLD") then
      ngorange:UnregisterEvent("PLAYER_ENTERING_WORLD")
      ngorange:SetScript("OnUpdate", onUpdate);
    end
    if (event == "PLAYER_TARGET_CHANGED") then
      if range_tests == nil then
	range_tests = ngorangeCreateRangeTests() -- no spellbook in PLAYER_ENTERING_WORLD
      end
      has_target = UnitExists("target")
      if has_target then
	self.cursor:Show()
      else
	self.cursor:Hide()
      end
    end
  end

  local function onLoad()
    self = ngorange
    self:SetScript("OnEvent", onEvent);
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    setChildrenKeys(self)
    setupFrames(self)
    print("Welcome to ngorange. Commands: `/ngorange help`, `/ngorange show`, `/ngorange reset`.");
  end

  return onLoad, onSlash
end

ngorange_onload, ngorange_onslash = closure()
SLASH_NGORANGE1 = "/ngorange"
SlashCmdList["NGORANGE"] = ngorange_onslash
function LOL()
  range_tests = ngorangeCreateRangeTests()
  local s, r
  r = ngorangeCreateRange()
  for k, v in ipairs(range_tests) do
    s = v()
    r = r * s
    print(v, s, r);
  end
end
