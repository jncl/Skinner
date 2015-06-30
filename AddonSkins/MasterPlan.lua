local aName, aObj = ...
if not aObj:isAddonEnabled("MasterPlan") then return end
local _G = _G

function aObj:MasterPlan() -- LoD

	-- find frames
	self.RegisterCallback("MasterPlan", "UIParent_GetChildren", function(this, child)
			-- activeUI waste popup frame
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and self:getInt(child:GetWidth()) == 260
		and self:getInt(child:GetHeight()) == 68
		then
			self:addSkinFrame{obj=child}
		end
	end)
	self:scanUIParentsChildren()

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
	-- local interestUI = self:getChild(missionList, mlc - 1)
	local sf = self:getChild(missionList, mlc) -- scroll frame
	local sc = sf:GetScrollChild()
	local bar = self:getChild(sf, 1)

	self:skinButton{obj=activeUI.CompleteAll}
	self:skinSlider{obj=bar, adj=-4}
	-- options frame in TLHC
	self:removeRegions(missionList.ctlContainer, {1, 2, 3})

	local function skinMissionButtons()
		local kids = {sc:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child:IsObjectType("Button") then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("BORDER")
				-- aObj:getChild(child, 1):DisableDrawLayer("OVERLAY") -- shadow background, don't remove this as it identifies missions that are unable to be selected
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
						aObj:getChild(grandchild, i).ring:SetTexture(nil)
					end
				end
				grandchild = nil
			end
		end
		kids = nil
	end
	-- hook this to skin new buttons
	self:SecureHookScript(bar, "OnValueChanged", function(this, ...)
		skinMissionButtons()
	end)
	-- skin any existing buttons, first time displayed
	skinMissionButtons()

	-- ActiveUI lootframe
	self:addSkinFrame{obj=activeUI.lootFrame, kfs=true, y1=-3, x2=-1}
	local function skinLootContainer(lootContainer)
		for i = 1, #lootContainer.items do
			lootContainer.items[i].Border:SetTexture(nil)
			aObj:addButtonBorder{obj=lootContainer.items[i], relTo=lootContainer.items[i].Icon, ofs=3}
		end
		for i = 1, #lootContainer.followers do
			lootContainer.followers[i].PortraitRing:SetTexture(nil)
			lootContainer.followers[i].LevelBorder:SetTexture(nil)
			lootContainer.followers[i].PortraitRingCover:SetTexture(nil)
		end
	end
	-- skin any existing followers & items
	skinLootContainer(self:getChild(activeUI.lootFrame, 3))
	-- hook this to skin new followers & items
	self:SecureHook(activeUI.lootFrame, "Show", function(this)
		skinLootContainer(self:getChild(this, 3))
	end)

	-- Garrison Missions Frame - Available Missions Tab
	self:removeRegions(self:getChild(self:getChild(availUI, 1), 1), {2}) -- follower focus portrait ring
	-- Clear Tentative Parties button, has to be done this way otherwise button skin isn't shown
	self:SecureHook(availUI.SendTentative, "SetShown", function(this)
		self:skinButton{obj=this}
		self:Unhook(availUI.SendTentative, "SetShown")
	end)

	-- Garrison Missions Frame - Available Missions Tab - Mission Page
	-- Get Suggested Groups button
	self:removeRegions(self:getChild(_G.GarrisonMissionFrame.MissionTab.MissionPage.Stage, 2), {2}) -- ring texture
	-- minimize button
	self:skinButton{obj=_G.GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton, ob="-"}

	-- SpecAffinityFrame (on FollowerTab frames)
	self:SecureHook("GarrisonMissionFrame_SetFollowerPortrait", function(pf, ...)
		if not pf == _G.GarrisonMissionFrame.FollowerTab.PortraitFrame
		and not pf == _G.GarrisonLandingPage.FollowerTab.PortraitFrame
		then
			return
		end
		local obj = pf:GetParent()
		local frame = self:getChild(obj, obj:GetNumChildren())
		if frame:GetNumChildren() == 2 then
			self:addButtonBorder{obj=frame.Affinity}
			self:addButtonBorder{obj=frame.ClassSpec}
			self:Unhook("GarrisonMissionFrame_SetFollowerPortrait")
		end
		obj, frame = nil, nil
	end)

	-- Follower Items Container
	self:addButtonBorder{obj=_G.MPFollowerItemContainer.weapon, es=12, x1=36}
	self:addButtonBorder{obj=_G.MPFollowerItemContainer.armor, es=12, x2=-36}

	-- Follower Summary
	_G.GarrisonMissionFrame.SummaryTab:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=_G.GarrisonMissionFrame.SummaryTab.matrix}
	self:addSkinFrame{obj=_G.GarrisonMissionFrame.SummaryTab.affin}
	self:addSkinFrame{obj=_G.GarrisonMissionFrame.SummaryTab.stats}

	-- Can't access UpgradesFrame to remove item name texture, as it is local to the Addon and can't be accessed externally

end
