if Controls then

----------------------------------------------------------------------------------------------------------------------------
-- $$\    $$\                    $$\           $$\       $$\                     
-- $$ |   $$ |                   \__|          $$ |      $$ |                    
-- $$ |   $$ |$$$$$$\   $$$$$$\  $$\  $$$$$$\  $$$$$$$\  $$ | $$$$$$\   $$$$$$$\ 
-- \$$\  $$  |\____$$\ $$  __$$\ $$ | \____$$\ $$  __$$\ $$ |$$  __$$\ $$  _____|
--  \$$\$$  / $$$$$$$ |$$ |  \__|$$ | $$$$$$$ |$$ |  $$ |$$ |$$$$$$$$ |\$$$$$$\  
--   \$$$  / $$  __$$ |$$ |      $$ |$$  __$$ |$$ |  $$ |$$ |$$   ____| \____$$\ 
--    \$  /  \$$$$$$$ |$$ |      $$ |\$$$$$$$ |$$$$$$$  |$$ |\$$$$$$$\ $$$$$$$  |
--     \_/    \_______|\__|      \__| \_______|\_______/ \__| \_______|\_______/ 
----------------------------------------------------------------------------------------------------------------------------

local iMaxGains = Properties["Number Of Gains"].Value
local DefaultComponentString = "Select"
local RemoveOptionString = "--[ REMOVE ]--"
local DefaultDuplicateString = "No Duplicates"
local ColorRed = "OrangeRed"
local ColorGreen = "LightGreen"
local ColorYellow = "Yellow"
local ColorWhite = "White"

-- holds the named components
CompGain = {}
CompMute = {}
CompAutomix = {}
CompPreamp = {}
CompPhantom = {}
GainMatchesPreamp = {}

for i = 1, iMaxGains do 
  CompGain[i] = nil
  CompMute[i] = nil
  CompAutomix[i] = nil
  CompPreamp[i] = nil
  CompPhantom[i] = nil
  GainMatchesPreamp[i] = nil
end 

-- define a table of timers to restore text to uci display
TextTimerTbl = {} 
for i = 1, iMaxGains do
  TextTimerTbl[i] = Timer.New()
end

-- table to hold position ranges for the Mute State Trigger controls
local iMaxStateTriggerValue = Properties["Mute State Trigger Max Val"].Value
local MuteStateTriggerRangeCompare = {
  [4] = {
    {upper = 1.1,   lower = 0.66,   val = 4},
    {upper = 0.66,  lower = 0.33,   val = 3},
    {upper = 0.36,  lower = -0.1,   val = 2},
  },
  [5] = {
    {upper = 1.1,   lower = 0.75,   val = 5},
    {upper = 0.76,  lower = 0.5,    val = 4},
    {upper = 0.5,   lower = 0.25,   val = 3},
    {upper = 0.25,  lower = -0.1,   val = 2},
  },
  [6] = {
    {upper = 1.1,   lower = 0.8,    val = 6},
    {upper = 0.8,   lower = 0.6,    val = 5},
    {upper = 0.6,   lower = 0.4,    val = 4},
    {upper = 0.4,   lower = 0.2,    val = 3},
    {upper = 0.2,   lower = -0.1,   val = 2},
  }
}
MuteStateTriggerRangeCompare = MuteStateTriggerRangeCompare[iMaxStateTriggerValue]


----------------------------------------------------------------------------------------------------------------------------
-- $$$$$$$$\                              $$\     $$\                               
-- $$  _____|                             $$ |    \__|                              
-- $$ |   $$\   $$\ $$$$$$$\   $$$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\   $$$$$$$\ 
-- $$$$$\ $$ |  $$ |$$  __$$\ $$  _____|\_$$  _|  $$ |$$  __$$\ $$  __$$\ $$  _____|
-- $$  __|$$ |  $$ |$$ |  $$ |$$ /        $$ |    $$ |$$ /  $$ |$$ |  $$ |\$$$$$$\  
-- $$ |   $$ |  $$ |$$ |  $$ |$$ |        $$ |$$\ $$ |$$ |  $$ |$$ |  $$ | \____$$\ 
-- $$ |   \$$$$$$  |$$ |  $$ |\$$$$$$$\   \$$$$  |$$ |\$$$$$$  |$$ |  $$ |$$$$$$$  |
-- \__|    \______/ \__|  \__| \_______|   \____/ \__| \______/ \__|  \__|\_______/ 
----------------------------------------------------------------------------------------------------------------------------

function funcPrintDebug(update)
  if DebugPrint then 
    print(update)
  end 
end 

-- sort the components
function SortGatheredComponents(tbl)
  table.sort(tbl, function(a, b)
    -- Convert both strings to lowercase for case-insensitive comparison
    a, b = tostring(a):lower(), tostring(b):lower()
    -- Compare numerically if both are numbers
    local numA, numB = tonumber(a), tonumber(b)
    if numA and numB then
      return numA < numB
    end
    -- Otherwise, compare alphabetically
    return a < b
  end)
end

-- get all components in design, put them in comboboxes
function funcGetComponents()
  -- gather components from Design
  local comp = {}
  local compNames = {}
  comp = Component.GetComponents()
  for _,v in pairs (comp) do 
    table.insert(compNames, v.Name)
  end 
  funcPrintDebug("Found "..#comp.." components in Design")
  -- sort the found components
  SortGatheredComponents(compNames)
  table.insert(compNames,1,RemoveOptionString)
  -- assign the gathered components into the combo boxes
  for i = 1, iMaxGains do
    Controls["Component "..i.." Gain Code Name"].Choices = compNames
    Controls["Component "..i.." Mute Code Name"].Choices = compNames
    Controls["Component "..i.." Automix Code Name"].Choices = compNames
    Controls["Component "..i.." Preamp Code Name"].Choices = compNames
  end 
  -- clear the comp table
  comp = nil
  compNames = nil
end 

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain -- Gain ----
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

-- configure the gain control
function funcSetUpGain(idx)
  funcPrintDebug("funcSetUpGain --- "..idx)

  -- configure mute if shared
  if Properties["Link Mute "..idx].Value == true then
    Controls["Component "..idx.." Mute Code Name"].String = Controls["Component "..idx.." Gain Code Name"].String
    funcSetUpMute(idx)
  end

  -- set min / max display controls
  local min, max = Properties["Min dB "..idx].Value, Properties["Max dB "..idx].Value
  Controls["Gain "..idx.." Display Min"].String = min > 0 and string.format("+%i", min) or (tostring(min))
  Controls["Gain "..idx.." Display Max"].String = max > 0 and string.format("+%i", max) or (tostring(max))

  -- check that component exists
  local componentName = Controls["Component "..idx.." Gain Code Name"].String
  local GetCompTbl = Component.GetControls(componentName)

  if #componentName == 0 or componentName == DefaultComponentString or componentName == RemoveOptionString or #GetCompTbl == 0 then 
    Controls["Component "..idx.." Gain Code Name"].Color = ColorRed
    Controls["Component "..idx.." Gain Code Name"].String = DefaultComponentString
    Controls["Component "..idx.." Gain Control Name"].Choices = {}
    funcBuildOrDestroyGainComponent(idx, "destroy")
    GetCompTbl = nil
    return

  else 
    Controls["Component "..idx.." Gain Code Name"].Color = ColorGreen
    -- find the gains in the component
    local gainCtls = {}
    for _, c_element in ipairs (GetCompTbl) do 
      if string.find(c_element.Name, "gain") then 
        table.insert(gainCtls, c_element.Name)
      end 
    end
    -- insert remove option
    table.insert(gainCtls,1,RemoveOptionString)
    -- assign choices
    Controls["Component "..idx.." Gain Control Name"].Choices = gainCtls
    -- check if gain control name has been chosen, and if it matches
    local foundGain = false 
    if #Controls["Component "..idx.." Gain Control Name"].String > 0 then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Gain Control Name"].String then 
          foundGain = true
        end
      end 
    end
    funcBuildOrDestroyGainComponent(idx, foundGain and "build" or "destroy")
    GetCompTbl = nil
    gainCtls = nil
    -- check for duplicates
    if foundGain then 
      funcCheckForDuplicates(idx, 1)
    end 
  end
end 

function funcBuildOrDestroyGainComponent(idx, action)
  funcPrintDebug("funcBuildOrDestroyGainComponent | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompGain[idx] then 
    CompGain[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompGain[idx] = nil
    Controls["Component "..idx.." Gain Control Name"].Color = ColorRed
    Controls["Component "..idx.." Gain Control Name"].String = DefaultComponentString
    Controls["Gain "..idx.." Fader"].Position = 0
    Controls["Gain "..idx.." Display 1"].String = ""
    Controls["Gain "..idx.." Display 2"].String = ""
    Controls["Gain "..idx.." Display 3"].String = ""
    EnableDisableChannelControls(idx)
    return 
  end 
  -- set color
  Controls["Component "..idx.." Gain Control Name"].Color = ColorGreen
  -- create a new Named Component
  CompGain[idx] = Component.New(Controls["Component "..idx.." Gain Code Name"].String)[Controls["Component "..idx.." Gain Control Name"].String]
  -- create a new EventHandler
  CompGain[idx].EventHandler = function(ctl) CompGainChangeEVT(idx) end 
  -- call EventHandler
  CompGainChangeEVT(idx)
  -- enable or disable controls
  EnableDisableChannelControls(idx)
  
end

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute -- Mute ----
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

-- configure the mute control
function funcSetUpMute(idx)
  funcPrintDebug("funcSetUpMute --- "..idx)

  -- check that component exists
  local componentName = Controls["Component "..idx.." Mute Code Name"].String
  local GetCompTbl = Component.GetControls(componentName)
  if #componentName == 0 or componentName == DefaultComponentString or componentName == RemoveOptionString or #GetCompTbl == 0 then 
    Controls["Component "..idx.." Mute Code Name"].Color = ColorRed
    Controls["Component "..idx.." Mute Code Name"].String = DefaultComponentString
    Controls["Component "..idx.." Mute Control Name"].Choices = {}
    funcBuildOrDestroyMuteComponent(idx, "destroy")
    GetCompTbl = nil
    return
  else 
    Controls["Component "..idx.." Mute Code Name"].Color = ColorGreen
    -- find the mutes in the component
    local muteCtls = {}
    for _, c_element in ipairs (GetCompTbl) do 
      if string.find(c_element.Name, "mute") then 
        table.insert(muteCtls, c_element.Name)
      end 
    end
    -- insert remove option
    table.insert(muteCtls,1,RemoveOptionString)
    -- assign choices
    Controls["Component "..idx.." Mute Control Name"].Choices = muteCtls
    -- check if gain control name has been chosen, and if it matches
    local foundMute = false 
    if #Controls["Component "..idx.." Mute Control Name"].String > 0 then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Mute Control Name"].String then 
          foundMute = true
        end
      end 
    end
    funcBuildOrDestroyMuteComponent(idx, foundMute and "build" or "destroy")
    GetCompTbl = nil
    muteCtls = nil
    -- check for duplicates
    if foundMute then 
      funcCheckForDuplicates(idx, 2)
    end 
  end
end 

function funcBuildOrDestroyMuteComponent(idx, action)
  funcPrintDebug("funcBuildOrDestroyMuteComponent | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompMute[idx] then 
    CompMute[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompMute[idx] = nil
    Controls["Component "..idx.." Mute Control Name"].Color = ColorRed
    Controls["Component "..idx.." Mute Control Name"].String = DefaultComponentString
    Controls["Gain "..idx.." Mute Toggle"].Boolean = false
    Controls["Gain "..idx.." Mute State Trigger"].Value = 0
    Controls["Gain "..idx.." Mute State Trigger Value"].String = ""
    EnableDisableChannelControls(idx)
    return 
  end 
  -- set color
  Controls["Component "..idx.." Mute Control Name"].Color = ColorGreen
  -- create a new Named Component
  CompMute[idx] = Component.New(Controls["Component "..idx.." Mute Code Name"].String)[Controls["Component "..idx.." Mute Control Name"].String]
  -- create a new EventHandler
  CompMute[idx].EventHandler = function(ctl) CompMuteChangeEVT(idx) end 
  -- call EventHandler
  CompMuteChangeEVT(idx)
  -- enable or disable controls
  EnableDisableChannelControls(idx)
end


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------ Automix -- Automix -- Automix -- Automix -- Automix -- Automix -- Automix -- Automix -- Automix -----
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

-- configure the Automix control
function funcSetUpAutomix(idx)
  funcPrintDebug("funcSetUpAutomix --- "..idx)

  -- check that component exists
  local componentName = Controls["Component "..idx.." Automix Code Name"].String
  local GetCompTbl = Component.GetControls(componentName)
  if #componentName == 0 or componentName == DefaultComponentString or componentName == RemoveOptionString or #GetCompTbl == 0 then 
    Controls["Component "..idx.." Automix Code Name"].Color = ColorRed
    Controls["Component "..idx.." Automix Code Name"].String = DefaultComponentString
    Controls["Component "..idx.." Automix Control Name"].Choices = {}
    funcBuildOrDestroyAutomixComponent(idx, "destroy")
    GetCompTbl = nil
    return
  else 
    Controls["Component "..idx.." Automix Code Name"].Color = ColorGreen
    -- find the Automixs in the component
    local AutomixCtls = {}
    for _, c_element in ipairs (GetCompTbl) do 
      if string.find(c_element.Name, "manual") then 
        table.insert(AutomixCtls, c_element.Name)
      end 
    end
    -- insert remove option
    table.insert(AutomixCtls,1,RemoveOptionString)
    -- assign choices
    Controls["Component "..idx.." Automix Control Name"].Choices = AutomixCtls
    -- check if gain control name has been chosen, and if it matches
    local foundAutomix = false 
    if #Controls["Component "..idx.." Automix Control Name"].String > 0 then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Automix Control Name"].String then 
          foundAutomix = true
        end
      end 
    end
    funcBuildOrDestroyAutomixComponent(idx, foundAutomix and "build" or "destroy")
    GetCompTbl = nil
    AutomixCtls = nil
    -- check for duplicates
    if foundAutomix then 
      funcCheckForDuplicates(idx, 3)
    end 
  end
end 

function funcBuildOrDestroyAutomixComponent(idx, action)
  funcPrintDebug("funcBuildOrDestroyAutomixComponent | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompAutomix[idx] then 
    CompAutomix[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompAutomix[idx] = nil
    Controls["Component "..idx.." Automix Control Name"].Color = ColorRed
    Controls["Component "..idx.." Automix Control Name"].String = DefaultComponentString
    Controls["Gain "..idx.." Automix Toggle"].Boolean = false
    Controls["Gain "..idx.." Automix Active"].IsInvisible = true
    EnableDisableChannelControls(idx)
    return 
  end 
  -- set color
  Controls["Component "..idx.." Automix Control Name"].Color = ColorGreen
  -- create a new Named Component
  CompAutomix[idx] = Component.New(Controls["Component "..idx.." Automix Code Name"].String)[Controls["Component "..idx.." Automix Control Name"].String]
  -- create a new EventHandler
  CompAutomix[idx].EventHandler = function(ctl) CompAutomixChangeEVT(idx) end 
  -- call EventHandler
  CompAutomixChangeEVT(idx)
  -- enable or disable controls
  EnableDisableChannelControls(idx)
end

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-- Preamp -- Phantom -- Preamp -- Phantom -- Preamp -- Phantom -- Preamp -- Phantom -- Preamp -- Phantom ---
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

-- configure the preamp and phantom controls
function funcSetUpPreamp(idx)
  funcPrintDebug("funcSetUpPreamp --- "..idx)

  -- check that component exists
  local componentName = Controls["Component "..idx.." Preamp Code Name"].String
  local GetCompTbl = Component.GetControls(componentName)
  if #componentName == 0 or componentName == DefaultComponentString or componentName == RemoveOptionString or #GetCompTbl == 0 then 
    Controls["Component "..idx.." Preamp Code Name"].Color = ColorRed
    Controls["Component "..idx.." Preamp Code Name"].String = DefaultComponentString
    Controls["Component "..idx.." Preamp Control Name"].Choices = {}
    Controls["Component "..idx.." Phantom Control Name"].Choices = {}
    funcBuildOrDestroyPreampComponent(idx, "destroy")
    funcBuildOrDestroyPhantomComponent(idx, "destroy")
    GetCompTbl = nil
    return
  else 
    Controls["Component "..idx.." Preamp Code Name"].Color = ColorGreen
    -- find the gains and phantoms in the component
    local gainCtls, phantomCtls = {}, {}
    for _, c_element in ipairs (GetCompTbl) do 
      if string.find(c_element.Name, "gain") then 
        table.insert(gainCtls, c_element.Name)
      end 
      if string.find(c_element.Name, "phantom") then 
        table.insert(phantomCtls, c_element.Name)
      end 
    end
    -- insert remove option
    table.insert(gainCtls,1,RemoveOptionString)
    table.insert(phantomCtls,1,RemoveOptionString)
    -- assign choices
    Controls["Component "..idx.." Preamp Control Name"].Choices = gainCtls
    Controls["Component "..idx.." Phantom Control Name"].Choices = phantomCtls
    -- check if gain control name has been chosen, and if it matches
    local foundPreamp, foundPhantom = false, false 
    if #Controls["Component "..idx.." Mute Control Name"].String > 0 then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Preamp Control Name"].String then 
          foundPreamp = true
        end
        if c_element.Name == Controls["Component "..idx.." Phantom Control Name"].String then 
          foundPhantom = true
        end
      end 
    end
    funcBuildOrDestroyPreampComponent(idx, foundPreamp and "build" or "destroy")
    funcBuildOrDestroyPhantomComponent(idx, foundPhantom and "build" or "destroy")
    GetCompTbl = nil
    gainCtls = nil
    phantomCtls = nil
    -- check for duplicates
    if foundPreamp then 
      funcCheckForDuplicates(idx, 4)
    end 
    if foundPhantom then 
      funcCheckForDuplicates(idx, 5)
    end 
  end
end 

function funcBuildOrDestroyPreampComponent(idx, action)
  funcPrintDebug("funcBuildOrDestroyPreampComponent | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompPreamp[idx] then 
    CompPreamp[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompPreamp[idx] = nil
    Controls["Component "..idx.." Preamp Control Name"].Color = ColorRed
    Controls["Component "..idx.." Preamp Control Name"].String = DefaultComponentString
    Controls["Gain "..idx.." Preamp Preset 1"].Boolean = false
    Controls["Gain "..idx.." Preamp Preset 2"].Boolean = false
    Controls["Gain "..idx.." Preamp Preset 3"].Boolean = false
    EnableDisableChannelControls(idx)
    return 
  end 
  -- set color
  Controls["Component "..idx.." Preamp Control Name"].Color = ColorGreen
  -- create a new Named Component
  CompPreamp[idx] = Component.New(Controls["Component "..idx.." Preamp Code Name"].String)[Controls["Component "..idx.." Preamp Control Name"].String]
  -- create a new EventHandler
  CompPreamp[idx].EventHandler = function(ctl) CompPreampChangeEVT(idx) end 
  -- call EventHandler
  CompPreampChangeEVT(idx)
  -- enable or disable controls
  EnableDisableChannelControls(idx)
end

function funcBuildOrDestroyPhantomComponent(idx, action)
  funcPrintDebug("funcBuildOrDestroyPhantomComponent | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompPhantom[idx] then 
    CompPhantom[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompPhantom[idx] = nil
    Controls["Component "..idx.." Phantom Control Name"].Color = ColorRed
    Controls["Component "..idx.." Phantom Control Name"].String = DefaultComponentString
    Controls["Gain "..idx.." Preamp Phantom Power Toggle"].Boolean = false
    Controls["Gain "..idx.." Preamp Phantom Active"].IsInvisible = true
    EnableDisableChannelControls(idx)
    return 
  end 
  -- set color
  Controls["Component "..idx.." Phantom Control Name"].Color = ColorGreen
  -- create a new Named Component
  CompPhantom[idx] = Component.New(Controls["Component "..idx.." Preamp Code Name"].String)[Controls["Component "..idx.." Phantom Control Name"].String]
  -- create a new EventHandler
  CompPhantom[idx].EventHandler = function(ctl) CompPhantomChangeEVT(idx) end 
  -- call EventHandler
  CompPhantomChangeEVT(idx)
  -- enable or disable controls
  EnableDisableChannelControls(idx)
end


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------ Helpers -- Helpers -- Helpers -- Helpers -- Helpers -- Helpers -- Helpers -- Helpers -- Helpers -----
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

function funcCheckForDuplicates(idx, ctlType)
  -- ctlType 1 : gain
  -- ctlType 2 : mute
  -- ctlType 3 : automix
  -- ctlType 4 : preamp
  -- ctlType 5 : phantom
  local friendlyctlType = {"Gain","Mute","Automix","Preamp","Phantom"}
  funcPrintDebug("funcCheckForDuplicates | "..idx.." | "..friendlyctlType[ctlType])
  local ctlsMap = {
    {CN = Controls["Component "..idx.." Gain Code Name"].String, ctlN = Controls["Component "..idx.." Gain Control Name"].String},
    {CN = Controls["Component "..idx.." Mute Code Name"].String, ctlN = Controls["Component "..idx.." Mute Control Name"].String},
    {CN = Controls["Component "..idx.." Automix Code Name"].String, ctlN = Controls["Component "..idx.." Automix Control Name"].String},
    {CN = Controls["Component "..idx.." Preamp Code Name"].String, ctlN = Controls["Component "..idx.." Preamp Control Name"].String},
    {CN = Controls["Component "..idx.." Preamp Code Name"].String, ctlN = Controls["Component "..idx.." Phantom Control Name"].String},
  }
  
  for k = 1, iMaxGains do 
    local foundDuplicate = false
    local ctlsCompare = {
      {CN = Controls["Component "..k.." Gain Code Name"].String, ctlN = Controls["Component "..k.." Gain Control Name"].String},
      {CN = Controls["Component "..k.." Mute Code Name"].String, ctlN = Controls["Component "..k.." Mute Control Name"].String},
      {CN = Controls["Component "..k.." Automix Code Name"].String, ctlN = Controls["Component "..k.." Automix Control Name"].String},
      {CN = Controls["Component "..k.." Preamp Code Name"].String, ctlN = Controls["Component "..k.." Preamp Control Name"].String},
      {CN = Controls["Component "..k.." Preamp Code Name"].String, ctlN = Controls["Component "..k.." Phantom Control Name"].String},
    }

    -- ignore if k == idx
    if (k ~= idx) then 
      -- compare the code names
      if ctlsMap[ctlType].CN == ctlsCompare[ctlType].CN and ctlsCompare[ctlType].CN  ~= DefaultComponentString then 
        -- if code names match, compare the control names
        if ctlsMap[ctlType].ctlN == ctlsCompare[ctlType].ctlN and ctlsCompare[ctlType].ctlN  ~= DefaultComponentString then 
          funcPrintDebug(friendlyctlType[ctlType].." "..idx.." matches "..k)
          local larger = math.max(k, idx)
          local smaller = math.min(k, idx)
          funcFoundDuplicate(larger, smaller, ctlType)
        end
      end 
    end
  end 

  -- check if idx is using the same control for gain and preamp
  if ctlType == 1 or ctlType == 4 then 
    local foundmatch = nil
    local remap = {
      [1] = 4,
      [4] = 1,
    }
    if ctlsMap[ctlType].CN == ctlsMap[remap[ctlType]].CN and ctlsMap[ctlType].CN  ~= DefaultComponentString then 
      -- if code names match, compare the control names
      if ctlsMap[ctlType].ctlN == ctlsMap[remap[ctlType]].ctlN and ctlsMap[ctlType].ctlN  ~= DefaultComponentString then 
        foundmatch = true
      end
    end
    GainMatchesPreamp[idx] = foundmatch
    if GainMatchesPreamp[idx] then 
      funcPrintDebug("Channel "..idx.." Gain and Preamp are set to match")
    end 
  end
end 

-- gets called when a duplicate is found
function funcFoundDuplicate(larger, smaller, ctlType)
  local friendlyctlType = {"Gain","Mute","Automix","Preamp","Phantom"}
  funcPrintDebug(string.format("funcFoundDuplicate | %s | larger = %u | smaller = %u", friendlyctlType[ctlType], larger, smaller))
  local ctl = nil
  
  if ctlType == 1 then 
    ctl = Controls["Component "..larger.." Gain Control Name"]
  elseif ctlType == 2 then 
    ctl = Controls["Component "..larger.." Mute Control Name"]
  elseif ctlType == 3 then 
    ctl = Controls["Component "..larger.." Automix Control Name"]
  elseif ctlType == 4 then 
    ctl = Controls["Component "..larger.." Preamp Control Name"]
  elseif ctlType == 5 then 
    ctl = Controls["Component "..larger.." Phantom Control Name"]
  end

  if ctl then
    ctl.String = DefaultDuplicateString
    ctl.Color = ColorYellow

    Timer.CallAfter(function() 
      if ctlType == 1 then 
        funcBuildOrDestroyGainComponent(larger, "destroy")
        funcBuildOrDestroyGainComponent(smaller, "build")
      elseif ctlType == 2 then 
        funcBuildOrDestroyMuteComponent(larger, "destroy")
        funcBuildOrDestroyMuteComponent(smaller, "build")
      elseif ctlType == 3 then 
        funcBuildOrDestroyAutomixComponent(larger, "destroy")
        funcBuildOrDestroyAutomixComponent(smaller, "build")
      elseif ctlType == 4 then 
        funcBuildOrDestroyPreampComponent(larger, "destroy")
        funcBuildOrDestroyPreampComponent(smaller, "build")
      elseif ctlType == 5 then 
        funcBuildOrDestroyPhantomComponent(larger, "destroy")
        funcBuildOrDestroyPhantomComponent(smaller, "build")
      end
    end, 2)
  end
end


function EnableDisableChannelControls(idx)
  funcPrintDebug("EnableDisableChannelControls | "..idx)
  if Controls["Gain "..idx.." Disable"].Boolean then 
    Controls["Gain "..idx.." Friendly Name Display"].IsDisabled = true
    Controls["Gain "..idx.." Fader"].IsDisabled = true
    Controls["Gain "..idx.." Meter"].IsDisabled = true
    Controls["Gain "..idx.." Display Min"].IsDisabled = true
    Controls["Gain "..idx.." Display Max"].IsDisabled = true
    Controls["Gain "..idx.." Bump Up"].IsDisabled = true
    Controls["Gain "..idx.." Bump Down"].IsDisabled = true
    Controls["Gain "..idx.." Mute Toggle"].IsDisabled = true
    Controls["Gain "..idx.." Mute State Trigger"].IsDisabled = true
    Controls["Gain "..idx.." Automix Toggle"].IsDisabled = true
    Controls["Gain "..idx.." Automix Active"].IsDisabled = true
    Controls["Gain "..idx.." Preamp Phantom Power Toggle"].IsDisabled = true
    Controls["Gain "..idx.." Preamp Phantom Active"].IsDisabled = true
    Controls["Gain "..idx.." Preamp Preset 1"].IsDisabled = true
    Controls["Gain "..idx.." Preamp Preset 2"].IsDisabled = true
    Controls["Gain "..idx.." Preamp Preset 3"].IsDisabled = true
    Controls["Gain "..idx.." Display 1"].IsDisabled = true
    Controls["Gain "..idx.." Display 2"].IsDisabled = true
    Controls["Gain "..idx.." Display 3"].IsDisabled = true
  else 
    Controls["Gain "..idx.." Friendly Name Display"].IsDisabled = false 
    -- gain controls
    Controls["Gain "..idx.." Fader"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Meter"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Display Min"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Display Max"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Bump Up"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Bump Down"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Display 1"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Display 2"].IsDisabled = CompGain[idx] == nil
    Controls["Gain "..idx.." Display 3"].IsDisabled = CompGain[idx] == nil
    -- mute controls
    Controls["Gain "..idx.." Mute Toggle"].IsDisabled = CompMute[idx] == nil
    Controls["Gain "..idx.." Mute State Trigger"].IsDisabled = CompMute[idx] == nil
    -- automix controls
    Controls["Gain "..idx.." Automix Toggle"].IsDisabled = CompAutomix[idx] == nil
    Controls["Gain "..idx.." Automix Active"].IsDisabled = CompAutomix[idx] == nil
    -- phantom controls
    Controls["Gain "..idx.." Preamp Phantom Power Toggle"].IsDisabled = CompPhantom[idx] == nil
    Controls["Gain "..idx.." Preamp Phantom Active"].IsDisabled = CompPhantom[idx] == nil
    -- Preamp controls
    Controls["Gain "..idx.." Preamp Preset 1"].IsDisabled = CompPreamp[idx] == nil
    Controls["Gain "..idx.." Preamp Preset 2"].IsDisabled = CompPreamp[idx] == nil
    Controls["Gain "..idx.." Preamp Preset 3"].IsDisabled = CompPreamp[idx] == nil
  end 
end 

function funcInsibilityControl(idx)
  local bool = Controls["Gain "..idx.." Invisible"].Boolean
  Controls["Gain "..idx.." Friendly Name Display"].IsInvisible = bool
  Controls["Gain "..idx.." Fader"].IsInvisible = bool
  Controls["Gain "..idx.." Meter"].IsInvisible = bool
  Controls["Gain "..idx.." Display Min"].IsInvisible = bool
  Controls["Gain "..idx.." Display Max"].IsInvisible = bool
  Controls["Gain "..idx.." Bump Up"].IsInvisible = bool
  Controls["Gain "..idx.." Bump Down"].IsInvisible = bool
  Controls["Gain "..idx.." Mute Toggle"].IsInvisible = bool
  Controls["Gain "..idx.." Mute State Trigger"].IsInvisible = bool
  Controls["Gain "..idx.." Automix Toggle"].IsInvisible = bool
  Controls["Gain "..idx.." Preamp Phantom Power Toggle"].IsInvisible = bool
  Controls["Gain "..idx.." Preamp Preset 1"].IsInvisible = bool
  Controls["Gain "..idx.." Preamp Preset 2"].IsInvisible = bool
  Controls["Gain "..idx.." Preamp Preset 3"].IsInvisible = bool
  Controls["Gain "..idx.." Display 1"].IsInvisible = bool
  Controls["Gain "..idx.." Display 2"].IsInvisible = bool
  Controls["Gain "..idx.." Display 3"].IsInvisible = bool
  if bool then
    Controls["Gain "..idx.." Preamp Phantom Active"].IsInvisible = bool
  elseif CompPhantom[idx] then
    Controls["Gain "..idx.." Preamp Phantom Active"].IsInvisible = not CompPhantom[idx].Boolean 
  end
  if bool then
    Controls["Gain "..idx.." Automix Active"].IsInvisible = bool
  elseif CompAutomix[idx] then
    Controls["Gain "..idx.." Automix Active"].IsInvisible = CompAutomix[idx].Boolean 
  end
end 

-- put the channel name text into the display and automixer channel names
function SyncNames(idx)
  local S = string.gsub(Controls["Gain "..idx.." Friendly Name"].String, "//", "\x0D")
  Controls["Gain "..idx.." Friendly Name Display"].String = S
  for i = 1, 3 do 
    if Controls["Gain "..idx.." Display Override "..i].Boolean then 
      Controls["Gain "..idx.." Display "..i].String = S
    end
  end 
end 

-- put the preamp preset names onto the preamp preset buttons
function SyncPreampLegends(idx)
  for k = 1, 3 do
     Controls["Gain "..idx.." Preamp Preset "..k].Legend = Controls["Gain "..idx.." Preamp Preset Name "..k].String
  end
end 

-- function returns a value of 2,3,4 based on fader position
function FaderPositionValue(position)
  -- cycle through MuteStateTriggerRangeCompare and compare position to the upper and lower keys.
  -- if it falls between upper and lower, return key "val"
  for k,v in pairs (MuteStateTriggerRangeCompare) do
    if position < v.upper and position >= v.lower then 
      return v.val
    end 
  end 
end

-- a function to set values for state trigger mute buttons
function funcStateTriggerMuteButtons(idx)
  if not Controls["Gain "..idx.." Mute Toggle"].Boolean then
    local STV = FaderPositionValue(Controls["Gain "..idx.." Fader"].Position)
    Controls["Gain "..idx.." Mute State Trigger"].Value = STV
    Controls["Gain "..idx.." Mute State Trigger Value"].String = tostring(STV)
  else 
    Controls["Gain "..idx.." Mute State Trigger"].Value = 1
    Controls["Gain "..idx.." Mute State Trigger Value"].String = "1"
  end
end 

-- a function to set feedback on the gain displays
function funcGainDisplays(idx, val, pos, key)

  -- dB readout
  if key == nil or key == 1 then
    local S = string.format("%.1fdB", val)
    if val > 0 then 
      S = "+"..S
    end
    Controls["Gain "..idx.." Display 1"].String = S
  end

  local P = math.floor(tonumber(string.format("%.4s", pos)) * 100)

  -- 0-100 readout
  if key == nil or key == 3 then
    Controls["Gain "..idx.." Display 3"].String = P
  end

  -- percent readout
  if key == nil or key == 2 then
    Controls["Gain "..idx.." Display 2"].String = P.."%"
  end

  TextTimerTbl[idx]:Start(math.floor(Controls["Text Override Time"].Value))
end 

-- evaluate presets
function funcEvalPreampPresets(idx)
  for k = 1, 3 do 
    Controls["Gain "..idx.." Preamp Preset "..k].Boolean = false 
    if CompPreamp[idx].Value == Controls["Gain "..idx.." Preamp Preset Value "..k].Value then 
      Controls["Gain "..idx.." Preamp Preset "..k].Boolean = true 
    end
  end 
end 



----------------------------------------------------------------------------------------------------------------------------
-- $$$$$$$$\                             $$\     $$\   $$\                           $$\ $$\                               
-- $$  _____|                            $$ |    $$ |  $$ |                          $$ |$$ |                              
-- $$ |  $$\    $$\  $$$$$$\  $$$$$$$\ $$$$$$\   $$ |  $$ | $$$$$$\  $$$$$$$\   $$$$$$$ |$$ | $$$$$$\   $$$$$$\   $$$$$$$\ 
-- $$$$$\\$$\  $$  |$$  __$$\ $$  __$$\\_$$  _|  $$$$$$$$ | \____$$\ $$  __$$\ $$  __$$ |$$ |$$  __$$\ $$  __$$\ $$  _____|
-- $$  __|\$$\$$  / $$$$$$$$ |$$ |  $$ | $$ |    $$  __$$ | $$$$$$$ |$$ |  $$ |$$ /  $$ |$$ |$$$$$$$$ |$$ |  \__|\$$$$$$\  
-- $$ |    \$$$  /  $$   ____|$$ |  $$ | $$ |$$\ $$ |  $$ |$$  __$$ |$$ |  $$ |$$ |  $$ |$$ |$$   ____|$$ |       \____$$\ 
-- $$$$$$$$\\$  /   \$$$$$$$\ $$ |  $$ | \$$$$  |$$ |  $$ |\$$$$$$$ |$$ |  $$ |\$$$$$$$ |$$ |\$$$$$$$\ $$ |      $$$$$$$  |
-- \________|\_/     \_______|\__|  \__|  \____/ \__|  \__| \_______|\__|  \__| \_______|\__| \_______|\__|      \_______/ 
----------------------------------------------------------------------------------------------------------------------------

for idx = 1, iMaxGains do 

  ------------------- Component Gain Code Name Changes
  Controls["Component "..idx.." Gain Code Name"].EventHandler = function()
    funcSetUpGain(idx)
  end 

  ------------------- Component Mute Code Name Changes
  Controls["Component "..idx.." Mute Code Name"].EventHandler = function()
    funcSetUpMute(idx)
  end 

  ------------------- Component Automix Name Changes
  Controls["Component "..idx.." Automix Code Name"].EventHandler = function()
    funcSetUpAutomix(idx)
  end 

  ------------------- Component Preamp Code Name Changes
  Controls["Component "..idx.." Preamp Code Name"].EventHandler = function()
    funcSetUpPreamp(idx)
  end 

  ------------------- Gain Control Name Changes
  Controls["Component "..idx.." Gain Control Name"].EventHandler = function()
    funcSetUpGain(idx)
  end 

  ------------------- Mute Control Name Changes
  Controls["Component "..idx.." Mute Control Name"].EventHandler = function()
    funcSetUpMute(idx)
  end 

  ------------------- Preamp Control Name Changes
  Controls["Component "..idx.." Automix Control Name"].EventHandler = function()
    funcSetUpAutomix(idx)
  end 

  ------------------- Preamp Control Name Changes
  Controls["Component "..idx.." Preamp Control Name"].EventHandler = function()
    funcSetUpPreamp(idx)
  end 

  ------------------- Phantom Control Name Changes
  Controls["Component "..idx.." Phantom Control Name"].EventHandler = function()
    funcSetUpPreamp(idx)
  end 

  ------------------- Friendly name changes
  Controls["Gain "..idx.." Friendly Name"].EventHandler = function()
    SyncNames(idx)
  end

  ------------------- Fader changes
  Controls["Gain "..idx.." Fader"].EventHandler = function(ctl)
    if CompGain[idx] then 
      CompGain[idx].Value = ctl.Value
    end 
  end 

  ------------------- Gain Bump Up
  Controls["Gain "..idx.." Bump Up"].EventHandler = function(ctl)
    if CompGain[idx] and CompGain[idx].Value < Properties["Max dB "..idx].Value then 
      CompGain[idx].Value = CompGain[idx].Value + 1
    end 
  end 

  ------------------- Gain Bump Down
  Controls["Gain "..idx.." Bump Down"].EventHandler = function(ctl)
    if CompGain[idx] and CompGain[idx].Value > Properties["Min dB "..idx].Value then 
      CompGain[idx].Value = CompGain[idx].Value - 1
    end 
  end 

  ------------------- Mute Toggle changes
  Controls["Gain "..idx.." Mute Toggle"].EventHandler = function(ctl)
    if CompMute[idx] then 
      CompMute[idx].Boolean = ctl.Boolean
    end 
  end 

  ------------------- Automix Toggle
  Controls["Gain "..idx.." Automix Toggle"].EventHandler = function(ctl)
    if CompAutomix[idx] then 
      CompAutomix[idx].Boolean = not ctl.Boolean
    end 
  end 

  ------------------- Mute State Trigger
  Controls["Gain "..idx.." Mute State Trigger"].EventHandler = function(ctl)
    if CompMute[idx] then 
      CompMute[idx].Boolean = not CompMute[idx].Boolean
    end 
  end 

  ------------------- Preamp Phantom Power Toggle
  Controls["Gain "..idx.." Preamp Phantom Power Toggle"].EventHandler = function(ctl)
    if CompPhantom[idx] then 
      CompPhantom[idx].Boolean = ctl.Boolean
    end 
  end 

  ------------------- TextTimerTbl Timer expires
  TextTimerTbl[idx].EventHandler = function()
    TextTimerTbl[idx]:Stop()
    SyncNames(idx)
  end  

  ------------------- Gain control invisible toggle
  Controls["Gain "..idx.." Invisible"].EventHandler = function(ctl)
    funcInsibilityControl(idx)
  end 

  ------------------- Gain control disable toggle
  Controls["Gain "..idx.." Disable"].EventHandler = function(ctl)
    EnableDisableChannelControls(idx)
  end 

  
  for k = 1, 3 do 

    ------------------- Display Override buttons (x3 per channel)
    Controls["Gain "..idx.." Display Override "..k].EventHandler = function(ctl)
      if ctl.Boolean then 
        SyncNames(idx)
      else 
        if CompGain[idx] then
          funcGainDisplays(idx, CompGain[idx].Value, Controls["Gain "..idx.." Fader"].Position, k)
        else 
          SyncNames(idx)
        end
      end 
    end

    ------------------- Preamp Preset Names (x3 per channel)
    Controls["Gain "..idx.." Preamp Preset Name "..k].EventHandler = function()
      SyncPreampLegends(idx)
    end 

    ------------------- Preamp Preset (x3 per channel)
    Controls["Gain "..idx.." Preamp Preset "..k].EventHandler = function()
      if CompPreamp[idx] then
        CompPreamp[idx].Value = Controls["Gain "..idx.." Preamp Preset Value "..k].Value
        funcEvalPreampPresets(idx)
      end 
    end 

    ------------------- Preamp Preset Value (x3 per channel)
    Controls["Gain "..idx.." Preamp Preset Value "..k].EventHandler = function()
      if CompGain[idx] then
        funcEvalPreampPresets(idx)
      end 
    end 
  end 
end 

-- logo trigger button is pressed
Controls["Logo"].EventHandler = function()
  for idx = 1, iMaxGains do 
    Controls["Gain "..idx.." Friendly Name Display"].String = "Onyx AV"
  end
  Timer.CallAfter(function()
    for idx = 1, iMaxGains do 
      SyncNames(idx)
    end 
  end, 2)
end



---------------------------------------------------------------------------------- Remote EVTs

---------------------- named component Gain changes
function CompGainChangeEVT(idx)
  Controls["Gain "..idx.." Fader"].Value = CompGain[idx].Value
  -- set strings on the 3x displays
  funcGainDisplays(idx, CompGain[idx].Value, Controls["Gain "..idx.." Fader"].Position)
  -- set state trigger buttons
  if CompMute[idx] then
    funcStateTriggerMuteButtons(idx)
  end
  -- evaluate preamp presets if the gain and preamp are controlling the same named component
  if GainMatchesPreamp[idx] then 
    funcEvalPreampPresets(idx)
  end
end 

---------------------- named component automix changes
function CompAutomixChangeEVT(idx)
  Controls["Gain "..idx.." Automix Toggle"].Boolean = not CompAutomix[idx].Boolean
  if not Controls["Gain "..idx.." Invisible"].Boolean then
    Controls["Gain "..idx.." Automix Active"].IsInvisible = CompAutomix[idx].Boolean  
  end
end 

---------------------- named component Preamp changes
function CompPreampChangeEVT(idx)
  funcEvalPreampPresets(idx)

  -- adjust the gain control if the gain and preamp are controlling the same named component
  if GainMatchesPreamp[idx] then 
    Controls["Gain "..idx.." Fader"].Value = CompPreamp[idx].Value
    -- set strings on the 3x displays
    funcGainDisplays(idx, CompPreamp[idx].Value, Controls["Gain "..idx.." Fader"].Position)
    -- set state trigger buttons
    if CompMute[idx] then
      funcStateTriggerMuteButtons(idx)
    end
  end
end 

---------------------- named component Mute changes
function CompMuteChangeEVT(idx)
  Controls["Gain "..idx.." Mute Toggle"].Boolean = CompMute[idx].Boolean
  -- set state trigger buttons
  if CompGain[idx] then
    funcStateTriggerMuteButtons(idx)
  end
end 

---------------------- named component Phantom changes
function CompPhantomChangeEVT(idx)
  Controls["Gain "..idx.." Preamp Phantom Power Toggle"].Boolean = CompPhantom[idx].Boolean
  if not Controls["Gain "..idx.." Invisible"].Boolean then
    Controls["Gain "..idx.." Preamp Phantom Active"].IsInvisible = not CompPhantom[idx].Boolean
  end
end 


----------------------------------------------------------------------------------------------------------------------------
--  $$$$$$\                   $$$$$$\    $$\                          $$\     
-- $$  __$$\                 $$  __$$\   $$ |                         $$ |    
-- $$ /  $$ |$$$$$$$\        $$ /  \__|$$$$$$\    $$$$$$\   $$$$$$\ $$$$$$\   
-- $$ |  $$ |$$  __$$\       \$$$$$$\  \_$$  _|   \____$$\ $$  __$$\\_$$  _|  
-- $$ |  $$ |$$ |  $$ |       \____$$\   $$ |     $$$$$$$ |$$ |  \__| $$ |    
-- $$ |  $$ |$$ |  $$ |      $$\   $$ |  $$ |$$\ $$  __$$ |$$ |       $$ |$$\ 
--  $$$$$$  |$$ |  $$ |      \$$$$$$  |  \$$$$  |\$$$$$$$ |$$ |       \$$$$  |
--  \______/ \__|  \__|       \______/    \____/  \_______|\__|        \____/ 
----------------------------------------------------------------------------------------------------------------------------



local INITIALIZATION_DELAY = 0.3
local InitializationComplete = false

local function InitializeGain(idx)
  print("Initialize Gain | "..idx)
  -- All gains have been initialized
  if idx > iMaxGains then
    InitializationComplete = true
    print("Gain initialization complete")
    print(PluginInfo.Name.." V"..PluginInfo.Version.." Build "..PluginInfo.BuildVersion)
    return
  end

  Controls["Gain "..idx.." Index"].String = tostring(idx)

  funcSetUpGain(idx)

  if Properties["Link Mute "..idx].Value == false then
    funcSetUpMute(idx)
  end

  funcSetUpAutomix(idx)
  funcSetUpPreamp(idx)
  SyncNames(idx)
  SyncPreampLegends(idx)
  funcInsibilityControl(idx)

  -- Schedule the next gain as a new execution
  Timer.CallAfter(function()
      InitializeGain(idx + 1)
    end, INITIALIZATION_DELAY
  )
end



function Init()
  print(PluginInfo.Name.." V"..PluginInfo.Version.." Build "..PluginInfo.BuildVersion)
  DebugPrint = Properties["plugin_show_debug"].Value == true
  funcGetComponents()
  InitializationComplete = false
  print("This is the correct runtime.")

  -- Start asynchronously so Init() can finish first
  Timer.CallAfter(function()
      InitializeGain(1)
    end,
    INITIALIZATION_DELAY
  )
 
end 
Init()

end
