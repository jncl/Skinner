
function Skinner:XPerl()

	self:checkAndRunAddOn("XPerl_Player")
	self:checkAndRunAddOn("XPerl_PlayerPet")
	self:checkAndRunAddOn("XPerl_Target")
	self:checkAndRunAddOn("XPerl_TargetTarget")
	self:checkAndRunAddOn("XPerl_Party")
	self:checkAndRunAddOn("XPerl_PartyPet")
	self:checkAndRunAddOn("XPerl_RaidFrames")
	self:checkAndRunAddOn("XPerl_RaidPets")
	self:checkAndRunAddOn("XPerl_RaidMonitor")

	-- Change the Frame and Border colours here
	XPerlDB.colour.frame = {r = self.db.profile.Backdrop.r, g = self.db.profile.Backdrop.g, b = self.db.profile.Backdrop.b, a = self.db.profile.Backdrop.a}
	XPerlDB.colour.border = {r = self.db.profile.BackdropBorder.r, g = self.db.profile.BackdropBorder.g, b = self.db.profile.BackdropBorder.b, a = self.db.profile.BackdropBorder.a}

end

function Skinner:XPerl_Player()
--	self:Debug("XPerl_Player")

-->>--	Player
	self:applySkin(XPerl_PlayerportraitFrame)
	self:applySkin(XPerl_PlayernameFrame)
	self:applySkin(XPerl_PlayerlevelFrame)
	self:applySkin(XPerl_PlayerclassFrame)
	self:applySkin(XPerl_PlayerstatsFrame)
	self:applySkin(XPerl_PlayergroupFrame)

	-- Put a border around the class icon
	if not XPerl_PlayerclassFrame.skinned then
		XPerl_PlayerclassFrame:SetWidth(XPerl_PlayerclassFrame:GetWidth() + 7)
		XPerl_PlayerclassFrame:SetHeight(XPerl_PlayerclassFrame:GetHeight() + 6)
		self:moveObject(XPerl_PlayerclassFrame, "+", 3, "-", 2)
		XPerl_PlayerclassFrametex:SetWidth(XPerl_PlayerclassFrametex:GetWidth() - 1)
		XPerl_PlayerclassFrametex:SetHeight(XPerl_PlayerclassFrametex:GetHeight() - 2)
		self:moveObject(XPerl_PlayerclassFrametex, "-", 4, "+", 4)
		XPerl_PlayerclassFrame.skinned = true
	end

	if not self:IsHooked("XPerl_Player_UpdateDisplay") then
		self:SecureHook("XPerl_Player_UpdateDisplay", function(...)
--			self:Debug("XPerl_Player_UpdateDisplay")
			self:XPerl_Player()
		end)
	end

end

function Skinner:XPerl_PlayerPet()
--	self:Debug("XPerl_PlayerPet")

-->>--	Player Pet
	self:applySkin(XPerl_Player_PetportraitFrame)
	self:applySkin(XPerl_Player_PetnameFrame)
	self:applySkin(XPerl_Player_PetlevelFrame)
	self:applySkin(XPerl_Player_PethappyFrame)
	self:applySkin(XPerl_Player_PetstatsFrame)

	if not self:IsHooked("XPerl_Player_Pet_UpdateDisplay") then
		self:SecureHook("XPerl_Player_Pet_UpdateDisplay", function()
--			self:Debug("XPerl_Player_Pet_UpdateDisplay")
			self:XPerl_PlayerPet()
			end)
	end

end

function Skinner:XPerl_Target()
--	self:Debug("XPerl_Target")

-->>--	Target
	self:applySkin(XPerl_TargetportraitFrame)
	self:applySkin(XPerl_TargetnameFrame)
	self:applySkin(XPerl_TargetlevelFrame)
	self:applySkin(XPerl_TargettypeFramePlayer)
	self:applySkin(XPerl_TargetstatsFrame)
	self:applySkin(XPerl_TargetcreatureTypeFrame)
	self:applySkin(XPerl_TargetbossFrame)

	-- Put a border around the class icon
	local cf = XPerl_TargettypeFramePlayer
	if not cf.skinned then
		cf:SetWidth(cf:GetWidth() - 3)
		cf:SetHeight(cf:GetHeight() - 4)
		self:moveObject(cf, "+", 1, "+", 3)
		local tex = XPerl_TargettypeFramePlayerclassTexture
		self:addSkinButton(tex, XPerl_Target, cf)
		cf.skinned = true
		-- only do this once
		RaiseFrameLevel(XPerl_TargetnameFrame)
	end

	XPerl_TargeteliteFrame:SetAlpha(0)

	-- use text label
	XPerlDB.target.elite = true

-->>--	Focus
	self:applySkin(XPerl_FocusportraitFrame)
	self:applySkin(XPerl_FocusnameFrame)
	self:applySkin(XPerl_FocuslevelFrame)
	self:applySkin(XPerl_FocustypeFramePlayer)
	self:applySkin(XPerl_FocusstatsFrame)
	self:applySkin(XPerl_FocuscreatureTypeFrame)
	self:applySkin(XPerl_FocusbossFrame)

	-- Put a border around the class icon
	local cf = XPerl_FocustypeFramePlayer
	if not cf.skinned then
		cf:SetWidth(cf:GetWidth() - 3)
		cf:SetHeight(cf:GetHeight() - 4)
		self:moveObject(cf, "+", 1, "+", 3)
		local tex = XPerl_FocustypeFramePlayerclassTexture
		self:addSkinButton(tex, XPerl_Focus, cf)
		cf.skinned = true
	end

	XPerl_FocuseliteFrame:SetAlpha(0)

	-- use text label
	XPerlDB.focus.elite = true

	if not self:IsHooked("XPerl_Target_UpdateDisplay") then
		self:SecureHook("XPerl_Target_UpdateDisplay", function()
--			self:Debug("XPerl_Target_UpdateDisplay")
			self:XPerl_Target()
		end)
	end

end

function Skinner:XPerl_TargetTarget()
--	self:Debug("XPerl_TargetTarget")

-->>--	TargetTarget
	self:applySkin(XPerl_TargetTargetnameFrame)
	self:applySkin(XPerl_TargetTargetlevelFrame)
	self:applySkin(XPerl_TargetTargetstatsFrame)
-->>--	TargetTargetTarget
	if XPerl_TargetTargetTarget then
		self:applySkin(XPerl_TargetTargetTargetnameFrame)
		self:applySkin(XPerl_TargetTargetTargetlevelFrame)
		self:applySkin(XPerl_TargetTargetTargetstatsFrame)
	end
-->>--	FocusTarget
	if XPerl_FocusTarget then
		self:applySkin(XPerl_FocusTargetnameFrame)
		self:applySkin(XPerl_FocusTargetlevelFrame)
		self:applySkin(XPerl_FocusTargetstatsFrame)
	end
-->>--	PetTarget
	if XPerl_PetTarget then
		self:applySkin(XPerl_PetTargetnameFrame)
		self:applySkin(XPerl_PetTargetlevelFrame)
		self:applySkin(XPerl_PetTargetstatsFrame)
	end

	if not self:IsHooked("XPerl_TargetTarget_UpdateDisplay") then
		self:SecureHook("XPerl_TargetTarget_UpdateDisplay", function()
--			self:Debug("XPerl_TargetTarget_UpdateDisplay")
			self:XPerl_TargetTarget()
		end)
	end

end

function Skinner:XPerl_Party()
--	self:Debug("XPerl_Party")

-->>--	Party
	for i = 1, 4 do
		self:applySkin(_G["XPerl_party"..i.."portraitFrame"])
		self:applySkin(_G["XPerl_party"..i.."nameFrame"])
		self:applySkin(_G["XPerl_party"..i.."statsFrame"])
		local lf = _G["XPerl_party"..i.."levelFrame"]
		self:applySkin(lf)
		-- Put a border around the class icon
		if not lf.skinned then
			local tex = _G[lf:GetName().."classTexture"]
			tex:SetWidth(tex:GetWidth() - 3)
			tex:SetHeight(tex:GetHeight() - 3)
			self:addSkinButton(tex, _G["XPerl_party"..i], lf)
			lf.skinned = true
		end
-->>--	Party Target
		self:applySkin(_G["XPerl_party"..i.."targetFrame"])
	end

	if not self:IsHooked("XPerl_Party_UpdateDisplayAll") then
		self:SecureHook("XPerl_Party_UpdateDisplayAll", function()
--			self:Debug("XPerl_Party_UpdateDisplayAll")
			self:XPerl_Party()
		end)
	end

end

function Skinner:XPerl_PartyPet()
--	self:Debug("XPerl_PartyPet")

-->>--	Party Pet
	for i = 1, 4 do
		self:applySkin(_G["XPerl_partypet"..i.."nameFrame"])
		self:applySkin(_G["XPerl_partypet"..i.."statsFrame"])
	end

	if not self:IsHooked("XPerl_Party_Pet_UpdateDisplayAll") then
		self:SecureHook("XPerl_Party_Pet_UpdateDisplayAll", function()
--			self:Debug("XPerl_Party_Pet_UpdateDisplayAll")
			self:XPerl_PartyPet()
		end)
	end

end

function Skinner:XPerl_RaidFrames()
	if self.initialized.XPerl_RaidFrames then return end
	self.initialized.XPerl_RaidFrames = true
--	self:Debug("XPerl_RaidFrames")

	local function skinRaid()

		for i = 1, 9 do
			for j = 1, 5 do
				local XPRGUB = _G["XPerl_Raid_Grp"..i.."UnitButton"..j]
				if XPRGUB and not XPRGUB.skinned then
					Skinner:applySkin(_G[XPRGUB:GetName().."nameFrame"])
					Skinner:applySkin(_G[XPRGUB:GetName().."statsFrame"])
					XPRGUB.skinned = true
				end
			end
		end

	end

	skinRaid()
	self:SecureHook("XPerl_RaidTitles", skinRaid)

end

function Skinner:XPerl_RaidPets()
	if self.initialized.XPerl_RaidPets then return end
	self.initialized.XPerl_RaidPets = true
--	self:Debug("XPerl_RaidPets")

	local function skinRaidPets()

		for i = 1, GetNumRaidMembers() do
			local XPRGPUB = _G["XPerl_Raid_GrpPetsUnitButton"..i]
			if XPRGPUB and not XPRGPUB.skinned then
				Skinner:applySkin(XPRGPUB)
				XPRGPUB.skinned = true
			end
		end

	end

	skinRaidPets()
	self:SecureHook("XPerl_RaidPets_Titles", skinRaidPets)

end

function Skinner:XPerl_RaidAdmin()
--	self:Debug("XPerl_RaidAdmin")

	self:applySkin(XPerl_AdminFrame)

end

function Skinner:XPerl_RaidHelper()
--	self:Debug("XPerl_RaidHelper")

	local function skinTanks()

		for i = 1, XPerlConfigHelper.MaxMainTanks do
			local MTTUB = _G["XPerl_MTTargetsUnitButton"..i]
			if MTTUB and not MTTUB.skinned then
				Skinner:applySkin(MTTUB)
				Skinner:applySkin(_G[MTTUB:GetName().."Target"])
				Skinner:applySkin(_G[MTTUB:GetName().."TargetTarget"])
				MTTUB.skinned = true
			end
		end

	end

	self:applySkin(XPerl_Frame)
	self:applySkin(XPerl_Assists_Frame)
	self:applySkin(XPerl_Target_AssistFrame)
	self:moveObject(XPerl_Target_AssistFrame, nil, nil, "+", 1)

	if not XPerl_Player_TargettingFrame.skinned then
		self:applySkin(XPerl_Player_TargettingFrame)
		self:Hook(XPerl_Player_TargettingFrame, "SetBackdropColor", function() end, true)
		self:Hook(XPerl_Player_TargettingFrame, "SetBackdropBorderColor", function() end, true)
		XPerl_Player_TargettingFrame.skinned = true
		-- these should only be done once as well
		skinTanks()
		self:SecureHook("XPerl_MTRosterChanged", skinTanks)
		if self.db.profile.Tooltips.skin then
			self:skinTooltip(XPerl_BottomTip)
			if self.db.profile.Tooltips.style == 3 then XPerl_BottomTip:SetBackdrop(self.backdrop) end
		end
	end

end

function Skinner:XPerl_RaidMonitor()
--	self:Debug("XPerl_RaidMonitor")

	self:applySkin(XPerl_RaidMonitor_Frame)

end

function Skinner:XPerl_GrimReaper()
--	self:Debug("XPerl_GrimReaper")

	self:SecureHook(XPerl_GrimReaper, "Tip", function()
		self:applySkin(XPerl_GrimReaper_Attachment)
		self:Unhook(XPerl_GrimReaper, "Tip")
	end)

end

function Skinner:XPerl_Options()
--	self:Debug("XPerl_Options")

-->>--	Texture Select Frame
	self:removeRegions(XPerl_Options_TextureSelectscrollBar)
	self:skinScrollBar(XPerl_Options_TextureSelectscrollBar)
	self:applySkin(XPerl_Options_TextureSelect)
	self:Hook(XPerl_Options_TextureSelect, "SetBackdropBorderColor", function() end, true)
-->>--	Options Question Dialog
	self:applySkin(XPerl_OptionsQuestionDialog)
	self:Hook(XPerl_OptionsQuestionDialog, "SetBackdropBorderColor", function() end, true)
-->>-- Tooltip Config	
	self:applySkin(XPerl_Options_TooltipConfig)
	self:Hook(XPerl_Options_TooltipConfig, "SetBackdropBorderColor", function() end, true)

	self:applySkin(XPerl_Party_AnchorVirtual)
	self:Hook(XPerl_Party_AnchorVirtual, "SetBackdropBorderColor", function() end, true)
	
-->>-- Options Frame
	self:applySkin(XPerl_Options)
	self:Hook(XPerl_Options, "SetBackdropBorderColor", function() end, true)
	
	self:skinDropDown(XPerl_Options_DropDown_LoadSettings)
	self:applySkin(XPerl_Options_Area_Align)
	self:skinEditBox(XPerl_Options_Layout_Name, {9})
	self:applySkin(XPerl_Options_Layout_List)
	self:removeRegions(XPerl_Options_Layout_ListScrollBar)
	self:skinScrollBar(XPerl_Options_Layout_ListScrollBar)
	self:applySkin(XPerl_Options_Area_Global)
	self:applySkin(XPerl_Options_Area_Tabs)
	
	XPerl_Options_Player_Gap:SetWidth(XPerl_Options_Player_Gap:GetWidth() - 10)
	self:moveObject(XPerl_Options_Player_Gap, "-", 10, nil, nil)
	self:moveObject(XPerl_Options_Player_BiggerGap, "+", 4, nil, nil)
	self:skinEditBox(XPerl_Options_Player_Gap, {9})
	self:applySkin(XPerl_Options_Player)
	self:skinDropDown(XPerl_Options_Party_Anchor)
	self:moveObject(XPerl_Options_Party_Gap, "-", 6, nil, nil)
	self:moveObject(XPerl_Options_Party_BiggerGap, "+", 6, nil, nil)
	self:skinEditBox(XPerl_Options_Party_Gap, {9})
	self:applySkin(XPerl_Options_Party)
	self:skinDropDown(XPerl_Options_Raid_Anchor)
	XPerl_Options_Raid_Gap:SetWidth(XPerl_Options_Raid_Gap:GetWidth() - 10)
	self:moveObject(XPerl_Options_Raid_Gap, "-", 10, nil, nil)
	self:moveObject(XPerl_Options_Raid_BiggerGap, "+", 4, nil, nil)
	self:skinEditBox(XPerl_Options_Raid_Gap, {9})
	self:applySkin(XPerl_Options_Raid)
-->>-- Colour Picker Frame	
	self:applySkin(XPerl_ColourPicker)

	XPerl_Options_Global_Options_RangeFinderSeparator:Hide()
-->-- Player Options
	self:applySkin(XPerl_Options_Player_Options_Buffs)
	self:applySkin(XPerl_Options_Player_Options_Totems)
-->-- Pet Options
	self:applySkin(XPerl_Options_Pet_Options_PetTarget)
-->-- Target Options
	self:applySkin(XPerl_Options_Target_Options_TargetTarget)
-->-- Focus Options
	self:applySkin(XPerl_Options_Focus_Options_FocusTarget)
-->	-- Party Options
	self:applySkin(XPerl_Options_Party_Options_PartyPets)
-->-- Raid Options
	self:applySkin(XPerl_Options_Raid_Options_Groups)
	self:moveObject(XPerl_Options_Raid_Options_Custom_Alpha, "-", 20, nil, nil)
	self:applySkin(XPerl_Options_Raid_Options_Custom)
-->-- All Options	
	self:applySkin(XPerl_Options_All_Options_AddOns)
-->-- Colour Options
	self:applySkin(XPerl_Options_Colour_Options_BarColours)
	self:applySkin(XPerl_Options_Colour_Options_UnitReactions)
	self:applySkin(XPerl_Options_Colour_Options_Appearance)
	self:applySkin(XPerl_Options_Colour_Options_FrameColours)

end
