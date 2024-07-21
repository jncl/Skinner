local _, aObj = ...
if not aObj:isAddonEnabled("MasterPlan") then return end
local _G = _G

aObj.lodAddons.MasterPlan = function(self) -- v 0.138

	local function skinScrollBar(frame)
		local track = aObj:getChild(frame, 1)
		aObj:keepFontStrings(track)
		aObj:skinObject("frame", {obj=track, bd=4, ng=true, x1=2, y1=2, x2=-2, y2=-2, clr="slider"})
	end
	local function skinTab(tab, id, frame, x1, y1, x2 ,y2)
		aObj:removeRegions(tab, {1, 2, 3, 4, 5, 6})
		aObj:skinObject("frame", {obj=tab, noBdr=aObj.isTT, x1=x1 or -4, y1=y1 or 2, x2=x2 or 0, y2=y2 or 0})
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
	_G.GarrisonMissionFrame.numTabs = 4

	-- Garrison Missions Frame - Active Missions Tab
	local missionList = _G.MasterPlanMissionList
	local mlc = missionList:GetNumChildren()
	local activeUI = self:getChild(missionList, mlc - 3)
	local availUI = self:getChild(missionList, mlc - 2)
	local sf = missionList.List
	local sc = sf:GetScrollChild()
	local bar = sf.Bar

	if self.modBtns then
		self:skinStdButton{obj=activeUI.CompleteAll}
	end
	skinScrollBar(bar)
	-- options frame in TLHC
	self:removeRegions(missionList.ctlContainer, {1, 2, 3})

	local function skinMissionButtons(scrollChild, objType, isML)
		for _, child in _G.ipairs({scrollChild:GetChildren()}) do
			if child:IsObjectType(objType) then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("BORDER")
				-- add texture to identify individual missions
				if not child.lineTex then
					child.lineTex = child:CreateTexture(nil, "OVERLAY", nil, -2)
					child.lineTex:SetAllPoints(child)
					child.lineTex:SetTexture (0.6, 0.6, 0.6)
					child.lineTex:SetBlendMode("ADD")
					child.lineTex:SetGradient("VERTICAL", _G.CreateColor(0.1, 0.3, 0.3, 1), _G.CreateColor(0.1, 0.1, 0.1, 1))
				end
				if child:GetID()/2%1 == 0.5 then -- choose odd numbered lines
					child.lineTex:Show()
				else
					child.lineTex:Hide()
				end
				if isML then
					local tex
					-- aObj:getChild(child, 1):DisableDrawLayer("OVERLAY") -- shadow background, don't remove this as it identifies missions that are unable to be selected
					-- extend the top & bottom highlight texture
					tex = aObj:getRegion(child, 12)
					tex:ClearAllPoints()
					tex:SetPoint("TOPLEFT", 0, 4)
					tex:SetPoint("TOPRIGHT", 0, 4)
					tex = aObj:getRegion(child, 13)
					tex:ClearAllPoints()
					tex:SetPoint("BOTTOMLEFT", 0, -4)
					tex:SetPoint("BOTTOMRIGHT", 0, -4)
					aObj:removeRegions(child, {14, 15, 16, 17, 23}) -- highlight corners & rare indicator
					if child.followers then -- Active mission button has these
						for _, btn in _G.pairs(child.followers) do
							if _G.type(btn) == "table" then
								btn.ring:SetTexture(nil)
							end
						end
					end
					if child.groups then -- Available mission button has these
						for _, btn in _G.pairs(child.groups) do
							btn:DisableDrawLayer("BACKGROUND")
						end
					end
					if aObj.modBtnBs then
						if child.rewards then
							for _, btn in _G.pairs(child.rewards) do
								if _G.type(btn) ~= "number" then
									aObj:addButtonBorder{obj=btn, reParent={btn.quantity}}
								end
							end
						end
					end
					 -- Missions of interest have these unused follower buttons
					local grandchild = aObj:getLastChild(child)
					if grandchild:IsObjectType("Button")
					and grandchild:GetNumChildren() == 21
					then
						for i = 1, grandchild:GetNumChildren() do
							aObj:getChild(grandchild, i).ring:SetTexture(nil)
						end
					end
				end
			end
		end
	end
	-- hook this to skin new buttons
	self:SecureHookScript(bar, "OnValueChanged", function(_, _)
		skinMissionButtons(sc, "Button", true)
	end)
	-- skin any existing buttons, first time displayed
	skinMissionButtons(sc, "Button", true)

	-- ActiveUI lootframe
	if self.modBtns then
		self:skinStdButton{obj=_G.MPLootSummaryDone}
		self:skinCloseButton{obj=activeUI.lootFrame.Dismiss2}
	end
	self:skinObject("frame", {obj=activeUI.lootFrame, kfs=true, y1=-3, x2=-1})
	local function skinLootContainer(lootContainer)
		for _, btn in _G.pairs(lootContainer.items) do
			btn.Border:SetTexture(nil)
			if self.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, ofs=3}
			end
		end
		for _, follower in _G.pairs(lootContainer.followers) do
			follower.PortraitRing:SetTexture(nil)
			follower.LevelBorder:SetTexture(nil)
			follower.PortraitRingCover:SetTexture(nil)
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
	if self.modBtns then
		self:SecureHook(availUI.SendTentative, "SetShown", function(this)
			self:skinStdButton{obj=this}
		end)
	end

	-- Garrison Missions Frame - Available Missions Tab - Mission Page
	-- Get Suggested Groups button
	self:removeRegions(self:getChild(_G.GarrisonMissionFrame.MissionTab.MissionPage.Stage, 3), {2}) -- ring texture
	-- minimize button
	if self.modBtns then
		self:skinOtherButton{obj=_G.GarrisonMissionFrame.MissionTab.MissionPage.MinimizeButton, text="-"}
	end

	if self.modBtnBs then
		-- SpecAffinityFrame (on FollowerTab frames)
		self:SecureHook("GarrisonMissionPortrait_SetFollowerPortrait", function(pf, _)
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
		end)
		-- Follower Items Container
		self:addButtonBorder{obj=_G.MPFollowerItemContainer.weapon, es=12, x1=36}
		self:addButtonBorder{obj=_G.MPFollowerItemContainer.armor, es=12, x2=-36}
	end

	-- Follower Summary
	_G.GarrisonMissionFrame.SummaryTab:DisableDrawLayer("BORDER")
	self:skinObject("frame", {obj=_G.GarrisonMissionFrame.SummaryTab.matrix, kfs=true, clr="gold"})
	self:skinObject("frame", {obj=_G.GarrisonMissionFrame.SummaryTab.affin, kfs=true, clr="gold"})
	self:skinObject("frame", {obj=_G.GarrisonMissionFrame.SummaryTab.stats, kfs=true, clr="gold"})

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
			self:SecureHook(frame, "Update", function(this, _)
				local kids = {this:GetChildren()}
				for _, child in _G.ipairs(kids) do
					child.Border:SetTexture(nil)
				end
			end)
			break
		end

		frame = _G.EnumerateFrames(frame)
	end

	-- GarrisonShipyard
	self:SecureHook(_G.GarrisonShipyardFrame, "ShowMission", function(this, _)
		local groups, kNum
		for k, child in _G.ipairs({this.MissionTab.MissionPage:GetChildren()}) do
			if self:getInt(child:GetWidth()) == 410
			and self:getInt(child:GetHeight()) == 24
			then
				groups = child
				kNum = k
				break
			end
		end
		for _, btn in _G.pairs(groups.buttons) do
			for _, tex in _G.pairs(btn.tex) do
				tex:SetTexture(nil)
			end
			if self.modBtns then
				self:skinStdButton{obj=btn}
			end
		end
		-- minimize button
		if self.modBtns then
			self:skinOtherButton{obj=self:getChild(this.MissionTab.MissionPage, kNum + 1), text="-"}
		end

		-- hook this to skin refit frame
		self:SecureHookScript(self:getChild(this.MissionTab.MissionPage, kNum + 2), "OnClick", function(fObj)
			self:skinObject("frame", {obj=self:getLastChild(fObj:GetParent())})

			self:Unhook(fObj, "OnClick")
		end)

		self:Unhook(_G.GarrisonShipyardFrame, "ShowMission")
	end)

	-- MPStatContainer
	_G.GarrisonShipyardFrame.MissionTab.MissionPage.MPStatContainer:DisableDrawLayer("BACKGROUND")
	self:skinObject("frame", {obj=_G.GarrisonShipyardFrame.MissionTab.MissionPage.MPStatContainer, ofs=-5})

	-- Missions of Interest Tab
	skinTab(_G.GarrisonShipyardFrameTab3, 3, _G.GarrisonShipyardFrame)
	_G.GarrisonShipyardFrame.numTabs = 3

	local sit = _G.GarrisonShipyardFrame.InterestTab
	sit:DisableDrawLayer("BACKGROUND")
	sit:DisableDrawLayer("BORDER")
	skinScrollBar(sit.List.Bar)
	-- hook this to skin buttons
	self:SecureHookScript(sit.List.Bar, "OnValueChanged", function(this, _)
		skinMissionButtons(this:GetParent():GetScrollChild(), "Button", true)
	end)

	-- MPLandingPageAlts
	local lpa = _G.MPLandingPageAlts
	-- Tab
	skinTab(lpa.Tab, 4, _G.GarrisonLandingPage, 5, -8, -4, -3)
	lpa.Tab.sf.ignore = true -- ignore size changes
	_G.GarrisonLandingPage.numTabs = 4
	-- fix tab textures for Tab4 on GarrisonLandingPage
	self:SecureHook("GarrisonLandingPageTab_SetTab", function(_)
		if _G.GarrisonLandingPage.selectedTab == 4 then
			_G.PanelTemplates_UpdateTabs(_G.GarrisonLandingPage)
		end
	end)
	skinScrollBar(lpa.List.Bar)
	-- hook this to skin new buttons
	self:SecureHookScript(lpa.List.Bar, "OnValueChanged", function(this, _)
		skinMissionButtons(this:GetParent():GetScrollChild(), "Frame", false)
	end)

	-- find activeUI waste popup frame
	self.RegisterCallback("MasterPlan", "UIParent_GetChildren", function(_, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and _G.Round(child:GetWidth()) == 260
		and _G.Round(child:GetHeight()) == 68
		then
			local slider = self:getChild(child, 1)
			self:skinObject("slider", {obj=slider, y1=0, y2=0})
			self:getRegion(slider, 11):SetAlpha(1) -- green trexture
			self:getRegion(slider, 11):SetDrawLayer("ARTWORK")
			self:getRegion(slider, 12):SetAlpha(1) -- red texture
			self:getRegion(slider, 12):SetDrawLayer("ARTWORK")
			self:skinObject("frame", {obj=child, kfs=true})
		end
	end)
	self:scanUIParentsChildren()

	self:add2Table(self.ttList, _G.NotGameTooltip1)

end
