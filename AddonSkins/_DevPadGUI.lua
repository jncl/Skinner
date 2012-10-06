local aName, aObj = ...
if not aObj:isAddonEnabled("_DevPad.GUI") then return end

function aObj:_DevPadGUI()

	-- List frame
	_DevPad.GUI.List.Background:SetTexture(nil)
	self:skinSlider{obj=_DevPad.GUI.List.ScrollFrame.Bar, size=3}
	self:skinEditBox{obj=_DevPad.GUI.List.RenameEdit, regs={9}}
	self:skinEditBox{obj=_DevPad.GUI.List.Search, regs={9}, mi=true}
	self:getRegion(_DevPad.GUI.List.Bottom, 1):SetTexture(nil)
	self:addSkinFrame{obj=_DevPad.GUI.List, ofs=1, nb=true}
	self:skinButton{obj=_DevPad.GUI.List.Close, cb=true}
	
	-- Editor frame
	self:moveObject{obj=_DevPad.GUI.Editor.Run, y=-1}
	_DevPad.GUI.Editor.Background:SetTexture(nil)
	self:skinSlider{obj=_DevPad.GUI.Editor.ScrollFrame.Bar, size=3}
	_DevPad.GUI.Editor.LineNumbers.Gutter:SetTexture(nil)
	self:skinEditBox{obj=_DevPad.GUI.Editor.Edit, regs={9}}
	self:getRegion(_DevPad.GUI.Editor.Bottom, 1):SetTexture(nil)
	self:addSkinFrame{obj=_DevPad.GUI.Editor, ofs=1, nb=true}
	self:skinButton{obj=_DevPad.GUI.Editor.Close, cb=true}

end
