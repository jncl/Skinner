local aName, aObj = ...
if not aObj:isAddonEnabled("Pawn") then return end
local _G = _G

aObj.addonsToSkin.Pawn = function(self) -- v 2.2.14a

	-- remove button textures from behind buttons
	self:addButtonBorder{obj=_G.PawnInterfaceOptionsFrame_PawnButton, ofs=0, y1=2}
	_G.PawnUI_InventoryPawnButton:DisableDrawLayer("BACKGROUND")

	-- skin the UI
	self:moveObject{obj=_G.PawnUIFrame_TinyCloseButton, x=16, y=16}
	self:skinCloseButton{obj=_G.PawnUIFrame_TinyCloseButton}
	self:addSkinFrame{obj=_G.PawnUIFrame, ft="a", nb=true}
	self:skinTabs{obj=_G.PawnUIFrame, lod=true, x1=6, y1=0, x2=-6, y2=2}

	self:keepFontStrings(_G.PawnUIScaleSelector)
	self:skinSlider{obj=_G.PawnUIScaleSelectorScrollFrame.ScrollBar}

	-- Scales Tab
	if self.modBtnBs then
		self:skinStdButton{obj=_G.PawnUIFrame_RenameScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_DeleteScaleButton}
		self:addButtonBorder{obj=_G.PawnUIFrame_ScaleColorSwatch, ofs=-4}
		self:skinCheckButton{obj=_G.PawnUIFrame_ShowScaleCheck}
		self:skinStdButton{obj=_G.PawnUIFrame_ImportScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_ExportScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_CopyScaleButton}
		self:skinStdButton{obj=_G.PawnUIFrame_NewScaleFromDefaultsButton}
		self:skinStdButton{obj=_G.PawnUIFrame_NewScaleButton}
	end

	-- Values Tab
	self:skinEditBox{obj=_G.PawnUIFrame_StatValueBox, regs={9}}
	self:skinStdButton{obj=_G.PawnUIFrame_ClearValueButton}
	self:skinCheckButton{obj=_G.PawnUIFrame_IgnoreStatCheck}
	self:skinCheckButton{obj=_G.PawnUIFrame_NoUpgradesCheck}
	self:skinCheckButton{obj=_G.PawnUIFrame_FollowSpecializationCheck}
	self:skinCheckButton{obj=_G.PawnUIFrame_NormalizeValuesCheck}
	self:addSkinFrame{obj=self:getChild(_G.PawnUIValuesTabPage, 1), ft="a", nb=true}
	self:skinSlider{obj=_G.PawnUIFrame_StatsList.ScrollBar}

	-- Compare Tab
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.PawnUICompareItemIcon1}
		self:addButtonBorder{obj=_G.PawnUICompareItemIcon2}
		self:addButtonBorder{obj=_G.PawnUIFrame_ClearItemsButton}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut1}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut2}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut3}
		self:addButtonBorder{obj=_G.PawnUICompareItemShortcut4}
	end
	self:skinSlider{obj=_G.PawnUICompareScrollFrame.ScrollBar}

	-- Gems Tab
	self:keepFontStrings(_G.PawnUIGemsTabPage)
	self:skinEditBox{obj=_G.PawnUIFrame_GemQualityLevelBox, regs={9}}
	self:skinSlider{obj=_G.PawnUIGemScrollFrame.ScrollBar}

	-- Options Tab
	for _, child in _G.pairs{_G.PawnUIOptionsTabPage:GetChildren()} do
		if child:IsObjectType("CheckButton") then
			self:skinCheckButton{obj=child}
		elseif child:IsObjectType("Button") then
			self:skinStdButton{obj=child}
		end
	end

	-- Dialog Frame
	self:skinEditBox(_G.PawnUIStringDialog_TextBox, {9})
	self:skinStdButton{obj=_G.PawnUIStringDialog_OKButton}
	self:skinStdButton{obj=_G.PawnUIStringDialog_CancelButton}
	self:addSkinFrame{obj=_G.PawnUIStringDialog, ft="a", nb=true}

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
