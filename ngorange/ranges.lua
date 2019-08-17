-- Beware, the ranges from `CheckInteractDistance` are ranges to the center of the target
-- the ranges from the spells are ranges to the side of the target. Those can't be mixed up

local isClassic = select(4, GetBuildInfo()) < 30000
local isRetail = not isClassic
local INF = 1 / 0
local rangeLib = {}

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

local function toSortedSet(tab)
  local a, b = {}, {}
  for _, v in ipairs(tab) do
    assert(type(v) == type(42))
    a[v] = 1
  end
  for k, _ in pairs(a) do
    table.insert(b, k)
  end
  table.sort(b)
  return b
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

local function toyBoxIter()
  local i = 1
  local itemId, itemName

  return function ()
    itemId = C_ToyBox.GetToyFromIndex(i)
    itemName = GetItemInfo(itemId)
    i = i + 1
    if itemId == nil or itemId < 0 then
      return nil
    else
      return i - 1, itemId, itemName
    end
  end

end

local function resetToyFilters()
  for i=1,20 do
    pcall(C_ToyBox.SetExpansionTypeFilter, i, true)
    pcall(C_ToyBox.SetSourceTypeFilter, i, true)
  end
  C_ToyBox.SetCollectedShown(true)
  C_ToyBox.SetUncollectedShown(true)
  C_ToyBox.SetUnusableShown(true)
  C_ToyBox.SetFilterString("")
end

rangeLib.createSpellInfo = function(id)
  local name, _, _, _, minrange, maxrange, id, _ = GetSpellInfo(id)
  local o = {}

  o.name = name
  o.id = id
  o.minrange = minrange
  o.maxrange = maxrange
  o.test = function(unit)
    return tribool(IsSpellInRange(name, unit)) -- /!\ Does no use id!
  end
  local function str()
    return name..':'..id..'@'..minrange..'-'..maxrange..'y'
  end
  setmetatable(o, {__tostring=str})

  return o
end

rangeLib.createItemInfo = function(id)
  local o = {}

  o.name = GetItemInfo(id)
  o.id = id
  o.spell = rangeLib.createSpellInfo(select(2, GetItemSpell(id)))
  o.minrange = o.spell.minrange
  o.maxrange = o.spell.maxrange
  o.test = function(unit)
    return tribool(IsItemInRange(id, unit))
  end
  local function str()
    return o.name..':'..id..'@'..o.minrange..'-'..o.maxrange..'y'
  end
  setmetatable(o, {__tostring=str})

  return o
end

rangeLib.createUnitInRangeInfo = function()
  local o = {}

  o.minrange = 0
  o.maxrange = 40
  o.test = function(unit)
    if UnitInParty(unit) or UnitInRaid(unit) ~= nil then
      return tribool(UnitInRange(unit))
    else
      return nil
    end
    return t
  end
  local function str()
    return 'unitInRange@0-40y'
  end

  setmetatable(o, {__tostring=str})
  return o
end

rangeLib.createInteractDistanceInfo = function(idx)
  -- TODO: Verify ranges in 1.12 and 8.2
  local names = {
    [1] = "Inspect",
    [2] = "Trade",
    [3] = "Duel",
    [4] = "Follow",
  }
  local maxranges = {
    [1] = isClassic and 10 or 28,
    [2] = isClassic and 11 or 8,
    [3] = isClassic and 10 or 8,
    [4] = 28,
  }
  local o = {}
  o.minrange = 0
  o.name = names[idx]
  o.maxrange = maxranges[idx]


  o.test = function(unit)
    if UnitExists(unit) then
      return tribool(CheckInteractDistance(unit, idx))
    else
      return nil
    end
  end
  local function str()
    return o.name..'@'..'0-'..o.maxrange..'y'
  end

  setmetatable(o, {__tostring=str})
  return o
end

rangeLib.createCentroidRangeInfos = function()
  return {
    rangeLib.createInteractDistanceInfo(2),
    rangeLib.createInteractDistanceInfo(4),
  }
end

rangeLib.createHitboxRangeInfos = function()
  local seen = {}
  local infos = {
    rangeLib.createUnitInRangeInfo()
  }

  for _, name, subtext in spellbookIter() do
    local _, _, _, _, minRange, maxRange, spellId = GetSpellInfo(name, subtext)
    if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
      test = rangeLib.createSpellInfo(spellId)
      if seen[tostring(test)] == nil then
        seen[tostring(test)] = 42
        table.insert(infos, test)
      end
    end
  end
  for bagId, slotId, name, id in inventoryIter() do
    local sname, sid = GetItemSpell(id)
    if sname then
      local _, _, _, _, minRange, maxRange, _ = GetSpellInfo(sid)
      if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
        test = rangeLib.createItemInfo(id)
        if seen[tostring(test)] == nil then
          seen[tostring(test)] = 42
          table.insert(infos, test)
        end
      end
    end
  end
  if isRetail then
    resetToyFilters()
    for toyId, id, name in toyBoxIter() do
      local sname, sid = GetItemSpell(id)
      if sname then
	local _, _, _, _, minRange, maxRange, _, _ = GetSpellInfo(sid)
	if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
	  test = rangeLib.createItemInfo(id)
	  if seen[tostring(test)] == nil then
	    seen[tostring(test)] = 42
	    table.insert(infos, test)
	  end
	end
      end
    end
  end

  return infos
end

rangeLib.createRangeEncoder = function(infos)
  local intervals, thresholds = {}, {}
  local set = {0}

  for _, info in ipairs(infos) do
    table.insert(set, info.minrange)
    table.insert(set, info.maxrange)
  end
  set = toSortedSet(set)
  table.insert(set, INF)

  for i=1, #set do
    thresholds[set[i]] = true
  end
  for i=1, #set - 1 do
    table.insert(intervals, {start=set[i], stop=set[i + 1]})
  end
  intervals.decode = function(bitfield)
    local bit_, prev, start
    local ranges = {}

    for i, interval in ipairs(intervals) do
      bit_ = bit.band(bit.lshift(1, i), bitfield) ~= 0 and 1 or 0
      if bit_ == 0 and prev == nil then
        prev = 0
      elseif bit_ == 1 and prev == nil then
        start = i
        prev = 1
      elseif bit_ == 0 and prev == 0 then
        prev = 0
      elseif bit_ == 1 and prev == 0 then
        start = i
        prev = 1
      elseif bit_ == 0 and prev == 1 then
        table.insert(ranges, {start=intervals[start].start, stop=intervals[i - 1].stop})
        prev = 0
      elseif bit_ == 1 and prev == 1 then
        prev = 1
      else
        assert(false)
      end
    end
    if prev == 1 then
      table.insert(ranges, {start=intervals[start].start, stop=intervals[#intervals].stop})
    end
    return ranges
  end
  intervals.bitfieldToString = function(bitfield)
    local s, mask = 'bitfield:_'

    for i, interval in ipairs(intervals) do
      mask = bit.lshift(1, i)
      if bit.band(mask, bitfield) ~= 0 then
        s = s..'1'
      else
        s = s..'0'
      end
    end
    for _, r in ipairs(intervals.decode(bitfield)) do
      s = s..'('..r.start..'-'..r.stop..')'
    end
    return s
  end
  intervals.encode = function(start, stop)
    local bitfield = 0

    assert(thresholds[start] == true)
    assert(thresholds[stop] == true)
    for i, interval in ipairs(intervals) do
      if interval.start >= start and interval.stop <= stop then
        bitfield = bit.bor(bitfield, bit.lshift(1, i))
      end
    end
    assert(bitfield ~= 0)
    return bitfield
  end

  return intervals
end

rangeLib.createDumbReducer = function(infos)
  local o = {}
  local bitfieldPerInfo = {}
  local rangeEncoder = rangeLib.createRangeEncoder(infos)

  for _, info in ipairs(infos) do
    bitfieldPerInfo[info] = rangeEncoder.encode(info.minrange, info.maxrange)
  end
  o.reduce = function(unit)
    local r = bit.bnot(0)
    local testCount = 0

    for _, info in ipairs(infos) do
      local bitfield = bitfieldPerInfo[info]
      local intersection = bit.band(r, bitfield)
      -- if true then
      if intersection ~= 0 and intersection ~= r then
        test = info.test(unit)
        testCount = testCount + 1
        if test == true then
          r = bit.band(r, bitfield)
        elseif test == false then
          r = bit.band(r, bit.bnot(bitfield))
        end
        -- if test ~= nil then
        --   print(rangeEncoder.bitfieldToString(r), rangeEncoder.bitfieldToString(bitfield), info);
        -- end
      end
    end
    return rangeEncoder.decode(r), testCount
  end
  return o
end

function LOL()
  print('********************************************************************************');

  local infos = rangeLib.createHitboxRangeInfos()
  -- infos = rangeLib.createCentroidRangeInfos()
  local reducer = rangeLib.createDumbReducer(infos)

  r, testCount = reducer.reduce("target")
  print(rangeEncoder.bitfieldToString(r), '<===');

  print('********************************************************************************');

end

_G['rangeLib'] = rangeLib
