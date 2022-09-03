local _, aObj = ...
if not aObj:isAddonEnabled("DejaClassicStats") then return end
local _G = _G

aObj.addonsToSkin.DejaClassicStats = function(self) -- v 1307r005/205r013

	self:SecureHookScript(_G.DCS_StatScrollFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollBar})
		_G.DCSPrimaryStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSMeleeEnhancementsStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSSpellEnhancementsStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSDefenseStatsHeader:DisableDrawLayer("ARTWORK")
		if self.isClsc then
			_G.DCSRangedStatsHeader:DisableDrawLayer("ARTWORK")
		end
		self:skinObject("frame", {obj=this, kfs=true, x1=-2, y1=14, x2=1, y2=-12})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.PaperDollFrame.ExpandButton, ofs=-3, x1=2, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end
