local aName, aObj = ...
if not aObj:isAddonEnabled("QuickMark") then return end
local _G = _G

function aObj:QuickMark()

	local QM = _G.LibStub("AceAddon-3.0"):GetAddon("QuickMark", true)

	if not QM then return end

	-- disable border & background color functions
	QM.Border = function() end
	QM.BackgroundColor = function() end

	-- find the QuickMark frame
	self.RegisterCallback("QuickMark", "UIParent_GetChildren", function(this, child)
		local ch, cw = self:getInt(child:GetHeight()), self:getInt(child:GetWidth())
		if (ch == 48 and cw == 195) -- horizontal
		or (ch == 260 and cw == 45) -- vertical
		then
			self:addSkinFrame{obj=child, kfs=true}
			self.UnregisterCallback("QuickMark", "UIParent_GetChildren")
		end
	end)

end
