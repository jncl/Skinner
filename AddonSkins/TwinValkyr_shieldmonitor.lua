
function Skinner:TwinValkyr_shieldmonitor()

	self:addSkinFrame{obj=TWcolishieldmini}
	-- Options frame
	self:addSkinFrame{obj=TwinValmenu, x=5, y1=-5, x2=-5, y2=4}
	self:skinButton{obj=TwinValmenu_Button1, x1=-1, y1=0, x2=1, y2=1}
	self:skinButton{obj=TwinValmenu_Button2}
	self:skinButton{obj=TwinValmenu_Button3}
	self:skinEditBox{obj=TwinValmenu_width1}
	self:moveObject{obj=TwinValmenu_width1, y=10}
	self:skinEditBox{obj=TwinValmenu_heigh1}
	self:moveObject{obj=TwinValmenu_heigh1, y=10}
	
end
