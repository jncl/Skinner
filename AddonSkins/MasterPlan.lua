local aName, aObj = ...
if not aObj:isAddonEnabled("MasterPlan") then return end
local _G = _G

aObj.lodAddons.MasterPlan = function(self) -- v 0.109.1

	local function skinTab(tab, id, frame, x1, y1, x2 ,y2)

		local x1, y1, x2, y2  = x1 or 9, y1 or 2, x2 or -9, y2 or 0
		aObj:rmRegionsTex(tab, {1, 2, 3 ,4 ,5 ,6})
		aObj:addSkinFrame{obj=tab, ft="a", nb=true, noBdr=aObj.isTT, x1=x1, y1=y1, x2=x2, y2=y2}
		if aObj.isTT then
			if frame.selectedTab == id then
				aObj:setActiveTab(tab.sf)
			else
				aObj:setInactiveTab(tab.sf)
			end
		end

	end
	-- skin extra tabs
	skinTab(_G.GarrisonMissionFrameTab3, 3, _G.GarrisonMissionFrame)
	skinTab(_G.GarrisonMissionFrameTab4, 4, _G.GarrisonMissionFrame)
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

	self:skinStdButton{obj=activeUI.CompleteAll}
	self:skinSlider{obj=bar, adj=-4}
	-- options frame in TLHC
	self:removeRegions(missionList.ctlContainer, {1, 2, 3})

	local function skinMissionButtons(scrollChild, objType, isML)
		local kids = {scrollChild:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child:IsObjectType(objType) then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("BORDER")
				-- add texture to identify individual missions
				if not child.lineTex then
					child.lineTex = child:CreateTexture(nil, "OVERLAY", nil, -2)
					child.lineTex:SetAllPoints(child)
					child.lineTex:SetTexture (0.6, 0.6, 0.6)
					child.lineTex:SetBlendMode("ADD")
					child.lineTex:SetGradient("VERTICAL", 0.1, 0.3, 0.3, 0.1, 0.1, 0.1)
				end
				if child:GetID()/2%1 == 0.5 then -- choose odd numbered lines
					child.lineTex:Show()
				else
					child.lineTex:Hide()
				end
				if isML then
					local t, grandchild
					-- aObj:getChild(child, 1):DisableDrawLayer("OVERLAY") -- shadow background, don't remove this as it identifies missions that are unable to be selected
					-- extend the top & bottom highlight texture
					t = aObj:getRegion(child, 12)
					t:ClearAllPoints()
					t:SetPoint("TOPLEFT", 0, 4)
					t:SetPoint("TOPRIGHT", 0, 4)
					t = aObj:getRegion(child, 13)
					t:ClearAllPoints()
					t:SetPoint("BOTTOMLEFT", 0, -4)
					t:SetPoint("BOTTOMRIGHT", 0, -4)
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
					grandchild = aObj:getLastChild(child)
					if grandchild:IsObjectType("Button")
					and grandchild:GetNumChildren() == 21
					then
						for i = 1, grandchild:GetNumChildren() do
							aObj:getChild(grandchild, i).ring:SetTexture(nil)
						end
					end
					t, grandchild = nil, nil
				end
			end
		end
		kids = nil
	end
	-- hook this to skin new buttons
	self:SecureHookScript(bar, "OnValueChanged", function(this, ...)
		skinMissionButtons(sc, "Button", true)
	end)
	-- skin any existing buttons, first time displayed
	skinMissionButtons(sc, "Button", true)

	-- ActiveUI lootframe
	self:skinStdButton{obj=_G.MPLootSummaryDone}
	self:skinCloseButton{obj=activeUI.lootFrame.Dismiss2}
	self:addSkinFrame{obj=activeUI.lootFrame, ft="a", kfs=true, nb=true, y1=-3, x2=-1}
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
	-- Clear/Send Tentative Parties button, has to be done this way otherwise button skin isn't shown
	self:SecureHook(availUI.SendTentative, "SetShown", function(this)
		self:skinStdButton{obj=this}
	end)

	-- Garrison Missions Frame - Available Missions Tab - Mission Page
	-- Get Suggested Groups button
	self:removeRegions(self:getChild(_G.GarrisonMissionFrame.MissionTab.MissionPage.Stage, 3), {2}) -- ring texture
	-- minimize button
	self:skinOtherButton{obj=_G.GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton, text="-"}

	if self.modBtnBs then
		-- SpecAffinityFrame (on FollowerTab frames)
		self:SecureHook("GarrisonMissionPortrait_SetFollowerPortrait", function(pf, ...)
			if pf ~= _G.GarrisonMissionFrame.FollowerTab.PortraitFrame
			and pf ~= _G.GarrisonLandingPage.FollowerTab.PortraitFrame
			then
				return
			end
			local frame = self:getLastChild(pf:GetParent())
			if frame.ClassSpec then
				self:addButtonBorder{obj=frame.ClassSpec}
				self:addButtonBorder{obj=frame.Affinity}
				self:addButtonBorder{obj=frame.Missions}
				self:Unhook("GarrisonMissionFrame_SetFollowerPortrait")
			end
			frame = nil
		end)
		-- Follower Items Container
		self:addButtonBorder{obj=_G.MPFollowerItemContainer.weapon, es=12, x1=36}
		self:addButtonBorder{obj=_G.MPFollowerItemContainer.armor, es=12, x2=-36}
	end

	-- Follower Summary
	_G.GarrisonMissionFrame.SummaryTab:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=_G.GarrisonMissionFrame.SummaryTab.matrix, ft="a", nb=true}
	self:addSkinFrame{obj=_G.GarrisonMissionFrame.SummaryTab.affin, ft="a", nb=true}
	self:addSkinFrame{obj=_G.GarrisonMissionFrame.SummaryTab.stats, ft="a", nb=true}

	-- UpgradesFrame
	local frame = _G.EnumerateFrames()

	while frame do

		if frame.IsObjectType -- handle object not being a frame !?
		and frame:IsObjectType("FRAME")
		and frame:GetName() == nil
		and frame:GetParent() == nil
		and frame:GetWidth(237)
		and frame:GetHeight(42)
		and frame.GetBackdropBorderColor and frame:GetBackdropBorderColor()
		and frame.Update
		then
			self:SecureHook(frame, "Update", function(this, liveUpdate)
				local kids = {this:GetChildren()}
				for _, child in _G.ipairs(kids) do
					child.Border:SetTexture(nil)
				end
				kids = nil
			end)
			break
		end

		frame = _G.EnumerateFrames(frame)
	end
	frame = nil

	-- GarrisonShipyard
	self:SecureHook(_G.GarrisonShipyardFrame, "ShowMission", function(this, ...)
		local groups, kNum
		local kids = {this.MissionTab.MissionPage:GetChildren()}
		for k, child in _G.ipairs(kids) do
			if self:getInt(child:GetWidth()) == 410
			and self:getInt(child:GetHeight()) == 24
			then
				groups = child
				kNum = k
				break
			end
		end
		kids = nil
		for i = 1, #groups.buttons do
			for j = 1, #groups.buttons[i].tex do
				groups.buttons[i].tex[j]:SetTexture(nil)
			end
			self:skinStdButton{obj=groups.buttons[i]}
		end
		-- minimize button
		self:skinOtherButton{obj=self:getChild(this.MissionTab.MissionPage, kNum + 1), text="-"}

		-- hook this to skin refit frame
		self:SecureHookScript(self:getChild(this.MissionTab.MissionPage, kNum + 2), "OnClick", function(this)
			self:addSkinFrame{obj=self:getLastChild(this:GetParent()), ft="a", nb=true}
			self:Unhook(this, "OnClick")
		end)
		groups, kNum = nil, nil
		self:Unhook(_G.GarrisonShipyardFrame, "ShowMission")
	end)

	-- MPStatContainer
	_G.GarrisonShipyardFrame.MissionTab.MissionPage.MPStatContainer:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.GarrisonShipyardFrame.MissionTab.MissionPage.MPStatContainer, ft="a", nb=true, ofs=-5}

	-- Missions of Interest Tab
	skinTab(_G.GarrisonShipyardFrameTab3, 3, _G.GarrisonShipyardFrame)
	_G.PanelTemplates_SetNumTabs(_G.GarrisonShipyardFrame, 3)

	local sit = _G.GarrisonShipyardFrame.InterestTab
	sit:DisableDrawLayer("BACKGROUND")
	sit:DisableDrawLayer("BORDER")
	self:skinSlider{obj=sit.List.Bar, adj=-4}
	-- hook this to skin buttons
	self:SecureHookScript(sit.List.Bar, "OnValueChanged", function(this, ...)
		skinMissionButtons(this:GetParent():GetScrollChild(), "Button", true)
	end)
	sit = nil

	-- MPLandingPageAlts
	local lpa = _G.MPLandingPageAlts
	-- Tab
	skinTab(lpa.Tab, 4, _G.GarrisonLandingPage, 5, -8, -4, -3)
	lpa.Tab.sf.ignore = true -- ignore size changes
	_G.PanelTemplates_SetNumTabs(_G.GarrisonLandingPage, 4)
	-- fix tab textures for Tab4 on GarrisonLandingPage
	self:SecureHook("GarrisonLandingPageTab_SetTab", function(...)
		if _G.GarrisonLandingPage.selectedTab == 4 then
			_G.PanelTemplates_UpdateTabs(_G.GarrisonLandingPage)
		end
	end)
	self:skinSlider{obj=lpa.List.Bar, adj=-4}
	-- hook this to skin new buttons
	self:SecureHookScript(lpa.List.Bar, "OnValueChanged", function(this, ...)
		skinMissionButtons(this:GetParent():GetScrollChild(), "Frame", false)
	end)
	lpa = nil

	-- find activeUI waste popup frame
	self.RegisterCallback("MasterPlan", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and _G.Round(child:GetWidth()) == 260
		and _G.Round(child:GetHeight()) == 68
		then
			self:addSkinFrame{obj=child, ft="a", nb=true}
		end
	end)
	self:scanUIParentsChildren()

end
