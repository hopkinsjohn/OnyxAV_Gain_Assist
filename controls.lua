


-- RUNTIME CODE input pin (comment this out when runtime has been added to this plugin)
table.insert(ctrls,{Name = "code",ControlType = "Text",UserPin = true,PinStyle = "Input",Count = 1})

-----------------------------------------------------
-------------------- Variables ----------------------
-----------------------------------------------------

local iMaxGains = math.floor(props["Number Of Gains"].Value)

local GainMaxTbl, GainMinTbl = {}, {}
for i = 1, iMaxGains do
  GainMaxTbl[i] = props["Max dB "..i].Value
  GainMinTbl[i] = props["Min dB "..i].Value
end


-----------------------------------------------------
-------------------- Controls -----------------------
-----------------------------------------------------

for i = 1, iMaxGains do
  ------------------------------- gain index
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Index",
    ControlType     = "Indicator",
    IndicatorType   = "Text",
    UserPin         = false,
  })  
  ------------------------------- gain friendly name
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Friendly Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- gain friendly name display
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Friendly Name Display",
    ControlType     = "Indicator",
    IndicatorType   = "Text",
    UserPin         = true,
    PinStyle        = "Output",
  })
  ------------------------------- gain fader
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Fader",
    ControlType     = "Knob",
    ControlUnit     = "dB",
    Min             = GainMinTbl[i],
    Max             = GainMaxTbl[i],
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- max gain display
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Display Max",
    ControlType     = "Indicator",
    IndicatorType   = "Text",
    UserPin         = false,
  })
  ------------------------------- min gain display
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Display Min",
    ControlType     = "Indicator",
    IndicatorType   = "Text",
    UserPin         = false,
  })
  
  ------------------------------- gain up trigger
  table.insert(ctrls, {
    Name            = "Gain "..i.." Bump Up",
    ControlType     = "Button",
    ButtonType      = "Trigger",
    UserPin         = true,
    PinStyle        = "Both",
    IconType        = "Icon",
    Icon            = "Plus",
  })
  ------------------------------- gain down trigger
  table.insert(ctrls, {
    Name            = "Gain "..i.." Bump Down",
    ControlType     = "Button",
    ButtonType      = "Trigger",
    UserPin         = true,
    PinStyle        = "Both",
    IconType        = "Icon",
    Icon            = "Minus",
  })
  ------------------------------- mute toggle
  table.insert(ctrls, {
    Name            = "Gain "..i.." Mute Toggle",
    ControlType     = "Button",
    ButtonType      = "Toggle",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- mute state trigger
  table.insert(ctrls, {
    Name            = "Gain "..i.." Mute State Trigger",
    ControlType     = "Button",
    ButtonType      = "StateTrigger",
    Min             = 1,
    Max             = 4,
    UserPin         = true,
    PinStyle        = "Both",
  })


end

