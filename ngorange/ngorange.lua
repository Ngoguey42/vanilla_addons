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

  self.bar = CreateFrame("Frame", self:GetName().."_bar")
  self.bar:SetParent(self);
  self.bar:SetFrameStrata("LOW");
  self.bar:EnableMouse(false)
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

  self.cursors = {}

  local function new_cursor(tab, k)
    cursor = CreateFrame("Frame", self:GetName().."_cursor"..k)
    cursor:SetParent(self);
    cursor:ClearAllPoints()
    cursor:EnableMouse(false)
    cursor:SetFrameStrata("DIALOG");
    cursor:SetPoint("TOPLEFT", self.bar, "TOPLEFT", 0, 8)
    cursor:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = false, tileSize = 16, edgeSize = 15,
        insets = {left = 3, right = 3, top = 3, bottom = 3}
    })
    cursor:SetHeight(18);
    cursor:SetAlpha(1);
    cursor:Hide()

    cursor.text = cursor:CreateFontString(
      self:GetName().."_cursor"..k.."_text", "OVERLAY", "GameFontNormalLarge")
    cursor.text:SetPoint("CENTER")
    cursor.text:SetTextColor(1, 1, 1, 0.65)
    cursor.text:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE")
    rawset(tab, k, cursor)
    return cursor
  end
  setmetatable(self.cursors, {__index=new_cursor})
end

function moveCursor(self, range)
  local left, right, middle, width, overflow_left, overflow_right
  local barBorder = 4
  local totalWidth = self:GetWidth() - barBorder * 2

  for i, o in ipairs(range) do
    left = o.start / NGORANGEMAXRANGE * totalWidth
    right = o.stop / NGORANGEMAXRANGE * totalWidth
    middle = (left + right) / 2
    width = right - left

    -- Apply a minimal width and a bound constraint
    -- TODO: Handle overlaps between cursors...
    width = max(33, width)
    left = middle - width / 2
    right = middle + width / 2
    overflow_left = -min(0, left)
    overflow_right = -min(0, totalWidth - right)
    left = left + overflow_left - overflow_right
    right = right - overflow_right + overflow_left
    middle = (left + right) / 2

    self.cursors[i]:ClearAllPoints()
    self.cursors[i]:SetPoint("TOP", self, "TOPLEFT", middle + barBorder, -barBorder);
    self.cursors[i]:SetPoint("BOTTOM", self, "BOTTOMLEFT", middle + barBorder, barBorder);
    self.cursors[i]:SetWidth(width);
    self.cursors[i].text:SetText(o.start.."+");
  end
  for i, _ in ipairs(self.cursors) do
    if i <= table.getn(range) then
      self.cursors[i]:Show()
    else
      self.cursors[i]:Hide()
    end
  end

end

local function help()
  print("| >>> ngorange, a wow-classic wow-retail addon to approximate the target's distance");
  print('| Works on all targets');
  print('| The 3 sources of distance:');
  print('| - Is the spell in range (works with all spells in your spellbook)');
  print('| - Is the item in range (works with all items in your bags that can be casted on a target)');
  -- print('| - Is your target close enough to be followed (28 yards) (works with all units)');
  -- print('| - Is your target close enough to be inspected (10 yards) (works with all units)');
  print('| - Is your target close enough to be healed (40 yards) (works with all units in party/raid)');
  print('|  ');
  print('| /ngorange help -> Print this message');
  print('| /ngorange reset -> Reset the spells and items monitored (useful when new spells or new items)');
  print("| /ngorange show -> Show what is monitored to approximate the target's distance");
  print('|  ');
  print('| Developped by ngo in august-2019 on wow-classic 1.13 and wow-retail 8.2.');
end

local function closure()
  local self
  local has_target = UnitExists("target")
  local range_tests

  local function primeTests()
    if range_tests == nil then
      range_tests = ngorangeCreateRangeTests() -- no spellbook in PLAYER_ENTERING_WORLD
    end
  end

  local function onSlash(msg)
    primeTests()
    if msg == 'reset' then
      range_tests = ngorangeCreateRangeTests()
    elseif msg == 'show' then
      for k, v in ipairs(range_tests) do
        print('->', v);
      end
    else
      help()
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
      primeTests()
      has_target = UnitExists("target")
      if has_target then
        for _, cursor in ipairs(self.cursors) do
          cursor:Show()
        end
      else
        for _, cursor in ipairs(self.cursors) do
          cursor:Hide()
        end
      end
    end
  end

  local function onLoad()
    self = ngorange

    self:SetScript("OnEvent", onEvent);
    self:RegisterEvent("PLAYER_TARGET_CHANGED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    setupFrames(self)
    print("Welcome to ngorange. Commands: `/ngorange help`, `/ngorange show`, `/ngorange reset`.");
  end

  function LOL() -- global for debug
    print("********************");
    primeTests()

    r = ngorangeCreateRange()
    for k, v in ipairs(range_tests) do
      s = v()
      r = r * s
      print(v, s, r);
    end
    moveCursor(self, r)
  end

  return onLoad, onSlash
end

ngorangeOnLoad, ngorangeOnSlash = closure()
SLASH_NGORANGE1 = "/ngorange"
SlashCmdList["NGORANGE"] = ngorangeOnSlash
