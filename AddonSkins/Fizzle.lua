local aName, aObj = ...
if not aObj:isAddonEnabled("Fizzle") then return end

function aObj:Fizzle()
	if not self.modBtnBs then
		self.Fizzle = nil
		return
	end

	local r, g, b, a = unpack(self.bbColour)
	local function charUpd()
		for _, child in ipairs{PaperDollItemsFrame:GetChildren()} do
			for _, reg in pairs{child:GetRegions()} do
				if reg:GetName()
				and reg:GetName():find("FizzleB")
				then
					if child.sknrBdr then
						if reg:IsVisible() then
							child.sknrBdr:SetBackdrop(aObj.modUIBtns.iqbDrop)
							child.sknrBdr:SetBackdropBorderColor(reg:GetVertexColor())
							reg:SetTexture()
						else
							child.sknrBdr:SetBackdrop(aObj.modUIBtns.bDrop)
							child.sknrBdr:SetBackdropBorderColor(r, g, b, a)
						end
					end
					break
				end
			end
		end
	end
	local evtRef
	self:SecureHook(CharacterFrame, "Show", function(this)
		self:ScheduleTimer(charUpd, 0.1)
		evtRef = self:RegisterEvent("UNIT_INVENTORY_CHANGED", function() self:ScheduleTimer(charUpd, 0.1) end)
	end)
	self:SecureHook(CharacterFrame, "Hide", function(this)
		self:UnregisterEvent("UNIT_INVENTORY_CHANGED", evtRef)
	end)

end
