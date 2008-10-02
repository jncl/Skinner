
function Skinner:LinksList()

	self:keepFontStrings(LinksList_ToggleButton)
	LinksList_ToggleButton:ClearAllPoints()
	LinksList_ToggleButton:GetFontString():SetPoint("CENTER", LinksList_ToggleButton, "CENTER")
	self:applySkin(LinksList_ToggleButton)

	local llsfr = "LinksList_SearchFrame_Reusable"

	self:HookScript(LinksList_ToggleButton, "OnClick", function()
		self.hooks[this].OnClick()
		LinksList_ResultsFrame:SetWidth(LinksList_ResultsFrame:GetWidth() * self.FxMult)
		LinksList_ResultsFrame:SetHeight(LinksList_ResultsFrame:GetHeight() * self.FyMult)
		self:keepFontStrings(LinksList_ResultsFrame)
		self:moveObject(LinksList_ResultsFrame_TitleButton, nil, nil, "+", 8)
		self:moveObject(LinksList_ResultsFrame_CloseButton, "+", 30, "+", 8)
		self:skinDropDown(LinksList_ResultsFrame_SectionDD)
		self:skinDropDown(LinksList_ResultsFrame_SortTypeDD)
		self:removeRegions(LinksList_ResultsFrame_ScrollFrame)
		self:skinScrollBar(LinksList_ResultsFrame_ScrollFrame)
		self:moveObject(LinksList_ResultsFrame_AdvancedSearchButton, "+", 30, "-", 70)
		self:applySkin(LinksList_ResultsFrame)
		LinksList_ResultsFrame_QuickSearchFrame:SetWidth(200)
		self:moveObject(LinksList_ResultsFrame_QuickSearchFrame, "-", 5, "-", 70)
		self:applySkin(LinksList_ResultsFrame_QuickSearchFrame)
--		hook this to skin the Advanced Search Frame
		self:HookScript(LinksList_ResultsFrame_AdvancedSearchButton, "OnClick", function()
			self.hooks[this].OnClick()
			if not LinksList_SearchFrame.skinned then
				self:keepFontStrings(LinksList_SearchFrame)
				self:moveObject(LinksList_SearchFrameTitleBoxText, nil, nil, "-", 7)
				self:applySkin(LinksList_SearchFrame_SectionParametersFrame)
				self:applySkin(LinksList_SearchFrame_SubsectionParametersFrame)
				self:skinDropDown(LinksList_SearchFrame_SubsectionParametersFrame_SubsectionDD)
				self:applySkin(LinksList_SearchFrame)
				LinksList_SearchFrame.skinned = true
			end
			for i = 1, select("#", LinksList_SearchFrame:GetChildren()) do
				local v = select(i, LinksList_SearchFrame:GetChildren())
				if not v.skinned then
					local objName = v:GetName()
					if string.match(objName, llsfr.."Frame") then self:skinDropDown(v)
					elseif string.match(objName, llsfr.."EditBox") then
						self:skinEditBox(v, {9})
						v:SetWidth(v:GetWidth() - 5)
						self:Hook(v, "SetHeight", function() end, true)
					end
					v.skinned = true
				end
			end
		end)
	self:Unhook(LinksList_ToggleButton, "OnClick")
	end)

end
