
function Skinner:oRA3()

	local ver = tonumber(string.match(GetAddOnMetadata("oRA3", "X-Curse-Packaged-Version"), "%d+"))
--	self:Debug("oRA3 ver: [%s]", ver)

	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook(oRA3, "SelectPanel", function(this, name)
			self:Debug("SP: [%s, %s, %s]", this, name, oRA3Frame.selectedTab)
			for i = 1, oRA3Frame.numTabs do
				local tabSF = self.skinFrame[_G["oRA3FrameTab"..i]]
				if i == oRA3Frame.selectedTab
				or ver < 326 and _G["oRA3FrameTab"..i].tabName == name
				then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
			-- move tabs left if in raid group
			local xOfs = select(4, oRA3FrameTab1:GetPoint())
--rl			self:Debug("oRA3_SelectPanel: [%s, %s, %s]", xOfs, oRA3.groupStatus, xOfs == 0 and oRA3.groupStatus and oRA3.groupStatus == oRA3.INRAID and -26 or 0)
			self:moveObject{obj=oRA3FrameTab1, x=xOfs == 0 and oRA3.groupStatus and oRA3.groupStatus == oRA3.INRAID and -26 or 0}
		end)
	end

	local function skinFrame()

		self:skinAllButtons{obj=oRA3Frame}
		self:addSkinFrame{obj=oRA3Frame, kfs=true, x1=10 , y1=1, x2=1, y2=-3}

		local subFrame = oRA3FrameSub or oRA3Disband:GetParent()

		if not oRA3.db.profile.open then oRA3Frame.title:SetAlpha(0) end
		-- show the title when opened
		self:SecureHook(subFrame, "Show", function()
			oRA3Frame.title:SetAlpha(1)
		end)
		-- hide the title when closed
		self:SecureHook(subFrame, "Hide", function()
			oRA3Frame.title:SetAlpha(0)
		end)

	-->>-- SubFrame
		subFrame:SetBackdrop(nil)
		self:skinScrollBar{obj=oRA3ScrollFrame}
		self:getChild(oRA3ScrollFrameBottom, 1):SetAlpha(0)
		self:getChild(oRA3ScrollFrameTop, 1):SetAlpha(0)

	-->>-- ScrollHeaders
		self:SecureHook(oRA3, "CreateScrollEntry", function(this, header)
			if not self.skinFrame[header] and header:GetName() then -- used by Tanks module as well
				self:removeRegions(header, {1, 2, 3})
				self:addSkinFrame{obj=header}
			end
		end)
		if ver < 326 then
			self:skinFFColHeads("oRA3ScrollHeader", 4)
		end

	-->>-- Tabs
		for i = 1, oRA3Frame.numTabs do
			local tabObj = _G["oRA3FrameTab"..i]
			self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=6, x2=-6, y2=2}
			local tabSF = self.skinFrame[tabObj]
			if i == 1 then
				self:moveObject{obj=tabObj, y=2}
				if self.isTT then self:setActiveTab(tabSF) end
			else
				if self.isTT then self:setInactiveTab(tabSF) end
			end
		end

	end
	if oRA3Frame then skinFrame()
	else
		self:SecureHook(oRA3, "SetupGUI", function(this)
			skinFrame()
			self:Unhook(oRA3, "SetupGUI")
		end)
	end

-->>-- ReadyCheck Frame
	local function skinRCFrame()

		self:skinAllButtons{obj=oRA3ReadyCheck}
		self:addSkinFrame{obj=oRA3ReadyCheck, kfs=true, y1=-1}

	end
	if oRA3ReadyCheck then skinRCFrame()
	else
		local method = ver < 313 and "SetupGUI" or "READY_CHECK"
		self:SecureHook(oRA3:GetModule("ReadyCheck"), method, function(this, ...)
			if oRA3.db:GetNamespace("ReadyCheck", true).profile.gui then skinRCFrame() end
			self:Unhook(oRA3:GetModule("ReadyCheck"), method)
		end)
	end

end
