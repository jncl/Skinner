local _, aObj = ...
if not aObj:isAddonEnabled("CompactVendor") then return end
local _G = _G

aObj.addonsToSkin.CompactVendor = function(self) -- v 9.0.0.200731

	self:SecureHookScript(_G.VladsVendorFrame, "OnShow", function(this)
		self:skinEditBox{obj=this.Search, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		self:skinSlider{obj=this.List.ListScrollFrame.ScrollBar, rt="background", wdth=-4}--, size=3, hgt=-10}
		self:removeInset(this.List.InsetFrame)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VladsVendorListItemQuantityStackSplitFrame, "OnShow", function(this)
		this.SingleItemSplitBackground:SetTexture(nil)
		this.MultiItemSplitBackground:SetTexture(nil)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=-6}
		if self.modBtns then
			self:skinStdButton{obj=this.OkayButton}
			self:skinStdButton{obj=this.CancelButton}
		end

		self:Unhook(this, "OnShow")
	end)

end
