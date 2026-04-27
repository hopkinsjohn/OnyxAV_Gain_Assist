


-- RUNTIME CODE input pin (comment this out when runtime has been added to this plugin)
--table.insert(ctrls,{Name = "code",ControlType = "Text",UserPin = false,PinStyle = "Input",Count = 1})

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

------------------------------- logo trigger
table.insert(ctrls, {
  Name              = "Logo",
  ControlType       = "Button",
  ButtonType        = "Trigger",
  UserPin           = true,
  PinStyle          = "Output",
  IconType          = "Image",
  Icon              = "--[[ #encode "logo.png" ]]"
})
------------------------------- Text Timeout
table.insert(ctrls, {
  Name              = "Text Override Time",
  ControlType       = "Knob", 
  ControlUnit       = "Integer",
  Min               = 2,
  Max               = 10,
  Count             = 1,
  DefaultValue      = 3,
  UserPin           = true,
  PinStyle          = "Both",
})

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
    Max             = props["Mute State Trigger Max Val"].Value,
    UserPin         = true,
    PinStyle        = "Input",
  })
  ------------------------------- mute state trigger value
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Mute State Trigger Value",
    ControlType     = "Indicator",
    IndicatorType   = "Text",
    UserPin         = false,
  }) 
  ------------------------------- meter
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Meter",
    ControlType     = "Indicator",
    IndicatorType   = "Meter",
    UserPin         = false,
    PinStyle        = "Input"
  }) 
  ------------------------------- automix toggle
  table.insert(ctrls, {
    Name            = "Gain "..i.." Automix Toggle",
    ControlType     = "Button",
    ButtonType      = "Toggle",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- automix on led
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Automix Active",
    ControlType     = "Indicator",
    IndicatorType   = "Led",
    UserPin         = false,
  }) 
  ------------------------------- phantom power toggle
  table.insert(ctrls, {
    Name            = "Gain "..i.." Preamp Phantom Power Toggle",
    ControlType     = "Button",
    ButtonType      = "Toggle",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- phantom power on led
  table.insert(ctrls, {             
    Name            = "Gain "..i.." Preamp Phantom Active",
    ControlType     = "Indicator",
    IndicatorType   = "Led",
    UserPin         = false,
  }) 
  for k = 1,3 do
    ------------------------------- feedback display
    table.insert(ctrls, {             
      Name          = "Gain "..i.." Display "..k,
      ControlType   = "Indicator",
      IndicatorType = "Text",
      UserPin       = true,
      PinStyle      = "Output",
    }) 
    ------------------------------- feedback display override
    table.insert(ctrls, {
      Name          = "Gain "..i.." Display Override "..k,
      ControlType   = "Button",
      ButtonType    = "Toggle",
      UserPin       = true,
      PinStyle      = "Both",
      IconType      = "Icon",
      Icon          = "Quote",
    })
  end
  ------------------------------- Invisible toggle
  table.insert(ctrls, {
    Name            = "Gain "..i.." Invisible",
    ControlType     = "Button",
    ButtonType      = "Toggle",
    UserPin         = true,
    PinStyle        = "Both",
    IconType        = "Icon",
    Icon            = "Eye",
  })
  ------------------------------- disable toggle
  table.insert(ctrls, {
    Name            = "Gain "..i.." Disable",
    ControlType     = "Button",
    ButtonType      = "Toggle",
    UserPin         = true,
    PinStyle        = "Both",
    IconType        = "Icon",
    Icon            = "Minus Circle",
  })





  -------------------------------------------------------------------------- setup page
  ------------------------------- Gain Code name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Gain Code Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- Mute Code name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Mute Code Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- Automix Code name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Automix Code Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- Preamp Code name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Preamp Code Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- gain control name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Gain Control Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- mute control name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Mute Control Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- Automix control name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Automix Control Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- preamp control name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Preamp Control Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  ------------------------------- phantom control name
  table.insert(ctrls, {             
    Name            = "Component "..i.." Phantom Control Name",
    ControlType     = "Text",
    UserPin         = true,
    PinStyle        = "Both",
  })
  local DefaultPreampText = {"Mic High","Mic Low","Line"}
  local DefaultPreampValues = {46,26,0}
  for k = 1,3 do
    ------------------------------- preamp presets
    table.insert(ctrls, {
      Name          = "Gain "..i.." Preamp Preset "..k,
      ControlType   = "Button",
      ButtonType    = "Toggle",
      UserPin       = true,
      PinStyle      = "Both",
    })
    ------------------------------- preamp preset names
    table.insert(ctrls, {             
      Name          = "Gain "..i.." Preamp Preset Name "..k,
      ControlType   = "Text",
      UserPin       = true,
      PinStyle      = "Both",
      DefaultValue = DefaultPreampText[k],
    })
    ------------------------------- Preamp Preset Value
    table.insert(ctrls, {             
      Name          = "Gain "..i.." Preamp Preset Value "..k,
      ControlType   = "Knob",
      ControlUnit   = "dB",
      Min           = 0,
      Max           = 100,
      UserPin       = true,
      PinStyle      = "Both",
      DefaultValue = DefaultPreampValues[k],
    })
  end



end

