local _, aObj = ...
if not aObj:isAddonEnabled("AnnounceTargetPH") then return end
local _G = _G

aObj.addonsToSkin.AnnounceTargetPH = function(self) -- v 9.1.0.0

	-- move frame if required
	local ufDB = self.db:GetNamespace("UnitFrames", true)
	if ufDB
	and ufDB.profile.player
	and _G.ATDB.y == -110
	then
		self:moveObject{obj=_G.ATargetFrame, x=0, y=-20}
	end
	ufDB = ufDB and nil
	
	if self.modBtns then
		self:skinStdButton{obj=self:getLastChild(_G.ATargetFrame)}
	end

end
