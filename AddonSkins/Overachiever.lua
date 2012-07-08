local aName, aObj = ...
if not aObj:isAddonEnabled("Overachiever") then return end

function aObj:Overachiever()
	if not self.db.profile.AchievementUI then return end

	local function findOptionsPanel(panel)
		local panelName
		if type(panel) == "string" then
			panelName = panel
			panel = nil
		end
		local elementToDisplay
		for _, element in next, INTERFACEOPTIONS_ADDONCATEGORIES do
			if ( element == panel or (panelName and element.name and element.name == panelName) ) then
				elementToDisplay = element
				break
			end
		end
		return elementToDisplay
	end

	local panel = findOptionsPanel("Overachiever")
	self:SecureHookScript(panel, "OnShow", function(this)
    	local tab = this.TjOpt_tab
		if tab.scrolling then
			self:skinScrollBar{obj=TjOptionsScrollFrame1}
		end
		for i = 1, #tab.items do
			local itm = _G["TjOptionsItemNumber"..i]
			if itm and itm.TjDDM then
--				self:Debug("Found a DropDown: [%s]", i)
				self:skinDropDown{obj=itm}
			end
		end
		self:Unhook(panel, "OnShow")
	end)

end


function aObj:Overachiever_Tabs()
	if not self.db.profile.AchievementUI then return end

	self:skinAllButtons{obj=Overachiever_LeftFrame}
-->>-- Search Frame
	self:keepFontStrings(Overachiever_SearchFrame)
	self:skinDropDown{obj=Overachiever_SearchFrameSortDrop, x2=110}
	self:skinEditBox(Overachiever_SearchFrameNameEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameDescEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameCriteriaEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameRewardEdit, {9})
	self:skinEditBox(Overachiever_SearchFrameAnyEdit, {9})
	self:skinDropDown{obj=Overachiever_SearchFrameTypeDrop, x2=110}
	self:skinSlider(Overachiever_SearchFrameContainerScrollBar)
	self:applySkin(self:getChild(Overachiever_SearchFrame, 1))
	LowerFrameLevel(self:getChild(Overachiever_SearchFrame, 1))

-->>-- Suggestions Frame
	self:keepFontStrings(Overachiever_SuggestionsFrame)
	self:skinDropDown{obj=Overachiever_SuggestionsFrameSortDrop, x2=110}
	self:skinEditBox{obj=Overachiever_SuggestionsFrameZoneOverrideEdit, regs={9}}
	self:skinDropDown{obj=Overachiever_SuggestionsFrameSubzoneDrop, x2=27}
	self:skinSlider(Overachiever_SuggestionsFrameContainerScrollBar)
	self:applySkin(self:getChild(Overachiever_SuggestionsFrame, 1))
	LowerFrameLevel(self:getChild(Overachiever_SuggestionsFrame, 1))

-->>-- Watch Frame
	self:keepFontStrings(Overachiever_WatchFrame)
	self:skinDropDown{obj=Overachiever_WatchFrameSortDrop, x2=110}
	self:skinDropDown{obj=Overachiever_WatchFrameListDrop, x2=27}
	self:skinDropDown{obj=Overachiever_WatchFrameDefListDrop, x2=27}
	self:skinDropDown{obj=Overachiever_WatchFrameDestinationListDrop, x2=27}
	self:skinSlider(Overachiever_WatchFrameContainerScrollBar)
	local wFrame = self:getChild(Overachiever_WatchFrame, 1)
	self:applySkin(wFrame)
	wFrame:SetFrameLevel(wFrame:GetFrameLevel() - 2) -- make sure text is shown

end
