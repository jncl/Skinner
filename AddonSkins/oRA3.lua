
function Skinner:oRA3()

	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook(oRA3, "SelectPanel", function(this, name)
			for i = 1, #oRA3.panels do
				local tabSF = self.skinFrame[_G["oRA3FrameTab"..i]]
				if i == oRA3Frame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
			local xOfs = select(4, oRA3FrameTab1:GetPoint())
			self:Debug("oRA3_SelectPanel: [%s]", xOfs)
			self:moveObject{obj=oRA3FrameTab1, x=(xOfs == 0 and oRA3.groupStatus == oRA3.INRAID) and -26 or 0}
		end)
	end

	self:skinAllButtons{obj=oRA3Frame}
	self:addSkinFrame{obj=oRA3Frame, kfs=true, x1=10 , y1=1, x2=1, y2=-3}

	if not oRA3.db.profile.open then oRA3Frame.title:SetAlpha(0) end
	-- show the title when opened
	self:SecureHook(oRA3FrameSub, "Show", function()
		oRA3Frame.title:SetAlpha(1)
	end)
	-- hide the title when closed
	self:SecureHook(oRA3FrameSub, "Hide", function()
		oRA3Frame.title:SetAlpha(0)
	end)

-->>-- SubFrame
	oRA3FrameSub:SetBackdrop(nil)
	oRA3ScrollFrameBottom:SetBackdrop(nil)
	oRA3ScrollFrameTop:SetBackdrop(nil)
	self:skinScrollBar{obj=oRA3ScrollFrame}
	oRA3ScrollFrameBottom.bar:SetAlpha(0)
	oRA3ScrollFrameTop.bar:SetAlpha(0)

-->>-- ScrollHeaders
	local shCnt = 4
	self:skinFFColHeads("oRA3ScrollHeader", shCnt)
	self:SecureHook(oRA3, "CreateScrollHeader", function()
		shCnt = shCnt + 1
		local sh = _G["oRA3ScrollHeader"..shCnt]
		self:removeRegions(sh, {1, 2, 3})
		self:addSkinFrame{obj=sh}
	end)

-->>-- Tabs
	for i = 1, #oRA3.panels do
		local tabName = _G["oRA3FrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			self:moveObject{obj=tabName, y=2}
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

-->>-- ReadyCheck Frame
	if oRA3ReadyCheck then
		self:skinAllButtons{obj=oRA3ReadyCheck}
		self:addSkinFrame{obj=oRA3ReadyCheck, kfs=true, y1=-1}
	else
		self:SecureHook(LibStub("AceAddon-3.0"):GetAddon("oRA3"):GetModule("ReadyCheck"), "SetupGUI", function()
			self:skinAllButtons{obj=oRA3ReadyCheck}
			self:addSkinFrame{obj=oRA3ReadyCheck, kfs=true, y1=-1}
			self:Unhook(LibStub("AceAddon-3.0"):GetAddon("oRA3"):GetModule("ReadyCheck"), "SetupGUI")
		end)
	end

end
