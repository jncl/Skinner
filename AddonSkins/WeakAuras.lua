local aName, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

function aObj:WeakAuras()

	-- hook this to skin the Tooltip Description frame
	self:SecureHook(_G.WeakAuras, "ShowDisplayTooltip", function(this, ...)
		self:addSkinFrame{obj=_G.ItemRefTooltip.WeakAuras_Desc_Box}
		self:Unhook(_G.WeakAuras, "ShowDisplayTooltip")
	end)

	-- setup defaults for Progress Bars
	_G.WeakAuras.regionTypes["aurabar"].default.texture = self.db.profile.StatusBar.texture
	_G.WeakAuras.regionTypes["aurabar"].default.barColor = {self.sbColour[1], self.sbColour[2],  self.sbColour[3], self.sbColour[4]}

end

function aObj:WeakAurasOptions()

	local optFrame, btn = _G.WeakAuras.OptionsFrame()
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

end
