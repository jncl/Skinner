local aName, aObj = ...
if not aObj:isAddonEnabled("Quester") then return end
local _G = _G

aObj.addonsToSkin.Quester = function(self) -- v 7.3.0.0

	local Quester = _G.LibStub("AceAddon-3.0"):GetAddon("Quester", true)

	-- hook these to handle colour changes
	local function chgTxtClr(text)
		if text:match("^|c(.*)%[") then
			text = text:gsub("|r", "") .. "|r"
		elseif text:match("^%[") then
			text = _G.NORMAL_QUEST_DISPLAY:format(text)
		end
		return text
	end
	local btn
	for i = 1, _G.NUMGOSSIPBUTTONS do
		btn = _G["GossipTitleButton" .. i]
		self:RawHook(btn, "SetText", function(this, text)
			self.hooks[this].SetText(this, chgTxtClr(text))
		end, true)
	end
	for i = 1, _G.MAX_NUM_QUESTS do
		btn = _G["QuestTitleButton" .. i]
		self:RawHook(btn, "SetText", function(this, text)
			self.hooks[this].SetText(this, chgTxtClr(text))
		end, true)
	end
	btn = nil

end
