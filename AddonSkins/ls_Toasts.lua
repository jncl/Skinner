local _, aObj = ...
if not aObj:isAddonEnabled("ls_Toasts") then return end
local _G = _G

function aObj:ls_Toasts() -- v 100100.03

	-- do return end

	local function getColour(obj)
		local vc = {obj["TOP"]:GetVertexColor()}
		vc[1] = aObj:round2(vc[1], 5)
		vc[2] = aObj:round2(vc[2], 5)
		vc[3] = aObj:round2(vc[3], 5)
		vc[4] = 1
		return vc
	end
	local toast_E = _G.ls_Toasts[1]
	toast_E.RegisterCallback("ls_Toasts", "ToastSpawned", function(_, toast)
		toast.BG:SetTexture(nil)
		toast.TextBG:SetTexture(nil)
		for _, tex in _G.pairs{"TOPLEFT", "TOPRIGHT", "BOTTOMLEFT", "BOTTOMRIGHT", "TOP", "BOTTOM", "LEFT", "RIGHT"} do
			toast.Border[tex]:SetTexture(nil)
			toast.IconBorder[tex]:SetTexture(nil)
		end
		aObj:skinObject("frame", {obj=toast, ofs=3})
		for i = 1, #toast.Leaves do
			toast.Leaves[i]:SetParent(toast.sf)
			toast.Leaves[i]:SetDrawLayer("OVERLAY")
		end
		toast.sf:SetBackdropBorderColor(_G.unpack(getColour(toast.Border)))
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=toast.IconParent, relTo=toast.Icon, reParent={toast.Dragon}}
			toast.Dragon:SetDrawLayer("OVERLAY")
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
	end)

	-- Config
	self.iofDD["LSToastsConfigPanelDirectionDropDown"] = 110

	if self.modBtns then
		self:skinStdButton{obj=self:getChild(_G.LSTConfigPanel, 1)}
	end

end
