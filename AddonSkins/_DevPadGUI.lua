local aName, aObj = ...
if not aObj:isAddonEnabled("_DevPad.GUI") then return end
local _G = _G

aObj.lodAddons["_DevPad.GUI"] = function(self) -- v 5.0.0.1

	-- List frame
	_G._DevPad.GUI.List.Background:SetTexture(nil)
	self:skinSlider{obj=_G._DevPad.GUI.List.ScrollFrame.Bar, size=3}
	self:skinEditBox{obj=_G._DevPad.GUI.List.RenameEdit, regs={6}}
	self:skinEditBox{obj=_G._DevPad.GUI.List.Search, regs={6}, mi=true}
	self:getRegion(_G._DevPad.GUI.List.Bottom, 1):SetTexture(nil)
	self:skinCloseButton{obj=_G._DevPad.GUI.List.Close}
	self:addSkinFrame{obj=_G._DevPad.GUI.List, ft="a", nb=true, ofs=1}

	-- Editor frame
	self:moveObject{obj=_G._DevPad.GUI.Editor.Run, y=-1}
	_G._DevPad.GUI.Editor.Background:SetTexture(nil)
	self:skinSlider{obj=_G._DevPad.GUI.Editor.ScrollFrame.Bar, size=3}
	_G._DevPad.GUI.Editor.LineNumbers.Gutter:SetTexture(nil)
	self:skinEditBox{obj=_G._DevPad.GUI.Editor.Edit, regs={6}}
	self:getRegion(_G._DevPad.GUI.Editor.Bottom, 1):SetTexture(nil)
	self:skinCloseButton{obj=_G._DevPad.GUI.Editor.Close}
	self:addSkinFrame{obj=_G._DevPad.GUI.Editor, ft="a", nb=true, ofs=1}

end
