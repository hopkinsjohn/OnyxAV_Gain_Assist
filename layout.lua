
-- RUNTIME CODE input pin (comment this out when runtime has been added to this plugin)
layout["code"]={PrettyName="code",Style="None"}

-----------------------------------------------------
-------------------- Variables ----------------------
-----------------------------------------------------

local GroupBoxFillColor = {51,51,51}
local GroupBoxStrokeColor = {125,198,35}
local StandardWidth = 50
local StandardHeight = 20
local PositionStartX = 123
local PositionStartY = 8
local TextFont    = "Montserrat"
local TextFontStyle = "Regular"
local TextColorBlack = {0,0,0}
local TextColorGreen = {125,198,35}
local TextColorSilver = {204,204,204} 

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
    Size          = {PositionStartX + (iMaxGains*StandardWidth) + 60,391},
    ZOrder        = -40,
  })

  --------------------------- otherstuff
  
  --------------------------- otherstuff
  
  --------------------------- otherstuff
  
  --------------------------- otherstuff
  
  for i = 1, iMaxGains do
  --------------------------- Label - channel index
  layout["Gain "..i.." Index"] = { 
    PrettyName    = "Gain "..i.." Index",
    Style         = "Text",
    TextBoxStyle  = "NoBackground",
    Position      = {PositionStartX + (i-1)*StandardWidth, PositionStartY},
    Size          = {StandardWidth,StandardHeight},
    FontSize      = 9,
    Margin        = 0,
    Font          = TextFont,
    FontStyle     = TextFontStyle,
    TextColor     = TextColorGreen,
    HTextAlign    = "Center",
    IsReadOnly    = true,
  }
  --------------------------- gain friendly names
  layout["Gain "..i.." Friendly Name"] = { 
    PrettyName    = string.format("Gain %i~Friendly Name",i),
    Style         = "Text",
    Position      = {PositionStartX + (i-1)*StandardWidth , PositionStartY + StandardHeight},
    Size          = {StandardWidth,StandardHeight},
    Color         = {255,255,255},
    FontSize      = 12,
    Font          = TextFont,
    FontStyle     = TextFontStyle,
    TextColor     = TextColorBlack,
    Margin        = 0,
    HTextAlign    = "Center",
    IsReadOnly    = false,
  }

  end


elseif CurrentPage == "Setup" then
  -- TBD
end