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

  local function str(r)
    return '('..tostring(r.start)..', '..tostring(r.stop)..')'
  end

  local function mul(r0, r1)
    local start = max(r0.start, r1.start)
    local stop = min(r0.stop, r1.stop)

    if start > stop then
      -- /!\ I duknow if it happens, let's hide this naughty error!!
      -- print('Faulty mul on', r0, r1);
      start = stop
    end
    return createRange(start, stop)
  end

  o.start = start or 0
  o.stop = stop or MAXRANGE
  setmetatable(o, {__mul=mul, __tostring=str})
  return o
end

local function createSpell(spellIdOrName)
  local o = {}
  local name, _, _, _, minrange, maxrange, id, _ = GetSpellInfo(spellIdOrName)
  local can_discriminate_too_close_too_far = minrange < 28 - 3 and maxrange > 28 + 3

  o.true_range = createRange(minrange, maxrange)
  local function call()
    local inrange = tribool(IsSpellInRange(name, "target")) -- /!\ does not use id!
    local possible = inrange ~= nil and UnitExists("target") and not UnitIsDeadOrGhost("target")
    local below28 = tribool(CheckInteractDistance("target", 4))

    if possible and inrange then
      return createRange(minrange, maxrange)
    elseif possible and minrange == 0 then
      return createRange(maxrange, MAXRANGE)
    elseif can_discriminate_too_close_too_far and below28 then
	return createRange(0, minrange)
    elseif can_discriminate_too_close_too_far and not below28 then
      return createRange(maxrange, MAXRANGE)
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
  local can_discriminate_too_close_too_far = minrange < 28 - 3 and maxrange > 28 + 3

  o.true_range = createRange(minrange, maxrange)
  local function call()
    local inrange = tribool(IsItemInRange(itemIdOrName, "target"))
    local possible = inrange ~= nil and UnitExists("target") and not UnitIsDeadOrGhost("target")
    local below28 = tribool(CheckInteractDistance("target", 4))

    if possible and inrange then
      return createRange(minrange, maxrange)
    elseif possible and minrange == 0 then
      return createRange(maxrange, MAXRANGE)
    elseif can_discriminate_too_close_too_far and below28 then
	return createRange(0, minrange)
    elseif can_discriminate_too_close_too_far and not below28 then
      return createRange(maxrange, MAXRANGE)
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
  local maxranges = {
    [1] = 10, -- 28y starting from wow version ~3.0
    [2] = 11,
    [3] = 10,
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

local function createRangeTests()
  local tests = {
    createInteractDistance(4),
    createInteractDistance(1),
    createUnitInRange(),
  }

  for _, name, subtext in spellbookIter() do
    local _, _, _, _, minRange, maxRange, spellId = GetSpellInfo(name, subtext)
    if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
      table.insert(tests, createSpell(spellId))
    end
  end
  for bagId, slotId, name, id in inventoryIter() do
    local sname, sid = GetItemSpell(id)
    if sname then
      local _, _, _, _, minRange, maxRange, _ = GetSpellInfo(sid)
      if minRange ~= nil and maxRange ~= nil and minRange < maxRange then
  	table.insert(tests, createItem(id))
      end
    end
  end
  return tests
end
ngorangeCreateRangeTests = createRangeTests
ngorangeCreateRange = createRange
NGORANGEMAXRANGE = MAXRANGE
