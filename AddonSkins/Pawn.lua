local aName, aObj = ...
if not aObj:isAddonEnabled("Pawn") then return end
local _G = _G

aObj.addonsToSkin.Pawn = function(self) -- v 2.3.16

	-- remove button textures from behind buttons
	_G.PawnUI_InventoryPawnButton:DisableDrawLayer("BACKGROUND")
	if self.modBtnBs then
		self:addButtonBorder{obj=_G._G.PawnUI_InventoryPawnButton, ofs=0, y1=2, clr="grey"}
		self:addButtonBorder{obj=_G.PawnInterfaceOptionsFrame_PawnButton, ofs=0, y1=2, clr="grey"}
	end

	-- skin the UI
	self:skinTabs{obj=_G.PawnUIFrame, lod=true, x1=6, y1=0, x2=-6, y2=2}
	self:moveObject{obj=_G.PawnUIFrame_TinyCloseButton, x=16, y=16}
	self:addSkinFrame{obj=_G.PawnUIFrame, ft="a", kfs=true, nb=true, ofs=0, y2=1}
	if self.modBtns then
		self:skinCloseButton{obj=_G.PawnUIFrame_TinyCloseButton}
	end

	-- Scales Tab
	self:keepFontStrings(_G.PawnUIScaleSelector)
	self:skinSlider{obj=_G.PawnUIScaleSelectorScrollFrame.ScrollBar}
	if self.modBtns then
		self:skinStdButton{obj=_G.PawnUIFrame_RenameScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_DeleteScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_ImportScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_ExportScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_CopyScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_NewScaleFromDefaultsButton}
		self:skinStdButton{obj=_G.PawnUIFrame_NewScaleButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.PawnUIFrame_ScaleColorSwatch, ofs=-4}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.PawnUIFrame_ShowScaleCheck}
	end

	-- Values Tab
	self:skinEditBox{obj=_G.PawnUIFrame_StatValueBox, regs={9}}
	self:skinSlider{obj=_G.PawnUIFrame_StatsList.ScrollBar}
	self:addSkinFrame{obj=self:getChild(_G.PawnUIValuesTabPage, 1), ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.PawnUIFrame_ClearValueButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.PawnUIFrame_IgnoreStatCheck}
		self:skinCheckButton{obj=_G.PawnUIFrame_NoUpgradesCheck}
		self:skinCheckButton{obj=_G.PawnUIFrame_FollowSpecializationCheck}
		self:skinCheckButton{obj=_G.PawnUIFrame_NormalizeValuesCheck}
	end

	-- Compare Tab
	self:skinSlider{obj=_G.PawnUICompareScrollFrame.ScrollBar}
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.PawnUICompareItemIcon1}
		self:addButtonBorder{obj=_G.PawnUICompareItemIcon2}
		self:addButtonBorder{obj=_G.PawnUIFrame_ClearItemsButton}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut1}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut2}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut3}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut4}
	end

	-- Gems Tab
	self:keepFontStrings(_G.PawnUIGemsTabPage)
	self:skinEditBox{obj=_G.PawnUIFrame_GemQualityLevelBox, regs={9}}
	self:skinSlider{obj=_G.PawnUIGemScrollFrame.ScrollBar}

	-- Options Tab
	for _, child in _G.pairs{_G.PawnUIOptionsTabPage:GetChildren()} do
		if child:IsObjectType("CheckButton")
		and self.modChkBtns
		then
			self:skinCheckButton{obj=child}
		elseif child:IsObjectType("Button")
		and self.modBtns
		then
			self:skinStdButton{obj=child}
		end
	end

	-- Dialog Frames
	self:skinEditBox{obj=_G.PawnUIStringDialogSingleLine.TextBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.PawnUIStringDialogSingleLine, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=self:getChild(_G.PawnUIStringDialogMultiLine, 2), ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.PawnUIStringDialogMultiLine, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.PawnUIStringDialogSingleLine.OKButton}
		self:skinStdButton{obj=_G.PawnUIStringDialogSingleLine.CancelButton}
		self:skinStdButton{obj=_G.PawnUIStringDialogMultiLine.OKButton}
		self:skinStdButton{obj=_G.PawnUIStringDialogMultiLine.CancelButton}
	end

	-- Tooltips
	_G.PawnCommon.ColorTooltipBorder = false -- disable tooltip border color change
	if self.db.profile.Tooltips.skin then
		self:SecureHook("PawnUI_OnSocketUpdate", function()
			if _G.PawnSocketingTooltip then
				self:add2Table(self.ttList, _G.PawnSocketingTooltip)
				self:Unhook("PawnUI_OnSocketUpdate")
			end
		end)
	end

	-- register callback to indicate already skinned
	self.RegisterCallback("Pawn", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Pawn" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("Pawn", "IOFPanel_Before_Skinning")
	end)

end
