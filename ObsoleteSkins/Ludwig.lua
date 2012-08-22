local aName, aObj = ...
if not aObj:isAddonEnabled("Ludwig") then return end

function aObj:Ludwig_Window()

	self:moveObject{obj=LudwigFrame.search, x=-10}
	self:skinEditBox{obj=LudwigFrame.search, regs={9}}
	self:skinEditBox{obj=LudwigFrame.minLevel, regs={9}}
	self:skinEditBox{obj=LudwigFrame.maxLevel, regs={9}}
	self:skinScrollBar{obj=LudwigFrame.scrollFrame}
	self:skinDropDown{obj=LudwigFrame.quality}
	self:skinDropDown{obj=LudwigFrame.category}
	self:addSkinFrame{obj=LudwigFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}

end
