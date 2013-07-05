local aName, aObj = ...
if not aObj:isAddonEnabled("PetBattleHUD") then return end
local _G = _G

function aObj:PetBattleHUD()

	if not (IsAddOnLoaded("Tukui")
	or IsAddOnLoaded("AsphyxiaUI")
	or IsAddOnLoaded("DuffedUI")
	or IsAddOnLoaded("ElvUI"))
	then
		return
	end
	
	local rtEvt
	local function hideSkinnerPBF()
		if _G.PetBattleFrame.sfl then
			aObj:CancelTimer(rtEvt, true)
			rtEvt = nil
			-- Hide Skinner added frames
			_G.PetBattleFrame.sfl:Hide()
			_G.PetBattleFrame.sfm:Hide()
			_G.PetBattleFrame.sfr:Hide()
			_G.PetBattleFrame.BottomFrame.sf:Hide()
		end
	end
	rtEvt = self:ScheduleRepeatingTimer(hideSkinnerPBF, 0.2)
	
end
