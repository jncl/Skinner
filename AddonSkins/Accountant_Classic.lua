local aName, aObj = ...
if not aObj:isAddonEnabled("Accountant_Classic") then return end
local _G = _G

aObj.addonsToSkin.Accountant_Classic = function(self) -- v

	self:skinDropDown{obj=_G.AccountantClassicFrameServerDropDown}
	self:skinDropDown{obj=_G.AccountantClassicFrameFactionDropDown}
	self:skinDropDown{obj=_G.AccountantClassicFrameCharacterDropDown}
	self:skinStdButton{obj=_G.AccountantClassicFrameResetButton}
	self:skinStdButton{obj=_G.AccountantClassicFrameOptionsButton}
	self:skinStdButton{obj=_G.AccountantClassicFrameExitButton}
	self:skinTabs{obj=_G.AccountantClassicFrame}
	self:addSkinFrame{obj=_G.AccountantClassicFrame, ft="a", kfs=true, y1=-15, y2=5}

end
