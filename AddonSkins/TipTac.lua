local _, aObj = ...
if not aObj:isAddonEnabled("TipTac") then return end
local _G = _G

aObj.addonsToSkin.TipTac = function(self) -- v 21.11.06
	if not self.db.profile.Tooltips.skin then return end

	-- Anchor frame
	self:SecureHookScript(_G.TipTac, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=this.close, noSkin=true}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.lodAddons.TipTacOptions = function(self) -- v 21.11.06

	-- hook this to skin the dropdown menu (also used by Examiner skin)
	if not self:IsHooked(_G.AzDropDown, "ToggleMenu") then
		self:SecureHook(_G.AzDropDown, "ToggleMenu", function(this, _)
			self:skinObject("slider", {obj=_G["AzDropDownScroll" .. this.vers].ScrollBar})
			self:skinObject("frame", {obj=_G["AzDropDownScroll" .. this.vers]:GetParent()})
			self:Unhook(this, "ToggleMenu")
		end)
	end

	local function skinCatPg()
		for _, child in _G.ipairs{_G.TipTacOptions:GetChildren()} do
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
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=this.btnAnchor}
			self:skinStdButton{obj=this.btnReset}
			self:skinStdButton{obj=this.btnClose}
		end

		self:Unhook(this, "OnShow")
	end)

end
