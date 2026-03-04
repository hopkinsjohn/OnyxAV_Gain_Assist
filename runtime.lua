if Controls then
-- Import dependencies
local rapidjson = require("rapidjson")


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
local DefaultComponentString = "Enter Component Name"
local DefaultDuplicateString = "No Duplicates"
local ColorRed = "OrangeRed"
local ColorGreen = "LightGreen"
local ColorYellow = "Yellow"
local ColorWhite = "White"

-- holds the named components
CompGain = {}
CompMute = {}
CompPhantom = {}
for i = 1, iMaxGains do 
  CompGain[i] = nil
  CompMute[i] = nil
  CompPhantom[i] = nil
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


function funcSetUpComponent(idx)
  funcPrintDebug("funcSetUpComponent --- "..idx)

  -- set min / max display controls
  local min, max = Properties["Min dB "..idx].Value, Properties["Max dB "..idx].Value
  Controls["Gain "..idx.." Display Min"].String = min > 0 and string.format("+%i", min) or (tostring(min))
  Controls["Gain "..idx.." Display Max"].String = max > 0 and string.format("+%i", max) or (tostring(max))

  -- check that component exists
  local componentName = Controls["Component "..idx.." Component Name"].String
  local GetCompTbl = Component.GetControls(componentName)
  local gainName = Controls["Component "..idx.." Gain Control Name"].String
  local muteName = Controls["Component "..idx.." Mute Control Name"].String

  if #componentName == 0 or componentName == DefaultComponentString then         
    -- string is empty, ignore
    funcPrintDebug("Error : Empty Component String")
    funDisableMainControls(idx, "all", true)
    Controls["Component "..idx.." Component Name"].Color = ColorRed
    Controls["Component "..idx.." Component Name"].String = DefaultComponentString
    funcSetUpGain(idx, "destroy")
    funcSetUpMute(idx, "destroy")
    funcSetUpPhantom(idx, "destroy")
    GetCompTbl = nil
    return
  elseif #GetCompTbl == 0 then 
    -- component does not exist, ignore
    funcPrintDebug("Error : Component Not Found")
    funDisableMainControls(idx, "all", true)
    Controls["Component "..idx.." Component Name"].Color = ColorRed
    Controls["Component "..idx.." Component Name"].String = DefaultComponentString
    funcSetUpGain(idx, "destroy")
    funcSetUpMute(idx, "destroy")
    funcSetUpPhantom(idx, "destroy")
    GetCompTbl = nil
    return
  else 
    -- component exists.
    -- check for gain and mute controls
    funDisableMainControls(idx, "info", false)
    Controls["Component "..idx.." Component Name"].Color = ColorGreen

    -- tables to hold gains, mutes
    local GetCompTblGains, GetCompTblMutes, GetCompTblPhantoms = {}, {}, {}
    -- cycle thru the Component.GetControls table, find gains, find mutes
    for _, c_element in ipairs (GetCompTbl) do 
      if string.find(c_element.Name, "gain") then 
        table.insert(GetCompTblGains,c_element.Name)
      end 
      if string.find(c_element.Name, "mute") then 
        table.insert(GetCompTblMutes,c_element.Name)
      end 
      if string.find(c_element.Name, "phantom") then 
        table.insert(GetCompTblPhantoms,c_element.Name)
      end 
    end 

    -- assign choices
    Controls["Component "..idx.." Gain Control Name"].Choices = GetCompTblGains
    Controls["Component "..idx.." Mute Control Name"].Choices = GetCompTblMutes
    Controls["Component "..idx.." Phantom Control Name"].Choices = GetCompTblPhantoms

    -- loop thru the Component.GetControls, determine if there's a match
    local foundGain, foundMute, foundPhantom = false, false, false
    if #Controls["Component "..idx.." Gain Control Name"].String > 0 then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Gain Control Name"].String then 
          foundGain = true
        end
      end 
    end
    if Controls["Component "..idx.." Mute Control Name"].String ~= "" then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Mute Control Name"].String then 
          foundMute = true
        end
      end 
    end
    if Controls["Component "..idx.." Phantom Control Name"].String ~= "" then
      for _ , c_element in ipairs (GetCompTbl) do 
        if c_element.Name == Controls["Component "..idx.." Phantom Control Name"].String then 
          foundPhantom = true
        end
      end 
    end

    -- clear string if no match
    if not foundGain then Controls["Component "..idx.." Gain Control Name"].String = "" end 
    if not foundMute then Controls["Component "..idx.." Mute Control Name"].String = "" end
    if not foundPhantom then Controls["Component "..idx.." Phantom Control Name"].String = "" end
    -- check for duplicates - returns a table
    local DuplicateIndex = funcCheckForDuplicates(idx)
    local larger = nil
    -- call functions to build or destroy the named component
    if DuplicateIndex[1] then 
      funcPrintDebug("Found Duplicate - Destroying the larger of the two")
      larger = (DuplicateIndex[1] > idx) and DuplicateIndex[1] or idx
      if DuplicateIndex[2] then
        funcSetUpGain(larger, "destroy")
        funcFoundDuplicate(larger, "gain")
      end 
      if DuplicateIndex[3] then
        funcSetUpMute(larger, "destroy")
        funcFoundDuplicate(larger, "mute")
      end
      if DuplicateIndex[4] then
        funcSetUpPhantom(larger, "destroy")
        funcFoundDuplicate(larger, "phantom")
      end
    end
    if idx ~= larger then
      funcSetUpGain(idx, foundGain and "build" or "destroy")
      funcSetUpMute(idx, foundMute and "build" or "destroy")
      funcSetUpPhantom(idx, foundPhantom and "build" or "destroy")
    end

    -- clear tables
    GetCompTblGains, GetCompTblMutes, GetCompTblPhantoms = nil, nil, nil
  end 
  GetCompTbl = nil
end

function funcSetUpGain(idx, action)
  funcPrintDebug("funcSetUpGain | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompGain[idx] then 
    CompGain[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompGain[idx] = nil
    funDisableMainControls(idx, "fader", true) 
    Controls["Component "..idx.." Gain Control Name"].String = ""
    funcConfigGainControlState(idx)
    return 
  end 
  -- enable the main user controls
  funDisableMainControls(idx, "fader", false) 
  -- create a new Named Component
  CompGain[idx] = Component.New(Controls["Component "..idx.." Component Name"].String)[Controls["Component "..idx.." Gain Control Name"].String]
  -- create a new EventHandler
  CompGain[idx].EventHandler = function(ctl) CompGainChangeEVT(idx) end 
  -- configure the gain conttrol combo box state
  funcConfigGainControlState(idx)
  -- call EventHandler
  CompGainChangeEVT(idx)
end 

function funcSetUpMute(idx, action)
  funcPrintDebug("funcSetUpMute | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompMute[idx] then 
    CompMute[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompMute[idx] = nil 
    funDisableMainControls(idx, "mute", true) 
    Controls["Component "..idx.." Mute Control Name"].String = ""
    funcConfigMuteControlState(idx)
    return 
  end 
  -- enable the main user controls
  funDisableMainControls(idx, "mute", false)
  -- create a new Named Component
  CompMute[idx] = Component.New(Controls["Component "..idx.." Component Name"].String)[Controls["Component "..idx.." Mute Control Name"].String]
  -- create a new EventHandler
  CompMute[idx].EventHandler = function(ctl) CompMuteChangeEVT(idx) end 
  -- configure the mute conttrol combo box state
  funcConfigMuteControlState(idx)
  -- call EventHandler
  CompMuteChangeEVT(idx)
end 

function funcSetUpPhantom(idx, action)
  funcPrintDebug("funcSetUpPhantom | "..idx.." | "..action)
  -- destroy EventHandler if existing
  if CompPhantom[idx] then 
    CompPhantom[idx].EventHandler = nil
  end 
  -- clear some things up and exit
  if action == "destroy" then 
    CompPhantom[idx] = nil 
    funDisableMainControls(idx, "phantom", true) 
    Controls["Component "..idx.." Phantom Control Name"].String = ""
    funcConfigPhantomControlState(idx)
    return 
  end 
  -- enable the main user controls
  funDisableMainControls(idx, "phantom", false)
  -- create a new Named Component
  CompPhantom[idx] = Component.New(Controls["Component "..idx.." Component Name"].String)[Controls["Component "..idx.." Phantom Control Name"].String]
  -- create a new EventHandler
  CompPhantom[idx].EventHandler = function(ctl) CompPhantomChangeEVT(idx) end 
  -- configure the mute conttrol combo box state
  funcConfigPhantomControlState(idx)
  -- call EventHandler
  CompPhantomChangeEVT(idx)
end 

-- configure the gain conttrol combo box state
function funcConfigGainControlState(idx)
  local ctl = Controls["Component "..idx.." Gain Control Name"]
  local componentName = Controls["Component "..idx.." Component Name"].String
  local isDefault = componentName == DefaultComponentString

  ctl.IsDisabled = isDefault

  if isDefault then 
    ctl.Choices = {}
    ctl.String = ""
    ctl.Color = ColorWhite
  else 
    ctl.Color = #ctl.String > 0 and ColorGreen or ColorRed
  end 
end 

-- configure the mute conttrol combo box state
function funcConfigMuteControlState(idx)
  local ctl = Controls["Component "..idx.." Mute Control Name"]
  local componentName = Controls["Component "..idx.." Component Name"].String
  local isDefault = componentName == DefaultComponentString

  ctl.IsDisabled = isDefault

  if isDefault then 
    ctl.Choices = {}
    ctl.String = ""
    ctl.Color = ColorWhite
  else 
    ctl.Color = #ctl.String > 0 and ColorGreen or ColorRed
  end 
end 

-- configure the phantom conttrol combo box state
function funcConfigPhantomControlState(idx)
  local ctl = Controls["Component "..idx.." Phantom Control Name"]
  local componentName = Controls["Component "..idx.." Component Name"].String
  local isDefault = componentName == DefaultComponentString

  ctl.IsDisabled = isDefault

  if isDefault then 
    ctl.Choices = {}
    ctl.String = ""
    ctl.Color = ColorWhite
  else 
    ctl.Color = #ctl.String > 0 and ColorGreen or ColorRed
  end 
end 

-- check for duplicates
function funcCheckForDuplicates(idx)
  
  local S1 = Controls["Component "..idx.." Component Name"].String
  local S2 = Controls["Component "..idx.." Gain Control Name"].String
  local S3 = Controls["Component "..idx.." Mute Control Name"].String
  local S4 = Controls["Component "..idx.." Phantom Control Name"].String
  local returnTbl = {nil, nil, nil, nil}

  for k =  1, iMaxGains do 
    local C1 = Controls["Component "..k.." Component Name"].String
    local C2 = Controls["Component "..k.." Gain Control Name"].String
    local C3 = Controls["Component "..k.." Mute Control Name"].String
    local C4 = Controls["Component "..k.." Phantom Control Name"].String

    if (k ~= idx) and (S1 == C1 and C1 ~= DefaultComponentString) then 
      if (S2 == C2 and #C2 > 0) then -- duplicate gain
        returnTbl[1] = k
        returnTbl[2] = k
      end
      if (S3 == C3 and #C3 > 0) then -- duplicate mute
        returnTbl[1] = k
        returnTbl[3] = k
      end
      if (S4 == C4 and #C4 > 0) then -- duplicate phantom
        returnTbl[1] = k
        returnTbl[4] = k
      end
      if returnTbl[1] then break end  -- break the for loop
    end
  end 
  return returnTbl
end 

-- show a duplicate notice
function funcFoundDuplicate(idx, ctlType)
  local ctl = nil
  if ctlType == "gain" then
    ctl = Controls["Component "..idx.." Gain Control Name"]
  elseif ctlType == "mute" then 
    ctl = Controls["Component "..idx.." Mute Control Name"]
  elseif ctlType == "phantom" then 
    ctl = Controls["Component "..idx.." Phantom Control Name"]
  end 

  if ctl then
    ctl.String = DefaultDuplicateString
    ctl.Color = ColorYellow

    Timer.CallAfter(function() 
      ctl.String = ""
      if ctlType == "gain" then
        funcConfigGainControlState(idx)
      elseif ctlType == "mute" then 
        funcConfigMuteControlState(idx)
      elseif ctlType == "phantom" then 
        funcConfigPhantomControlState(idx)
      end 
    end, 2)
  end
end

-- enable or disable a bank of controls
function funDisableMainControls(idx, part, bool)
  if part == "all" or part == "info" then
    Controls["Gain "..idx.." Index"].IsDisabled = bool
    Controls["Gain "..idx.." Friendly Name"].IsDisabled = bool
    Controls["Gain "..idx.." Friendly Name Display"].IsDisabled = bool
  end

  if part == "all" or part == "fader" then
    Controls["Gain "..idx.." Fader"].IsDisabled = bool
    Controls["Gain "..idx.." Display Max"].IsDisabled = bool
    Controls["Gain "..idx.." Display Min"].IsDisabled = bool
    Controls["Gain "..idx.." Bump Up"].IsDisabled = bool
    Controls["Gain "..idx.." Bump Down"].IsDisabled = bool
    for k = 1, 3 do 
      Controls["Gain "..idx.." Display Override "..k].IsDisabled = bool
      Controls["Gain "..idx.." Display "..k].IsDisabled = bool
    end 
    if bool then 
      Controls["Gain "..idx.." Fader"].Position = 0
      for k = 1, 3 do 
        Controls["Gain "..idx.." Display Override "..k].Boolean = false
        Controls["Gain "..idx.." Display "..k].String = ""
      end 
    end
  end

  if part == "all" or part == "mute" then
    Controls["Gain "..idx.." Mute Toggle"].IsDisabled = bool
    Controls["Gain "..idx.." Mute State Trigger"].IsDisabled = bool
    Controls["Gain "..idx.." Mute State Trigger Value"].IsDisabled = bool
    if bool then 
      Controls["Gain "..idx.." Mute Toggle"].Boolean = false
      Controls["Gain "..idx.." Mute State Trigger"].Value = 0
      Controls["Gain "..idx.." Mute State Trigger Value"].String = ""
    end
  end

  if part == "all" or part == "phantom" then
    Controls["Gain "..idx.." Preamp Phantom Power Toggle"].IsDisabled = bool
    for k = 1, 3 do 
      if CompGain[idx] then
        Controls["Gain "..idx.." Preamp Preset "..k].IsDisabled = bool
      else
        Controls["Gain "..idx.." Preamp Preset "..k].IsDisabled = true
      end
    end 
    if bool then 
      Controls["Gain "..idx.." Preamp Phantom Power Toggle"].Boolean = false
      Controls["Gain "..idx.." Preamp Phantom Active"].IsInvisible = true
      for k = 1, 3 do 
        Controls["Gain "..idx.." Preamp Preset "..k].Boolean = false
      end 
    end
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
    if CompGain[idx].Value == Controls["Gain "..idx.." Preamp Preset Value "..k].Value then 
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

  ------------------- Component Name Changes
  Controls["Component "..idx.." Component Name"].EventHandler = function()
    funcSetUpComponent(idx)
  end 

  ------------------- Component Gain Control Changes
  Controls["Component "..idx.." Gain Control Name"].EventHandler = function()
    funcSetUpComponent(idx)
  end 

  ------------------- Component Mute Control Changes
  Controls["Component "..idx.." Mute Control Name"].EventHandler = function()
    funcSetUpComponent(idx)
  end 

  ------------------- Component Phantom Control Changes
  Controls["Component "..idx.." Phantom Control Name"].EventHandler = function()
    funcSetUpComponent(idx)
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
      if CompGain[idx] then
        CompGain[idx].Value = Controls["Gain "..idx.." Preamp Preset Value "..k].Value
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



---------------------------------------------------------------------------------- Remove EVTs

---------------------- named component Gain changes
function CompGainChangeEVT(idx)
  Controls["Gain "..idx.." Fader"].Value = CompGain[idx].Value
  -- set strings on the 3x displays
  funcGainDisplays(idx, CompGain[idx].Value, Controls["Gain "..idx.." Fader"].Position)
  -- set state trigger buttons
  if CompMute[idx] then
    funcStateTriggerMuteButtons(idx)
  end
  -- evaluate preamp presets if using preamp controls
  if Properties["Preamp Controls "..idx].Value == true then 
    funcEvalPreampPresets(idx)
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
  Controls["Gain "..idx.." Preamp Phantom Active"].IsInvisible = not CompPhantom[idx].Boolean
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



function Init()
  print(PluginInfo.Name.." V"..PluginInfo.Version.." Build "..PluginInfo.BuildVersion)
  DebugPrint = Properties["plugin_show_debug"].Value == true

  for idx = 1, iMaxGains do 
    Controls["Gain "..idx.." Index"].String = tostring(idx)
    funcSetUpComponent(idx)
    SyncNames(idx)
    SyncPreampLegends(idx)
  end 
  
end 
Init()

end
