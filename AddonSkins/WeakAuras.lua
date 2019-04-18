local aName, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

aObj.addonsToSkin.WeakAuras = function(self) -- v 2.12.0-beta6

	-- hook this to skin the WeakAuras added elements
	local s1, s2, s3, s4
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
	_G.WeakAuras.regionTypes["aurabar"].default.texture = self.sbTexture
	_G.WeakAuras.regionTypes["aurabar"].default.barColor = _G.CopyTable(self.sbClr)

end

aObj.lodAddons.WeakAurasOptions = function(self) -- v 2.12.0-beta6

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
		self:skinEditBox{obj=optFrame.filterInput, regs={6}, mi=true}
		-- make filter input box higher
	    optFrame.filterInput:SetPoint("TOPLEFT", optFrame.buttonsContainer.frame, "TOPLEFT", 6, 8)

		if self.modBtns then
			local function skinBtn(id)

				local frame = aObj:getChild(optFrame, id)
				aObj:keepFontStrings(frame)
				aObj:moveObject{obj=frame, x=23, y= id ~= 2 and 1 or 0}
				if id == 1 then aObj:skinCloseButton{obj=aObj:getChild(frame, 1)} end
				if id == 2 then aObj:skinCheckButton{obj=aObj:getChild(frame, 1)} end
				if id == 6 then aObj:skinOtherButton{obj=aObj:getChild(frame, 1), font=self.fontS, text="↕"} end -- up-down arrow
				frame = nil

			end
			skinBtn(1) -- close button frame
			skinBtn(2) -- import button frame
			skinBtn(6) -- minimize button frame
			self:skinStdButton{obj=self:getLastChild(optFrame.importexport.frame)} -- close/done button
		end
		local _, _, _, enabled, loadable = _G.GetAddOnInfo("WeakAurasTutorials")
    	if enabled
		and loadable
		then
			self:keepFontStrings(self:getChild(optFrame, 5)) -- tutorial button frame
		end
		enabled, loadable = nil, nil
		self:addSkinFrame{obj=optFrame, ft="a", kfs=true, nb=true, ofs=0, y1=6}
		optFrame.moversizer:SetBackdropBorderColor(self.bbClr:GetRGB())

	end
	optFrame = nil

	-- Templates
	if self.modBtns then
		self:SecureHook(_G.WeakAuras, "OpenTriggerTemplate", function(data)
			self:skinStdButton{obj=_G.WeakAuras.OptionsFrame().newView.backButton}
			self:skinStdButton{obj=self:getLastChild(_G.WeakAuras.OptionsFrame().newView.frame)}
			self:Unhook(this, "OpenTriggerTemplate")
		end)
	end

end
