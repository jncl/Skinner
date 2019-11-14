local aName, aObj = ...
if not aObj:isAddonEnabled("buffOmat") then return end
local _G = _G

aObj.addonsToSkin.buffOmat = function(self) -- v 0.96

	self:skinTabs{obj=_G.BuffOmat_MainWindow, ignore=true, lod=true}
	self:skinSlider{obj=_G.BuffOmat_SpellTab_Scroll.ScrollBar}
	self:addSkinFrame{obj=_G.BuffOmat_MainWindow, ft="a", kfs=true, nb=true, y2=-3}
	if self.modBtns then
		self:skinStdButton{obj=_G.BuffOmat_MainWindow_CloseButton}
		self:skinStdButton{obj=_G.BuffOmat_MainWindow_SettingsButton}
		self:skinStdButton{obj=_G.BuffOmat_MainWindow_MacroButton}
		self:skinStdButton{obj=_G.BuffOmat_ListTab_Button, seca=true}
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.BuffOmat_Tooltip)
	end)

	-- minimap button
	self.mmButs["buffOmat"] = _G.BUFFOMAT_ADDON.MinimapButton.button

end
