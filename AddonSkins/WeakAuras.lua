local aName, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end

function aObj:WeakAuras()

	-- hook this to skin the Tooltip Description frame
	self:SecureHook(WeakAuras, "ShowDisplayTooltip", function(this, ...)
		self:addSkinFrame{obj=ItemRefTooltip.WeakAuras_Desc_Box}
		self:Unhook(WeakAuras, "ShowDisplayTooltip")
	end)

	-- setup defaults for Progress Bars
	WeakAuras.regionTypes["aurabar"].default.texture = self.db.profile.StatusBar.texture
	WeakAuras.regionTypes["aurabar"].default.barColor = CopyTable(self.sbColour)
	
end

function aObj:WeakAurasOptions()

	local frame = WeakAuras.OptionsFrame() 
	if frame then
		self:skinDropDown{obj=WeakAuras_DropDownMenu}
		self:skinEditBox{obj=frame.filterInput, regs={9}, mi=true}
		self:keepFontStrings(self:getChild(frame, 1)) -- close button frame
		self:keepFontStrings(self:getChild(frame, 4)) -- minimize button frame
		local _, _, _, enabled, loadable = GetAddOnInfo("WeakAurasTutorials")
    	if enabled
		and loadable
		then
			self:keepFontStrings(self:getChild(frame, 5)) -- tutorial button frame
		end
		self:addSkinFrame{obj=frame, kfs=true, y1=6}
		frame.moversizer:SetBackdropBorderColor(unpack(self.bbColour))
	end

end
