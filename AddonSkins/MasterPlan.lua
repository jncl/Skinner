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
	local sf = self:getChild(_G.GarrisonMissionFrameMissions, 5) -- scroll frame
	self:skinSlider{obj=self:getChild(sf, 1), adj=-4}
	local sc = sf:GetScrollChild()

	local function skinMissionButtons()
		local kids = {sc:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child:IsObjectType("Button") then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("OVERLAY") -- shadow background
				child:DisableDrawLayer("BORDER")
				self:removeRegions(child, {16, 17, 18, 19}) -- highlight corners
				for i = 1, 3 do
					child.followers[i].ring:SetTexture(nil)
				end
				for i = 1, #child.rewards do
					self:addButtonBorder{obj=child.rewards[i], reParent={child.rewards[i].quantity}}
				end
			end
		end
		kids = _G.null
	end
	-- hook activeUI SetShown to skin buttons
	self:SecureHook(activeUI, "SetShown", function(this, action)
		if action then
			self:ScheduleTimer(skinMissionButtons, 0.2, nil) -- wait for buttons to be created
		end
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
	local sortIndicator = self:getChild(_G.GarrisonMissionFrameMissions, 6)
	self:removeRegions(sortIndicator, {1}) -- background
	local roamingParty = self:getChild(_G.GarrisonMissionFrameMissions, 7)
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
