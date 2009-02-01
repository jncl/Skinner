
function Skinner:AucAdvanced()
	if not self.db.profile.AuctionUI then return end

	if IsAddOnLoaded("EnhTooltip") then self:checkAndRunAddOn("EnhTooltip") end

	-- move and skin the progress bars
	self:SecureHook(AucAdvanced.Scan , "ProgressBars", function(sbObj, value, show, text)
--		self:Debug("AAS_PB: [%s, %s, %s, %s]", sbObj, value, show, text)
		if not sbObj.skinned then
			sbObj:SetBackdrop(nil)
			self:glazeStatusBar(sbObj, 0)
			sbObj.skinned = true
		end
		local point, relTo, relPoint, xOfs, yOfs = sbObj:GetPoint()
--		self:Debug("AAS_PB(GP): [%s, %s, %s, %s, %s]", point, relTo:GetName(), relPoint, xOfs, yOfs)
		if relTo == AuctionFrame then
			sbObj:ClearAllPoints()
			sbObj:SetPoint(point, relTo, relPoint, xOfs, yOfs + 10)
		end
	end)
	
	if AucAdvanced.Modules.Util.SimpleAuction then
		-- skin the Simple Auction Frame
		self:SecureHook(AucAdvanced.Modules.Util.SimpleAuction.Private, "CreateFrames", function()
			local frame = AucAdvanced.Modules.Util.SimpleAuction.Private.frame
			self:skinMoneyFrame(frame.minprice, nil, true, true)
			self:skinMoneyFrame(frame.buyout, nil, true, true)
			self:skinEditBox(frame.stacks.num, {9})
			self:skinEditBox(frame.stacks.size, {9})
			self:moveObject(frame.create, nil, nil, "-", 10)
			self:RawHook(frame.create , "SetPoint", function() end, true)
			self:moveObject(frame.scanbutton, nil, nil, "-", 5)
			self:moveObject(frame.refresh, nil, nil, "-", 5)
			self:Unhook(AucAdvanced.Modules.Util.SimpleAuction.Private,"CreateFrames")
		end)
	end

	if AucAdvanced.Modules.Util.Appraiser then
		-- skin the Appraiser Frame
		self:SecureHook(AucAdvanced.Modules.Util.Appraiser.Private, "CreateFrames", function()
			local frame = AucAdvanced.Modules.Util.Appraiser.Private.frame
			self:moveObject(frame.toggleManifest, "-", 10, "+", 8)
			self:applySkin(frame.itembox)
			self:skinSlider(frame.scroller)
			self:applySkin(frame.salebox)
			self:skinEditBox(frame.salebox.numberentry, {9})
			self:skinEditBox(frame.salebox.stackentry, {9})
			self:skinDropDown(frame.salebox.model)
			self:skinMoneyFrame(frame.salebox.bid, nil, true, true)
			self:skinMoneyFrame(frame.salebox.buy, nil, true, true)
			self:applySkin(frame.manifest)
			self:moveObject(frame.itembox.showAuctions, "-", 10, nil, nil)
			frame.imageview.purchase:SetBackdrop(nil)
			frame.imageview.purchase:SetBackdropColor(0, 0, 0, 0)
			self:moveObject(frame.cancel, nil, nil, "-", 5)
			self:moveObject(frame.go, nil, nil, "-", 5)
			self:RawHook(frame.go , "SetPoint", function() end, true)
			self:moveObject(frame.gobatch, nil, nil, "-", 5)
			self:moveObject(frame.refresh, nil, nil, "-", 5)
			self:Unhook(AucAdvanced.Modules.Util.Appraiser.Private,"CreateFrames")
			-- move the scan button and stop it being moved again
			self:moveObject(AucAdvScanButton, nil, nil, "+", 5)
			self:RawHook(AucAdvScanButton, "SetPoint", function() end, true)
		end)
	end

	-- skin the Buy prompt frame
	if AucAdvanced.Buy then
		self:skinEditBox(AucAdvanced.Buy.Private.Prompt.Reason, {9})
		self:applySkin(AucAdvanced.Buy.Private.Prompt)
	end

end
