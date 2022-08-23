local _, aObj = ...
if not aObj:isAddonEnabled("Journalator") then return end
local _G = _G

aObj.addonsToSkin.Journalator = function(self) -- v 1.3

	-- N.B. 0.54-5 alpha introduced Filters, so handle both versions for now
	self:SecureHookScript(_G.JNRView, "OnShow", function(this)
		local function skinFilters(frame)
			aObj:skinObject("editbox", {obj=frame.SearchFilter, si=true})
			aObj:skinObject("dropdown", {obj=frame.TimePeriodDropDown.DropDown})
			if frame.RealmDropDown.ResetButton then
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.RealmDropDown}
				end
			else
				aObj:skinObject("dropdown", {obj=frame.RealmDropDown.DropDown})
			end
			aObj:skinObject("dropdown", {obj=frame.FactionDropDown.DropDown})
		end
		if this.Filters then
			skinFilters(this.Filters)
			skinFilters = _G.nop
		end
		for _, frame in _G.pairs(this.Views) do
			if frame.displayMode ~= "Info" then
				skinFilters(frame)
				for _, child in _G.ipairs{frame.ResultsListing.HeaderContainer:GetChildren()} do
					self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					self:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				self:skinObject("slider", {obj=frame.ResultsListing.ScrollFrame.scrollBar})
				frame.ResultsListingInset.Bg:SetTexture(nil)
				self:removeNineSlice(frame.ResultsListingInset.NineSlice)
			else
				frame.Inset.Bg:SetTexture(nil)
				self:removeNineSlice(frame.Inset.NineSlice)
				self:skinObject("editbox", {obj=frame.DiscordLink.InputBox})
				self:skinObject("editbox", {obj=frame.BugReportLink.InputBox})
				if self.modBtns then
					self:skinStdButton{obj=frame.OptionsButton}
				end
			end
		end
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, y2=-2})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton}
			self:skinStdButton{obj=this.ExportCSV}
		end

		self:SecureHookScript(this.exportCSVDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true, ri=true, rns=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Close}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self.RegisterMessage("Journalator", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "Journalator" then return end
		aObj.iofSkinnedPanels[panel] = true

		if self.modBtns then
			self:skinStdButton{obj=panel.ComputeFullStatistics}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=panel.TooltipSaleRate.CheckBox}
			self:skinCheckButton{obj=panel.TooltipFailures.CheckBox}
			self:skinCheckButton{obj=panel.TooltipLastSold.CheckBox}
			self:skinCheckButton{obj=panel.TooltipLastBought.CheckBox}
			self:skinCheckButton{obj=panel.GroupJunk.CheckBox}
			self:skinCheckButton{obj=panel.ShowDetailedStatus.CheckBox}
			self:skinCheckButton{obj=panel.ShowMinimapIcon.CheckBox}
			self:skinCheckButton{obj=panel.DebugMode.CheckBox}
		end

		self.UnregisterMessage("Journalator", "IOFPanel_Before_Skinning")
	end)

end
