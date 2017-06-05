local aName, aObj = ...
if not aObj:isAddonEnabled("DejaCharacterStats") then return end
local _G = _G

function aObj:DejaCharacterStats()

	self:addButtonBorder{obj=_G.PaperDollFrame.ExpandButton, ofs=-2}

	self:skinSlider{obj=_G.CharacterFrameInsetRightScrollBar, size=3}

	self:skinButton{obj=_G.DCS_TableRelevantStats}
	self:skinButton{obj=_G.DCS_TableResetButton}

end
