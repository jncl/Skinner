local _, aObj = ...
if not aObj:isAddonEnabled("CompactVendor") then return end
local _G = _G

aObj.addonsToSkin.CompactVendor = function(self) -- v 12.0.0.260124

	self:SecureHookScript(_G.CompactVendorFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.Search, si=true, y1=-4, y2=4})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.CompactVendorFilterButton, ofs=-2, x1=1, clr="grey"}
		end
		-- colour the Item price white, fixes #270
		self:skinObject("scrollbar", {obj=this.ScrollBar})
		local function skinElement(...)
			local _, element, elementData
			if _G.select("#", ...) == 2 then
				element, elementData = ...
			else
				_, element, elementData = ...
			end
			for _, frame in _G.pairs(element.Cost.Costs) do
				if frame.costType == "Item" then
					frame.Icon.Count:SetTextColor(1, 1, 1, 1)
				end
			end
		end
		_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)

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
