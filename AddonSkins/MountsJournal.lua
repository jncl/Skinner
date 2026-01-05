local _, aObj = ...
if not aObj:isAddonEnabled("MountsJournal") then return end
local _G = _G

aObj.addonsToSkin.MountsJournal= function(self) -- v v11.2.26/5.5.15

	self:SecureHookScript(_G.MountsJournal.summonPanel, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, fb=true, ofs=6})
		if self.modBtns then
			self:addButtonBorder{obj=this.summon1, ofs=3, reParent={this.summon1.FlyoutArrowNormal, this.summon1.FlyoutArrowPushed, this.summon1.FlyoutArrowHighlight}}
			self:addButtonBorder{obj=this.summon2, ofs=3, reParent={this.summon2.FlyoutArrowNormal, this.summon2.FlyoutArrowPushed, this.summon2.FlyoutArrowHighlight}}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.MountsJournal.summonPanel)

end
