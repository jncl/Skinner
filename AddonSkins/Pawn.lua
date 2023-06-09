local _, aObj = ...
if not aObj:isAddonEnabled("Pawn") then return end
local _G = _G

aObj.addonsToSkin.Pawn = function(self) -- v 2.8.1

	-- remove button textures from behind buttons
	_G.PawnUI_InventoryPawnButton:DisableDrawLayer("BACKGROUND")
	if self.modBtnBs then
		self:addButtonBorder{obj=_G._G.PawnUI_InventoryPawnButton, ofs=0, y1=2, clr="grey"}
		self:addButtonBorder{obj=_G.PawnInterfaceOptionsFrame_PawnButton, ofs=0, y1=2, clr="grey"}
	end

	-- skin the UI
	self:moveObject{obj=_G.PawnUIFrame_TinyCloseButton, x=16, y=16}
	self:skinObject("tabs", {obj=_G.PawnUIFrame, prefix="PawnUIFrame", lod=self.isTT and true})
	self:skinObject("frame", {obj=_G.PawnUIFrame, kfs=true, y2=4})
	if self.modBtns then
		self:skinCloseButton{obj=_G.PawnUIFrame_TinyCloseButton}
	end

	-- Scales Tab
	self:keepFontStrings(_G.PawnUIScaleSelector)
	self:skinObject("slider", {obj=_G.PawnUIScaleSelectorScrollFrame.ScrollBar})
	if self.modBtns then
		self:skinStdButton{obj=_G.PawnUIFrame_RenameScaleButton, schk=true}
		self:skinStdButton{obj=_G.PawnUIFrame_DeleteScaleButton, schk=true}
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

	-- Values Tab a.k.a Weights
	self:skinObject("editbox", {obj=_G.PawnUIFrame_StatValueBox})
	self:skinObject("slider", {obj=_G.PawnUIFrame_StatsList.ScrollBar})
	self:skinObject("frame", {obj=self:getChild(_G.PawnUIValuesTabPage, 1), kfs=true, fb=true})
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
	self:skinObject("slider", {obj=_G.PawnUICompareScrollFrame.ScrollBar})
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
	self:skinObject("editbox", {obj=_G.PawnUIFrame_GemQualityLevelBox,})
	self:skinObject("slider", {obj=_G.PawnUIGemScrollFrame.ScrollBar})

	-- Options Tab
	for _, child in _G.pairs{_G.PawnUIOptionsTabPage:GetChildren()} do
		if child:IsObjectType("CheckButton")
		and self.modChkBtns
		and child.GetPushedTexture
		and child:GetPushedTexture()
		then
			self:skinCheckButton{obj=child}
		end
	end
	if self.modBtns then
		self:skinStdButton{obj=_G.PawnUIFrame_ResetUpgradesButton, clr="grey"}
	end

	-- Dialog Frames
	self:skinObject("editbox", {obj=_G.PawnUIStringDialogSingleLine.TextBox})
	self:skinObject("frame", {obj=_G.PawnUIStringDialogSingleLine, kfs=true})
	self:skinObject("frame", {obj=self:getChild(_G.PawnUIStringDialogMultiLine, 2), kfs=true})
	self:skinObject("frame", {obj=_G.PawnUIStringDialogMultiLine, kfs=true})
	if self.modBtns then
		self:skinStdButton{obj=_G.PawnUIStringDialogSingleLine.OKButton, schk=true}
		self:skinStdButton{obj=_G.PawnUIStringDialogSingleLine.CancelButton}
		self:skinStdButton{obj=_G.PawnUIStringDialogMultiLine.OKButton, schk=true}
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
	self.RegisterCallback("Pawn", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "Pawn" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("Pawn", "IOFPanel_Before_Skinning")
	end)

end
