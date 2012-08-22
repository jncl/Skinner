local aName, aObj = ...
if not aObj:isAddonEnabled("Pawn") then return end

function aObj:Pawn()

	self:addSkinFrame{obj=PawnUIFrame}

	if self.modBtnBs then
		self:addButtonBorder{obj=PawnUI_InventoryPawnButton, es=12, ofs=0, y1=2}
	end

-->>-- Scale Selector Frame
	self:keepFontStrings(PawnUIScaleSelector)
	self:skinScrollBar{obj=PawnUIScaleSelectorScrollFrame}
-->>-- Scales Tab
	if self.modBtnBs then
		self:addButtonBorder{obj=PawnUIFrame_ScaleColorSwatch, ofs=-4}
	end
-->>-- Values Tab
	self:skinEditBox{obj=PawnUIFrame_StatValueBox, regs={9}}
	self:addSkinFrame{obj=self:getChild(PawnUIValuesTabPage, 1)}
	self:skinScrollBar{obj=PawnUIFrame_StatsList}
-->>-- Compare Tab
	if self.modBtnBs then
		self:addButtonBorder{obj=PawnUICompareItemIcon1}
		self:addButtonBorder{obj=PawnUICompareItemIcon2}
		self:addButtonBorder{obj=PawnUIFrame_ClearItemsButton}
		self:addButtonBorder{obj=PawnUICompareItemShortcut1}
		self:addButtonBorder{obj=PawnUICompareItemShortcut2}
		self:addButtonBorder{obj=PawnUICompareItemShortcut3}
		self:addButtonBorder{obj=PawnUICompareItemShortcut4}
	end
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
	self:skinTabs{obj=PawnUIFrame, lod=true, x1=6, y1=0, x2=-6, y2=2}

-->>-- Tooltips
	PawnCommon.ColorTooltipBorder = false -- disable tooltip border color change
	if self.db.profile.Tooltips.skin then
		self:SecureHook("PawnUI_OnSocketUpdate", function()
			if self.db.profile.Tooltips.style == 3 then PawnSocketingTooltip:SetBackdrop(self.Backdrop[1]) end
			self:SecureHookScript(PawnSocketingTooltip, "OnShow", function(this)
				self:skinTooltip(this)
			end)
			self:Unhook("PawnUI_OnSocketUpdate")
		end)
		self:SecureHook("PawnUI_OnReforgingUpdate", function()
			if self.db.profile.Tooltips.style == 3 then PawnReforgingTooltip:SetBackdrop(self.Backdrop[1]) end
			self:SecureHookScript(PawnReforgingTooltip, "OnShow", function(this)
				self:skinTooltip(this)
			end)
			self:Unhook("PawnUI_OnReforgingUpdate")
		end)
	end

end
