local aName, aObj = ...
if not aObj:isAddonEnabled("ChampionCommander") then return end
local _G = _G

-- loads with Blizzard_GarrisonUI
aObj.lodAddons.ChampionCommander = function(self) -- v 1.3.2 90001

	-- tooltip
	_G.C_Timer.After(0.1, function()
		_G.BFAFollowerTip.PortraitFrame.PortraitRing:SetTexture(nil)
		_G.BFAFollowerTip.PortraitFrame.LevelBorder:SetAlpha(0)
		self:add2Table(self.ttList, _G.BFAFollowerTip)
	end)

	local mLst = _G.BFA:GetMissionlistModule()
	if mLst then
		self:SecureHook(mLst, "Menu", function(this, flags)
			local frame = self:getLastChild(_G.BFAMissionFrame)
			self:moveObject{obj=frame.Tutorial, x=2, y=6}
			self:skinCloseButton{obj=frame.Close}
			self:moveObject{obj=frame.Close, x=3, y=3}
			self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ofs=0, x1=-2, y2=-6}
			if self.modBtnBs then
				-- replace the mission menu tab texture
				local mBtn = self:getLastChild(_G.BFAMissionFrame.MissionTab)
				mBtn:SetSize(44, 44)
				mBtn:GetNormalTexture():SetTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
				mBtn:GetHighlightTexture():SetTexture([[Interface\Buttons\UI-Common-MouseHilight]])
				mBtn:GetNormalTexture():SetRotation(0)
				mBtn:GetHighlightTexture():SetRotation(0)
				mBtn:SetPoint("TOPLEFT", _G.BFAMissionFrame.MissionTab, "TOPRIGHT", -6, 5)
				self:addButtonBorder{obj=mBtn, ofs=-4, x1=3, clr="gold"}
				mBtn = nil
			end
			frame = nil

			self:Unhook(this, "Menu")
		end)
		self:SecureHook(mLst, "AddMembers", function(this, frame)
			local mm = _G.BFA:GetMembersFrame(frame)
			if not mm then return end
			for i = 1, 3 do
				mm.Champions[i].PortraitRing:SetTexture(nil)
				mm.Champions[i].LevelBorder:SetAlpha(0)
			end
			mm = nil
		end)
		self:SecureHook(mLst, "NoMartiniNoParty", function(this, text)
			self:addSkinFrame{obj=_G.BFAWarner, ft="a", kfs=true, nb=true}

			self:Unhook(this, "NoMartiniNoParty")
		end)
		-- handle Alpha/beta versions' frame
		self:SecureHook(mLst, "InitialSetup", function(this)
			if _G.BFA.version:find("(Beta)")
			or _G.BFA.version:find("(Alpha)")
			then
				self:addSkinFrame{obj=self:getLastChild(_G.BFAMissionFrame), ft="a", kfs=true, nb=true}
			end

			self:Unhook(this, "InitialSetup")
		end)
	end
	mLst = nil

	local mPage = _G.BFA:GetMissionpageModule()
	if mPage then
		self:SecureHook(mPage, "Analyze", function(this, mission)
			-- BFAAnalyzer
			self:skinSlider{obj=_G.BFAAnalizerListScrollBar, wdth=-4}
			local btn
			for i = 1, #_G.BFAAnalyzer.list.buttons do
				btn = _G.BFAAnalyzer.list.buttons[i]
				btn:DisableDrawLayer("BACKGROUND")
				btn:DisableDrawLayer("BORDER")
				for j = 1, #btn.Rewards do
					btn:DisableDrawLayer("BACKGROUND")
					self:addButtonBorder{obj=btn.Rewards[j], relTo=btn.Rewards[j].Icon, reParent={btn.Rewards[j].Quantity}}
					self:clrButtonFromBorder(btn.Rewards[j])
				end
				for j = 1, #btn.Followers.Champions do
					btn.Followers.Champions[j].PortraitRing:SetTexture(nil)
					btn.Followers.Champions[j].LevelBorder:SetAlpha(0)
				end
			end
			btn = nil
			self:skinCloseButton{obj=_G.BFAAnalyzer.Close}
			self:addSkinFrame{obj=_G.BFAAnalyzer, ft="a", kfs=true, nb=true}
			-- fix the title spelling
			if _G.BFAAnalyzer.Title:GetText():find("analisys") then
				_G.BFAAnalyzer.Title:SetText(mission.name .. " analysis")
			end

			self:Unhook(this, "Analyze")
		end)
	end
	mPage = nil

	-- followerpage

	local aC = _G.BFA:GetAutocompleteModule()
	if aC then
		self:skinStdButton{obj=self:getLastChild(_G.BFAMissionFrame.MissionTab.MissionList.CompleteDialog.BorderFrame.ViewButton), x1=-10, x2=10}
	end
	aC = nil

	local cache = _G.BFA:GetCacheModule()
	local tFrame
	if cache then
		self:SecureHook(cache, "GetTroopsFrame", function(this)
			tFrame = self:getLastChild(_G.BFAMissionFrame)
			self:addSkinFrame{obj=tFrame, ft="a", kfs=true, nb=true, ofs=0 ,x1=4, x2=-4}
		end)
	end
	cache = nil

	local tut = _G.BFA:GetTutorialsModule()
	if tut then
		local Clicker, Enhancer
		-- N.B. Tutorial uses this function, but leaves the frame showing...
		self:SecureHook(tut, "Show", function(this, opening)
			if not Clicker then
				for _, child in _G.pairs{_G.HelpPlateTooltip:GetChildren()} do
					if child.Home
					and child.Home.tooltip
					then
						Clicker = child
						break
					end
				end
			end
			if Clicker then
				if self.modBtns
				or self.modBtnBs
				then
					if self.modBtns then
						 self:skinCloseButton{obj=Clicker.Close, noSkin=true}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=Clicker.Forward, ofs=-2, x2=-3, clr="gold"}
						self:addButtonBorder{obj=Clicker.Backward, ofs=-2, x2=-3, clr="gold"}
					end
				end
				Clicker = nil
			end
			-- skin Enhancer frame
			local hptParent = _G.HelpPlateTooltip:GetParent()
			if hptParent ~= _G.BFAMissionFrame
			and not Enhancer
			then
				Enhancer = self:getLastChild(hptParent)
				Enhancer:DisableDrawLayer("BACKGROUND")
				self:addFrameBorder{obj=Enhancer, aso={bbclr="gold"}, ofs=4}
			end
			-- this shows/hides the Troop frame as required
			if tFrame then
				if tFrame == hptParent then
					tFrame:Show()
				else
					tFrame:Hide()
				end
			end
			hptParent = nil
		end)
	end
	tut = nil

	-- hook this to manage GarrisonFollowerAlerts
	self:secureHook("GarrisonFollowerAlertFrame_SetUp", function(frame, FAKE_FOLLOWERID, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.PortraitFrame.PortraitRing:SetTexture(nil)
		self:nilTexture(frame.PortraitFrame.LevelBorder, true)
		self:nilTexture(frame.FollowerBG, true)
		self:addSkinFrame{obj=frame, ft="a", nb=true, ofs=-8}
	end)

end
