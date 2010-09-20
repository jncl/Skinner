if not Skinner:isAddonEnabled("FPSideBar") then return end

function Skinner:FPSideBar()

	self:skinScrollBar{obj=FPSideBarListScrollFrame}
	self:addSkinFrame{obj=FPSideBarList}

end
