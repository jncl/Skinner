local aName, aObj = ...
if not aObj:isAddonEnabled("Ludwig") then return end
local _G = _G

function aObj:Ludwig_Window()

	self:moveObject{obj=_G.LudwigFrame.search, x=-10}
	self:skinEditBox{obj=_G.LudwigFrame.search, regs={9}}
	self:skinEditBox{obj=_G.LudwigFrame.minLevel, regs={9}}
	self:skinEditBox{obj=_G.LudwigFrame.maxLevel, regs={9}}
	self:addButtonBorder{obj=self:getChild(_G.LudwigFrame, 5), x1=9, y1=-6, x2=-6, y2=10}
	self:skinScrollBar{obj=_G.LudwigFrame.scrollFrame}
	self:skinDropDown{obj=_G.LudwigFrame.quality}
	self:skinDropDown{obj=_G.LudwigFrame.category}
	self:addSkinFrame{obj=_G.LudwigFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}

end
