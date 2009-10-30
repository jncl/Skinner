
function Skinner:TinyPad()

	-- search frame
	self:skinEditBox{obj=TinyPadSearchEditBox}
	self:addSkinFrame{obj=TinyPadSearchFrame}
	-- main frame
	self:skinScrollBar{obj=TinyPadEditScrollFrame}
	self:addSkinFrame{obj=TinyPadEditFrame, y1=-5, y2=4}
	self:addSkinFrame{obj=TinyPadFrame}

end
