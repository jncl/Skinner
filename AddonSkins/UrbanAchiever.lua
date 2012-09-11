local aName, aObj = ...
if not aObj:isAddonEnabled("UrbanAchiever") then return end

function aObj:UrbanAchiever()
	if not self.db.profile.AchievementUI then return end
	
	-- bugfix to handle Initialize not called by Addon if it is the last addon loaded
	if not UrbanAchiever.frame and UrbanAchiever.Initialize then
		UrbanAchiever:Initialize()
	end

	local function skinStatusBar(sBaro, orig)

		local sBar = sBaro:GetName()
		if sBaro.text then aObj:moveObject{obj=sBaro.text, y=1} end
		if sBaro.name then aObj:moveObject{obj=sBaro.name, y=1} end
		if orig then
			_G[sBar.."BorderLeft"]:SetAlpha(0)
			_G[sBar.."BorderRight"]:SetAlpha(0)
			_G[sBar.."BorderCenter"]:SetAlpha(0)
		else
			_G[sBar.."Left"]:SetAlpha(0)
			_G[sBar.."Right"]:SetAlpha(0)
			_G[sBar.."Middle"]:SetAlpha(0)
		end
		self:glazeStatusBar(sBaro, 0, orig and _G[sBar.."BG"] or _G[sBar.."BG"])

	end
	
	local this = UrbanAchiever
	local uaFrame = this.frame
	uaFrame.close:SetPoint("TOPRIGHT", uaFrame, "TOPRIGHT")
	self:skinButton{obj=uaFrame.close, cb=true}
	local uaPS = UrbanAchieverFramePointShield
	uaPS:SetAlpha(1)
	uaPS:SetPoint("TOP", uaFrame, "TOP", 60, -5)
	this.pointsText:SetPoint("LEFT", uaPS, "RIGHT", 5, 2)
	this.compPointsText:SetPoint("TOPRIGHT", uaFrame, "TOP", -67, -5)
	self:skinEditBox{obj=self:getChild(uaFrame.editbox, 1), regs={9}}
	skinStatusBar(uaFrame.summaryBar)
	skinStatusBar(uaFrame.comparisonSummaryBar)
	skinStatusBar(categoryStatusBar92)
	skinStatusBar(categoryStatusBar95)
	skinStatusBar(categoryStatusBar96)
	skinStatusBar(categoryStatusBar97)
	skinStatusBar(categoryStatusBar155)
	skinStatusBar(categoryStatusBar168)
	skinStatusBar(categoryStatusBar169)
	skinStatusBar(categoryStatusBar201)
	skinStatusBar(categoryStatusBar15077)
	skinStatusBar(categoryStatusBar15078)
	skinStatusBar(categoryStatusBar15079)
	skinStatusBar(categoryStatusBar15080)
	skinStatusBar(categoryStatusBar15088)
	skinStatusBar(categoryStatusBar15117)
	skinStatusBar(categoryStatusBar15165)
	self:skinSlider{obj=uaFrame.catScroll}
	self:skinSlider{obj=uaFrame.achScroll}
	-- Category frame
	self:moveObject{obj=uaFrame.category, x=-10}
	self:addSkinFrame{obj=uaFrame.category}
	self:addSkinFrame{obj=uaFrame, kfs=true}

-->>-- Category Buttons
	local btn
	for i = 1, #uaFrame.catButtons do
		btn = uaFrame.catButtons[i]
		self:getRegion(btn, 3):SetAlpha(1) -- highlight texture
		self:applySkin{obj=btn, kfs=true, bd=7}
	end
	--	Achievement Sort Buttons
	for _, v in pairs{"name", "points", "completed", "comparison"} do
		uaFrame.achSort[v]:GetNormalTexture():SetAlpha(0)
	end
	--	Achievement Buttons
	for i = 1, #uaFrame.achButtons do
		btn = uaFrame.achButtons[i]
		btn.background:SetAlpha(0)
		btn.comparison.background:SetAlpha(0)
	end
-->>-- Achievement Display Frame
	skinStatusBar(uaFrame.display.bar, true)
	skinStatusBar(uaFrame.display.compareBar, true)
	self:skinSlider{obj=uaFrame.criteriaScroll}

-->>-- Tabs
	for i = 1, #uaFrame.tabButtons do
		local tabObj = uaFrame.tabButtons[i]
		tabObj.backdrop:SetAlpha(0)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			tabObj.ignore = true -- don't resize
			if i == 1 then
				self:setActiveTab(tabObj)
			else
				self:setInactiveTab(tabObj)
			end
		else
			self:applySkin(tabObj)
		end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook(this, "RefreshCategoryButtons", function(this)
			for i = 1, #uaFrame.tabButtons do
				if this.currentTab == "achievements" then
					self:setActiveTab(uaFrame.tabButtons[1])
					self:setInactiveTab(uaFrame.tabButtons[2])
					self:setInactiveTab(uaFrame.tabButtons[3])
				elseif this.currentTab == "guild" then
					self:setActiveTab(uaFrame.tabButtons[3])
					self:setInactiveTab(uaFrame.tabButtons[1])
					self:setInactiveTab(uaFrame.tabButtons[2])
				else
					self:setActiveTab(uaFrame.tabButtons[2])
					self:setInactiveTab(uaFrame.tabButtons[1])
					self:setInactiveTab(uaFrame.tabButtons[3])
				end
			end
		end)
	end

end
