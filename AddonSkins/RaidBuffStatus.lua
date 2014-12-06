local aName, aObj = ...
if not aObj:isAddonEnabled("RaidBuffStatus") then return end
local _G = _G

function aObj:RaidBuffStatus()

	self:addButtonBorder{obj=_G.RBSFrameTalentsButton, ofs=0}
	self:addButtonBorder{obj=_G.RBSFrameOptionsButton, ofs=0}
	self:addSkinFrame{obj=_G.RBSFrame}
	self:addSkinFrame{obj=_G.RBSTalentsFrame}
	self:addSkinFrame{obj=_G.RBSOptionsFrame}

end
