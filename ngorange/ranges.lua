-- Beware, the ranges from `CheckInteractDistance` are ranges to the center of the target
-- the ranges from the spells are ranges to the side of the target. Those can't be mixed up

local MAXRANGE = 43

local function tribool(v)
  if v == nil then
    return nil
  else
    if v == 1 or v == true then
      return true
    elseif v == 0 or v == false then
      return false
    else
      assert(false)
    end
  end
end

local function createRange(start, stop)
  local o = {}
  local str, mul, add, dist

  local function decompose_ranges(r0, r1)
    local threshs = {}

    local function dist_lt(a, b)
      return (a[1] == b[1]) and ((a[2] and 1 or 0) < (b[2] and 1 or 0)) or (a[1] < b[1])
    end
    local function dist_eq(a, b)
      return (a[1] == b[1]) and (a[2] == b[2])
    end
    local function dist_le(a, b)
      return (a[1] == b[1]) and ((a[2] and 1 or 0) <= (b[2] and 1 or 0)) or (a[1] < b[1])
    end

    for i, r in ipairs({r0, r1}) do
      for _, s in ipairs(r) do
        dist = {s.start, true, i}
        setmetatable(dist, {__lt=dist_lt, __eq=dist_eq, __le=dist_le})
        table.insert(threshs, dist)
        dist = {s.stop, false, i}
        setmetatable(dist, {__lt=dist_lt, __eq=dist_eq, __le=dist_le})
        table.insert(threshs, dist)
      end
    end
    table.sort(threshs)
    return threshs
  end

  function str(r)
    local strings = {}
    for _, v in ipairs(r) do
      table.insert(strings, '('..tostring(v.start)..', '..tostring(v.stop)..')')
    end
    return table.concat(strings, "&")
  end

  function mul(r0, r1)
    -- Intersection
    local statuses, begin, o
    local threshs = decompose_ranges(r0, r1)

    statuses = {}
    o = {}
    for _, t in ipairs(threshs) do
      range, is_start, i = unpack(t)
      statuses[i] = is_start
      if is_start and statuses[1] and statuses[2] then
        begin = range
      elseif not is_start and begin then
        table.insert(o, {start=begin, stop=range})
        begin = nil
      end
    end

    if table.getn(o) == 0 then
      -- The intersection is empty, let's hide this naughty bug that may never
      -- happend to avoid a crash.
      o = {{start=0, stop=MAXRANGE}}
    end

    setmetatable(o, {__mul=mul, __add=add, __tostring=str})
    return o
  end

  function add(r0, r1)
    -- Union
    local statuses, begin, o
    local threshs = decompose_ranges(r0, r1)

    statuses = {}
    o = {}
    for _, t in ipairs(threshs) do
      range, is_start, i = unpack(t)
      statuses[i] = is_start
      if is_start and begin == nil then
        begin = range
      elseif not is_start and begin then
        table.insert(o, {start=begin, stop=range})
        begin = nil
      end
    end

    assert(table.getn(o) > 0)

    setmetatable(o, {__mul=mul, __add=add, __tostring=str})
    return o
  end

  o = {{start=start or 0, stop=stop or MAXRANGE}}
  setmetatable(o, {__mul=mul, __add=add, __tostring=str})
  return o
end

local function createSpell(spellIdOrName)
  local o = {}
  local name, _, _, _, minrange, maxrange, id, _ = GetSpellInfo(spellIdOrName)

  maxrange = min(maxrange, MAXRANGE)
  minrange = max(0, min(minrange, maxrange))

  o.true_range = createRange(minrange, maxrange)
  local function call()
    local inrange = tribool(IsSpellInRange(name, "target")) -- /!\ does not use id!
    local possible = inrange ~= nil and UnitExists("target") and not UnitIsDeadOrGhost("target")

    if possible and inrange then
      return createRange(minrange, maxrange)
    elseif possible and minrange == 0 then
      return createRange(maxrange, MAXRANGE)
    elseif possible then
      return createRange(0, minrange) + createRange(maxrange, MAXRANGE)
    else
      return createRange()
    end
  end
  local function str()
    return name..':'..id..'@'..minrange..'-'..maxrange..'y'
  end

  setmetatable(o, {__call=call, __tostring=str})
  return o
end

local function createItem(itemIdOrName)
  local o = {}

  local name = GetItemInfo(itemIdOrName)
  local sname, sid = GetItemSpell(itemIdOrName)
  assert(sname ~= nil)
  local _, _, _, _, minrange, maxrange, _, _ = GetSpellInfo(sid)
  assert(maxrange ~= nil)

  maxrange = min(maxrange, MAXRANGE)
  minrange = max(0, min(minrange, maxrange))

  o.true_range = createRange(minrange, maxrange)
  local function call()
    local inrange = tribool(IsItemInRange(itemIdOrName, "target"))
    local possible = inrange ~= nil and UnitExists("target") and not UnitIsDeadOrGhost("target")

    if possible and inrange then
      return createRange(minrange, maxrange)
    elseif possible and minrange == 0 then
      return createRange(maxrange, MAXRANGE)
    elseif possible then
      return createRange(0, minrange) + createRange(maxrange, MAXRANGE)
    else
      return createRange()
    end
  end
  local function str()
    local s = name..':'..itemIdOrName..'('..sname..':'..sid..')@'..minrange..'-'..maxrange..'y'
    return s
  end

  setmetatable(o, {__call=call, __tostring=str})
  return o
end

local function createInteractDistance(idx)
  local o = {}
  local names = {
    [1] = "Inspect",
    [2] = "Trade",
    [3] = "Duel",
    [4] = "Follow",
  }
  local _, _, _, v = GetBuildInfo()
  -- TODO: Verify ranges in 1.12 and 8.2
  local maxranges = {
    [1] = (v <= 30000) and 10 or 28,
    [2] = (v <= 30000) and 11 or 8,
    [3] = (v <= 30000) and 10 or 8,
    [4] = 28,
  }

  o.true_range = createRange(0, maxranges[idx])
  local function call()
    local test = CheckInteractDistance("target", idx)
    if test == 1 or test == true then
      return createRange(0, maxranges[idx])
    elseif UnitExists("target") then
      return createRange(maxranges[idx], MAXRANGE)
    else
      return createRange()
    end
  end
  local function str()
    return names[idx]..'@'..'0-'..maxranges[idx]..'y'
  end

  setmetatable(o, {__call=call, __tostring=str})
  return o
end

local function createUnitInRange()
  local o = {}

  o.true_range = createRange(0, 40)
  local function call()
    local test = UnitInRange("target")
    if UnitInParty("target") or UnitInRaid("target") ~= nil then
      if UnitInRange("target") then
        return createRange(0, 40)
      else
        return createRange(40, MAXRANGE)
      end
    else
      return createRange()
    end
  end
  local function str()
    return 'unitInRange@0-40y'
  end

  setmetatable(o, {__call=call, __tostring=str})
  return o
end

local function spellbookIter()
  local i = 1

  return function ()
    local name, subtext = GetSpellBookItemName(i, BOOKTYPE_SPELL)

    if name == nil then
      return nil
    end
    i = i + 1
    return i - 1, name, subtext
  end
end

local function inventoryIter()
  local bagId = 0
  local bagSize = GetContainerNumSlots(bagId) or 0
  local slotId = 1
  local id, link, name

  return function ()
    id = nil
    repeat
      -- Advance cursor to next item or `return nil`
      if bagId > 4 then
        return nil
      elseif slotId <= bagSize then
        _, _, _, _, _, _, link, _, _, id = GetContainerItemInfo(bagId, slotId)
        slotId = slotId + 1
      else
        bagId = bagId + 1
        bagSize = GetContainerNumSlots(bagId) or 0
        slotId = 1
      end
    until id ~= nil
    name = string.gsub(link, "(.+)%[(.-)%](.+)", "%2")
    return bagId, slotId - 1, name, id
  end
end
local function createCentroidRangeTests()
  return {
    createInteractDistance(2),
    createInteractDistance(4),
  }
end

local function createHitboxRangeTests()
  local tests = {
    createUnitInRange(),
  }
  local seen = {}

  for _, name, subtext in spellbookIter() do
    local _, _, _, _, minRange, maxRange, spellId = GetSpellInfo(name, subtext)
    if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
      test = createSpell(spellId)
      if seen[tostring(test)] == nil then
        seen[tostring(test)] = 42
        table.insert(tests, test)
      end
    end
  end
  for bagId, slotId, name, id in inventoryIter() do
    local sname, sid = GetItemSpell(id)
    if sname then
      local _, _, _, _, minRange, maxRange, _ = GetSpellInfo(sid)
      if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
	test = createItem(id)
	if seen[tostring(test)] == nil then
	  seen[tostring(test)] = 42
	  table.insert(tests, test)
	end
      end
    end
  end
  return tests
end
ngorangeCreateHitboxRangeTests = createHitboxRangeTests
ngorangeCreateRange = createRange
ngorangeCreateCentroidRangeTests = createCentroidRangeTests
NGORANGEMAXRANGE = MAXRANGE
