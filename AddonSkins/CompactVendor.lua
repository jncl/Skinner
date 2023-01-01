local _, aObj = ...
if not aObj:isAddonEnabled("CompactVendor") then return end
local _G = _G

aObj.addonsToSkin.CompactVendor = function(self) -- v 10.0.2.221230

	self:SecureHookScript(_G.CompactVendorFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.Search, si=true, y1=-4, y2=4})
		self:skinObject("scrollbar", {obj=this.ScrollBar})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.CompactVendorFilterButton, ofs=-2, x1=1, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CompactVendorFrameMerchantStackSplitFrame, "OnShow", function(this)
		this.SingleItemSplitBackground:SetTexture(nil)
		this.MultiItemSplitBackground:SetTexture(nil)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=this.OkayButton}
			self:skinStdButton{obj=this.CancelButton}
		end

		self:Unhook(this, "OnShow")
	end)

end
