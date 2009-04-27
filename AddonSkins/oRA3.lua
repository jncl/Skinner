
function Skinner:oRA3()

	local function skinTab(tabNo)
	
		local tabName = _G["oRA3FrameTab"..tabNo]
		if not Skinner.skinFrame[tabName] then
			Skinner:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
			Skinner:addSkinFrame(tabName, 6, 0, -6, 2, nil, Skinner.isTT)
			local tabSF = Skinner.skinFrame[tabName]
			if tabNo == 1 then
				Skinner:moveObject(tabName, nil,nil, "+", 3)
				if Skinner.isTT then Skinner:setActiveTab(tabSF) end
			else
				if Skinner.isTT then Skinner:setInactiveTab(tabSF) end
			end
		end
		
	end
	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook(oRA3, "SelectPanel", function(this, name)
			local curTab
			curTab = oRA3Frame.selectedTab
			for i = 1, #oRA3.panels do
				local tabSF = self.skinFrame[_G["oRA3FrameTab"..i]]
				if i == curTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:keepFontStrings(oRA3Frame)
	self:addSkinFrame(oRA3Frame, 10 , 1, 1, 0)
	self.skinFrame[oRA3Frame]:SetFrameStrata("BACKGROUND")
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
	self:keepFontStrings(oRA3ScrollFrame)
	self:skinScrollBar(oRA3ScrollFrame)
	oRA3ScrollFrameBottom:SetBackdrop(nil)
	oRA3ScrollFrameTop:SetBackdrop(nil)
	
-->>-- ScrollHeaders
	local shCnt = 4
	self:skinFFColHeads("oRA3ScrollHeader", shCnt)
	self:SecureHook(oRA3, "CreateScrollHeader", function()
		shCnt = shCnt + 1
		local sh = _G["oRA3ScrollHeader"..shCnt]
		self:keepRegions(sh, {4, 5}) -- N.B 4 is text, 5 is highlight
		self:applySkin(sh)
	end)
	
-->>-- Tabs
	for i = 1, #oRA3.panels do
		skinTab(i)
	end
		
end
