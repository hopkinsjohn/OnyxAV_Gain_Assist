
-- RUNTIME CODE input pin (comment this out when runtime has been added to this plugin)
layout["code"]={PrettyName="code",Style="None"}

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

local iMaxGains = math.floor(props["Number Of Gains"].Value)
local CurrentPage = PageNames[props["page_index"].Value] -- gathers the name of the current page

if CurrentPage == "Control" then
  --------------------------- background groupbox
  table.insert(graphics,{
    Type          = "GroupBox",
    Text          = "",
    Fill          = GroupBoxFillColor,
    StrokeColor   = GroupBoxStrokeColor,
    StrokeWidth   = 1,
    Position      = {0,0},
    Size          = {PositionStartX + StandardWidth + (iMaxGains*StandardWidth) + 60,391},
    ZOrder        = -40,
  })

  --------------------------- otherstuff
  
  --------------------------- otherstuff
  
  --------------------------- otherstuff
  
  --------------------------- otherstuff
  
  for i = 1, iMaxGains do
    -- iterate some variables
    PositionStartX = PositionStartX + StandardWidth
    PositionStartY = 8
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
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- gain friendly names
    layout["Gain "..i.." Friendly Name"] = { 
      PrettyName    = string.format("Gain %i~Friendly Name",i),
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
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- gain friendly names display
    layout["Gain "..i.." Friendly Name Display"] = { 
      PrettyName    = string.format("Gain %i~Friendly Name Display",i),
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
    }
    PositionStartY = PositionStartY + StandardHeight
    --------------------------- gain faders
    layout["Gain "..i.." Fader"] = { 
      PrettyName    = string.format("Gain %i~Fader",i),
      Style         = "Fader",
      Position      = {PositionStartX + 5 , PositionStartY},
      Size          = {StandardWidth - 10 , FaderHeight},
      Color         = ColorGreen,
    }
    --------------------------- Label - Max Gain Display
    layout["Gain "..i.." Display Max"] = { 
      PrettyName    = string.format("Gain %i~Max dB",i),
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
      ZOrder        = -39,
    }
    PositionStartY = PositionStartY + FaderHeight
    --------------------------- Label - Min Gain Display
    layout["Gain "..i.." Display Min"] = { 
      PrettyName    = string.format("Gain %i~Min dB",i),
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
      ZOrder        = -38,
    }
    --------------------------- Gain Bump Up
    -- Channel Selection
    layout["Gain "..i.." Bump Up"] = {
      PrettyName    = string.format("Gain %i~Bump Up",i),
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
    }
    --------------------------- Gain Bump Down
    -- Channel Selection
    layout["Gain "..i.." Bump Down"] = {
      PrettyName    = string.format("Gain %i~Bump Down",i),
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
    }






  end


elseif CurrentPage == "Setup" then
  -- TBD
end