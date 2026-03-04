
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


local ShowPreamp = false
for i = 1, iMaxGains do 
  if props["Preamp Controls "..i].Value == true then
    ShowPreamp = true
  end
end


if CurrentPage == "Control" then
  --------------------------- background groupbox
  table.insert(graphics,{
    Type            = "GroupBox",
    Text            = "",
    Fill            = GroupBoxFillColor,
    StrokeColor     = GroupBoxStrokeColor,
    StrokeWidth     = 1,
    Position        = {0,0},
    Size            = {PositionStartX + StandardWidth + (iMaxGains*StandardWidth) + 60, ShowPreamp and 484 or 411},
    ZOrder          = -1000,
  })  
  PositionStartY    = PositionStartY + StandardHeight
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
    ZOrder          = -900,
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
    ZOrder          = -901,
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
    ZOrder          = -902,
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
    ZOrder          = -903,
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
    ZOrder          = -904,
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
    ZOrder          = -905,
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
    ZOrder          = -906,
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
    ZOrder          = -907,
  })
  PositionStartY    = PositionStartY + StandardHeight
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
      ZOrder          = -908,
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
      ZOrder          = -909,
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
    ZOrder          = -910,
  }
  
  for i = 1, iMaxGains do
    -- iterate some variables
    PositionStartX = PositionStartX + StandardWidth
    PositionStartY = 8
    local DiscreetHasPreamp = props["Preamp Controls "..i].Value == true
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
      ZOrder        = -800,
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
      ZOrder        = -801,
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
      ZOrder        = -802,
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
      ZOrder        = -700 + i,
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
      ZOrder        = -750 + i,
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
      ZOrder        = -650 + i,
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
      ZOrder        = -600 + i,
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
      ZOrder        = -550 + i,
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
      ZOrder        = -500 + i,
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
      ZOrder        = -450 + i,
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
        ZOrder        = -400 + i + k,
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
        ZOrder        = -350 + i + k,
      }
    end
    PositionStartY = PositionStartY + StandardHeight
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
        ZOrder        = -250 + i,
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
        ZOrder        = -200 + i,
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
          ZOrder        = -300 + i + k,
        }

      end

    end

    

  end


elseif CurrentPage == "Setup" then
  -- initiate some variables
  PositionStartY    = 25
  PositionStartX    = 44
  --------------------------- background groupbox
  table.insert(graphics,{
    Type            = "GroupBox",
    Text            = "",
    Fill            = GroupBoxFillColor,
    StrokeColor     = GroupBoxStrokeColor,
    StrokeWidth     = 1,
    Position        = {0,0},
    Size            = {ShowPreamp and 965 or 568 , PositionStartY + (iMaxGains*StandardHeight) + 60},
    ZOrder          = -2000,
  })
  --------------------------- Text - Component
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Component",
    Position        = {PositionStartX , PositionStartY},
    Size            = {120 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Center",
    VTextAlign      = "Center",
    ZOrder          = -1900,
  })
  PositionStartX = PositionStartX + 123
  --------------------------- Text - Gain Control
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Gain Control",
    Position        = {PositionStartX , PositionStartY},
    Size            = {120 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Center",
    VTextAlign      = "Center",
    ZOrder          = -1901,
  })
  PositionStartX = PositionStartX + 123
  --------------------------- Text - Mute Control
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Mute Control",
    Position        = {PositionStartX , PositionStartY},
    Size            = {120 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Center",
    VTextAlign      = "Center",
    ZOrder          = -1902,
  })
  if ShowPreamp then
    PositionStartX = PositionStartX + 123
    --------------------------- Text - Phantom Control
    table.insert(graphics,{
      Type          = "Label",
      Text          = "Phantom Control",
      Position      = {PositionStartX , PositionStartY},
      Size          = {120 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1903,
    })
    PositionStartX = PositionStartX + 123
    --------------------------- Header - Preamp Presets
    table.insert(graphics,{
      Type          = "Header",
      Text          = "Preamp Presets",
      Position      = {PositionStartX , PositionStartY - StandardHeight},
      Size          = {300 , StandardHeight},
      FontSize      = 11,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
    ZOrder          = -1904,
    })
    --------------------------- Text - Preset 1 Name
    table.insert(graphics,{
      Type          = "Label",
      Text          = "1 : Name",
      Position      = {PositionStartX , PositionStartY},
      Size          = {64 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1905,
    })
    --------------------------- Text - Preset 1 dB
    table.insert(graphics,{
      Type          = "Label",
      Text          = "dB",
      Position      = {PositionStartX + 64 , PositionStartY},
      Size          = {36 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1906,
    })
    --------------------------- Text - Preset 2 Name
    table.insert(graphics,{
      Type          = "Label",
      Text          = "2 : Name",
      Position      = {PositionStartX + 100 , PositionStartY},
      Size          = {64 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1907,
    })
    --------------------------- Text - Preset 2 dB
    table.insert(graphics,{
      Type          = "Label",
      Text          = "dB",
      Position      = {PositionStartX + 164 , PositionStartY},
      Size          = {36 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1908,
    })
    --------------------------- Text - Preset 3 Name
    table.insert(graphics,{
      Type          = "Label",
      Text          = "3 : Name",
      Position      = {PositionStartX + 200 , PositionStartY},
      Size          = {64 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1909,
    })
    --------------------------- Text - Preset 3 dB
    table.insert(graphics,{
      Type          = "Label",
      Text          = "dB",
      Position      = {PositionStartX + 264 , PositionStartY},
      Size          = {36 , StandardHeight},
      FontSize      = 11,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = "Light",
      Color         = ColorSilver,
      HTextAlign    = "Center",
      VTextAlign    = "Center",
    ZOrder          = -1910,
    })
    PositionStartX = PositionStartX + 300
  else
    PositionStartX = PositionStartX + 150
  end
  --------------------------- Text - Text Timeout
  table.insert(graphics,{
    Type            = "Label",
    Text            = "Text Timeout",
    Position        = {PositionStartX , PositionStartY},
    Size            = {120 , StandardHeight},
    FontSize        = 11,
    Margin          = 0,
    Font            = TextFont,
    FontStyle       = "Light",
    Color           = ColorSilver,
    HTextAlign      = "Center",
    VTextAlign      = "Center",
    ZOrder          = -1911,
  })
  --------------------------- Knob - Text Override Time
  layout["Text Override Time"] = {
    PrettyName      = "Text Override Time",
    Style           = "Knob",
    Position        = {PositionStartX + 42 , PositionStartY + StandardHeight + 8},
    Size            = {36,36},
    Color           = ColorGreen,
    ZOrder          = -1912,
  }
  
  
  for i = 1, iMaxGains do
    -- iterate some variables
    PositionStartY  = PositionStartY + StandardHeight
    PositionStartX  = 25
    local DiscreetHasPreamp = props["Preamp Controls "..i].Value == true
    --------------------------- Label - channel index
    layout["Gain "..i.." Index"] = { 
      PrettyName    = "Gain "..i.." Index",
      Style         = "Text",
      TextBoxStyle  = "NoBackground",
      Position      = {PositionStartX , PositionStartY},
      Size          = {16 , StandardHeight},
      FontSize      = 9,
      Margin        = 0,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorGreen,
      HTextAlign    = "Right",
      IsReadOnly    = true,
      ZOrder        = -1800 + i,
    }
    PositionStartX = PositionStartX + 19
    --------------------------- component name
    layout["Component "..i.." Component Name"] = { 
      PrettyName    = string.format("Gain %i~Component~Code Name",i),
      Style         = "Text",
      Position      = {PositionStartX, PositionStartY},
      Size          = {120 , StandardHeight},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -1750 + i,
    }
    PositionStartX = PositionStartX + 123
    --------------------------- gain control name
    layout["Component "..i.." Gain Control Name"] = { 
      PrettyName    = string.format("Gain %i~Component~Gain Control Name",i),
      Style         = "ComboBox",
      Position      = {PositionStartX, PositionStartY},
      Size          = {120 , StandardHeight},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -1700 + i,
    }
    PositionStartX = PositionStartX + 123
    --------------------------- mute control name
    layout["Component "..i.." Mute Control Name"] = { 
      PrettyName    = string.format("Gain %i~Component~Mute Control Name",i),
      Style         = "ComboBox",
      Position      = {PositionStartX, PositionStartY},
      Size          = {120 , StandardHeight},
      Color         = {255,255,255},
      FontSize      = 9,
      Font          = TextFont,
      FontStyle     = TextFontStyle,
      TextColor     = ColorBlack,
      Margin        = 0,
      HTextAlign    = "Center",
      IsReadOnly    = false,
      ZOrder        = -1600 + i,
    }
    if DiscreetHasPreamp then
      PositionStartX = PositionStartX + 123
      --------------------------- preamp control name
      layout["Component "..i.." Phantom Control Name"] = { 
        PrettyName    = string.format("Gain %i~Component~Phantom Control Name",i),
        Style         = "ComboBox",
        Position      = {PositionStartX, PositionStartY},
        Size          = {120 , StandardHeight},
        Color         = {255,255,255},
        FontSize      = 9,
        Font          = TextFont,
        FontStyle     = TextFontStyle,
        TextColor     = ColorBlack,
        Margin        = 0,
        HTextAlign    = "Center",
        IsReadOnly    = false,
        ZOrder        = -1550+ i,
      }
      PositionStartX = PositionStartX + 123
      for k = 1, 3 do
        --------------------------- Preamp Preset Name
        layout["Gain "..i.." Preamp Preset Name "..k] = { 
          PrettyName    = string.format("Gain %i~Preamp~Preset %i Name",i,k),
          Style         = "Text",
          Position      = {PositionStartX , PositionStartY},
          Size          = {64 , StandardHeight},
          Color         = {255,255,255},
          FontSize      = 9,
          Font          = TextFont,
          FontStyle     = TextFontStyle,
          TextColor     = ColorBlack,
          Margin        = 0,
          HTextAlign    = "Center",
          IsReadOnly    = false,
          ZOrder        = -1450 + i + k,
        }
        PositionStartX = PositionStartX + 64
        --------------------------- Preamp Preset Value
        layout["Gain "..i.." Preamp Preset Value "..k] = {
          PrettyName   = string.format("Gain %i~Preamp~Preset %i Value",i,k),
          Style        = "Text",
          TextBoxStyle = "Meter",
          Position     = {PositionStartX , PositionStartY},
          Size         = {36,StandardHeight},
          Color        = ColorGreen,
          ZOrder        = -1400 + i + k,
        }
        PositionStartX = PositionStartX + 36

      end

    end

  end

end
