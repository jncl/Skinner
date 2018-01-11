local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["MSA-DropDownMenu-1.0"] = function(self) -- v 2
	if self.initialized["MSA-DropDownMenu"] then return end
	self.initialized["MSA-DropDownMenu"] = true

	_G.MSA_DropDownList1Backdrop:SetBackdrop(nil)
	_G.MSA_DropDownList1MenuBackdrop:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.MSA_DropDownList1, ft="a", nb=true}
	_G.MSA_DropDownList2Backdrop:SetBackdrop(nil)
	_G.MSA_DropDownList2MenuBackdrop:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.MSA_DropDownList2, ft="a", nb=true}

end
