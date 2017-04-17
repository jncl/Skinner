local aName, aObj = ...
if not aObj:isAddonEnabled("ls_Toasts") then return end
local _G = _G

function aObj:ls_Toasts()

	local toast_F = _G.unpack(_G.ls_Toasts)
	function toast_F:SkinToast(toast, toastType)

		toast.BG:SetTexture(nil)
		aObj:addSkinFrame{obj=toast, ofs=-1}
		toast.Border:SetAlpha(0)
		local bc = {toast.Border:GetVertexColor()}
		bc[1] = aObj:round2(bc[1], 5)
		bc[2] = aObj:round2(bc[2], 5)
		bc[3] = aObj:round2(bc[3], 5)
		toast.sf:SetBackdropBorderColor(bc[1], bc[2], bc[3], 1)

		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=toast, relTo=toast.Icon}

			if toast.IconBorder then
				toast.IconBorder:SetAlpha(0)
				if toast.IconBorder:IsShown() then
					toast.sbb:SetBackdropBorderColor(bc[1], bc[2], bc[3], 1)
					toast.sbb:Show()
				else
					-- set Icon ButtonBorder to default
					toast.sbb:SetBackdropBorderColor(aObj.bbColour[1], aObj.bbColour[2], aObj.bbColour[3], aObj.bbColour[4])
					toast.sbb:Hide()
				end
			else
				toast.sbb:Hide()
			end
		end

		bc = nil

	end
	
	-- Config
	self.iofDD["LSToastsConfigPanelDirectionDropDown"] = 110

end
