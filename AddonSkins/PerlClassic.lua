
local barSuffixes = {"", "FadeBar", "BG"}
local hmSuffixes = {"Health", "Mana"}
local hmdSuffixes = CopyTable(hmSuffixes) table.insert(hmdSuffixes, "Druid")
local hmphSuffixes = CopyTable(hmSuffixes) table.insert(hmphSuffixes, "PetHealth")
local nsSuffixes = {"Name", "Stats"}
local nspSuffixes = CopyTable(nsSuffixes) table.insert(nspSuffixes, "Portrait")
local nsplSuffixes = CopyTable(nspSuffixes) table.insert(nsplSuffixes, "Level")

local function changeBBC(frame)

	local r, g, b, a = frame:GetBackdropBorderColor()
	r, g, b, a = string.sub(r, 2, 3), string.sub(g, 2, 3), string.sub(b, 2, 3), math.ceil(a)
--	Skinner:Debug("changeBBC: [%s, %s, %s, %s, %s]", frame:GetName(), r, g, b, a)
	if r == ".5" and g == ".5" and b == ".5" and a == 1 then
--		Skinner:Debug("changeBBC match")
		frame:SetBackdropBorderColor(unpack(Skinner.bbColour))
	end

end

function Skinner:Perl_CombatDisplay()
--	self:Debug("Perl_CombatDisplay")

	self:applySkin(Perl_CombatDisplay_ManaFrame)
	self:applySkin(Perl_CombatDisplay_Target_ManaFrame)

	local combatdisplayframes = CopyTable(hmdSuffixes)
	table.insert(combatdisplayframes, "CP")
	table.insert(combatdisplayframes, "PetHealth")
	table.insert(combatdisplayframes, "PetMana")
	table.insert(combatdisplayframes, "Target_Health")
	table.insert(combatdisplayframes, "Target_Mana")
	for _, b in pairs(combatdisplayframes) do
		for _, t in pairs(barSuffixes) do
			local bName = _G["Perl_CombatDisplay_"..b.."Bar"..t]
			self:glazeStatusBar(bName)
		end
	end

	if not self:IsHooked("Perl_CombatDisplay_Buff_UpdateAll") then
		self:SecureHook("Perl_CombatDisplay_Buff_UpdateAll", function(unit, frame)
--			self:Debug("Perl_CombatDisplay_Buff_UpdateAll")
			changeBBC(frame)
		end)
	end

	if not self:IsHooked("Perl_CombatDisplay_Initialize_Frame_Color") then
		self:SecureHook("Perl_CombatDisplay_Initialize_Frame_Color", function()
-- 			self:Debug("Perl_CombatDisplay_Initialize_Frame_Color")
			self:applySkin(Perl_CombatDisplay_ManaFrame)
			self:applySkin(Perl_CombatDisplay_Target_ManaFrame)
		end)
	end

end

function Skinner:Perl_Focus()
--	self:Debug("Perl_Focus")

	local focusframes = CopyTable(nsplSuffixes)
	table.insert(focusframes, "ClassName")
	table.insert(focusframes, "Civilian")
	table.insert(focusframes, "RareElite")
	for _, f in pairs(focusframes) do
		self:applySkin(_G["Perl_Focus_"..f.."Frame"])
	end
	self:applySkin(Perl_Focus_BuffFrame)
	self:applySkin(Perl_Focus_DebuffFrame)
	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			self:glazeStatusBar(_G["Perl_Focus_"..b.."Bar"..t])
		end
	end
	self:glazeStatusBar(Perl_Focus_NameFrame_CPMeter)
	self:glazeStatusBar(Perl_ArcaneBar_focus)

	RaiseFrameLevel(Perl_Focus_Name)

	if not self:IsHooked("Perl_Focus_Buff_UpdateAll") then
		self:SecureHook("Perl_Focus_Buff_UpdateAll", function()
--			self:Debug("Perl_Focus_Buff_UpdateAll")
			for _, f in pairs(focusframes) do
				changeBBC(_G["Perl_Focus_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Focus_Initialize_Frame_Color") then
		self:SecureHook("Perl_Focus_Initialize_Frame_Color", function()
--			self:Debug("Perl_Focus_Initialize_Frame_Color")
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

	self:glazeStatusBar(Perl_Party_Target5_HealthBar)
	self:glazeStatusBar(Perl_Party_Target5_ManaBar)

end

function Skinner:Perl_Party()
--	self:Debug("Perl_Party")

	local partyframes = nsplSuffixes
	for i = 1, 4 do
		for _, f in pairs(partyframes) do
			self:applySkin(_G["Perl_Party_MemberFrame"..i.."_"..f.."Frame"])
		end
		for _, b in pairs(hmphSuffixes) do
			for _, t in pairs(barSuffixes) do
				self:glazeStatusBar(_G["Perl_Party_MemberFrame"..i.."_"..b.."Bar"..t])
			end
		end
		local AbName = _G["Perl_ArcaneBar_party"..i]
		self:glazeStatusBar(AbName)
	end

	if not self:IsHooked("Perl_Party_Buff_UpdateAll") then
		self:SecureHook("Perl_Party_Buff_UpdateAll", function(this)
--			self:Debug("Perl_Party_Buff_UpdateAll: [%s]", this.id)
			for _, f in pairs(partyframes) do
				changeBBC(_G["Perl_Party_MemberFrame"..this.id.."_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Party_Initialize_Frame_Color") then
		self:SecureHook("Perl_Party_Initialize_Frame_Color", function()
-- 			self:Debug("Perl_Party_Initialize_Frame_Color")
			for i = 1, 4 do
				for _, f in pairs(partyframes) do
					self:applySkin(_G["Perl_Party_MemberFrame"..i.."_"..f.."Frame"])
				end
			end
		end)
	end

end

function Skinner:Perl_Party_Pet()
--	self:Debug("Perl_Party_Pet")

	local partypetframes = nspSuffixes
	for i = 1, 4 do
		for _, f in pairs(partypetframes) do
			self:applySkin(_G["Perl_Party_Pet"..i.."_"..f.."Frame"])
		end
		for _, b in pairs(hmSuffixes) do
			for _, t in pairs(barSuffixes) do
				self:glazeStatusBar(_G["Perl_Party_Pet"..i.."_"..b.."Bar"..t])
			end
		end
	end

	if not self:IsHooked("Perl_Party_Pet_Buff_UpdateAll") then
		self:SecureHook("Perl_Party_Pet_Buff_UpdateAll", function(unit)
--			self:Debug("Perl_Party_Pet_Buff_UpdateAll: [%s]", unit)
			local id = string.sub(unit, 9, 9)
			for _, f in pairs(partypet) do
				changeBBC(_G["Perl_Party_Pet"..id.."_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Party_Pet_Initialize_Frame_Color") then
		self:SecureHook("Perl_Party_Pet_Initialize_Frame_Color", function()
--			self:Debug("Perl_Party_Pet_Initialize_Frame_Color")
			for i = 1, 4 do
				for _, f in pairs(partypetframes) do
					self:applySkin(_G["Perl_Party_Pet"..i.."_"..f.."Frame"])
				end
			end
		end)
	end

end

function Skinner:Perl_Party_Target()
--	self:Debug("Perl_Party_Target")

	local partytargetframes = nsSuffixes
	for i = 1, 4 do
		for _, f in pairs(partytargetframes) do
			self:applySkin(_G["Perl_Party_Target"..i.."_"..f.."Frame"])
		end
		for _, b in pairs(hmSuffixes) do
			for _, t in pairs(barSuffixes) do
				self:glazeStatusBar(_G["Perl_Party_Target"..i.."_"..b.."Bar"..t])
			end
		end
	end

	if not self:IsHooked("Perl_Party_Target_Update_Buffs") then
		self:SecureHook("Perl_Party_Target_Update_Buffs", function(this)
-- 			self:Debug("Perl_Party_Target_Update_Buffs")
			changeBBC(this.nameFrame)
			changeBBC(this.statsFrame)
		end)
	end

	if not self:IsHooked("Perl_Party_Target_Initialize_Frame_Color") then
		self:SecureHook("Perl_Party_Target_Initialize_Frame_Color", function()
--			self:Debug("Perl_Party_Target_Initialize_Frame_Color")
			for i = 1, 4 do
				for _, f in pairs(partytargetframes) do
					self:applySkin(_G["Perl_Party_Target"..i.."_"..f.."Frame"])
				end
			end
		end)
	end

end

function Skinner:Perl_Player()
--	self:Debug("Perl_Player")

	local partyframes = CopyTable(nsplSuffixes)
	table.insert(partyframes, "RaidGroupNumber")
	for _, f in pairs(partyframes) do
		self:applySkin(_G["Perl_Player_"..f.."Frame"])
	end

	for _, b in pairs(hmdSuffixes) do
		for _, t in pairs(barSuffixes) do
			self:glazeStatusBar(_G["Perl_Player_"..b.."Bar"..t])
		end
	end
	self:glazeStatusBar(Perl_Player_XPBar)
	self:glazeStatusBar(Perl_Player_XPBarBG)
	self:glazeStatusBar(Perl_Player_XPRestBar)
	self:glazeStatusBar(Perl_Player_EnergyTicker)
	self:glazeStatusBar(Perl_ArcaneBar_player)

	if not self:IsHooked("Perl_Player_BuffUpdateAll") then
		self:SecureHook("Perl_Player_BuffUpdateAll", function()
--			self:Debug("Perl_Focus_Buff_UpdateAll")
			for _, f in pairs(partyframes) do
				changeBBC(_G["Perl_Player_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Player_Initialize_Frame_Color") then
		self:SecureHook("Perl_Player_Initialize_Frame_Color", function()
--			self:Debug("Perl_Player_Initialize_Frame_Color")
			for _, f in pairs(partyframes) do
				self:applySkin(_G["Perl_Player_"..f.."Frame"])
			end
		end)
	end

end

function Skinner:Perl_Player_Pet()
--	self:Debug("Perl_Player_Pet")

	local playerpetframes = nsplSuffixes
	for _, f in pairs(playerpetframes) do
		self:applySkin(_G["Perl_Player_Pet_"..f.."Frame"])
	end
	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			self:glazeStatusBar(_G["Perl_Player_Pet_"..b.."Bar"..t])
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
--			self:Debug("Perl_Player_Pet_Target_OnUpdate")
			changeBBC(Perl_Player_Pet_Target_NameFrame)
			changeBBC(Perl_Player_Pet_Target_StatsFrame)
			end)
	end

	if not self:IsHooked("Perl_Player_Pet_Initialize_Frame_Color") then
		self:SecureHook("Perl_Player_Pet_Initialize_Frame_Color", function()
--			self:Debug("Perl_Player_Pet_Initialize_Frame_Color")
			for _, f in pairs(playerpetframes) do
				self:applySkin(_G["Perl_Player_Pet_"..f.."Frame"])
			end
			self:applySkin(Perl_Player_Pet_Target_NameFrame)
			self:applySkin(Perl_Player_Pet_Target_StatsFrame)
		end)
	end

end

function Skinner:Perl_Target()
--	self:Debug("Perl_Target")

	local targetframes = CopyTable(nsplSuffixes)
	table.insert(targetframes, "ClassName")
	table.insert(targetframes, "Guild")
	table.insert(targetframes, "RareElite")
	table.insert(targetframes, "CP")
	for _, f in pairs(targetframes) do
		self:applySkin(_G["Perl_Target_"..f.."Frame"])
	end
	self:applySkin(Perl_Target_BuffFrame)
	self:applySkin(Perl_Target_DebuffFrame)
	for _, b in pairs(hmSuffixes) do
		for _, t in pairs(barSuffixes) do
			self:glazeStatusBar(_G["Perl_Target_"..b.."Bar"..t])
		end
	end
	self:glazeStatusBar(Perl_Target_NameFrame_CPMeter)
	self:glazeStatusBar(Perl_ArcaneBar_target)

	RaiseFrameLevel(Perl_Target_Name)

	if not self:IsHooked("Perl_Target_Buff_UpdateAll") then
		self:SecureHook("Perl_Target_Buff_UpdateAll", function()
--			self:Debug("Perl_Target_Buff_UpdateAll")
			for _, f in pairs(targetframes) do
				changeBBC(_G["Perl_Target_"..f.."Frame"])
			end
		end)
	end

	if not self:IsHooked("Perl_Target_Initialize_Frame_Color") then
		self:SecureHook("Perl_Target_Initialize_Frame_Color", function()
--			self:Debug("Perl_Target_Initialize_Frame_Color")
			for _, f in pairs(targetframes) do
				self:applySkin(_G["Perl_Target_"..f.."Frame"])
			end
			self:applySkin(Perl_Target_BuffFrame)
			self:applySkin(Perl_Target_DebuffFrame)
		end)
	end

end

function Skinner:Perl_Target_Target()
--	self:Debug("Perl_Target_Target")

	local targettargetframes = CopyTable(hmSuffixes)
	table.insert(targettargetframes, "Target_Health")
	table.insert(targettargetframes, "Target_Mana")
	for _, b in pairs(targettargetframes) do
		for _, t in pairs(barSuffixes) do
			self:glazeStatusBar(_G["Perl_Target_Target_"..b.."Bar"..t])
		end
	end

	self:applySkin(Perl_Target_Target_NameFrame)
	self:applySkin(Perl_Target_Target_StatsFrame)

	if not self:IsHooked("Perl_Target_Target_Update_Buffs") then
		self:SecureHook("Perl_Target_Target_Update_Buffs", function()
--			self:Debug("Perl_Target_Target_Update_Buffs")
			changeBBC(Perl_Target_Target_NameFrame)
			changeBBC(Perl_Target_Target_StatsFrame)
		end)
	end

-- TargetTarget Target
	self:applySkin(Perl_Target_Target_Target_NameFrame)
	self:applySkin(Perl_Target_Target_Target_StatsFrame)

	if not self:IsHooked("Perl_Target_Target_Target_Update_Buffs") then
		self:SecureHook("Perl_Target_Target_Target_Update_Buffs", function()
--			self:Debug("Perl_Target_Target_Target_Update_Buffs")
			changeBBC(Perl_Target_Target_Target_NameFrame)
			changeBBC(Perl_Target_Target_Target_StatsFrame)
			end)
	end

	if not self:IsHooked("Perl_Target_Target_Initialize_Frame_Color") then
		self:SecureHook("Perl_Target_Target_Initialize_Frame_Color", function()
--			self:Debug("Perl_Target_Target_Initialize_Frame_Color")
			self:applySkin(Perl_Target_Target_NameFrame)
			self:applySkin(Perl_Target_Target_StatsFrame)
			self:applySkin(Perl_Target_Target_Target_NameFrame)
			self:applySkin(Perl_Target_Target_Target_StatsFrame)
		end)
	end

end

function Skinner:Perl_Config_Options()

	self:Hook("Perl_Config_Set_Background", function() end, true)

--Config
	Perl_Config_Header:Hide()
	self:moveObject(Perl_Config_Header, nil, nil, "-", 6)
	Perl_Config_NotInstalled_Header:Hide()
	Perl_Config_All_Header:Hide()
	self:keepFontStrings(Perl_Config_All_Frame_DropDown1)
	Perl_Config_ArcaneBar_Header:Hide()
	Perl_Config_CombatDisplay_Header:Hide()
	Perl_Config_Focus_Header:Hide()
	Perl_Config_Party_Header:Hide()
	Perl_Config_Party_Pet_Header:Hide()
	Perl_Config_Party_Target_Header:Hide()
	Perl_Config_Player_Header:Hide()
	Perl_Config_Player_Buff_Header:Hide()
	Perl_Config_Player_Pet_Header:Hide()
	Perl_Config_Target_Header:Hide()
	Perl_Config_Target_Target_Header:Hide()

	self:applySkin(Perl_Config_Frame)

end
