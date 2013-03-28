local aName, aObj = ...
if not aObj:isAddonEnabled("QuickMark") then return end

function aObj:QuickMark()

	local QuickMark = LibStub("AceAddon-3.0"):GetAddon("QuickMark", true)

	-- disable border & background color functions
	QuickMark.Border = function() end
	QuickMark.BackgroundColor = function() end

	-- find the QuickMark frame
	local qmFrame = self:findFrame2(UIParent, "Frame", 48, 195) -- horizontal
	if not qmFrame then
		qmFrame = self:findFrame2(UIParent, "Frame", 260, 45) -- vertical
	end

	if qmFrame then
		self:addSkinFrame{obj=qmFrame}
	end

end
