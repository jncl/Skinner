local _, aObj = ...
if not aObj:isAddonEnabled("TinyTooltip") then return end
local _G = _G

aObj.addonsToSkin.TinyTooltip = function(self) -- v 8.2.1

	-- setup textures and colours
	_G.TinyTooltip.db.general.bgfile           = self.bdTexName
	_G.TinyTooltip.db.general.borderCorner     = self.bdbTexName
	_G.TinyTooltip.db.general.borderSize       = self.prdb.BdEdgeSize
	_G.TinyTooltip.db.general.borderColor      = {self.tbClr:GetRGBA()}
	_G.TinyTooltip.db.general.background       = {self.bClr:GetRGBA()}
	_G.TinyTooltip.db.general.statusbarTexture = self.sbTexture
	_G.TinyTooltip.db.spell.borderColor        = {self.tbClr:GetRGBA()}
	_G.TinyTooltip.db.spell.background         = {self.bClr:GetRGBA()}

	local lEvent = _G.LibStub:GetLibrary("LibEvent.7000", true)
	lEvent:trigger("tooltip.statusbar.texture", _G.TinyTooltip.db.general.statusbarTexture)

	local function addGradient(tTip)
	    tTip.style.mask:SetShown(false)
		aObj:applyTooltipGradient(tTip.style)
	end
	-- hook this to handle gradient effect
	lEvent:attachTrigger("tooltip:show", function(_, tTip)
		addGradient(tTip)
	end)
	self.RegisterCallback("TinyTooltip", "Tooltip_Setup", function(_, tTip, type)
		if type == "init" then
			lEvent:trigger("tooltip.style.init", tTip)
		end
		lEvent:trigger("tooltip.scale", tTip, _G.TinyTooltip.db.general.scale)
		lEvent:trigger("tooltip.style.mask", tTip, _G.TinyTooltip.db.general.mask)
		lEvent:trigger("tooltip.style.bgfile", tTip, _G.TinyTooltip.db.general.bgfile)
		lEvent:trigger("tooltip.style.border.corner", tTip, _G.TinyTooltip.db.general.borderCorner)
		lEvent:trigger("tooltip.style.border.size", tTip, _G.TinyTooltip.db.general.borderSize)
		lEvent:trigger("tooltip.style.border.color", tTip, _G.unpack(_G.TinyTooltip.db.general.borderColor))
		lEvent:trigger("tooltip.style.background", tTip, _G.unpack(_G.TinyTooltip.db.general.background))
		addGradient(tTip)
	end)
	for _, tTip in _G.pairs(_G.TinyTooltip.tooltips) do
		self.callbacks:Fire("Tooltip_Setup", tTip)
	end

	-- find and skin the DropDown Frame
	self.RegisterCallback("TinyTooltip", "UIParent_GetChildren", function(_, child, _)
		if child:IsObjectType("Frame")
		and child.Bg
		and child.ScrollFrame
		and child.ListFrame
		then
			self:skinObject("slider", {obj=child.ScrollFrame.ScrollBar})
			child:DisableDrawLayer("BORDER")
			self:skinObject("frame", {obj=child, x2=2})
			self.UnregisterCallback("TinyTooltip", "UIParent_GetChildren")
		end
	end)

	-- skin Option panels
	local pCnt = 0
	self.RegisterCallback("TinyTooltip", "IOFPanel_Before_Skinning", function(_, panel, _)
		if panel.name == "TinyTooltip"
		or panel.parent == "TinyTooltip"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
			if panel:IsObjectType("ScrollFrame") then -- Player options are in a scroll child frame
				self:skinObject("slider", {obj=panel.ScrollBar})
				panel.ScrollBar:SetPoint("TOPLEFT", panel, "TOPRIGHT", -22, -22)
				panel.ScrollBar:SetPoint("BOTTOMLEFT", panel, "BOTTOMRIGHT", -22, 20)
				panel = panel:GetScrollChild()
			end
			for _, child in _G.ipairs{panel:GetChildren()} do
				if self:isDropDown(child) then
					self:skinObject("dropdown", {obj=child, x2=109})
				elseif child:IsObjectType("Slider") then
					self:skinObject("slider", {obj=child})
				elseif child:IsObjectType("CheckButton")
				and self.modChkBtns
				then
					self:skinCheckButton{obj=child}
				elseif child:IsObjectType("EditBox") then
					self:skinObject("editbox", {obj=child})
				elseif child:IsObjectType("Button")	then
					if not child.hasopacity  -- colorpick
					and not child.text -- DIY
					and self.modBtns
					then
						self:skinStdButton{obj=child}
					end
				elseif child:IsObjectType("Frame") then
					if child.anchorbutton then -- anchor
						self:skinObject("dropdown", {obj=child.dropdown, x2=109})
						if self.modBtns then
							self:skinStdButton{obj=child.anchorbutton}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=child.checkbox1}
							self:skinCheckButton{obj=child.checkbox2}
							self:skinCheckButton{obj=child.checkbox3}
						end
					elseif child.slider then -- dropdown slider
						self:skinObject("dropdown", {obj=child.dropdown, x2=109})
						self:skinObject("slider", {obj=child.slider})
					elseif child.checkbox then -- element
						child:SetBackdrop(nil)
						if self.modChkBtns then
							self:skinCheckButton{obj=child.checkbox}
						end
						if child.colorpick then -- colorpick
							_G.RaiseFrameLevel(child.colorpick)
							self:skinObject("dropdown", {obj=child.colordropdown, noBB=true, x2=109})
							child.colordropdown:SetPoint("LEFT", 200, -3)
						end
						if child.editbox then
							self:skinObject("editbox", {obj=child.editbox})
						end
						if child.filterdropdown then
							self:skinObject("dropdown", {obj=child.filterdropdown, x2=109})
						end
					end
				end
			end
		end
		if pCnt == 6 then
			self.UnregisterCallback("TinyTooltip", "IOFPanel_Before_Skinning")
		end
	end)

end
