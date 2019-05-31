local aName, aObj = ...
if not aObj:isAddonEnabled("OrderHallCommander") then return end
local _G = _G

aObj.lodAddons.OrderHallCommander = function(self) -- v 1.7.2 80000

	local OHC = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("OrderHallCommander", true)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		_G.OHCFollowerTip.PortraitFrame.PortraitRing:SetTexture(nil)
		_G.OHCFollowerTip.PortraitFrame.LevelBorder:SetAlpha(0)
		self:add2Table(self.ttList, _G.OHCFollowerTip)
	end)

	-- hook this to move the Tutorial button in the TLHC of the OrderHallMissionFrame
	self:SecureHook(OHC, "MarkAsNew", function(this, obj, key, message, method)
		local frame = self:getLastChild(_G.OrderHallMissionFrame)
		if frame:IsObjectType("Button")
		and frame.tooltip == message
		then
			self:moveObject{obj=frame, x=5}
		end
		frame = nil
		self:Unhook(this, "MarkAsNew")
	end)

	local cache = OHC:GetCacheModule()
	if cache then
		self:RawHook(cache, "GetTroopsFrame", function(this)
			local frame = self.hooks[this].GetTroopsFrame(this)
			frame.Top:SetTexture(nil)
			self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ofs=-1, x1=2, y2=2}
			self:Unhook(this, "GetTroopsFrame")
			return frame
		end, true)
		self:SecureHook(cache, "DrawKrokuls", function(this, main)
			self:moveObject{obj=main.Buttons[1], x=10}
		end)
	end
	cache = nil

	local mLst = OHC:GetMissionlistModule()
	if mLst then
		self:SecureHook(mLst, "Menu", function(this, flag)
			local frame = self:getLastChild(_G.OrderHallMissionFrame)
			self:moveObject{obj=frame.Tutorial, x=2, y=6}
			self:skinCloseButton{obj=frame.Close}
			self:moveObject{obj=frame.Close, x=3, y=5}
			self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, y1=2, y2=-5}
			if self.modBtnBs then
				-- replace the mission menu tab texture
				local mBtn = self:getLastChild(_G.OrderHallMissionFrame.MissionTab)
				mBtn:SetSize(44, 44)
				mBtn:GetNormalTexture():SetTexture([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
				mBtn:GetHighlightTexture():SetTexture([[Interface\Buttons\UI-Common-MouseHilight]])
				mBtn:GetNormalTexture():SetRotation(0)
				mBtn:GetHighlightTexture():SetRotation(0)
				mBtn:SetPoint("TOPLEFT", _G.OrderHallMissionFrame.MissionTab, "TOPRIGHT", -6, 6)
				self:addButtonBorder{obj=mBtn, ofs=-4}
				mBtn = nil
			end
			frame = nil
			self:Unhook(this, "Menu")
		end)
		self:SecureHook(mLst, "AddMembers", function(this, frame)
			local mm = OHC:GetMembersFrame(frame)
			if not mm then return end
			for i = 1, 3 do
				mm.Champions[i].LevelBorder:SetAlpha(0)
			end
			mm = nil
		end)
		self:SecureHook(mLst, "NoMartiniNoParty", function(this, text)
			self:addSkinFrame{obj=_G.OHCWarner, ft="a", kfs=true, nb=true}
			self:Unhook(this, "NoMartiniNoParty")
		end)
	end
	mLst = nil

	local aC = OHC:GetAutocompleteModule()
	if aC then
		self:skinStdButton{obj=self:getLastChild(_G.OrderHallMissionFrameMissions.CompleteDialog.BorderFrame.ViewButton), x1=-10, x2=10}
	end
	aC = nil

	if self.modBtns
	or self.modBtnBs
	then
		local tut = OHC:GetTutorialsModule()
		if tut then
			self:SecureHook(tut, "Show", function(this, opening)
				local Clicker = self:getLastChild(_G.HelpPlateTooltip)
				if self.modBtns then
					self:skinCloseButton{obj=Clicker.Close}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=Clicker.Forward, ofs=-2, x2=-3}
					self:addButtonBorder{obj=Clicker.Backward, ofs=-2, x2=-3}
				end
				Clicker = nil
				self:Unhook(this, "Show")
			end)
		end
		tut = nil
	end

	-- hook this to manage GarrisonFollowerAlerts
	self:secureHook("GarrisonFollowerAlertFrame_SetUp", function(frame, FAKE_FOLLOWERID, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.PortraitFrame.PortraitRing:SetTexture(nil)
		self:nilTexture(frame.PortraitFrame.LevelBorder, true)
		self:nilTexture(frame.FollowerBG, true)
		self:addSkinFrame{obj=frame, ft="a", nb=true, ofs=-8}
	end)

end
