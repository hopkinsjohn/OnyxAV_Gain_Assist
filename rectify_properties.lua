local maximumsize = 24

for i = 2, maximumsize do
  props["Max dB "..i].IsHidden = true
  props["Min dB "..i].IsHidden = true
  props["Link Mute "..i].IsHidden = true
  props["Show Meter "..i].IsHidden = true
  props["Preamp Controls "..i].IsHidden = true
end

if props["Number Of Gains"].Value > 1 then 
  for i = 2, props["Number Of Gains"].Value do
    props["Max dB "..i].IsHidden = false
    props["Min dB "..i].IsHidden = false
    props["Link Mute "..i].IsHidden = false
    props["Show Meter "..i].IsHidden = false
    props["Preamp Controls "..i].IsHidden = false
  end
end

