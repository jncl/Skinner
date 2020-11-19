local aName, aObj = ...
if not aObj:isAddonEnabled("Smoker") then return end

function aObj:Smoker()

	if self.modBtnBs then
		self:addButtonBorder{obj=Smokerbluebutton, sec=true}--, ofs=1, x1=-1, y1=1, x2=1, y2=-1}
		self:addButtonBorder{obj=Smokergreenbutton, sec=true}--, ofs=1, x1=-1, y1=1, x2=1, y2=-1}
		self:addButtonBorder{obj=Smokerpurplebutton, sec=true}--, ofs=1, x1=-1, y1=1, x2=1, y2=-1}
		self:addButtonBorder{obj=Smokerredbutton, sec=true}--, ofs=1, x1=-1, y1=1, x2=1, y2=-1}
		self:addButtonBorder{obj=Smokerwhitebutton, sec=true}--, ofs=1, x1=-1, y1=1, x2=1, y2=-1}
	end
	self:addSkinFrame{obj=Smokermainframe}

end
