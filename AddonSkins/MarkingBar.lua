local aName, aObj = ...
if not aObj:isAddonEnabled("MarkingBar") then return end
local _G = _G

function aObj:MarkingBar()

	-- Icon frame
	self:addSkinFrame{obj=_G.moverLeft}
	self:addSkinFrame{obj=_G.MB_iconFrame}

	-- Control frame
	self:addSkinFrame{obj=_G.moverRight}
	self:addSkinFrame{obj=_G.MB_controlFrame}

	-- Flares frame
	self:addSkinFrame{obj=_G.MBFlares_moverLeft}
	self:addSkinFrame{obj=_G.MB_flareFrame}

end
