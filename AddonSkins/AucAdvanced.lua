
function Skinner:AucAdvanced()
	if not self.db.profile.AuctionUI then return end

	if IsAddOnLoaded("EnhTooltip") then self:checkAndRunAddOn("EnhTooltip") end

	if UIParentHealthBar then
		UIParentHealthBar:SetBackdrop(nil)
		self:glazeStatusBar(UIParentHealthBar, 0)
	end

	if AucAdvanced.Modules.Util.SimpleAuction then
		-- skin the Simple Auction Frame
		self:SecureHook(AucAdvanced.Modules.Util.SimpleAuction.Private, "CreateFrames", function()
			local frame = AucAdvanced.Modules.Util.SimpleAuction.Private.frame
			self:skinMoneyFrame(frame.minprice, nil, true, true)
			self:skinMoneyFrame(frame.buyout, nil, true, true)
			self:skinEditBox(frame.stacks.num, {9})
			self:skinEditBox(frame.stacks.size, {9})
			self:Unhook(AucAdvanced.Modules.Util.SimpleAuction.Private,"CreateFrames")
		end)
	end
	
	if AucAdvanced.Modules.Util.Appraiser then
		-- skin the Appraiser Frame
		self:SecureHook(AucAdvanced.Modules.Util.Appraiser.Private, "CreateFrames", function()
			local frame = AucAdvanced.Modules.Util.Appraiser.Private.frame
			self:applySkin(frame.itembox)
			self:skinSlider(frame.scroller)
			self:applySkin(frame.salebox)
			self:skinEditBox(frame.salebox.numberentry, {9})
			self:skinEditBox(frame.salebox.stackentry, {9})
			self:skinDropDown(frame.salebox.model)
			self:skinMoneyFrame(frame.salebox.bid, nil, true, true)
			self:skinMoneyFrame(frame.salebox.buy, nil, true, true)
			self:applySkin(frame.manifest)
			self:Unhook(AucAdvanced.Modules.Util.Appraiser.Private,"CreateFrames")
		end)
	end
	
	-- skin the Buy prompt frame
	if AucAdvanced.Buy then
		self:skinEditBox(AucAdvanced.Buy.Private.Prompt.Reason, {9})
		self:applySkin(AucAdvanced.Buy.Private.Prompt)
	end
	
	-- skin the Library objects
	self:Configator()
	
end
