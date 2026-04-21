local maximumsize = 24

table.insert(props, { 
  Name = "Number Of Gains",
  Type = "integer",
  Min = 1,
  Max = maximumsize,
  Value = 1,  
})

table.insert(props, { 
  Name = "Mute State Trigger Max Val",
  Type = "integer",
  Min = 4,
  Max = 6,
  Value = 4,  
  Comment = "CSS State Trigger Max Value. Mute == 1. Low == 2. Etc. This value will be \"High\" value.",
})

for i = 1, maximumsize do
  table.insert(props, {
    Name = "Max dB "..i,
    Type = "double",
    Min = -100,
    Max = 100,
    Value = 20,  
  })
  table.insert(props, {
    Name = "Min dB "..i,
    Type = "double",
    Min = -100,
    Max = 100,
    Value = -100,  
  })
  table.insert(props, {
    Name = "Link Mute "..i,
    Type = "boolean",
    Value = true,
  })
  table.insert(props, {
    Name = "Show Meter "..i,
    Type = "boolean",
    Value = false,
  })
  table.insert(props, {
    Name = "Preamp Controls "..i,
    Type = "boolean",
    Value = false,
    Comment = " ",
  })
end