local aName, aObj = ...
if not aObj:isAddonEnabled("_DevPad.GUI") then return end

function aObj:_DevPadGUI()

	local eFrame = _G["_DevPadGUIEditor"]
	local lFrame = _G["_DevPadGUIList"]
	
	-- List frame
	lFrame.Background:SetTexture(nil)
	self:skinSlider{obj=lFrame.ScrollFrame.Bar, size=3}
	self:skinEditBox{obj=lFrame.RenameEdit, regs={9}}
	self:skinEditBox{obj=lFrame.SearchEdit, regs={9}}
	self:getRegion(lFrame.Bottom, 1):SetTexture(nil)
	self:addSkinFrame{obj=lFrame, ofs=1}
	
	-- Editor frame
	self:getRegion(eFrame.Bottom, 1):SetTexture(nil)
	eFrame.Background:SetTexture(nil)
	self:skinSlider{obj=eFrame.ScrollFrame.Bar, size=3}
	eFrame.Margin.Gutter:SetTexture(nil)
	self:skinEditBox{obj=eFrame.Edit, regs={9}}
	self:addSkinFrame{obj=eFrame, ofs=1}

end
