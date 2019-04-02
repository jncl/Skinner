local aName, aObj = ...
if not aObj:isAddonEnabled("Fizzle") then return end
local _G = _G

aObj.addonsToSkin.Fizzle = function(self) -- v 80000-1

	if not self.modBtnBs then
		self.addonsToSkin.Fizzle = nil
		return
	end

	local function charUpd()
		for _, child in _G.ipairs{_G.PaperDollItemsFrame:GetChildren()} do
			for _, reg in _G.pairs{child:GetRegions()} do
				if aObj:hasTextInName(reg, "FizzleB")
				then
					if child.sbb then
						if reg:IsVisible() then
							child.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
							child.sbb:SetBackdropBorderColor(reg:GetVertexColor())
							reg:SetTexture()
						else
							child.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
							child.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
						end
					end
					break
				end
			end
		end
	end
	self:SecureHook(_G.CharacterFrame, "Show", function(this)
		_G.C_Timer.After(0.1, function() charUpd() end)
		self:RegisterEvent("UNIT_INVENTORY_CHANGED", function() _G.C_Timer.After(0.1, function() charUpd() end) end)
	end)
	self:SecureHook(_G.CharacterFrame, "Hide", function(this)
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
	end)

end
