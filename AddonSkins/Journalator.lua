local _, aObj = ...
if not aObj:isAddonEnabled("Journalator") then return end
local _G = _G

aObj.addonsToSkin.Journalator = function(self) -- v 0.48

	self:SecureHookScript(_G.JNRView, "OnShow", function(this)
		for _, frame in _G.pairs(this.Views) do
			if frame.displayMode ~= "Info" then
				self:skinObject("editbox", {obj=frame.SearchFilter, si=true})
				self:skinObject("dropdown", {obj=frame.TimePeriodDropDown.DropDown})
				self:skinObject("dropdown", {obj=frame.RealmDropDown.DropDown})
				for _, child in _G.ipairs{frame.ResultsListing.HeaderContainer:GetChildren()} do
					self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					self:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				self:skinObject("slider", {obj=frame.ResultsListing.ScrollFrame.scrollBar})
				frame.ResultsListingInset.Bg:SetTexture(nil)
				self:removeNineSlice(frame.ResultsListingInset.NineSlice)
				if self.modBtnBs then
					self:addButtonBorder{obj=self:getChild(frame, 1), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
			else
				frame.Inset.Bg:SetTexture(nil)
				self:removeNineSlice(frame.Inset.NineSlice)
				self:skinObject("editbox", {obj=frame.DiscordLink.InputBox})
				self:skinObject("editbox", {obj=frame.BugReportLink.InputBox})
			end
		end
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, y2=-1})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseDialog}
			self:skinStdButton{obj=this.ExportCSV}
		end
		
		self:SecureHookScript(this.exportCSVDialog, "OnShow", function(this)
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Close}
			end

			self:Unhook(this, "OnShow")
		end)
		
		self:Unhook(this, "OnShow")
	end)

	if self.modChkBtns then
		self.RegisterCallback("Journalator", "IOFPanel_Before_Skinning", function(this, panel)
			if panel.name ~= "Journalator" then return end
			aObj.iofSkinnedPanels[panel] = true
			self:skinCheckButton{obj=panel.TooltipSaleRate.CheckBox}
			self:skinCheckButton{obj=panel.TooltipFailures.CheckBox}
			self:skinCheckButton{obj=panel.TooltipLastSold.CheckBox}
			self:skinCheckButton{obj=panel.TooltipLastBought.CheckBox}
		
			self.UnregisterCallback("Journalator", "IOFPanel_Before_Skinning")
		end)
	end
	
end
