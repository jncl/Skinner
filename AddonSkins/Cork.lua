local aName, aObj = ...
if not aObj:isAddonEnabled("Cork") then return end
local _G = _G

function aObj:Cork()

	-- skin the anchor
	self.RegisterCallback("Cork", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Button")
		and self:getInt(child:GetHeight()) == 24
		then
			self:addSkinFrame{obj=child, kfs=true, x1=-2}
			self.UnregisterCallback("Cork", "UIParent_GetChildren")
		end
	end)

	-- tooltip
	-- this is required for WoD, not sure why it has changed but skinned tooltip no longer gets hidden automatically
	local rtTmr
	local function skinTooltip(obj)
		aObj:applySkin(obj)
		if not rtTmr then
			rtTmr = aObj:ScheduleRepeatingTimer(function(ttip)
				if ttip:NumLines() == 0 then
					ttip:Hide()
					aObj:CancelTimer(rtTmr, true)
					rtTmr = nil
				end
			end, obj.updateTooltip, obj)
		end

	end
	self:SecureHook(_G.Corkboard, "Show", function(this)
		skinTooltip(this)
	end)
	if _G.Corkboard then
		skinTooltip(_G.Corkboard)
	end

end
