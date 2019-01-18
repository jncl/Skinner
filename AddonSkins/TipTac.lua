local aName, aObj = ...
if not aObj:isAddonEnabled("TipTac") then return end
local _G = _G

aObj.addonsToSkin.TipTac = function(self) -- v 18.08.20
	if not self.db.profile.Tooltips.skin then return end

	-- set the TipTac backdrop settings to ours
	_G.TipTac_Config.tipBackdropBG = self.backdrop.bgFile
	_G.TipTac_Config.tipBackdropEdge = self.backdrop.edgeFile
	_G.TipTac_Config.backdropEdgeSize = self.backdrop.edgeSize
	_G.TipTac_Config.backdropInsets = self.backdrop.insets.left
	_G.TipTac_Config.tipColor = {self.bClr.r, self.bClr.g, self.bClr.b}
	_G.TipTac_Config.tipBorderColor = {self.tbClr.r, self.tbClr.g, self.tbClr.b}
	_G.TipTac_Config.barTexture = self.sbTexture

	-- N.B. The ItemRefTooltip border will be set to reflect the item's quality by TipTac

	-- check to see if settings have been applied yet
	if not _G.TipTac.VARIABLES_LOADED then
		_G.TipTac:ApplySettings()
	end

	-- Anchor frame
	self:skinCloseButton{obj=_G.TipTac.close, ofs=2}
	self:addSkinFrame{obj=_G.TipTac, ft="a", kfs=true, nb=true, y1=1, y2=-1}

end

aObj.lodAddons.TipTacOptions = function(self) -- v 18.08.12

	local function skinCatPg()

		-- skin DropDowns, EditBoxes, Sliders & Checkboxes
		for _, child in _G.ipairs{_G.TipTacOptions:GetChildren()} do
			if child.option then
				if child.option.type == "DropDown" then
					child:SetBackdrop(nil)
					-- add a texture, if required
					if aObj.db.profile.TexturedDD then
						child.ddTex = child:CreateTexture(nil, "BORDER")
						child.ddTex:SetTexture(aObj.itTex)
						child.ddTex:ClearAllPoints()
						child.ddTex:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -2)
						child.ddTex:SetPoint("BOTTOMRIGHT", child, "BOTTOMRIGHT", -3, 3)
					end
					-- skin the frame
					if aObj.db.profile.DropDownButtons then
						aObj:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, aso={ng=true}, x1=-4, y1=2, x2=1, y2=-1}
					end
					if aObj.modBtnBs then
						-- add a button border around the dd button
						aObj:addButtonBorder{obj=child.button, es=12, ofs=-2, x1=1}
					end
				elseif child.option.type == "Slider" then
					aObj:skinEditBox{obj=child.edit, noWidth=true, y=-2}
					aObj:skinSlider{obj=child.slider}
				elseif child.option.type == "Text" then
					aObj:skinEditBox{obj=child, regs={child.text and 12 or nil}, noWidth=true}
				elseif child.option.type == "Check"
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				end
			end
		end

	end

	-- hook this to skin new objects
	self:SecureHook(_G.TipTacOptions, "BuildCategoryPage", function()
		skinCatPg()
	end)

	-- hook this to skin the dropdown menu (also used by Examiner skin)
	self:secureHook(_G.AzDropDown, "ToggleMenu", function(this, ...)
		local menu = _G["AzDropDownScroll" .. _G.AzDropDown.vers]:GetParent()
		self:skinSlider{obj=menu.scroll.ScrollBar}
		self:addSkinFrame{obj=menu, ft="a", kfs=true, nb=true}
		-- raise frame level so DD button borders are below menu
		_G.RaiseFrameLevel(menu)
		self:RawHook(menu, "SetFrameLevel", function(this, lvl)
			self.hooks[this].SetFrameLevel(this, lvl + 1)
		end, true)
		self:Unhook(this, "ToggleMenu")
		menu = nil
	end)

	-- skin already created objects
	skinCatPg()
	self:addSkinFrame{obj=_G.TipTacOptions.outline, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.TipTacOptions, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.TipTacOptions.btnAnchor}
		self:skinStdButton{obj=_G.TipTacOptions.btnReset}
		self:skinStdButton{obj=_G.TipTacOptions.btnClose}
	end

end
