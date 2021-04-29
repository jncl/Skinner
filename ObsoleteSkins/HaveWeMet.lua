local aName, aObj = ...
if not aObj:isAddonEnabled("HaveWeMet") then return end

function aObj:HaveWeMet()

	self:moveObject{obj=HWM_FriendButt, x=-60, y=-9}
	
	-- Browse Frame
	self:skinEditBox{obj=HWM_Browse_Frame_FindTxt, regs={9}}
	self:addSkinFrame{obj=HWM_Browse_Frame, x1=10, y1=-12, x2=-20, y2=80}
	
	-- Rate frame
	self:skinEditBox{obj=HWM_Rate_note, regs={9}}
	self:addSkinFrame{obj=HWM_Rate, nb=true, y1=-6, x2=-12, y2=10}
	self:skinButton{obj=HWM_Rate_OK}
	self:skinButton{obj=HWM_Rate_Cancel}
	
	-- Session Frame
	self:skinScrollBar{obj=HWM_Session_Frame_scroll}
	self:addSkinFrame{obj=HWM_Session_Frame, kfs=true, x1=10, y1=-10, x2=-30, y2=71}

end