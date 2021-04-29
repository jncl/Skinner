local aName, aObj = ...
if not aObj:isAddonEnabled("DressUp") then return end
local _G = _G

function aObj:DressUp()

	self:skinDropDown{obj=_G.DressUpRaceDropdown}
	-- click button to change height or dropdown, then close the Menu
	_G.DressUpRaceDropdown_OnClick()
	_G.CloseMenus()

	self:skinDropDown{obj=_G.CustomDressUpFrame.OutfitDropDown, y2=-4}
	-- This is used by the OutfitDropDown
	self:addSkinFrame{obj=_G.WardrobeOutfitFrame, ft="p", nb=true}

	self:addButtonBorder{obj=_G.DressUpPreviewWhisperButton, ofs=-3, x1=1}
	self:addButtonBorder{obj=_G.DressupSettingsButton, ofs=-3, x1=1}
	self:addSkinFrame{obj=_G.CustomDressUpFrame, kfs=true, ofs=2, x2=1, ri=true}

	-- N.B. NOT skinning button borders

end
