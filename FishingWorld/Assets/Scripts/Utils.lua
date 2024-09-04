--!Type(Module)

--!Type(Module)

function is_in_table(t, value)
    for _, v in t do
      if v == value then
        return true
      end
    end
    return false
  end
  
  function is_in_inventory_table(tbl, item)
    for _, v in tbl do
      if v.id == item then
        return true
      end
    end
    return false
  end

  function find_inventory_index(tbl, item)
    -- Iterate over the table using ipairs for ordered tables
    for index, value in ipairs(tbl) do
        -- Check if the current element is equal to the item we are searching for
        if value.id == item then
            return index -- Return the index if item is found
        end
    end
    return nil -- Return nil if item is not found in the table
end

function is_table_equal(t1,t2,ignore_mt)
  local ty1 = type(t1)
  local ty2 = type(t2)
  if ty1 ~= ty2 then return false end
  -- non-table types can be directly compared
  if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
  -- as well as tables which have the metamethod __eq
  local mt = getmetatable(t1)
  if not ignore_mt and mt and mt.__eq then return t1 == t2 end
  for k1,v1 in pairs(t1) do
     local v2 = t2[k1]
     if v2 == nil or not is_table_equal(v1,v2) then return false end
  end
  for k2,v2 in pairs(t2) do
     local v1 = t1[k2]
     if v1 == nil or not is_table_equal(v1,v2) then return false end
  end
  return true
end
  
  function GetPositionSuffix(position: number): string
    if position == 1 then
      return "1st"
    elseif position == 2 then
      return "2nd"
    elseif position == 3 then
      return "3rd"
    else
      return tostring(position) .. "th"
    end
  end
  
  -- Function to deep copy a table (testing)
  function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
      if type(v) == "table" then
        copy[k] = DeepCopy(v)
      else
        copy[k] = v
      end
    end
    return copy
  end
  
  -- Function to add or remove a class from an element
  function AddRemoveClass(element, class: string, add: boolean)
    if add then
      element:AddToClassList(class)
    else
      element:RemoveFromClassList(class)
    end
  end
  
  -- Activate the object if it is not active
  function ActivateObject(object)
    if not object.activeSelf then
      object:SetActive(true)
    end
  end
  
  -- Deactivate the object if it is active
  function DeactivateObject(object)
    if object.activeSelf then
      object:SetActive(false)
    end
  end
  
  -- Activate all objects in the list
  function ActivateObjects(objects)
    for _, object in ipairs(objects) do
      ActivateObject(object)
    end
  end
  
  -- Deactivate all objects in the list
  function DeactivateObjects(objects)
    for _, object in ipairs(objects) do
      DeactivateObject(object)
    end
  end
  
  -- Function to print a table
  function PrintTable(t, indent)
    indent = indent or ''
    for k, v in pairs(t) do
      if type(v) == 'table' then
        print(indent .. k .. ' :')
        PrintTable(v, indent .. '  ')
      else
        print(indent .. k .. ' : ' .. tostring(v))
      end
    end
  end
  
  -- Function to get the count of a table
  function GetCount(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    return count
  end

  function FormatNumberWithCommas(amount: number)
    local formattedNumber = tostring(amount)
    local reverseFormatted = formattedNumber:reverse():gsub("(%d%d%d)", "%1,"):reverse()
  
    -- Remove any leading commas if the number is less than 1,000
    if reverseFormatted:sub(1, 1) == "," then
        reverseFormatted = reverseFormatted:sub(2)
    end
  
    return reverseFormatted
  end

  function CombineTables(tableOfTable)
    local combinedTable = {}
    for _, table in ipairs(tableOfTable) do
      for _, value in ipairs(table) do
        table.insert(combinedTable, value)
      end
    end
    return combinedTable
  end

-- Function to trim text and replace it with an ellipsis if it exceeds the specified length
function TrimText(text: string, maxLength: number)
    if text:len() > maxLength then
        return text:sub(1, maxLength - 3) .. "..."
    else
        return text
    end
end

function SortScores(topScoreTable)
  -- Create a sortable list of players with score
  local sortableScores = {}
  for playerName, playerInfo in topScoreTable do
      table.insert(sortableScores, {playerName = playerInfo.playerName, playerScore = playerInfo.playerScore})
  end

  -- Sort the list by score in descending order
  table.sort(sortableScores, function(a, b)
      return a.playerScore > b.playerScore
  end)

  -- Extract the top scores (up to the number of players available)
  local numPlayers = #sortableScores
  local topScoresCount = math.min(numPlayers, 10)

  local topScores = {}
  local iTopScores = {}
  for i = 1, topScoresCount do
      topScores[sortableScores[i].playerName] = sortableScores[i]
      table.insert(iTopScores, sortableScores[i])
  end

  return topScores, iTopScores;
end