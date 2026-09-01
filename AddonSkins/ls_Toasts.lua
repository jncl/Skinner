local _, aObj = ...
if not aObj:isAddonEnabled("ls_Toasts")
and not aObj:isAddonEnabled("ls_Toasts_Classic")
then
	return
end
local _G = _G


local function skinToasts(addonName)

	local vc
	local function getColour(obj)
		vc = {obj["TOP"]:GetVertexColor()}
		vc[1] = _G.Round(vc[1])
		vc[2] = _G.Round(vc[2])
		vc[3] = _G.Round(vc[3])
		vc[4] = 1
		return vc
	end

	_G[addonName][1].RegisterCallback("ls_Toasts", "ToastSpawned", function(_, toast)
		toast.BG:SetTexture(nil)
		toast.TextBG:SetTexture(nil)
		for _, tex in _G.pairs{"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"} do
			toast.Border[tex]:SetTexture(nil)
			toast.IconBorder[tex]:SetTexture(nil)
		end
		aObj:skinObject("frame", {obj=toast, ofs=3, clr=_G.unpack(getColour(toast.Border))})
		-- handle in combat
		if not _G.InCombatLockdown() then
			for i = 1, #toast.Leaves do
				toast.Leaves[i]:SetParent(toast.sf)
				toast.Leaves[i]:SetDrawLayer("OVERLAY")
			end
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=toast.IconParent, relTo=toast.Icon, reParent={toast.Dragon}}
			toast.Dragon:SetDrawLayer("OVERLAY")
			if not _G.InCombatLockdown() then
				if toast.IconBorder then
					if toast.IconBorder["TOP"]:IsShown() then
						toast.IconParent.sbb:SetBackdropBorderColor(_G.unpack(getColour(toast.IconBorder)))
						toast.IconParent.sbb:Show()
					else
						toast.IconParent.sbb:Hide()
					end
				else
					toast.IconParent.sbb:Hide()
				end
			end
		end
	end)

	-- Config
	aObj.RegisterCallback("ls_Toasts", "SettingsPanel_DisplayCategory", function(_, panel)
		if panel ~= _G.LSToastsConfigPanel
		or aObj.spSkinnedPanels[panel]
		then
			return
		end
		aObj.spSkinnedPanels[panel] = true
		aObj:skinStdButton{obj=aObj:getChild(_G.LSToastsConfigPanel, 1)}

		aObj.UnregisterCallback("ls_Toasts", "SettingsPanel_DisplayCategory")
	end)

end

aObj.addonsToSkin.ls_Toasts = function(_) -- v 120100.01

	skinToasts("ls_Toasts")

end

aObj.addonsToSkin.ls_Toasts_Classic = function(_) -- v 20506.01

	skinToasts("ls_Toasts_Classic")

end
