local aName, aObj = ...
if not aObj:isAddonEnabled("MasterPlan") then return end
local _G = _G

function aObj:MasterPlan() -- LoD

	local function skinTab(tab, id)
		aObj:rmRegionsTex(tab, {1, 2, 3 ,4 ,5 ,6})
		aObj:addSkinFrame{obj=tab, noBdr=self.isTT, x1=9, y1=2, x2=-9, y2=0}
		if _G.GarrisonMissionFrame.selectedTab == id then
			aObj:setActiveTab(tab.sf)
		else
			aObj:setInactiveTab(tab.sf)
		end
	end
	-- skin extra tabs
	skinTab(_G.GarrisonMissionFrameTab3, 3)
	skinTab(_G.GarrisonMissionFrameTab4, 4)
	_G.PanelTemplates_SetNumTabs(_G.GarrisonMissionFrame, 4)

	-- Garrison Missions Frame - Active Missions Tab
	local missionList = _G.MasterPlanMissionList
	local mlc = missionList:GetNumChildren()
	local activeUI = self:getChild(missionList, mlc - 3)
	local availUI = self:getChild(missionList, mlc - 2)
	local interestUI = self:getChild(missionList, mlc - 1)
	local sf = self:getChild(missionList, mlc) -- scroll frame
	local sc = sf:GetScrollChild()
	local bar = self:getChild(sf, 1)
	self:skinButton{obj=activeUI.CompleteAll}
	self:skinSlider{obj=bar, adj=-4}

	local function skinMissionButtons()
		local kids = {sc:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child:IsObjectType("Button") then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("BORDER")
				-- aObj:getChild(child, 1):DisableDrawLayer("OVERLAY") -- shadow background, don't remove this as it identifies missions that are unable to be slected
				-- re-align the top & bottom highlight
				local t = aObj:getRegion(child, 12)
				t:ClearAllPoints()
				t:SetPoint("topleft", 0, 4)
				t:SetPoint("topright", 0, 4)
				t = aObj:getRegion(child, 13)
				t:ClearAllPoints()
				t:SetPoint("bottomleft", 0, -4)
				t:SetPoint("bottomright", 0, -4)
				aObj:removeRegions(child, {14, 15, 16, 17, 23}) -- highlight corners & rare indicator
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
					aObj:addButtonBorder{obj=child.rewards[i], reParent={child.rewards[i].quantity}}
				end
				 -- Missions of interest have these unused follower buttons
				local grandchild = aObj:getChild(child, child:GetNumChildren())
				if grandchild:IsObjectType("Button")
				and grandchild:GetNumChildren() == 21
				then
					for i = 1, grandchild:GetNumChildren() do
						grandchild[i].ring:SetTexture(nil)
					end
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
			aObj:addButtonBorder{obj=lootContainer.items[i], relTo=lootContainer.items[i].Icon, ofs=3}
		end
		for i = 1, #lootContainer.followers do
			lootContainer.followers[i].PortraitRing:SetTexture(nil)
			lootContainer.followers[i].LevelBorder:SetTexture(nil)
			-- lootContainer.followers[i].LevelBorder:SetAlpha(0) -- texture changed
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
	self:removeRegions(self:getChild(availUI, 1), {1}) -- sort indicator background
	local roamingParty = self:getChild(availUI, 2)
	for i = 1, 3 do
		local btn = self:getChild(roamingParty, i)
		self:removeRegions(btn, {2}) -- portrait ring
	end

	-- Garrison Missions Frame - Available Missions Tab - Mission Page
	-- Get Suggested Groups button
	self:removeRegions(self:getChild(_G.GarrisonMissionFrame.MissionTab.MissionPage.Stage, 2), {2}) -- ring texture
	-- minimize button
	self:skinButton{obj=_G.GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton, ob="-"}

end
