local _, aObj = ...
if not aObj:isAddonEnabled("BattlePetBattleUITweaks") then return end
local _G = _G

aObj.addonsToSkin.BattlePetBattleUITweaks = function(self) -- v 2.0.4

	local function skinElements()
		if _G.BattlePetBattleUITweaksSettings.RoundCounter
		and _G.PetBattleFrame.sfm
		then
			_G._BattlePetBattleUITweaks.round.roundTitle:SetParent(_G.PetBattleFrame.sfm)
		end
		if _G.BattlePetBattleUITweaksSettings.CurrentStats then
			for _, stat in _G.ipairs(_G._BattlePetBattleUITweaks.stats.stats) do
				stat.health.back:SetTexture(nil)
				stat.power.back:SetTexture(nil)
				stat.speed.back:SetTexture(nil)
			end
		end
		if _G.BattlePetBattleUITweaksSettings.EnemyAbilities then
			for _, btn in _G.pairs(_G._BattlePetBattleUITweaks.abilities.buttons) do
				btn.back:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=btn, reParent={btn.hint}, ofs=-1, clr="gold"}
				end
			end
		end
	end
	if self.prdb.PetBattleUI then
		if self:IsHooked(_G.PetBattleFrame, "OnShow") then
			self.RegisterCallback("BattlePetBattleUITweaks", "PetBattleUI_OnShow", function(_)
				skinElements()

				self.UnregisterCallback("BattlePetBattleUITweaks", "PetBattleUI_OnShow")
			end)
		else
			skinElements()
		end
	end

	-- skin config
	self.RegisterCallback("BattlePetBattleUITweaks", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Battle Pet UI Tweaks" then return end
		self.iofSkinnedPanels[panel] = true

		self:removeInset(panel.list)
		if self.modChkBtns then
			for _, btn in _G.pairs(panel.buttons) do
				btn:SetSize(26, 26)
				self:skinCheckButton{obj=btn}
			end
		end

		self.UnregisterCallback("BattlePetBattleUITweaks", "IOFPanel_Before_Skinning")
	end)

end
