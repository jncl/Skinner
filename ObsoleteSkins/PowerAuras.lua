local aName, aObj = ...
if not aObj:isAddonEnabled("PowerAuras") then return end
local _G = _G

function aObj:PowerAuras()

-->>-- Config Frame
	self.iofDD["PowaDropDownDefaultTimer"] = -90
	self.iofDD["PowaDropDownDefaultStacks"] = -110
	self:moveObject{obj=_G.PowaOptionsHeader, y=-9}
	self:addSkinFrame{obj=_G.PowaOptionsPlayerListFrame}
	self:addSkinFrame{obj=_G.PowaOptionsGlobalListFrame, y1=2}
	self:addSkinFrame{obj=_G.PowaOptionsSelectorFrame, y2=-4}
	self:skinEditBox{obj=_G.PowaOptionsRenameEditBox, regs={9}}
	self:addSkinFrame{obj=_G.PowaOptionsFrame, kfs=true, bgen=0, ofs=-8}
	self:moveObject{obj=_G.PowaOptionsFrameCloseButton, x=5, y=5}
	self:addSkinFrame{obj=_G.PowaOptionsFrame, kfs=true}

	-- top Panel
	self:skinDropDown{obj=_G.PowaGradientStyleDropDown}
	self:skinDropDown{obj=_G.PowaModelCategoryDropDown}
	self:skinDropDown{obj=_G.PowaModelTextureDropDown}
	self:skinDropDown{obj=_G.PowaStrataDropDown}
	self:skinDropDown{obj=_G.PowaTextureStrataDropDown}
	self:skinDropDown{obj=_G.PowaBlendModeDropDown}
	self:skinEditBox{obj=_G.PowaBarCustomTexName, regs={9}}
	self:skinEditBox{obj=_G.PowaBarCustomModelsEditBox, regs={9}}
	self:skinEditBox{obj=_G.PowaBarAurasText, regs={9}}
	self:addSkinFrame{obj=_G.PowaBarConfigFrameEditor, ofs=2}
	-- Activation Panel
	self:skinDropDown{obj=_G.PowaDropDownBuffType}
	self:skinDropDown{obj=_G.PowaDropDownPowerType}
	self:skinDropDown{obj=_G.PowaDropDownStance}
	self:skinDropDown{obj=_G.PowaDropDownGTFO}
	self:skinEditBox{obj=_G.PowaBarBuffStacks, regs={9}}
	self:skinEditBox{obj=_G.PowaBarBuffName, regs={9, 10}}
	self:skinEditBox{obj=_G.PowaBarMultiID, regs={9, 10}, y=6}
	self:skinEditBox{obj=_G.PowaBarTooltipCheck, regs={9, 10}, y=10}
	self:skinEditBox{obj=_G.PowaBarUnitn, regs={9, 10}, y=10}
	self:moveObject{obj=_G.PowaInverseButton, y=6}
	self:addSkinFrame{obj=_G.PowaBarConfigFrameEditor1, ofs=2}
	-- Animation Panel
	self:skinDropDown{obj=_G.PowaDropDownAnimBegin}
	self:skinDropDown{obj=_G.PowaDropDownAnimEnd}
	self:skinDropDown{obj=_G.PowaDropDownAnim1}
	self:skinDropDown{obj=_G.PowaDropDownAnim2}
	self:skinDropDown{obj=_G.PowaSecondaryBlendModeDropDown}
	self:skinDropDown{obj=_G.PowaSecondaryStrataDropDown}
	self:skinDropDown{obj=_G.PowaSecondaryTextureStrataDropDown}
	self:addSkinFrame{obj=_G.PowaBarConfigFrameEditor2, ofs=2}
	-- Sound Panel
	self:skinDropDown{obj=_G.PowaDropDownSound}
	self:skinDropDown{obj=_G.PowaDropDownSound2}
	self:skinEditBox{obj=_G.PowaBarCustomSound, regs={9, 10}, x=-4}
	self:skinDropDown{obj=_G.PowaDropDownSoundEnd}
	self:skinDropDown{obj=_G.PowaDropDownSound2End}
	self:skinEditBox{obj=_G.PowaBarCustomSoundEnd, regs={9, 10}, x=-4}
	self:addSkinFrame{obj=_G.PowaBarConfigFrameEditor3, ofs=2}
	-- Timer Panel
	self:skinDropDown{obj=_G.PowaDropDownTimerTexture}
	self:skinDropDown{obj=_G.PowaBuffTimerRelative}
	self:addSkinFrame{obj=_G.PowaBarConfigFrameEditor4, ofs=2}
	-- Stacks Panel
	self:skinDropDown{obj=_G.PowaDropDownStacksTexture}
	self:skinDropDown{obj=_G.PowaBuffStacksRelative}
	self:addSkinFrame{obj=_G.PowaBarConfigFrameEditor5, ofs=2}

	-- Export Dialog
	self:skinEditBox{obj=_G.PowaAuraExportDialogCopyBox, regs={9}}
	self:skinEditBox{obj=_G.PowaAuraExportDialogSendBox, regs={9}}
	self:addSkinFrame{obj=_G.PowaAuraExportDialog}

end

function aObj:PowerAurasButtons()

	-- skin Module Manager frame
	self:addSkinFrame{obj=_G.PowerAurasButtons_ModuleScrollFrame:GetParent()}

end
