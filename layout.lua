
-- RUNTIME CODE input pin (comment this out when runtime has been added to this plugin)
--layout["code"]={PrettyName="code",Style="None"}

-----------------------------------------------------
-------------------- Variables ----------------------
-----------------------------------------------------

local GroupBoxFillColor = {51,51,51}
local GroupBoxStrokeColor = {125,198,35}
local StandardWidth = 60
local StandardHeight = 20
local FaderHeight = 200
local PositionStartX = 123 - StandardWidth
local PositionStartY = 8
local TextFont    = "Montserrat"
local TextFontStyle = "Regular"
local ColorBlack = {0,0,0}
local ColorGreen = {125,198,35}
local ColorSilver = {204,204,204} 
local ColorButtonOff = {102,102,102} 
local ColorRed = {255,0,0}

local iMaxGains = math.floor(props["Number Of Gains"].Value)
local CurrentPage = PageNames[props["page_index"].Value] -- gathers the name of the current page





if CurrentPage == "Control" then
  local ShowAutomix = false
  local ShowPreamp = false
  local GroupboxHeight = 428
  for i = 1, iMaxGains do 
    if props["Automix Controls "..i].Value == true then
      ShowAutomix = true
    end
    if props["Preamp Controls "..i].Value == true then
      ShowPreamp = true
    end
  end
  if ShowAutomix then GroupboxHeight = GroupboxHeight + StandardHeight end
  if ShowPreamp then GroupboxHeight = GroupboxHeight + StandardHeight*4 end
  --------------------------- background groupbox
  table.insert(graphics,{
    Type            = "GroupBox",
    Text            = "",
    Fill            = GroupBoxFillColor,
    StrokeColor     = GroupBoxStrokeColor,
    StrokeWidth     = 1,
    Position        = {0,0},
    Size            = {PositionStartX + StandardWidth + (iMaxGains*StandardWidth) + 60, GroupboxHeight},
    ZOrder          = -100000,
  })  
  PositionStartY    = PositionStartY + StandardHeight*2
  --------------------------- Text - Friendly Name
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Name ( // = \\r )",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , 40},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99999,
  })
  PositionStartY    = PositionStartY + 40
  --------------------------- Text - Fader
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Fader",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , FaderHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99998,
  })
  PositionStartY    = PositionStartY + FaderHeight
  --------------------------- Text - Gain Bump
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Gain Bump",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99997,
  })
  PositionStartY    = PositionStartY + StandardHeight
  --------------------------- Text - Mute Toggle
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Mute Toggle",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99996,
  })
  PositionStartY    = PositionStartY + StandardHeight
  --------------------------- Text - Mute State Trigger
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Mute State Trigger",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99995,
  })
  PositionStartY    = PositionStartY + StandardHeight
  --------------------------- Text - dB Display
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Display - dB",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99994,
  })
  PositionStartY    = PositionStartY + StandardHeight
  --------------------------- Text - % Display
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Display - %",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99993,
  })
  PositionStartY    = PositionStartY + StandardHeight
  --------------------------- Text - 0-100 Display
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Display - 0-100",
    Position        = {PositionStartX - 53 , PositionStartY},
    Size            = {110 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Right",
    VTextAlign      = "Center",
    ZOrder          = -99992,
  })
  PositionStartY    = PositionStartY + StandardHeight
  if ShowAutomix then
    --------------------------- Text - Automix
    table.insert(graphics,{
      Type            = "Label",
      Text            = "Automix",
      Position        = {PositionStartX - 53 , PositionStartY},
      Size            = {110 , StandardHeight},
      FontSize        = 11,
      Margin          = 0,
      Font            = TextFont,
      FontStyle       = "Light",
      Color           = ColorSilver,
      HTextAlign      = "Right",
      VTextAlign      = "Center",
      ZOrder          = -26854,
    })
    PositionStartY    = PositionStartY + StandardHeight
  end
  if ShowPreamp then
    --------------------------- Text - Phantom Power
    table.insert(graphics,{
      Type            = "Label",
      Text            = "Phantom Power",
      Position        = {PositionStartX - 53 , PositionStartY},
      Size            = {110 , StandardHeight},
      FontSize        = 11,
      Margin          = 0,
      Font            = TextFont,
      FontStyle       = "Light",
      Color           = ColorSilver,
      HTextAlign      = "Right",
      VTextAlign      = "Center",
      ZOrder          = -99991,
    })
    PositionStartY    = PositionStartY + StandardHeight
    --------------------------- Text - Preamp Presets
    table.insert(graphics,{
      Type            = "Label",
      Text            = "Preamp Presets",
      Position        = {PositionStartX - 53 , PositionStartY},
      Size            = {110 , StandardHeight * 3},
      FontSize        = 11,
      Margin          = 0,
      Font            = TextFont,
      FontStyle       = "Light",
      Color           = ColorSilver,
      HTextAlign      = "Right",
      VTextAlign      = "Center",
      ZOrder          = -99990,
    })

  end

  --------------------------- Logo
  layout["Logo"] = {
    PrettyName      = "Logo",
    Style           = "Button",
    Position        = {PositionStartX + StandardWidth + (iMaxGains*StandardWidth) + 20 , 28},
    Size            = {30,29},
    Margin          = 0,
    CornerRadius    = 0,
    StrokeWidth     = 0,
    Color           = ColorGreen,
    OffColor        = {255, 255, 255, 0},
    ButtonVisualStyle = "Flat",
    UnlinkOffColor  = true,
    Padding         = 2,
    ZOrder          = -99989,
  }
  
  
  for i = 1, iMaxGains do
    -- iterate some variables
    PositionStartX = PositionStartX + StandardWidth
    PositionStartY = 8
    local DiscreetHasPreamp = props["Preamp Controls "..i].Value == true
    local DiscreetHasAutomix = props["Automix Controls "..i].Value == true
    local DiscreetHasMeter = props["Show Meter "..i].Value == true
    --------------------------- Label - channel index
    layout["Gain "..i.." Index"] = { 
      PrettyName    = "Gain "..i.." Index",
      Style         = "Text",
      TextBoxStyle  = "NoBackground",
      Position      = {PositionStartX , PositionStartY},
      Size          = {StandardWidth , StandardHeight},
      FontSize      = 9,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorGreen,
      HTextAlign    = "Center",
      IsReadOnly    = true,
      ZOrder        = -99900 - i,
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- Invisible Toggle
    layout["Gain "..i.." Invisible"] = {
      PrettyName    = string.format("Gain %i~Visible",i),
      Style         = "Button",
      Position      = {PositionStartX , PositionStartY},
      Size          = {StandardWidth/2 , StandardHeight},
      Margin        = 1,
      CornerRadius  = 4,
      StrokeWidth   = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      Color         = ColorRed,
      OffColor      = GroupBoxFillColor,
      ButtonVisualStyle = "Flat",
      UnlinkOffColor = true,
      ZOrder        = -95900 - i,
    }
    --------------------------- Disable Toggle
    layout["Gain "..i.." Disable"] = {
      PrettyName    = string.format("Gain %i~Disable",i),
      Style         = "Button",
      Position      = {PositionStartX + StandardWidth/2 , PositionStartY},
      Size          = {StandardWidth/2 , StandardHeight},
      Margin        = 1,
      CornerRadius  = 4,
      StrokeWidth   = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      Color         = ColorRed,
      OffColor      = GroupBoxFillColor,
      ButtonVisualStyle = "Flat",
      UnlinkOffColor = true,
      Padding       = 2,
      ZOrder        = -95800 - i,
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- gain friendly names
    layout["Gain "..i.." Friendly Name"] = { 
      PrettyName    = string.format("Gain %i~Friendly Name~Edit",i),
      Style         = "Text",
      Position      = {PositionStartX, PositionStartY},
      Size          = {StandardWidth , StandardHeight},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -99800 - i,
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- gain friendly names display
    layout["Gain "..i.." Friendly Name Display"] = { 
      PrettyName    = string.format("Gain %i~Friendly Name~Display",i),
      Style         = "Text",
      TextBoxStyle  = "Normal",
      Position      = {PositionStartX , PositionStartY},
      Size          = {StandardWidth , StandardHeight},
      Color         = {194,194,194},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = true,
      ZOrder        = -99700 - i,
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- gain faders
    layout["Gain "..i.." Fader"] = { 
      PrettyName    = string.format("Gain %i~Gain~Fader",i),
      Style         = "Fader",
      Position      = {PositionStartX + 5 , PositionStartY},
      Size          = {StandardWidth - 10 , FaderHeight},
      Color         = ColorGreen,
      ZOrder        = i,
    }
    --------------------------- meter
    if DiscreetHasMeter then
      layout["Gain "..i.." Meter"] = { 
        PrettyName    = string.format("Gain %i~Meter",i),
        Style         = "Meter",
        MeterStyle    = "Standard",
        Radius        = 3,
        ShowTextbox   = false,
        BackgroundColor  = GroupBoxFillColor,
        StrokeColor   = ColorButtonOff,
        StrokeWidth   = 1,
        Position      = {PositionStartX + 55 , PositionStartY + 20},
        Size          = {StandardWidth - 52 , FaderHeight-40},
        ZOrder        = -99600 - i,
      }
    end
    --------------------------- Label - Max Gain Display
    layout["Gain "..i.." Display Max"] = { 
      PrettyName    = string.format("Gain %i~Gain~Max dB",i),
      Style         = "Text",
      TextBoxStyle  = "NoBackground",
      Position      = {PositionStartX , PositionStartY},
      Size          = {StandardWidth,14},
      FontSize      = 9,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorButtonOff,
      HTextAlign    = "Center",
      IsReadOnly    = true,
      ZOrder        = -99500 - i,
    }
    PositionStartY = PositionStartY + FaderHeight
    --------------------------- Label - Min Gain Display
    layout["Gain "..i.." Display Min"] = { 
      PrettyName    = string.format("Gain %i~Gain~Min dB",i),
      Style         = "Text",
      TextBoxStyle  = "NoBackground",
      Position      = {PositionStartX , PositionStartY - 14},
      Size          = {StandardWidth,14},
      FontSize      = 9,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorButtonOff,
      HTextAlign    = "Center",
      IsReadOnly    = true,
      ZOrder        = -99400 - i,
    }
    --------------------------- Gain Bump Up
    layout["Gain "..i.." Bump Up"] = {
      PrettyName    = string.format("Gain %i~Gain~Bump Up",i),
      Style         = "Button",
      Position      = {PositionStartX , PositionStartY},
      Size          = {30,StandardHeight},
      Margin        = 1,
      CornerRadius  = 0,
      StrokeWidth   = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      Color         = ColorGreen,
      OffColor      = GroupBoxFillColor,
      ButtonVisualStyle = "Flat",
      UnlinkOffColor = true,
      Padding       = 2,
      IconColor     = ColorGreen,
      ZOrder        = -99300 - i,
    }
    --------------------------- Gain Bump Down
    layout["Gain "..i.." Bump Down"] = {
      PrettyName    = string.format("Gain %i~Gain~Bump Down",i),
      Style         = "Button",
      Position      = {PositionStartX + 30 , PositionStartY},
      Size          = {30,StandardHeight},
      Margin        = 1,
      CornerRadius  = 0,
      StrokeWidth   = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      Color         = ColorGreen,
      OffColor      = GroupBoxFillColor,
      ButtonVisualStyle = "Flat",
      UnlinkOffColor = true,
      Padding       = 2,
      IconColor     = ColorGreen,
      ZOrder        = -99200 - i,
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- Mute Toggle
    layout["Gain "..i.." Mute Toggle"] = {
      PrettyName    = string.format("Gain %i~Gain~Mute Toggle",i),
      Style         = "Button",
      Position      = {PositionStartX , PositionStartY},
      Size          = {StandardWidth , StandardHeight},
      Margin        = 1,
      CornerRadius  = 0,
      StrokeWidth   = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      Color         = ColorRed,
      OffColor      = ColorButtonOff,
      ButtonVisualStyle = "Flat",
      UnlinkOffColor = true,
      ZOrder        = -99100 - i,
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- Mute State Trigger
    layout["Gain "..i.." Mute State Trigger"] = {
      PrettyName    = string.format("Gain %i~Gain~Mute State Trigger",i),
      Style         = "Button",
      Position      = {PositionStartX , PositionStartY},
      Size          = {StandardWidth - 16 , StandardHeight},
      Margin        = 1,
      CornerRadius  = 0,
      StrokeWidth   = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      Color         = ColorButtonOff,
      OffColor      = ColorButtonOff,
      ButtonVisualStyle = "Flat",
      UnlinkOffColor = true,
      ZOrder        = -98900 - i,
    }
    --------------------------- Mute State Trigger Value
    layout["Gain "..i.." Mute State Trigger Value"] = {
      PrettyName    = string.format("Gain %i~Gain~Mute State Trigger Value",i),
      Style         = "Text",
      TextBoxStyle  = "NoBackground",
      Position      = {PositionStartX + 44 , PositionStartY},
      Size          = {16 , StandardHeight},
      FontSize      = 9,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorGreen,
      HTextAlign    = "Center",
      IsReadOnly    = true,
      ZOrder        = -98800 - i,
    }
    local displayName = {"dB","%","0-100"}
    for k = 1, 3 do
      PositionStartY = PositionStartY + StandardHeight
      --------------------------- feedback display
      layout["Gain "..i.." Display "..k] = { 
        PrettyName    = string.format("Gain %i~Display~%s",i,displayName[k]),
        Style         = "Text",
        Position      = {PositionStartX, PositionStartY},
        Size          = {StandardWidth - 16 , StandardHeight},
        Color         = {194,194,194},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 1,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -98700 - i - k,
      }
      --------------------------- feedback display override
      layout["Gain "..i.." Display Override "..k] = {
        PrettyName    = string.format("Gain %i~Display~Override %s",i,displayName[k]),
        Style         = "Button",
        Position      = {PositionStartX + 44 , PositionStartY},
        Size          = {16 , StandardHeight},
        Margin        = 1,
        CornerRadius  = 0,
        StrokeWidth   = 0,
        FontSize      = 7,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        Color         = ColorGreen,
        OffColor      = ColorButtonOff,
        ButtonVisualStyle = "Flat",
        UnlinkOffColor = true,
        IconColor     = {255,255,255},
        ZOrder        = -98600 - i - k,
      }
    end
    PositionStartY = PositionStartY + StandardHeight
    if DiscreetHasAutomix then
      --------------------------- Automix Toggle
      layout["Gain "..i.." Automix Toggle"] = {
        PrettyName    = string.format("Gain %i~Automix~Toggle",i),
        Style         = "Button",
        Position      = {PositionStartX , PositionStartY },
        Size          = {StandardWidth - 16 , StandardHeight},
        Margin        = 1,
        CornerRadius  = 0,
        StrokeWidth   = 0,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        Color         = {0,156,218},
        ButtonVisualStyle = "Flat",
        UnlinkOffColor = false,
        ZOrder        = -96500 - i,
      }
      --------------------------- Automix Active led
      layout["Gain "..i.." Automix Active"] = {
        PrettyName    = string.format("Gain %i~Automix~Active",i),
        Style         = "Led",
        Position      = {PositionStartX + 44 , PositionStartY + 2},
        Size          = {16 , 16},
        Margin        = 3,
        IsReadOnly    = true,
        Color         = {0,156,218},
        OffColor      = {0,156,218},
        UnlinkOffColor = true,
        ZOrder        = -96400 - i,
      }
    end
    if ShowAutomix then
      PositionStartY = PositionStartY + StandardHeight
    end
    if DiscreetHasPreamp then
      --------------------------- Phantom Power Toggle
      layout["Gain "..i.." Preamp Phantom Power Toggle"] = {
        PrettyName    = string.format("Gain %i~Preamp~Phantom Power",i),
        Style         = "Button",
        Position      = {PositionStartX , PositionStartY },
        Size          = {StandardWidth - 16 , StandardHeight},
        Margin        = 1,
        CornerRadius  = 0,
        StrokeWidth   = 0,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        Color         = {242,137,174},
        ButtonVisualStyle = "Flat",
        UnlinkOffColor = false,
        ZOrder        = -98500 - i,
      }
      --------------------------- Phantom Power active led
      layout["Gain "..i.." Preamp Phantom Active"] = {
        PrettyName    = string.format("Gain %i~Preamp~Phantom Power Active",i),
        Style         = "Led",
        Position      = {PositionStartX + 44 , PositionStartY + 2},
        Size          = {16 , 16},
        Margin        = 3,
        IsReadOnly    = true,
        Color         = {242,137,174},
        OffColor      = {242,137,174},
        UnlinkOffColor = true,
        ZOrder        = -98400 - i,
      }
      PositionStartY = PositionStartY + StandardHeight
      for k = 1, 3 do
        --------------------------- Preamp Preset
        layout["Gain "..i.." Preamp Preset "..k] = {
          PrettyName    = string.format("Gain %i~Preamp~Preset %i",i,k),
          Style         = "Button",
          Position      = {PositionStartX , PositionStartY + (k - 1)*StandardHeight},
          Size          = {StandardWidth , StandardHeight},
          Margin        = 1,
          CornerRadius  = 0,
          StrokeWidth   = 0,
          Font          = TextFont,
          FontStyle     = TextFontStyle,
          Color         = ColorGreen,
          OffColor      = ColorButtonOff,
          ButtonVisualStyle = "Flat",
          UnlinkOffColor = true,
          ZOrder        = -98300 - i - k,
        }

      end
    end
  end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
-------------------------------------- SETUP PAGE  -----------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

elseif CurrentPage == "Setup" then
  -- PositionStartX and PositionStartX mapping
  local catchAuomixStack = {false,false,false,false}
  local catchPreampStack = {false,false,false,false}
  local posXMap = {86, 214, 342, 470, 598, 726}
  local posYMap = {13, 0, 0, 0} -- 2,3,4 are determined below based on [1]
  for i = 1, iMaxGains do 
    if i <= 6 then
      if props["Automix Controls "..i].Value == true then
        catchAuomixStack[1] = true
      end
      if props["Preamp Controls "..i].Value == true then
        catchPreampStack[1] = true
      end
    elseif i <= 12 then 
      if props["Automix Controls "..i].Value == true then
        catchAuomixStack[2] = true
      end
      if props["Preamp Controls "..i].Value == true then
        catchPreampStack[2] = true
      end
    elseif i <= 18 then
      if props["Automix Controls "..i].Value == true then
        catchAuomixStack[3] = true
      end
      if props["Preamp Controls "..i].Value == true then
        catchPreampStack[3] = true
      end
    elseif i <= iMaxGains then
      if props["Automix Controls "..i].Value == true then
        catchAuomixStack[4] = true
      end
      if props["Preamp Controls "..i].Value == true then
        catchPreampStack[4] = true
      end
    end
  end
  -- determine the posYMap based on which rows are using preamp controls
  -------------------------------- row 2
  posYMap[2] = posYMap[1] + StandardHeight*3
  if catchAuomixStack[1] then
    posYMap[2] = posYMap[2] + StandardHeight 
  end
  if catchPreampStack[1] then
    posYMap[2] = posYMap[2] + StandardHeight*5 
  end
  -------------------------------- row 3
  posYMap[3] = posYMap[2] + StandardHeight*3
  if catchAuomixStack[2] then
    posYMap[3] = posYMap[3] + StandardHeight 
  end
  if catchPreampStack[2] then
    posYMap[3] = posYMap[3] + StandardHeight*5 
  end
  -------------------------------- row 4
  posYMap[4] = posYMap[3] + StandardHeight*3
  if catchAuomixStack[3] then
    posYMap[4] = posYMap[4] + StandardHeight 
  end
  if catchPreampStack[3] then
    posYMap[4] = posYMap[4] + StandardHeight*5 
  end
  -- determine groupbox background size

  local GroupboxWidth = 958
  if iMaxGains < 2 then 
    GroupboxWidth = 318
  elseif iMaxGains < 3 then 
    GroupboxWidth = 446
  elseif iMaxGains < 4 then 
    GroupboxWidth = 574
  elseif iMaxGains < 5 then 
    GroupboxWidth = 702
  elseif iMaxGains < 6 then 
    GroupboxWidth = 830
  end

  local adder = 0
  local GroupboxHeight = 1000
  if iMaxGains < 7 then 
    if catchAuomixStack[1] then adder = adder + StandardHeight end
    if catchPreampStack[1] then adder = adder + StandardHeight*5 end
    GroupboxHeight = posYMap[1] + StandardHeight*4 + adder
  elseif iMaxGains < 13 then 
    if catchAuomixStack[2] then adder = adder + StandardHeight end
    if catchPreampStack[2] then adder = adder + StandardHeight*5 end
    GroupboxHeight = posYMap[2] + StandardHeight*4 + adder
  elseif iMaxGains < 19 then 
    if catchAuomixStack[3] then adder = adder + StandardHeight end
    if catchPreampStack[3] then adder = adder + StandardHeight*5 end
    GroupboxHeight = posYMap[3] + StandardHeight*4 + adder
  else
    if catchAuomixStack[4] then adder = adder + StandardHeight end
    if catchPreampStack[4] then adder = adder + StandardHeight*5 end
    GroupboxHeight = posYMap[4] + StandardHeight*4 + adder
  end
  --------------------------- background groupbox
  table.insert(graphics,{
    Type            = "GroupBox",
    Text            = "",
    Fill            = GroupBoxFillColor,
    StrokeColor     = GroupBoxStrokeColor,
    StrokeWidth     = 1,
    Position        = {0,0},
    Size            = {GroupboxWidth,GroupboxHeight},
    ZOrder          = -80000,
  })
  --------------------------- Text - Text Timeout
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Text Timeout",
    Position        = {GroupboxWidth - 94,posYMap[1]},
    Size            = {94 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Center",
    VTextAlign      = "Center",
    ZOrder          = -79999,
  })
  --------------------------- Knob - Text Override Time
  layout["Text Override Time"] = {
    PrettyName      = "Text Override Time",
    Style           = "Knob",
    Position        = {GroupboxWidth - 65,posYMap[1] + StandardHeight},
    Size            = {36,36},
    Color           = ColorGreen,
    ZOrder          = -79998,
  }
  
  
  for i = 1, iMaxGains do
    local RowIncludesAutomix = false
    if i < 7 then
      PositionStartY = posYMap[1]
      PositionStartX = posXMap[i]
      RowIncludesAutomix = catchAuomixStack[1]
    elseif i < 13 then
      PositionStartY = posYMap[2]
      PositionStartX = posXMap[i - 6]
      RowIncludesAutomix = catchAuomixStack[2]
    elseif i < 19 then
      PositionStartY = posYMap[3]
      PositionStartX = posXMap[i - 12]
      RowIncludesAutomix = catchAuomixStack[3]
    else
      PositionStartY = posYMap[4]
      PositionStartX = posXMap[i - 18]
      RowIncludesAutomix = catchAuomixStack[4]
    end
    local DiscreetHasPreamp = props["Preamp Controls "..i].Value == true
    local DiscreetHasAutomix = props["Automix Controls "..i].Value == true
    local DiscreetMuteComponent = props["Link Mute "..i].Value == false

    -- left hand text
    if i == 1 or i == 7 or i == 13 or i == 19 then
      local Ycoord = {
        [1] = 33,
        [7] = posYMap[2] + StandardHeight,
        [13] = posYMap[3] + StandardHeight,
        [19] = posYMap[4] + StandardHeight,
      }
      local AutomixGroup = {
        [1] = catchAuomixStack[1],
        [7] = catchAuomixStack[2],
        [13] = catchAuomixStack[3],
        [19] = catchAuomixStack[4],
      }
      local PreampGroup = {
        [1] = catchPreampStack[1],
        [7] = catchPreampStack[2],
        [13] = catchPreampStack[3],
        [19] = catchPreampStack[4],
      }
      --------------------------- Text - Gain
      table.insert(graphics,{Type="Label",Text="Gain",Position={posXMap[1]-80,Ycoord[i]},Size={76,StandardHeight},FontSize=8,Margin=0,Font=TextFont,FontStyle="Light",Color=ColorSilver,HTextAlign="Right",VTextAlign="Center",ZOrder=-46900-i})
      --------------------------- Text - Mute
      table.insert(graphics,{Type="Label",Text="Mute",Position={posXMap[1]-80,Ycoord[i]+StandardHeight},Size={76,StandardHeight},FontSize=8,Margin=0,Font=TextFont,FontStyle="Light",Color=ColorSilver,HTextAlign="Right",VTextAlign="Center",ZOrder=-46800-i})
      if AutomixGroup[i] then
        --------------------------- Text - Preamp Gain
        table.insert(graphics,{Type="Label",Text="Automix Manual",Position={posXMap[1]-80,Ycoord[i]+StandardHeight*2},Size={76,StandardHeight},FontSize=8,Margin=0,Font=TextFont,FontStyle="Light",Color=ColorSilver,HTextAlign="Right",VTextAlign="Center",ZOrder=-46700-i})
      end
      if PreampGroup[i] then
        --------------------------- Text - Preamp Gain
        table.insert(graphics,{Type="Label",Text="Preamp Gain",Position={posXMap[1]-80,AutomixGroup[i] and (Ycoord[i]+StandardHeight*3) or (Ycoord[i]+StandardHeight*2)},Size={76,StandardHeight},FontSize=8,Margin=0,Font=TextFont,FontStyle="Light",Color=ColorSilver,HTextAlign="Right",VTextAlign="Center",ZOrder=-46600-i})
        --------------------------- Text - Preamp Phantom
        table.insert(graphics,{Type="Label",Text="Preamp Phantom",Position={posXMap[1]-80,AutomixGroup[i] and (Ycoord[i]+StandardHeight*4) or (Ycoord[i]+StandardHeight*3)},Size={76,StandardHeight},FontSize=8,Margin=0,Font=TextFont,FontStyle="Light",Color=ColorSilver,HTextAlign="Right",VTextAlign="Center",ZOrder=-46500-i})
        --------------------------- Text - Preamp Presets
        table.insert(graphics,{Type="Label",Text="Preamp Presets",Position={posXMap[1]-80,AutomixGroup[i] and (Ycoord[i]+StandardHeight*5) or (Ycoord[i]+StandardHeight*4)},Size={76,StandardHeight*3},FontSize=8,Margin=0,Font=TextFont,FontStyle="Light",Color=ColorSilver,HTextAlign="Right",VTextAlign="Center",ZOrder=-46400-i})
      end
    end


    --------------------------- Header - Gain Index
    table.insert(graphics,{
      Type          = "Header",
      Text          = "Gain "..i,
      Position      = {PositionStartX , PositionStartY},
      Size          = {120 , StandardHeight},
      FontSize      = 11,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      ZOrder        = -79900 - i,
    })
    PositionStartY  = PositionStartY + StandardHeight
    --------------------------- Gain Code name
    layout["Component "..i.." Gain Code Name"] = { 
      PrettyName    = string.format("Gain %i~Component~Gain Code Name",i),
      Style         = "ComboBox",
      Position      = {PositionStartX, PositionStartY},
      Size          = {60 , DiscreetMuteComponent and StandardHeight or StandardHeight*2},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -79800 - i,
    }
    PositionStartY  = PositionStartY + StandardHeight
    --------------------------- Mute Code name
    if DiscreetMuteComponent then
      layout["Component "..i.." Mute Code Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Mute Code Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {60 , StandardHeight},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -79700 - i,
      }
    end
    PositionStartY  = PositionStartY + StandardHeight
    if DiscreetHasAutomix then
      --------------------------- Automix Code Name
      layout["Component "..i.." Automix Code Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Automix Code Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {60 , StandardHeight},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -53500 - i,
      }  
      
    end
    if RowIncludesAutomix then
      PositionStartY  = PositionStartY + StandardHeight 
    end
    if DiscreetHasPreamp then
      --------------------------- Preamp Code name
      layout["Component "..i.." Preamp Code Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Preamp Code Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {60 , StandardHeight*2},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -79600 - i,
      }  
      PositionStartY  = PositionStartY + StandardHeight*2    
      for k = 1, 3 do
        --------------------------- Preamp Preset Name
        layout["Gain "..i.." Preamp Preset Name "..k] = { 
          PrettyName    = string.format("Gain %i~Preamp~Preset %i Name",i,k),
          Style         = "Text",
          Position      = {PositionStartX , PositionStartY},
          Size          = {60 , StandardHeight},
          Color         = {255,255,255},
          FontSize      = 9,
          Font          = TextFont,
          FontStyle     = TextFontStyle,
          TextColor     = ColorBlack,
          Margin        = 0,
          HTextAlign    = "Center",
          IsReadOnly    = false,
          ZOrder        = -79500 - i - k,
        }
        PositionStartY  = PositionStartY + StandardHeight
      end
    end

    --------------------------- reset positions
    if i < 7 then
      PositionStartY = posYMap[1] + StandardHeight
      PositionStartX = posXMap[i] + 60
    elseif i < 13 then
      PositionStartY = posYMap[2] + StandardHeight
      PositionStartX = posXMap[i - 6] + 60
    elseif i < 19 then
      PositionStartY = posYMap[3] + StandardHeight
      PositionStartX = posXMap[i - 12] + 60
    else
      PositionStartY = posYMap[4] + StandardHeight
      PositionStartX = posXMap[i - 18] + 60
    end

    --------------------------- gain control name
    layout["Component "..i.." Gain Control Name"] = { 
      PrettyName    = string.format("Gain %i~Component~Gain Control Name",i),
      Style         = "ComboBox",
      Position      = {PositionStartX, PositionStartY},
      Size          = {60 , StandardHeight},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -79400 - i,
    }
    PositionStartY  = PositionStartY + StandardHeight  
    --------------------------- mute control name
    layout["Component "..i.." Mute Control Name"] = { 
      PrettyName    = string.format("Gain %i~Component~Mute Control Name",i),
      Style         = "ComboBox",
      Position      = {PositionStartX, PositionStartY},
      Size          = {60 , StandardHeight},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -79300 - i,
    }
    PositionStartY  = PositionStartY + StandardHeight 

    if DiscreetHasAutomix then  
      --------------------------- Automix Control Name
      layout["Component "..i.." Automix Control Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Automix Control Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {60 , StandardHeight},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -54300 - i,
      } 
    end
    if RowIncludesAutomix then
      PositionStartY  = PositionStartY + StandardHeight 
    end

    if DiscreetHasPreamp then  
      --------------------------- Preamp Control Name
      layout["Component "..i.." Preamp Control Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Preamp Control Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {60 , StandardHeight},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -79200 - i,
      } 
      PositionStartY  = PositionStartY + StandardHeight 
      --------------------------- Phantom Control Name
      layout["Component "..i.." Phantom Control Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Phantom Control Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {60 , StandardHeight},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -79100 - i,
      }
      PositionStartY  = PositionStartY + StandardHeight 
      for k = 1, 3 do
        --------------------------- Preamp Preset Value
        layout["Gain "..i.." Preamp Preset Value "..k] = {
          PrettyName   = string.format("Gain %i~Preamp~Preset %i Value",i,k),
          Style        = "Text",
          TextBoxStyle = "Meter",
          Position     = {PositionStartX , PositionStartY},
          Size         = {60,StandardHeight},
          Color        = ColorGreen,
          ZOrder       = -79000 - i - k,
        }
        PositionStartY  = PositionStartY + StandardHeight 
      end
    end
  end
end
