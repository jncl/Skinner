local aName, aObj = ...
if not aObj:isAddonEnabled("FlyoutButtonCustom") then return end
local _G = _G

aObj.addonsToSkin.FlyoutButtonCustom = function(self) -- v 2.85

	-- turn off borders and keep them off
	_G.FbcShowBorders = nil
	_G.FlyoutButtonCustom_Settings = _G.FlyoutButtonCustom_Settings or {}
	_G.FlyoutButtonCustom_Settings["ShowBorders"] = false
	local mt = {__newindex = function(t, k, v)
		if k == "ShowBorders" then
			_G.FbcShowBorders = nil
			_G.rawset(t, k, false)
			return
		else
			_G.rawset(t, k, v)
		end
	end}
	_G.setmetatable(_G.FlyoutButtonCustom_Settings, mt)

	-- Settings frame
	_G.C_Timer.After(0.5, function()
		 self:addSkinFrame{obj=_G.FBCSettingsDialog, ft="a", kfs=true, nb=true, y1=2, x2=2}
		 if self.modBtns then
			 self:skinStdButton{obj=_G.FBCSettingsDialogDone}
			 self:skinCloseButton{obj=_G.FBCSettingsDialog.Toggle}
		 end
		 for _, child in _G.ipairs{_G.FBCSettingsDialog:GetChildren()} do
			 aObj:Debug("FBCSettingsDialog: [%s, %s]", child, child:GetObjectType())
		 	if child:IsObjectType("CheckButton")
			and self.modChkBtns
			then
				self:skinCheckButton{obj=child}
			elseif child:IsObjectType("Slider") then
				self:skinSlider{obj=child, hgt=-2}
			end
		 end
	end)

	-- MacroText_CustomizeFrame
	_G.C_Timer.After(0.5, function()
		self:moveObject{obj=self:getRegion(_G.MacroText_CustomizeFrame, 2), y=-6}
	end)
	self:skinSlider{obj=_G.MacroText_CustomizeFrame.ScrollMacro.ScrollBar}
	self:skinEditBox{obj=_G.MacroText_CustomizeFrame.ScrollMacro.EditBoxMacro, regs={6}} -- 6 is text
	_G.MacroText_CustomizeFrame.spellIcon:DisableDrawLayer("BACKGROUND")
	self:skinEditBox{obj=_G.MacroText_CustomizeFrame.EditBoxIcon, regs={6}} -- 6 is text
	self:skinSlider{obj=_G.MacroText_CustomizeFrame.ScrollTooltip.ScrollBar}
	self:skinEditBox{obj=_G.MacroText_CustomizeFrame.ScrollTooltip.EditBoxTooltip, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.MacroText_CustomizeFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinCloseButton{obj=_G.MacroText_CustomizeFrame.Toggle}
		self:skinStdButton{obj=_G.MacroText_CustomizeFrame.OK}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MacroText_CustomizeFrame.spellIcon, relTo=_G.MacroText_CustomizeFrameSpellIconIcon}
	end

end
