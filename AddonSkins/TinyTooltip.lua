local _, aObj = ...
if not aObj:isAddonEnabled("TinyTooltip") then return end
local _G = _G

aObj.addonsToSkin.TinyTooltip = function(self) -- v 8.2.1

	-- prevent GameTooltip from changing Backdrop settings
	_G.GameTooltip.SetBackdrop            = _G.nop
	_G.GameTooltip.SetBackdropColor       = _G.nop
	_G.GameTooltip.SetBackdropBorderColor = _G.nop

	-- setup textures and colours
	_G.TinyTooltip.db.general.bgfile           = self.bdTexName
	_G.TinyTooltip.db.general.borderCorner     = self.bdbTexName
	_G.TinyTooltip.db.general.borderSize       = self.prdb.BdEdgeSize
	_G.TinyTooltip.db.general.background       = _G.CopyTable(self.bClr)
	_G.TinyTooltip.db.general.borderColor      = _G.CopyTable(self.tbClr)
	_G.TinyTooltip.db.general.statusbarTexture = self.sbTexture
	_G.TinyTooltip.db.spell.borderColor        = _G.CopyTable(self.tbClr)
	_G.TinyTooltip.db.spell.background         = _G.CopyTable(self.bClr)

	local LibEvent = _G.LibStub:GetLibrary("LibEvent.7000", true)
	local function addGradient(tTip)
	    tTip.style.mask:SetShown(false)
		-- apply a gradient texture
		if aObj.prdb.Tooltips.style == 1 then -- Rounded
			aObj:applyGradient(tTip.style, 32)
		elseif aObj.prdb.Tooltips.style == 2 then -- Flat
			aObj:applyGradient(tTip.style)
		elseif aObj.prdb.Tooltips.style == 3 then -- Custom
			aObj:applyGradient(tTip.style, aObj.prdb.FadeHeight.value <= _G.Round(tTip.style:GetHeight()) and aObj.prdb.FadeHeight.value or _G.Round(tTip.style:GetHeight()))
		end
	end
	-- hook this to handle gradient effect
	LibEvent:attachTrigger("tooltip:show", function(_, tTip)
		addGradient(tTip)
	end)
	self.RegisterMessage("TinyTooltip", "Tooltip_Setup", function(_, tTip, _)
		LibEvent:trigger("tooltip.style.bgfile", tTip, _G.TinyTooltip.db.general.bgfile)
		LibEvent:trigger("tooltip.style.border.corner", tTip, _G.TinyTooltip.db.general.borderCorner)
		LibEvent:trigger("tooltip.style.border.size", tTip, _G.TinyTooltip.db.general.borderSize)
		LibEvent:trigger("tooltip.style.border.color", tTip, _G.TinyTooltip.db.general.borderColor:GetRGBA())
		LibEvent:trigger("tooltip.style.background", tTip, _G.TinyTooltip.db.general.background:GetRGBA())
		LibEvent:trigger("tooltip.statusbar.texture", _G.TinyTooltip.db.general.statusbarTexture)
		addGradient(tTip)
	end)

	-- add addon skins' tooltips to tooltips table
	for _, tTip in _G.ipairs(self.ttList) do
		LibEvent:trigger("tooltip.style.init", tTip)
	end
	-- update existing tooltips
	for _, tTip in _G.pairs(_G.TinyTooltip.tooltips) do
		self:SendMessage("Tooltip_Setup", tTip)
	end

	-- find and skin the DropDown Frame
	self.RegisterMessage("TinyTooltip", "UIParent_GetChildren", function(_, child, _)
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
	self.RegisterMessage("TinyTooltip", "IOFPanel_Before_Skinning", function(_, panel, _)
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
			self.UnregisterMessage("TinyTooltip", "IOFPanel_Before_Skinning")
		end
	end)

end
