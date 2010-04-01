if not Skinner:isAddonEnabled("Prat-3.0") then return end

function Skinner:Prat30() -- concatenation of Prat-3.0

	local eb = LibStub("AceAddon-3.0"):GetAddon("Prat"):GetModule("Editbox", true)
	if eb then eb.frame:Hide() end
	
	if PratCCFrame then
		self:skinScrollBar{obj=PratCCFrameScroll}
		self:skinButton{obj=PratCCFrameButton}
		self:addSkinFrame{obj=PratCCFrame}
	end
	
end
