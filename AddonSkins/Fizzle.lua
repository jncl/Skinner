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
				if aObj:hasTextInName(reg, "FizzleB")
				then
					if child.sb then
						if reg:IsVisible() then
							child.sb:SetBackdrop(aObj.modUIBtns.iqbDrop)
							child.sb:SetBackdropBorderColor(reg:GetVertexColor())
							reg:SetTexture()
						else
							child.sb:SetBackdrop(aObj.modUIBtns.bDrop)
							child.sb:SetBackdropBorderColor(r, g, b, a)
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
