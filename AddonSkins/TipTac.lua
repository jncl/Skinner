local _, aObj = ...
if not aObj:isAddonEnabled("TipTac") then return end
local _G = _G

aObj.addonsToSkin.TipTac = function(self) -- v 25.08.14

	-- Anchor frame
	self:SecureHookScript(_G.TipTac, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=this.close, noSkin=true}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.TipTac)

	-- change Backdrop options
	_G.TipTac_Config.enableBackdrop = false
	_G.TipTac_Config.tipBackdropBG = "nil"
	_G.TipTac_Config.tipBackdropEdge = "nil"
	_G.TipTac_Config.backdropEdgeSize = self.prdb.BdEdgeSize
	_G.TipTac_Config.backdropInsets = self.prdb.BdInset
	_G.TipTac_Config.gradientTip = false
	_G.TipTac_Config.pixelPerfectBackdrop = false
	_G.TipTac:ApplyConfig()

end

aObj.lodAddons.TipTacOptions = function(self) -- v 25.08.14

	if self.prdb.DisabledSkins["TipTac"] then
		return
	end

	-- hook this to skin the dropdown menu (also used by Examiner skin)
	if not self:IsHooked(_G.AzDropDown, "ToggleMenu") then
		self:SecureHook(_G.AzDropDown, "ToggleMenu", function(this, _)
			self:skinObject("slider", {obj=_G["AzDropDownScroll" .. this.vers].ScrollBar})
			self:skinObject("frame", {obj=_G["AzDropDownScroll" .. this.vers]:GetParent(), kfs=true})

			-- stop the backdrop being re-applied
			_G["AzDropDownScroll" .. this.vers]:GetParent().ApplyOurBackdrop = _G.nop

			self:Unhook(this, "ToggleMenu")
		end)
	end

	local function skinCatPg()
		for _, child in _G.ipairs{_G.TipTacOptions.content:GetChildren()} do
			if child.option then
				if child.option.type == "DropDown" then
					aObj:skinObject("frame", {obj=child, kfs=true, ng=true, bd=5, ofs=0})
					-- add a texture, if required
					if aObj.db.profile.TexturedDD then
						child.ddTex = child:CreateTexture(nil, "BORDER")
						child.ddTex:SetTexture(aObj.itTex)
						child.ddTex:ClearAllPoints()
						child.ddTex:SetPoint("TOPLEFT", child, "TOPLEFT", 3, -3)
						child.ddTex:SetPoint("BOTTOMRIGHT", child, "BOTTOMRIGHT", -3, 3)
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=child.button, es=12, ofs=-2, x1=1}
					end
				elseif child.option.type == "Slider" then
					aObj:skinObject("editbox", {obj=child.edit})
					aObj:skinObject("slider", {obj=child.slider})
				elseif child.option.type == "Text" then
					aObj:skinObject("editbox", {obj=child})
				elseif child.option.type == "Check"
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child.option.type == "Button"
				and aObj.modBtns
				then
					aObj:skinStdButton{obj=child}
				end
			end
		end
	end
	skinCatPg()
	self:SecureHook(_G.TipTacOptions, "BuildCategoryPage", function()
		skinCatPg()
	end)

	self:SecureHookScript(_G.TipTacOptions, "OnShow", function(this)
		self:skinObject("frame", {obj=this.outline, kfs=true, fb=true})
		self:keepFontStrings(this.btnMisc.dropDownMenu)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=this.btnAnchor}
			self:skinStdButton{obj=this.btnReset}
			self:skinStdButton{obj=this.btnMisc}
			self:skinStdButton{obj=this.btnReport}
			self:skinStdButton{obj=this.btnClose}
		end
		if self.modChkBtns then
			for _, child in _G.ipairs_reverse{this.outline:GetChildren()} do
				if child.check then
					self:skinCheckButton{obj=child.check}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
