local keywords = {}
local banned = {}
local notifiedSenders = {}
local filterEnabled = true

function AddKeyword(word)
  if not tContains(keywords, word) then
    table.insert(keywords, word)
    print("|cff00ff00[ChatTracker]|r Added keyword: " .. word)
  end
end

function RemoveKeyword(word)
  for i, v in ipairs(keywords) do
    if v:lower() == word:lower() then
      table.remove(keywords, i)
      print("|cff00ff00[ChatTracker]|r Removed keyword: " .. word)
      return
    end
  end
end

function AddBannedWord(word)
  if not tContains(banned, word) then
    table.insert(banned, word)
    print("|cff00ff00[ChatTracker]|r Added banned word: " .. word)
  end
end

function RemoveBannedWord(word)
  for i, v in ipairs(banned) do
    if v:lower() == word:lower() then
      table.remove(banned, i)
      print("|cff00ff00[ChatTracker]|r Removed banned word: " .. word)
      return
    end
  end
end

function ToggleFilter(state)
  if state == "on" then
    filterEnabled = true
    print("|cff00ff00[ChatTracker]|r Filter enabled.")
  elseif state == "off" then
    filterEnabled = false
    print("|cff00ff00[ChatTracker]|r Filter disabled.")
  end
end

function ChatTracker(self, event, msg, sender, ...)
  if not filterEnabled then return end
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

SLASH_CHATTRACKER1 = "/track"
SlashCmdList["CHATTRACKER"] = function(msg)
  local cmd, arg = msg:match("^(%S+)%s*(.-)$")
  if cmd == "addkw" and arg ~= "" then
    AddKeyword(arg)
  elseif cmd == "rmkw" and arg ~= "" then
    RemoveKeyword(arg)
  elseif cmd == "addban" and arg ~= "" then
    AddBannedWord(arg)
  elseif cmd == "rmban" and arg ~= "" then
    RemoveBannedWord(arg)
  elseif cmd == "on" then
    ToggleFilter("on")
  elseif cmd == "off" then
    ToggleFilter("off")
  elseif cmd == "list" then
    print("|cff00ff00[ChatTracker]|r Keywords: " .. table.concat(keywords, ", "))
    print("|cff00ff00[ChatTracker]|r Banned words: " .. table.concat(banned, ", "))
  elseif cmd == "clear" then
    notifiedSenders = {}
    print("|cff00ff00[ChatTracker]|r Cleared notified senders.")
  else
    print("|cff00ff00[ChatTracker]|r Usage: /track addkw <word>, rmkw <word>, addban <word>, rmban <word>, on, off, list")
  end
end

-- Apply the filters to msg events
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ChatTracker)