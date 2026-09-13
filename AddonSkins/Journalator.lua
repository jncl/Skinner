local _, aObj = ...
if not aObj:isAddonEnabled("Journalator") then return end
local _G = _G

aObj.addonsToSkin.Journalator = function(self) -- v 169

	-- N.B. 0.54-5 alpha introduced Filters, so handle both versions for now
	self:SecureHook(_G.Journalator, "ToggleView", function()
		self:SecureHookScript(_G.JNRView, "OnShow", function(this)
			self:skinObject("editbox", {obj=this.Filters.SearchFilter, si=true})
			self:skinObject("ddbutton", {obj=this.Filters.TimePeriodDropDown.DropDown})
			self:skinObject("ddbutton", {obj=this.Filters.FactionDropDown.DropDown})
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true})
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, y1=-1, x2=0})
			if self.modBtns then
				self:skinStdButton{obj=this.Filters.RealmDropDown}
				self:skinStdButton{obj=this.Filters.CharacterDropDown}
				self:skinCloseButton{obj=this.CloseButton}
				self:skinStdButton{obj=this.ExportCSV}
			end

			local function skinResultsListing(fObj)
				aObj:removeInset(fObj.ResultsListingInset)
				for _, child in _G.ipairs{fObj.ResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
					aObj:skinObject("scrollbar", {obj=fObj.ResultsListing.ScrollArea.ScrollBar})
					aObj:skinObject("frame", {obj=fObj.ResultsListing.ScrollArea, kfs=true, fb=true, y1=6, y2=-8})
				end
			end

			for _, frame in _G.pairs(this.Views) do
				if frame.Views then
					for _, frame2 in _G.pairs(frame.Views) do
						if frame2.ResultsListing then
							skinResultsListing(frame2)
						end
					end
				end
				if frame.ResultsListing then
					skinResultsListing(frame)
				end
				if frame.Tabs then
					self:skinObject("tabs", {obj=frame, tabs=frame.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true})
				end
				if frame.displayMode == "Info" then
					self:removeInset(frame.Inset)
					self:skinObject("editbox", {obj=frame.DiscordLink.InputBox})
					self:skinObject("editbox", {obj=frame.BugReportLink.InputBox})
					if self.modBtns then
						self:skinStdButton{obj=frame.OptionsButton}
					end
				end
			end

			self:SecureHookScript(this.exportCSVDialog, "OnShow", function(fObj)
				self:removeNineSlice(fObj.Border)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar})
				self:skinObject("frame", {obj=fObj, kfs=true, ri=true, rns=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Close}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
			skinResultsListing = nil
		end)
		self:checkShown(_G.JNRView)

		self:Unhook(_G.Journalator, "ToggleView")
		-- hide then show frame to force textured tabs
		if self.isTT then
			_G.JNRView:Hide()
			_G.JNRView:Show()
		end
	end)

	local pCnt, pName = 0
	self.RegisterCallback("Journalator", "SettingsPanel_DisplayCategory", function(_, panel)
		aObj:Debug("SP_DC: [%s, %s]", panel, panel.name)
		pName = panel:GetName()
		if not pName:find("Journalator")
		or self.spSkinnedPanels[panel]
		then
			return
		end
		self.spSkinnedPanels[panel] = true
		if pName:find("BasicOptions") then
			pCnt = pCnt + 1
			self:skinObject("dropdown", {obj=panel.DefaultTabChooser})
			if self.modBtns then
				self:skinStdButton{obj=panel.ComputeFullStatistics}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=panel.GroupJunk.CheckBox}
				self:skinCheckButton{obj=panel.ShowDetailedStatus.CheckBox}
				self:skinCheckButton{obj=panel.ShowMinimapIcon.CheckBox}
			end
		elseif pName:find("Tooltips") then
			pCnt = pCnt + 1
			if self.modChkBtns then
				self:skinCheckButton{obj=panel.TooltipSaleRate.CheckBox}
				self:skinCheckButton{obj=panel.TooltipSuccesses.CheckBox}
				self:skinCheckButton{obj=panel.TooltipFailures.CheckBox}
				self:skinCheckButton{obj=panel.TooltipLastSold.CheckBox}
				self:skinCheckButton{obj=panel.TooltipLastBought.CheckBox}
				self:skinCheckButton{obj=panel.TooltipSoldStats.CheckBox}
				self:skinCheckButton{obj=panel.TooltipBoughtStats.CheckBox}
			end
		elseif pName:find("Monitors") then
			pCnt = pCnt + 1
			if self.modChkBtns then
				self:skinCheckButton{obj=panel.AuctionHouse.CheckBox}
				self:skinCheckButton{obj=panel.Vendoring.CheckBox}
				self:skinCheckButton{obj=panel.CraftingOrders.CheckBox}
				self:skinCheckButton{obj=panel.TradingPost.CheckBox}
				self:skinCheckButton{obj=panel.Questing.CheckBox}
				self:skinCheckButton{obj=panel.Looting.CheckBox}
				self:skinCheckButton{obj=panel.WoWTokens.CheckBox}
				self:skinCheckButton{obj=panel.Mail.CheckBox}
				self:skinCheckButton{obj=panel.Trades.CheckBox}
			end
		elseif pName:find("IgnoreTransfers") then
			pCnt = pCnt + 1
			if self.modBtns then
				self:skinStdButton{obj=panel.AddNewEntryButton}
			end
		end

		if pCnt == 4 then
			self.UnregisterCallback("Journalator", "SettingsPanel_DisplayCategory")
		end
	end)

end
