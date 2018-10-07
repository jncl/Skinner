local aName, aObj = ...
if not aObj:isAddonEnabled("GarrisonCommander") then return end
local _G = _G

aObj.lodAddons.GarrisonCommander = function(self) -- v 2.18.5 70200

	-- hook these to skin the GarrisonCommander Button on LHS of frame
	if self.modBtnBs then
		local gmfos = _G.GarrisonMissionFrame:GetScript("OnShow")
		_G.GarrisonMissionFrame:HookScript("OnShow", function(this)
			local btn = self:getLastChild(this)
			if not btn.sbb then
				self:addButtonBorder{obj=btn, sec=true, reParent={btn.Quantity}}
			end
			btn = nil
			this:SetScript("OnShow", gmfos) -- revert to original script
			gmfos = nil
		end)
		local gsfos = _G.GarrisonShipyardFrame:GetScript("OnShow")
		_G.GarrisonShipyardFrame:HookScript("OnShow", function(this)
			local btn = self:getLastChild(this)
			if not btn.sbb then
				self:addButtonBorder{obj=btn, reParent={btn.Quantity}}
			end
			btn = nil
			this:SetScript("OnShow", gsfos) -- revert to original script
			gsfos = nil
		end)
	end

	-- used by GarrisonCommander, Shipyard module
	self:RawHook(_G.GAC, "CreateHeader", function(this, ...)
		-- Header panel
		local frame = self.hooks[this].CreateHeader(this, ...)
		frame.GarrCorners:DisableDrawLayer("BACKGROUND")
		self:moveObject{obj=frame.CloseButton, x=-3, y=0}
		self:addButtonBorder{obj=frame.Pin, ofs=-2}
		self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, x1=2, y1=5, x2=1}
		_G.RaiseFrameLevelByTwo(frame)
		return frame
	end, true)

	self:SecureHook(_G.GAC, "Setup", function(this, ...)
		-- tabs on RHS
		self:removeRegions(_G.GarrisonMissionFrame.tabMC, {1})
		self:removeRegions(_G.GarrisonMissionFrame.tabCF, {1})
		self:removeRegions(_G.GarrisonMissionFrame.tabHP, {1})
		self:removeRegions(_G.GarrisonMissionFrame.tabQ, {1})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.GarrisonMissionFrame.tabMC}
			self:addButtonBorder{obj=_G.GarrisonMissionFrame.tabCF}
			self:addButtonBorder{obj=_G.GarrisonMissionFrame.tabHP}
			self:addButtonBorder{obj=_G.GarrisonMissionFrame.tabQ}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.GarrisonCommanderQuickMissionComplete} -- on GarrisonMissionFrame.Missions.CompleteDialog.BorderFrame.ViewButton
		end
		self:Unhook(this, "Setup")
	end)

	-- skin follower buttons
	self:SecureHook(_G.GAC, "BuildFollowersButtons", function(this, button, bg, limit, bigscreen)
		for _, follower in pairs(bg.Party) do
			follower:DisableDrawLayer("BACKGROUND")
			follower.PortraitFrame.LevelBorder:SetAlpha(0) -- texture changed
		end
	end)
	self:SecureHook(_G.GAC, "RenderFollowerButton", function(this, frame, followerID, missionID, b, t)
		if frame == _G.GCFMissionsHeader then
			frame:DisableDrawLayer("BACKGROUND")
			frame.PortraitFrame.LevelBorder:SetAlpha(0) -- texture changed
			self:getRegion(_G.GCFMissions, _G.GCFMissions:GetNumRegions()):SetAlpha(0)
		end
	end)

	-- MissionControl module
	local mcM = _G.GAC:GetModule("MissionControl", true)
	if mcM then
		local GMC = _G.GarrisonMissionFrame.MissionControlTab
		if self.modBtns then
			self:skinStdButton{obj=GMC.startButton}
			self:skinStdButton{obj=GMC.runButton, x1=-10, x2=10} -- make button skin wider to encompass the text
		end
		if self.modBtnBs then
			for i = 1, #GMC.ignoreFrames do
				self:addButtonBorder{obj=GMC.ignoreFrames[i], ibt=true}
			end
		end
		GMC = nil
	end
	mcM = nil

	local fpM = _G.GAC:GetModule("FollowerPage", true)
	if fpM then
		self:SecureHook(fpM, "Setup", function()
			self:skinDropDown{obj=_G.GarrisonTraitCountersFrame.choice, noBB=true}
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.GarrisonTraitCountersFrame.choice.button, es=12, ofs=-2, x1=152}
			end
			self:Unhook(this, "Setup")
		end)
	end
	fpM = nil

	-- Shipyard module
	local sM = _G.GAC:GetModule("ShipYard", true)
	if sM then
		self:SecureHook(sM, "Setup", function(this, ...)
			-- tabs on RHS
			self:removeRegions(_G.GarrisonShipyardFrame.tabHP, {1})
			self:removeRegions(_G.GarrisonShipyardFrame.tabMC, {1})
			self:moveObject{obj=_G.GarrisonShipyardFrame.tabMC, {1}, y=-40}
			self:removeRegions(_G.GarrisonShipyardFrame.tabQ, {1})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.GarrisonShipyardFrame.tabHP}
				self:addButtonBorder{obj=_G.GarrisonShipyardFrame.tabMC}
				self:addButtonBorder{obj=_G.GarrisonShipyardFrame.tabQ}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.GCQuickShipMissionCompletionButton}
			end
			self:Unhook(this, "Setup")
		end)
		-- TODO: skin mission GcAddendum frame(s)
		sM = nil
	end

	-- ShipControl module
	local scM = _G.GAC:GetModule("ShipControl", true)
	if scM then
		local GMC = _G.GarrisonShipyardFrame.MissionControlTab
		if self.modBtns then
			self:skinStdButton{obj=GMC.startButton}
			self:skinStdButton{obj=GMC.runButton, x1=-10, x2=10} -- make button skin wider to encompass the text
		end
		GMC = nil
	end
	scM = nil

	--  BuildingPage module
	local bpM = _G.GAC:GetModule("BuildingPage", true)
	if bpM then
		self:SecureHook(bpM, "AddFollowerToPlot", function(this, plot)
			plot.followerIcon.PortraitFrame.LevelBorder:SetAlpha(0)
		end)
	end
	bpM = nil

	-- hook this to move mission expires string
	self:SecureHook(_G.GAC, "FillMissionPage", function(this, missionInfo)
		local missionType, frame, yOfs = missionInfo.followerTypeID
		if missionType == _G.LE_FOLLOWER_TYPE_GARRISON_6_0 then
			frame = _G.GarrisonMissionFrame
			yOfs = -4
		elseif missionType == _G.LE_FOLLOWER_TYPE_SHIPYARD_6_2 then
			frame = _G.GarrisonShipyardFrame
			yOfs = -10
		elseif missionType == _G.LE_FOLLOWER_TYPE_GARRISON_7_0 then
			frame = _G.OrderHallMissionFrame
			yOfs = -4
		end
		if frame.MissionTab.MissionPage.Stage
		and frame.MissionTab.MissionPage.Stage.expires
		then
			self:moveObject{obj=frame.MissionTab.MissionPage.Stage.expires, y=yOfs}
		end
		missionType, frame = nil, nil
	end)

end
