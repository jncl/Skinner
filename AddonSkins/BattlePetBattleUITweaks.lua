local _, aObj = ...
if not aObj:isAddonEnabled("BattlePetBattleUITweaks") then return end
local _G = _G

aObj.addonsToSkin.BattlePetBattleUITweaks = function(self) -- v 2.0.2

	local pbf = _G.PetBattleFrame

	local function skinElements()
		-- reparent RoundTitle
		aObj:getRegion(pbf, pbf:GetNumRegions()):SetParent(pbf.sfm)
		-- skin stats
		for _, child in _G.pairs{pbf.ActiveAlly:GetChildren()} do
			if _G.Round(child:GetWidth()) == 16 then
				child.back:SetTexture(nil)
			end
		end
		for _, child in _G.pairs{pbf.ActiveEnemy:GetChildren()} do
			if _G.Round(child:GetWidth()) == 16 then
				child.back:SetTexture(nil)
			end
		end
	end
	if self.prdb.PetBattleUI then
		if self:IsHooked(pbf, "OnShow") then
			self.RegisterCallback("BattlePetBattleUITweaks", "PetBattleUI_OnShow", function(_)
				skinElements()

				self.UnregisterCallback("BattlePetBattleUITweaks", "PetBattleUI_OnShow")
			end)
		else
			skinElements()
		end
	end

	-- skin abilities buttons
	self.RegisterCallback("BattlePetBattleUITweaks", "UIParent_GetChildren", function(this, child)
		if child.vulnerabilities
		and child.buttons
		then
			for _, btn in _G.pairs(child.buttons) do
				btn.back:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, reParent={btn.hint}, ofs=-1, clr="gold"}
				end
			end

			self.UnregisterCallback("BattlePetBattleUITweaks", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

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
