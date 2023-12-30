local _, aObj = ...
if not aObj:isAddonEnabled("DejaClassicStats") then return end
local _G = _G

aObj.addonsToSkin.DejaClassicStats = function(self) -- v 11500r6

	self:SecureHookScript(_G.DCS_StatScrollFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollBar})
		_G.DCSPrimaryStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSMeleeEnhancementsStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSSpellEnhancementsStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSDefenseStatsHeader:DisableDrawLayer("ARTWORK")
		_G.DCSRangedStatsHeader:DisableDrawLayer("ARTWORK")
		self:skinObject("frame", {obj=this, kfs=true, x1=-2, y1=14, x2=1, y2=-12})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.PaperDollFrame.ExpandButton, ofs=-3, x1=2, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self.RegisterCallback("DejaClassicStats", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "DejaClassicStats" then return end
		self.iofSkinnedPanels[panel] = true

		for _, child in _G.ipairs_reverse{panel:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and self.modChkBtns
			then
				self:skinCheckButton{obj=child}
			elseif child:IsObjectType("Button")
			and self.modBtns
			then
				self:skinStdButton{obj=child}
			end
		end

		self.UnregisterCallback("DejaClassicStats", "IOFPanel_Before_Skinning")
	end)

end
