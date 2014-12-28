local aName, aObj = ...
if not aObj:isAddonEnabled("MasterPlan") then return end
local _G = _G

function aObj:MasterPlan() -- LoD

	local function skinTab()
		local tab = _G.GarrisonMissionFrameTab3
		self:keepRegions(tab, {7, 8, 9, 10})
		self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=9, y1=2, x2=-9, y2=0}
		_G.PanelTemplates_SetNumTabs(_G.GarrisonMissionFrame, 3)
		if _G.GarrisonMissionFrame.selectedTab == 3 then
			self:setActiveTab(tab.sf)
		else
			self:setInactiveTab(tab.sf)
		end
	end
	-- skin tab after short delay
	self:ScheduleTimer(skinTab, 0.2)

	-- Garrison Missions Frame - Active Missions Tab
	local activeUI = self:getChild(_G.GarrisonMissionFrameMissions, 4)
	local availUI = self:getChild(_G.GarrisonMissionFrameMissions, 5)
	local sf = self:getChild(_G.GarrisonMissionFrameMissions, 6) -- scroll frame
	local sc = sf:GetScrollChild()
	local bar = self:getChild(sf, 1)
	self:skinSlider{obj=bar, adj=-4}

	local function skinMissionButtons()
		local kids = {sc:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child:IsObjectType("Button") then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("BORDER")
				-- self:getChild(child, 1):DisableDrawLayer("OVERLAY") -- shadow background, don't remove this
				-- re-align the top & bottom highlight
				local t = self:getRegion(child, 12)
				t:ClearAllPoints()
				t:SetPoint("topleft", 0, 4)
				t:SetPoint("topright", 0, 4)
				t = self:getRegion(child, 13)
				t:ClearAllPoints()
				t:SetPoint("bottomleft", 0, -4)
				t:SetPoint("bottomright", 0, -4)
				self:removeRegions(child, {14, 15, 16, 17, 23}) -- highlight corners & rare indicator
				if child.followers then -- Active mission button has these
					for i = 1, #child.followers do
						child.followers[i].ring:SetTexture(nil)
					end
				end
				if child.groups then -- Available mission button has these
					for i = 1, #child.groups do
						child.groups[i]:DisableDrawLayer("BACKGROUND")
					end
				end
				for i = 1, #child.rewards do
					self:addButtonBorder{obj=child.rewards[i], reParent={child.rewards[i].quantity}}
				end
			end
		end
		kids = _G.null
	end
	-- hook this to skin new buttons
	self:SecureHookScript(bar, "OnValueChanged", function(this, ...)
		skinMissionButtons()
	end)
	-- skin any existing buttons, first time displayed
	skinMissionButtons()

	-- ActiveUI lootframe
	self:addSkinFrame{obj=activeUI.lootFrame, kfs=true}
	local lootContainer = self:getChild(activeUI.lootFrame, 2)
	local function skinLootContainer()
		for i = 1, #lootContainer.items do
			lootContainer.items[i].Border:SetTexture(nil)
			self:addButtonBorder{obj=lootContainer.items[i], relTo=lootContainer.items[i].Icon, ofs=3}
		end
		for i = 1, #lootContainer.followers do
			lootContainer.followers[i].PortraitRing:SetTexture(nil)
			lootContainer.followers[i].LevelBorder:SetAlpha(0) -- texture changed
			lootContainer.followers[i].PortraitRingCover:SetTexture(nil)
		end
	end
	-- skin any existing followers & items
	skinLootContainer()
	-- hook this to skin new followers & items
	self:SecureHook(activeUI.lootFrame, "Show", function(this)
		skinLootContainer()
	end)

	-- Garrison Missions Frame - Available Missions Tab
	local sortIndicator = self:getChild(availUI, 1)
	self:removeRegions(sortIndicator, {1}) -- background
	local roamingParty = self:getChild(availUI, 2)
	for i = 1, 3 do
		local btn = self:getChild(roamingParty, i)
		self:removeRegions(btn, {2}) -- portrait ring
	end

	-- Garrison Missions Frame - Available Missions Tab - Mission Page
	-- Get Suggested Groups button
	local lfgButton = self:getChild(_G.GarrisonMissionFrame.MissionTab.MissionPage.Stage, 2)
	self:removeRegions(lfgButton, {2}) -- ring texture
	-- minimize button
	self:skinButton{obj=_G.GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton, ob="-"}

end
