


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
    Name          = "Gain "..i.." Index",
    ControlType   = "Indicator",
    IndicatorType = "Text",
    UserPin       = false,
  })
  ------------------------------- gain friendly name
  table.insert(ctrls, {             
    Name          = "Gain "..i.." Friendly Name",
    ControlType   = "Text",
    UserPin       = true,
    PinStyle      = "Both",
  })


end

