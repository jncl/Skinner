local aName, aObj = ...
if not aObj:isAddonEnabled("DejaClassicStats") then return end
local _G = _G

aObj.addonsToSkin.DejaClassicStats = function(self) -- v 1302r022

	self:SecureHookScript(_G.DCS_StatScrollFrame, "OnShow", function(this)
		self:skinSlider{obj=this.ScrollBar}
		_G.DCSPrimaryStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSDefenseStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSMeleeEnhancementsStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSSpellEnhancementsStatsHeader:DisableDrawLayer("ARTWORK")
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, y1=14, x2=1, y2=-15}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.PaperDollFrame.ExpandButton, ofs=-3, x1=2, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end
