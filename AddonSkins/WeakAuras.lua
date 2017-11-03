local aName, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

aObj.addonsToSkin.WeakAuras = function(self) -- v 2.4.25

	-- hook this to skin the WeakAuras added elements
	local s1, s2, s3, s4 = nil, nil, nil, nil
	self:SecureHook(_G.WeakAuras, "ShowDisplayTooltip", function(this, ...)
		if _G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail
		and not s1
		then
			self:addButtonBorder{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail}
			s1 = true
		end
		if _G.ItemRefTooltip.WeakAuras_Tooltip_Button
		and not s2
		then
			self:skinStdButton{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Button}
			s2 = true
		end
		if _G.ItemRefTooltip.WeakAuras_Tooltip_Button2
		and not s3
		then
			self:skinStdButton{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Button2}
			s3 = true
		end
		if _G.ItemRefTooltip.WeakAuras_Desc_Box
		and not s4
		then
			self:addSkinFrame{obj=_G.ItemRefTooltip.WeakAuras_Desc_Box, ft="a", nb=true}
			_G.ItemRefTooltip.WeakAuras_Desc_Box.SetBackdrop = _G.nop
			s4 = true
		end
		if s1 and s2 and s3 and s4 then
			self:Unhook(this, "ShowDisplayTooltip")
		end
	end)

	-- setup defaults for Progress Bars
	_G.WeakAuras.regionTypes["aurabar"].default.texture = self.db.profile.StatusBar.texture
	_G.WeakAuras.regionTypes["aurabar"].default.barColor = {self.sbColour[1], self.sbColour[2],  self.sbColour[3], self.sbColour[4]}

end

aObj.lodAddons.WeakAurasOptions = function(self) -- v 2.4.25

	-- wait until frame is created
	if not _G.WeakAuras.OptionsFrame() then
		_G.C_Timer.After(0.1, function()
			aObj.lodAddons.WeakAurasOptions(self)
		end)
		return
	end

	local optFrame = _G.WeakAuras.OptionsFrame()
	if optFrame then
		self:skinDropDown{obj=_G.WeakAuras_DropDownMenu}
		self:skinEditBox{obj=optFrame.filterInput, regs={9}, mi=true}
		local function skinBtn(id)

			local frame = aObj:getChild(optFrame, id)
			aObj:keepFontStrings(frame)
			aObj:moveObject{obj=frame, x=23, y= id ~= 2 and 1 or 0}
			if id == 1 then aObj:skinCloseButton{obj=aObj:getChild(frame, 1)} end
			if id == 2 then aObj:skinCheckButton{obj=aObj:getChild(frame, 1)} end
			if id == 5 then aObj:skinOtherButton{obj=aObj:getChild(frame, 1), font=self.fontS, text="↕"} end -- up-down arrow
			frame = nil

		end
		skinBtn(1) -- close button frame
		skinBtn(2) -- import button frame
		skinBtn(5) -- minimize button frame
		local _, _, _, enabled, loadable = _G.GetAddOnInfo("WeakAurasTutorials")
    	if enabled
		and loadable
		then
			self:keepFontStrings(self:getChild(optFrame, 5)) -- tutorial button frame
		end
		self:addSkinFrame{obj=optFrame, ft="a", nb=true, kfs=true, y1=6}
		optFrame.moversizer:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])

	end
	optFrame = nil

	-- Templates
	self:SecureHook(_G.WeakAuras, "OpenTriggerTemplate", function(this, data)
		local optFrame = _G.WeakAuras.OptionsFrame()
		self:skinStdButton{obj=optFrame.newView.backButton}
		self:skinStdButton{obj=self:getChild(optFrame.newView.frame, optFrame.newView.frame:GetNumChildren())}
		self:Unhook(this, "OpenTriggerTemplate")
	end)

end
