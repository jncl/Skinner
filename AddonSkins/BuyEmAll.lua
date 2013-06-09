local aName, aObj = ...
if not aObj:isAddonEnabled("BuyEmAll") then return end
local _G = _G

function aObj:BuyEmAll()

	self:addSkinFrame{obj=_G.BuyEmAllFrame, kfs=true, ofs=-6}

end
