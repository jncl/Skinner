local aName, aObj = ...
if not aObj:isAddonEnabled("Perl_Config") then return end

local barSuffixes = {"", "FadeBar", "BG"}
local hmSuffixes = {"Health", "Mana"}
local hmdSuffixes = CopyTable(hmSuffixes) tinsert(hmdSuffixes, "Druid")
local hmphSuffixes = CopyTable(hmSuffixes) tinsert(hmphSuffixes, "PetHealth")
local nsSuffixes = {"Name", "Stats"}
local nspSuffixes = CopyTable(nsSuffixes) tinsert(nspSuffixes, "Portrait")
local nsplSuffixes = CopyTable(nspSuffixes) tinsert(nsplSuffixes, "Level")

local function changeBBC(frame)

	local r, g, b, a = frame:GetBackdropBorderColor()
	r, g, b, a = strsub(r, 2, 3), strsub(g, 2, 3), strsub(b, 2, 3), ceil(a)
	if r == ".5" and g == ".5" and b == ".5" and a == 1 then
		frame:SetBackdropBorderColor(unpack(aObj.bbColour))
	end

end

function aObj:Perl_CombatDisplay()

	self:applySkin(Perl_CombatDisplay_ManaFrame)
	self:applySkin(Perl_CombatDisplay_Target_ManaFrame)

	local combatdisplayframes = CopyTable(hmdSuffixes)
	tinsert(combatdisplayframes, "CP")
	tinsert(combatdisplayframes, "PetHealth")
	tinsert(combatdisplayframes, "PetMana")
	tinsert(combatdisplayframes, "Target_Health")
	tinsert(combatdisplayframes, "Target_Mana")
	for _, b in pairs(combatdisplayframes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_CombatDisplay_"..b.."Bar"..t]
			if bName then self:glazeStatusBar(bName) end
		end
	end

	if not self:IsHooked("Perl_CombatDisplay_Buff_UpdateAll") then
		self:SecureHook("Perl_CombatDisplay_Buff_UpdateAll", function(unit, frame)
			changeBBC(frame)
		end)
	end

	if not self:IsHooked("Perl_CombatDisplay_Initialize_Frame_Color") then
		self:SecureHook("Perl_CombatDisplay_Initialize_Frame_Color", function()
			self:applySkin(Perl_CombatDisplay_ManaFrame)
			self:applySkin(Perl_CombatDisplay_Target_ManaFrame)
		end)
	end

end

function aObj:Perl_Focus()

	local focusframes = CopyTable(nsplSuffixes)
	tinsert(focusframes, "ClassName")
	tinsert(focusframes, "Civilian")
	tinsert(focusframes, "RareElite")
	for _, f in pairs(focusframes) do
		self:applySkin(_G["Perl_Focus_"..f.."Frame"])
	end
	self:applySkin(Perl_Focus_BuffFrame)
	self:applySkin(Perl_Focus_DebuffFrame)
	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_Focus_"..b.."Bar"..t]
			if bName then self:glazeStatusBar(bName) end
		end
	end
	self:glazeStatusBar(Perl_Focus_NameFrame_CPMeter)
	if Perl_ArcaneBar_focus then self:glazeStatusBar(Perl_ArcaneBar_focus) end

	RaiseFrameLevel(Perl_Focus_Name)

	if not self:IsHooked("Perl_Focus_Buff_UpdateAll") then
		self:SecureHook("Perl_Focus_Buff_UpdateAll", function()
			for _, f in pairs(focusframes) do
				changeBBC(_G["Perl_Focus_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Focus_Initialize_Frame_Color") then
		self:SecureHook("Perl_Focus_Initialize_Frame_Color", function()
			for _, f in pairs(focusframes) do
				self:applySkin(_G["Perl_Focus_"..f.."Frame"])
			end
			self:applySkin(Perl_Focus_BuffFrame)
			self:applySkin(Perl_Focus_DebuffFrame)
		end)
	end

--Focus Target
	for _, f in pairs(nsSuffixes) do
		self:applySkin(_G["Perl_Party_Target5_"..f.."Frame"])
	end

	if Perl_Party_Target5_HealthBar then self:glazeStatusBar(Perl_Party_Target5_HealthBar) end
	if Perl_Party_Target5_ManaBar then self:glazeStatusBar(Perl_Party_Target5_ManaBar) end

end

function aObj:Perl_Party()

	local partyframes = nsplSuffixes
	for i = 1, 4 do
		for _, f in pairs(partyframes) do
			self:applySkin(_G["Perl_Party_MemberFrame"..i.."_"..f.."Frame"])
		end
		for _, b in pairs(hmphSuffixes) do
			for _, t in pairs(barSuffixes) do
				local bName = _G["Perl_Party_MemberFrame"..i.."_"..b.."Bar"..t]
				if bName then self:glazeStatusBar(bName) end
 			end
		end
		local AbName = _G["Perl_ArcaneBar_party"..i]
		if AbName then self:glazeStatusBar(AbName) end
	end

	if not self:IsHooked("Perl_Party_Buff_UpdateAll") then
		self:SecureHook("Perl_Party_Buff_UpdateAll", function(this)
			for _, f in pairs(partyframes) do
				changeBBC(_G["Perl_Party_MemberFrame"..this.id.."_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Party_Initialize_Frame_Color") then
		self:SecureHook("Perl_Party_Initialize_Frame_Color", function()
			for i = 1, 4 do
				for _, f in pairs(partyframes) do
					self:applySkin(_G["Perl_Party_MemberFrame"..i.."_"..f.."Frame"])
				end
			end
		end)
	end

end

function aObj:Perl_Party_Pet()

	local partypetframes = nspSuffixes
	for i = 1, 4 do
		for _, f in pairs(partypetframes) do
			self:applySkin(_G["Perl_Party_Pet"..i.."_"..f.."Frame"])
		end
		for _, b in pairs(hmSuffixes) do
			for _, t in pairs(barSuffixes) do
				local bName = _G["Perl_Party_Pet"..i.."_"..b.."Bar"..t]
				if bName then self:glazeStatusBar(bName) end
			end
		end
	end

	if not self:IsHooked("Perl_Party_Pet_Buff_UpdateAll") then
		self:SecureHook("Perl_Party_Pet_Buff_UpdateAll", function(unit)
			local id = strsub(unit, 9, 9)
			for _, f in pairs(partypetframes) do
				changeBBC(_G["Perl_Party_Pet"..id.."_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Party_Pet_Initialize_Frame_Color") then
		self:SecureHook("Perl_Party_Pet_Initialize_Frame_Color", function()
			for i = 1, 4 do
				for _, f in pairs(partypetframes) do
					self:applySkin(_G["Perl_Party_Pet"..i.."_"..f.."Frame"])
				end
			end
		end)
	end

end

function aObj:Perl_Party_Target()

	local partytargetframes = nsSuffixes
	for i = 1, 4 do
		for _, f in pairs(partytargetframes) do
			self:applySkin(_G["Perl_Party_Target"..i.."_"..f.."Frame"])
		end
		for _, b in pairs(hmSuffixes) do
			for _, t in pairs(barSuffixes) do
				local bName = _G["Perl_Party_Target"..i.."_"..b.."Bar"..t]
				if bName then self:glazeStatusBar(bName) end
			end
		end
	end

	if not self:IsHooked("Perl_Party_Target_Update_Buffs") then
		self:SecureHook("Perl_Party_Target_Update_Buffs", function(this)
			changeBBC(this.nameFrame)
			changeBBC(this.statsFrame)
		end)
	end

	if not self:IsHooked("Perl_Party_Target_Initialize_Frame_Color") then
		self:SecureHook("Perl_Party_Target_Initialize_Frame_Color", function()
			for i = 1, 4 do
				for _, f in pairs(partytargetframes) do
					self:applySkin(_G["Perl_Party_Target"..i.."_"..f.."Frame"])
				end
			end
		end)
	end

end

function aObj:Perl_Player()

	local partyframes = CopyTable(nsplSuffixes)
	tinsert(partyframes, "RaidGroupNumber")
	for _, f in pairs(partyframes) do
		self:applySkin(_G["Perl_Player_"..f.."Frame"])
	end

	for _, b in pairs(hmdSuffixes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_Player_"..b.."Bar"..t]
			if bName then self:glazeStatusBar(bName) end
		end
	end
	self:glazeStatusBar(Perl_Player_XPBar)
	self:glazeStatusBar(Perl_Player_XPBarBG)
	self:glazeStatusBar(Perl_Player_XPRestBar)
	self:glazeStatusBar(Perl_Player_FiveSecondRule)
	if Perl_ArcaneBar_player then self:glazeStatusBar(Perl_ArcaneBar_player) end

	if not self:IsHooked("Perl_Player_BuffUpdateAll") then
		self:SecureHook("Perl_Player_BuffUpdateAll", function()
			for _, f in pairs(partyframes) do
				changeBBC(_G["Perl_Player_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Player_Initialize_Frame_Color") then
		self:SecureHook("Perl_Player_Initialize_Frame_Color", function()
			for _, f in pairs(partyframes) do
				self:applySkin(_G["Perl_Player_"..f.."Frame"])
			end
		end)
	end

end

function aObj:Perl_Player_Pet()

	local playerpetframes = nsplSuffixes
	for _, f in pairs(playerpetframes) do
		self:applySkin(_G["Perl_Player_Pet_"..f.."Frame"])
	end
	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_Player_Pet_"..b.."Bar"..t]
			if bName then self:glazeStatusBar(bName) end
		end
	end

	self:glazeStatusBar(Perl_Player_Pet_XPBar)
	self:glazeStatusBar(Perl_Player_Pet_XPBarBG)

	if not self:IsHooked("Perl_Player_Pet_Buff_UpdateAll") then
		self:SecureHook("Perl_Player_Pet_Buff_UpdateAll", function()
--			self:Debug("Perl_Player_Pet_Buff_UpdateAll")
			for _, f in pairs(playerpetframes) do
				changeBBC(_G["Perl_Player_Pet_"..f.."Frame"])
			end
		end)
	end

-- Player Pet Target
	self:applySkin(Perl_Player_Pet_Target_NameFrame)
	self:applySkin(Perl_Player_Pet_Target_StatsFrame)

	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			self:glazeStatusBar(_G["Perl_Player_Pet_Target_"..b.."Bar"..t])
		end
	end

	if not self:IsHooked("Perl_Player_Pet_Target_OnUpdate") then
		self:SecureHook("Perl_Player_Pet_Target_OnUpdate", function()
			changeBBC(Perl_Player_Pet_Target_NameFrame)
			changeBBC(Perl_Player_Pet_Target_StatsFrame)
			end)
	end

	if not self:IsHooked("Perl_Player_Pet_Initialize_Frame_Color") then
		self:SecureHook("Perl_Player_Pet_Initialize_Frame_Color", function()
			for _, f in pairs(playerpetframes) do
				self:applySkin(_G["Perl_Player_Pet_"..f.."Frame"])
			end
			self:applySkin(Perl_Player_Pet_Target_NameFrame)
			self:applySkin(Perl_Player_Pet_Target_StatsFrame)
		end)
	end

end

function aObj:Perl_Target()

	local targetframes = CopyTable(nsplSuffixes)
	tinsert(targetframes, "ClassName")
	tinsert(targetframes, "Guild")
	tinsert(targetframes, "RareElite")
	tinsert(targetframes, "CP")
	for _, f in pairs(targetframes) do
		self:applySkin(_G["Perl_Target_"..f.."Frame"])
	end
	self:applySkin(Perl_Target_BuffFrame)
	self:applySkin(Perl_Target_DebuffFrame)
	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_Target_"..b.."Bar"..t]
			if bName then self:glazeStatusBar(bName) end
		end
	end
	self:glazeStatusBar(Perl_Target_NameFrame_CPMeter)
	if Perl_ArcaneBar_target then self:glazeStatusBar(Perl_ArcaneBar_target) end

	RaiseFrameLevel(Perl_Target_Name)

	if not self:IsHooked("Perl_Target_Buff_UpdateAll") then
		self:SecureHook("Perl_Target_Buff_UpdateAll", function()
			for _, f in pairs(targetframes) do
				changeBBC(_G["Perl_Target_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Target_Initialize_Frame_Color") then
		self:SecureHook("Perl_Target_Initialize_Frame_Color", function()
			for _, f in pairs(targetframes) do
				self:applySkin(_G["Perl_Target_"..f.."Frame"])
			end
			self:applySkin(Perl_Target_BuffFrame)
			self:applySkin(Perl_Target_DebuffFrame)
		end)
	end

end

function aObj:Perl_Target_Target()

	local targettargetframes = CopyTable(hmSuffixes)
	tinsert(targettargetframes, "Target_Health")
	tinsert(targettargetframes, "Target_Mana")
	for _, b in pairs(targettargetframes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_Target_Target_"..b.."Bar"..t]
			if bName then self:glazeStatusBar(bName) end
		end
	end

	self:applySkin(Perl_Target_Target_NameFrame)
	self:applySkin(Perl_Target_Target_StatsFrame)

	if not self:IsHooked("Perl_Target_Target_Update_Buffs") then
		self:SecureHook("Perl_Target_Target_Update_Buffs", function()
			changeBBC(Perl_Target_Target_NameFrame)
			changeBBC(Perl_Target_Target_StatsFrame)
		end)
	end

-- TargetTarget Target
	self:applySkin(Perl_Target_Target_Target_NameFrame)
	self:applySkin(Perl_Target_Target_Target_StatsFrame)

	if not self:IsHooked("Perl_Target_Target_Target_Update_Buffs") then
		self:SecureHook("Perl_Target_Target_Target_Update_Buffs", function()
			changeBBC(Perl_Target_Target_Target_NameFrame)
			changeBBC(Perl_Target_Target_Target_StatsFrame)
			end)
	end

	if not self:IsHooked("Perl_Target_Target_Initialize_Frame_Color") then
		self:SecureHook("Perl_Target_Target_Initialize_Frame_Color", function()
			self:applySkin(Perl_Target_Target_NameFrame)
			self:applySkin(Perl_Target_Target_StatsFrame)
			self:applySkin(Perl_Target_Target_Target_NameFrame)
			self:applySkin(Perl_Target_Target_Target_StatsFrame)
		end)
	end

end

function aObj:Perl_Config_Options()

	Perl_Config_Set_Background = function() end

--Config
	Perl_Config_Header:Hide()
	self:moveObject{obj=Perl_Config_Header, y=-6}
	Perl_Config_NotInstalled_Header:Hide()
	-- All
	Perl_Config_All_Header:Hide()
	self:skinDropDown{obj=Perl_Config_All_Frame_DropDown1}
	self:skinAllButtons{obj=Perl_Config_All_Frame}
	-- ArcaneBar
	Perl_Config_ArcaneBar_Header:Hide()
	-- CombatDisplay
	Perl_Config_CombatDisplay_Header:Hide()
	self:skinAllButtons{obj=Perl_Config_CombatDisplay_Frame}
	-- Focus
	Perl_Config_Focus_Header:Hide()
	-- Focus/Party Target
	Perl_Config_Party_Target_Header:Hide()
	self:skinAllButtons{obj=Perl_Config_Party_Target_Frame}
	-- Party
	Perl_Config_Party_Header:Hide()
	-- PartyPet
	Perl_Config_Party_Pet_Header:Hide()
	self:skinAllButtons{obj=Perl_Config_Party_Pet_Frame}
	-- Player
	Perl_Config_Player_Header:Hide()
	-- PlayerBuff
	Perl_Config_Player_Buff_Header:Hide()
	-- PlayerPet
	Perl_Config_Player_Pet_Header:Hide()
	self:skinAllButtons{obj=Perl_Config_Player_Pet_Frame}
	-- Target
	Perl_Config_Target_Header:Hide()
	Perl_Config_Target_Target_Header:Hide()
	-- Target/Target
	self:skinAllButtons{obj=Perl_Config_Target_Target_Frame}
	-- Config Frame
	self:addSkinFrame{obj=Perl_Config_Frame}

end
