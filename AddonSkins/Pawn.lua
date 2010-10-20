if not Skinner:isAddonEnabled("Pawn") then return end

function Skinner:Pawn()

	self:addSkinFrame{obj=PawnUIFrame}
	
-->>-- Scale Selector Frame
	self:keepFontStrings(PawnUIScaleSelector)
	self:skinScrollBar{obj=PawnUIScaleSelectorScrollFrame}
-->>-- Scales Tab
-->>-- Values Tab
	self:addSkinFrame{obj=self:getChild(PawnUIValuesTabPage, 1)}
	self:skinScrollBar{obj=PawnUIFrame_StatsList}
-->>-- Compare Tab
	self:removeRegions(PawnUICompareTabPage, {1, 11, 12, 13, 14, 15})
	self:skinScrollBar{obj=PawnUICompareScrollFrame}
-->>-- Gems Tab
	self:keepFontStrings(PawnUIGemsTabPage)
	self:skinDropDown{obj=PawnUIFrame_GemQualityDropDown}
	self:skinDropDown{obj=PawnUIFrame_MetaGemQualityDropDown}
	self:skinScrollBar{obj=PawnUIGemScrollFrame}
-->>-- Options Tab
	self:skinEditBox(PawnUIFrame_DigitsBox, {9})

-->>-- Dialog Frame
	self:skinEditBox(PawnUIStringDialog_TextBox, {9})
	self:addSkinFrame{obj=PawnUIStringDialog}
	
-->>-- Tabs
	for i = 1, PawnUIFrame.numTabs do
		local tabObj = _G["PawnUIFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[PawnUIFrame] = true
	
end
