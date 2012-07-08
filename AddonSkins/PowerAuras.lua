local aName, aObj = ...
if not aObj:isAddonEnabled("PowerAuras") then return end

function aObj:PowerAuras()

	self:moveObject{obj=PowaOptionsHeader, y=-9}
	self:addSkinFrame{obj=PowaOptionsPlayerListFrame, nb=true}
	self:skinButton{obj=PowaOptionsRename}
	self:addSkinFrame{obj=PowaOptionsGlobalListFrame, nb=true, y1=2}
	self:addSkinFrame{obj=PowaOptionsSelectorFrame, y2=-4}
	self:skinEditBox{obj=PowaOptionsRenameEditBox, regs={9}}
	self:addSkinFrame{obj=PowaOptionsFrame, kfs=true, bgen=0, ofs=-8}
-->>-- Config Frame
	self:moveObject{obj=PowaCloseButton, x=5, y=5}
	self:addSkinFrame{obj=PowaBarConfigFrame, kfs=true}
	-- top Panel
	self:skinEditBox{obj=PowaBarAuraTextureEdit, regs={9}}
	self:skinEditBox{obj=PowaBarAuraCoordXEdit, regs={9}}
	self:skinEditBox{obj=PowaBarAuraCoordYEdit, regs={9}}
	self:addSkinFrame{obj=PowaBarConfigFrameEditor, ofs=2}
	-- Activation Panel
	self:skinDropDown{obj=PowaDropDownBuffType}
	self:skinEditBox{obj=PowaBarBuffStacks, regs={9}}
	self:skinEditBox{obj=PowaBarBuffName, regs={9, 10}}
	self:skinEditBox{obj=PowaBarMultiID, regs={9, 10}, y=6}
	self:skinEditBox{obj=PowaBarTooltipCheck, regs={9, 10}, y=10}
	self:moveObject{obj=PowaInverseButton, y=6}
	self:addSkinFrame{obj=PowaBarConfigFrameEditor2, ofs=2}
	-- Animation Panel
	self:skinDropDown{obj=PowaDropDownAnimBegin, x2=10}
	self:skinDropDown{obj=PowaDropDownAnimEnd, x2=10}
	self:skinDropDown{obj=PowaDropDownAnim1, x2=10}
	self:skinDropDown{obj=PowaDropDownAnim2, x2=10}
	self:addSkinFrame{obj=PowaBarConfigFrameEditor3, ofs=2}
	-- Sound Panel
	self:skinDropDown{obj=PowaDropDownSound, x2=34}
	self:skinDropDown{obj=PowaDropDownSound2, x2=34}
	self:skinEditBox{obj=PowaBarCustomSound, regs={9, 10}, x=-4}
	self:skinDropDown{obj=PowaDropDownSoundEnd, x2=34}
	self:skinDropDown{obj=PowaDropDownSound2End, x2=34}
	self:skinEditBox{obj=PowaBarCustomSoundEnd, regs={9, 10}, x=-4}
	self:addSkinFrame{obj=PowaBarConfigFrameEditor5, ofs=2}
	-- Timer Panel
	self:skinDropDown{obj=PowaDropDownTimerTexture, x2=-10}
	self:skinDropDown{obj=PowaBuffTimerRelative, x2=-10}
	self:addSkinFrame{obj=PowaBarConfigFrameEditor4, ofs=2}
	-- Stacks Panel
	self:skinDropDown{obj=PowaDropDownStacksTexture, x2=-10}
	self:skinDropDown{obj=PowaBuffStacksRelative, x2=-10}
	self:addSkinFrame{obj=PowaBarConfigFrameEditor6, ofs=2}

end

function aObj:PowerAurasButtons()

	-- skin Module Manager frame
	self:addSkinFrame{obj=PowerAurasButtons_ModuleScrollFrame:GetParent()}

end
