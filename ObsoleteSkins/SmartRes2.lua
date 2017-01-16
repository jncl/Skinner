local aName, aObj = ...
if not aObj:isAddonEnabled("SmartRes2") then return end
local _G = _G

function aObj:SmartRes2()

	local sr2 = _G.LibStub("AceAddon-3.0"):GetAddon("SmartRes2")

	-- ResBars anchor
	self:addSkinFrame{obj=sr2.rez_bars.button}
	-- ResBars texture
	sr2.db.profile.resBarsTexture = self.db.profile.StatusBar.texture

	-- TimeOutBars anchor
	self:addSkinFrame{obj=sr2.timeOut_bars.button}

end
