local _, aObj = ...
if not aObj:isAddonEnabled("CoolDownWatcher") then return end
local _G = _G

aObj.addonsToSkin.CoolDownWatcher = function(self) -- v 1.5

	_G.cdw_MainFrame:DisableDrawLayer("BACKGROUND")
	_G.cdw_MainFrame:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=_G.cdw_MainFrame, ft="a", kfs=true, x2=1.5}

end
