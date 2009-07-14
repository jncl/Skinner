
function Skinner:Hack()

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(Hack, "SetMode",function(this, ...)
			for i = 1, HackListFrame.numTabs do
				local tabSF = self.skinFrame[_G["HackListFrameTab"..i]]
				if i == HackListFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:addSkinFrame{obj=HackListFrame, kfs=true, x2=1}
	self:skinEditBox{obj=HackSearchEdit, regs={9}, noHeight=true, noWidth=true}	
	HackSearchEdit:SetHeight(18)
	self:skinScrollBar{obj=HackListScrollFrame}
	for i = 1, HackListFrame.numTabs do
		local tabName = _G["HackListFrameTab"..i]
		if i == 1 then self:moveObject{obj=tabName, y=4} end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
	self:addSkinFrame{obj=HackEditFrame, kfs=true}

end
