local keywords = { "Strat", "UBRS" }
local banned = { "lfg", "strategy", "live" }
local notifiedSenders = {}
function callMeMaybe(self, event, msg, sender, ...)
  for _, kw in ipairs(keywords) do
    local msg = msg:lower() or ""
    if msg:find(kw:lower()) then
      for _, ban in ipairs(banned) do
        if msg:find(ban) then
          return -- Ignore banned messages
        end
      end
      if sender and not notifiedSenders[sender] then
        print("\124cffff0000" .. sender .. ": " .. msg .. "\124r")
        PlaySoundFile("Sound\\Interface\\RaidWarning.wav")
        notifiedSenders[sender] = true
      end
      break
    end
  end
end
