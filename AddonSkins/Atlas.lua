local aName, aObj = ...
if not aObj:isAddonEnabled("Atlas") then return end
local _G = _G

function aObj:Atlas()

-->>--	AtlasFrame
	self:skinDropDown{obj=_G.AtlasFrameDropDownType}
	self:skinDropDown{obj=_G.AtlasFrameDropDown}
	self:removeRegions(_G.AtlasFrame, {1, 2, 3, 4, 5}) -- N.B. other regions are text or Map Textures
	self:skinEditBox{obj=_G.AtlasSearchEditBox, regs={9}}
	self:skinScrollBar{obj=_G.AtlasScrollBar}
	self:addSkinFrame{obj=_G.AtlasFrame, x1=12, y1=-10, x2=2}
	-- change the draw layer so the map is visible
	_G.AtlasMap:SetDrawLayer("OVERLAY")

end
