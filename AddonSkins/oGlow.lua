local aName, aObj = ...
if not aObj:isAddonEnabled("oGlow") then return end

function aObj:oGlow()
	if not aObj.modBtnBs then
		self.oGlow = nil
		return
	end

	local r, g, b, a = unpack(self.bbColour)
	local function btnUpd(obj, oGB)
		oGB = oGB or obj
		if obj.sbb then
			if oGB.oGlowBorder
			and oGB.oGlowBorder:IsVisible()
			then
				obj.sbb:SetBackdrop(aObj.modUIBtns.iqbDrop)
				obj.sbb:SetBackdropBorderColor(oGB.oGlowBorder:GetVertexColor())
				oGB.oGlowBorder:SetTexture()
			else
				obj.sbb:SetBackdrop(aObj.modUIBtns.bDrop)
				obj.sbb:SetBackdropBorderColor(r, g, b, a)
			end
		end
	end

	local delays = {
		["inspect"]     = 0.2, -- LoD
		["gbank"]       = 0.5, -- LoD
		["tradeskill"]  = 0.2, -- LoD
	}
	-- hook this function to update the buttons
	self:SecureHook(oGlow, "CallFilters", function(this, pipe, frame, ...)
		aObj:ScheduleTimer(btnUpd, delays[pipe] or 0.1, frame)
	end)

	-- remove delays when UI is skinned
	self:RegisterMessage("InspectUI_Skinned", function() delays["inspect"] = nil end)
	self:RegisterMessage("GuildBankUI_Skinned", function() delays["gbank"] = nil end)

end
