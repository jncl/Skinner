
function Skinner:AucAdvanced()
	if not self.db.profile.AuctionUI then return end

	if IsAddOnLoaded("EnhTooltip") then self:checkAndRunAddOn("EnhTooltip") end

	-- move and skin the progress bars
	self:SecureHook(AucAdvanced.Scan , "ProgressBars", function(sbObj, value, show, text)
		if not self.sbGlazed[sbObj] then
			sbObj:SetBackdrop(nil)
			self:glazeStatusBar(sbObj, 0)
		end
	end)

	if AucAdvanced.Modules.Util.SimpleAuction then
		-- skin the Simple Auction Frame (tab labelled Post)
		self:SecureHook(AucAdvanced.Modules.Util.SimpleAuction.Private, "CreateFrames", function()
			local frame = AucAdvanced.Modules.Util.SimpleAuction.Private.frame
			self:moveObject{obj=frame.config, y=-2}
			self:skinMoneyFrame{obj=frame.minprice, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinMoneyFrame{obj=frame.buyout, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinEditBox{obj=frame.stacks.num, regs={9}}
			self:skinEditBox{obj=frame.stacks.size, regs={9}}
			self:Unhook(AucAdvanced.Modules.Util.SimpleAuction.Private, "CreateFrames")
		end)
	end

	if AucAdvanced.Modules.Util.SearchUI then
		-- skin the SearchUI Frame
		self:SecureHook(AucAdvanced.Modules.Util.SearchUI, "CreateAuctionFrames", function()
			self:addSkinFrame{obj=AucAdvSearchUiAuctionFrame.backing}
			AucAdvSearchUiAuctionFrame.money:SetAlpha(0)
			self:Unhook(AucAdvanced.Modules.Util.SearchUI, "CreateAuctionFrames")
		end)
		-- skin the GUI frame as well
		self:SecureHook(AucAdvanced.Modules.Util.SearchUI, "MakeGuiConfig", function()
			AucAdvanced.Modules.Util.SearchUI.Private.gui.frame.progressbar:SetBackdrop(nil)
			self:glazeStatusBar(AucAdvanced.Modules.Util.SearchUI.Private.gui.frame.progressbar, 0)
			self:Unhook(AucAdvanced.Modules.Util.SearchUI, "MakeGuiConfig")
		end)
	end
	
	if AucAdvanced.Modules.Util.Appraiser then
		-- skin the Appraiser Frame
		self:SecureHook(AucAdvanced.Modules.Util.Appraiser.Private, "CreateFrames", function()
			local frame = AucAdvanced.Modules.Util.Appraiser.Private.frame
			self:moveObject{obj=frame.toggleManifest, y=-2}
			self:addSkinFrame{obj=frame.itembox}
			self:skinSlider(frame.scroller)
			self:addSkinFrame{obj=frame.salebox}
			self:skinEditBox{obj=frame.salebox.numberentry, regs={9}}
			self:skinEditBox{obj=frame.salebox.stackentry, regs={9}}
			self:skinDropDown{obj=frame.salebox.model}
			self:skinMoneyFrame{obj=frame.salebox.bid, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinMoneyFrame{obj=frame.salebox.buy, noWidth=true, moveSEB=true, moveGEB=true}
			self:addSkinFrame{obj=frame.manifest, bg=true, y1=-2, x2=-2} -- a.k.a. Sidebar, put behind AH frame
			frame.imageview.purchase:SetBackdrop(nil)
			frame.imageview.purchase:SetBackdropColor(0, 0, 0, 0)
			self:Unhook(AucAdvanced.Modules.Util.Appraiser.Private,"CreateFrames")
		end)
	end

	-- skin the Buy prompt frame
	if AucAdvanced.Buy then
		self:skinEditBox{obj=AucAdvanced.Buy.Private.Prompt.Reason, regs={9}}
		self:addSkinFrame{obj=AucAdvanced.Buy.Private.Prompt}
	end

end
