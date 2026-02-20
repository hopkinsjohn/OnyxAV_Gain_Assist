local maximumsize = 24

table.insert(props, { 
  Name = "Number Of Gains",
  Type = "integer",
  Min = 1,
  Max = maximumsize,
  Value = 1,  
})

for i = 1, maximumsize do
  table.insert(props, {
    Name = "Max dB "..i,
    Type = "double",
    Min = -100,
    Max = 20,
    Value = 20,  
  })
  table.insert(props, {
    Name = "Min dB "..i,
    Type = "double",
    Min = -100,
    Max = 20,
    Value = -100,  
  })
end