local aName, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

-- WeakAuras 2
function aObj:WeakAuras() -- v 2.4.17

	-- hook this to skin the WeakAuras added elements
	self:SecureHook(_G.WeakAuras, "ShowDisplayTooltip", function(this, ...)
		if _G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail
		and not _G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail.sbb
		then
			self:addButtonBorder{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail}
		end
		if _G.ItemRefTooltip.WeakAuras_Tooltip_Button
		and not _G.ItemRefTooltip.WeakAuras_Tooltip_Button.sb
		then
			self:skinButton{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Button}
		end
		if _G.ItemRefTooltip.WeakAuras_Tooltip_Button2
		and not _G.ItemRefTooltip.WeakAuras_Tooltip_Button2.sb
		then
			self:skinButton{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Button2}
		end
		if _G.ItemRefTooltip.WeakAuras_Desc_Box
		and not _G.ItemRefTooltip.WeakAuras_Desc_Box.sf
		then
			self:addSkinFrame{obj=_G.ItemRefTooltip.WeakAuras_Desc_Box}
			_G.ItemRefTooltip.WeakAuras_Desc_Box.SetBackdrop = _G.nop
		end
	end)

	-- setup defaults for Progress Bars
	_G.WeakAuras.regionTypes["aurabar"].default.texture = self.db.profile.StatusBar.texture
	_G.WeakAuras.regionTypes["aurabar"].default.barColor = {self.sbColour[1], self.sbColour[2],  self.sbColour[3], self.sbColour[4]}

end

function aObj:WeakAurasOptions()

	local optFrame = _G.WeakAuras.OptionsFrame()

	if optFrame then
		self:skinDropDown{obj=_G.WeakAuras_DropDownMenu}
		self:skinEditBox{obj=optFrame.filterInput, regs={9}, mi=true}
		local function skinBtn(id)

			local frame = aObj:getChild(optFrame, id)
			aObj:keepFontStrings(frame)
			aObj:moveObject{obj=frame, x=23, y= id ~= 2 and 1 or 0}
			if id == 1 then aObj:skinButton{obj=aObj:getChild(frame, 1), cb=true} end
			if id == 5 then aObj:skinButton{obj=aObj:getChild(frame, 1), ob3="↕"} end -- up-down arrow
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
		self:addSkinFrame{obj=optFrame, kfs=true, y1=6}
		optFrame.moversizer:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])

	end
	optFrame = nil

	-- Templates
	self:SecureHook(_G.WeakAuras, "OpenTriggerTemplate", function(this, data)
		local optFrame = _G.WeakAuras.OptionsFrame()
		self:skinButton{obj=optFrame.newView.backButton}
		self:skinButton{obj=self:getChild(optFrame.newView.frame, optFrame.newView.frame:GetNumChildren())}
		self:Unhook(this, "OpenTriggerTemplate")
	end)

end
