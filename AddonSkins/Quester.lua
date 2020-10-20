local aName, aObj = ...
if not aObj:isAddonEnabled("Quester") then return end
local _G = _G

aObj.addonsToSkin.Quester = function(self) -- v 9.0.1.2

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
	self:SecureHook(Quester, "GOSSIP_SHOW", function()
		for btn in _G.GossipFrame.titleButtonPool:EnumerateActive() do
			btn:SetText(chgTxtClr(btn:GetText()))
		end
	end)
	self:SecureHook(Quester, "QUEST_GREETING", function()
		for btn in _G.QuestFrameGreetingPanel.titleButtonPool:EnumerateActive() do
			btn:SetText(chgTxtClr(btn:GetText()))
		end
	end)

end
