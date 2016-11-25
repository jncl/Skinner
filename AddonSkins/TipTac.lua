local aName, aObj = ...
if not aObj:isAddonEnabled("TipTac") then return end
local _G = _G

function aObj:TipTac()
	if not self.db.profile.Tooltips.skin then return end

	-- set the TipTac backdrop settings to ours
	_G.TipTac_Config.tipBackdropBG = self.backdrop.bgFile
	_G.TipTac_Config.tipBackdropEdge = self.backdrop.edgeFile
	_G.TipTac_Config.backdropEdgeSize = self.backdrop.edgeSize
	_G.TipTac_Config.backdropInsets = self.backdrop.insets.left
	_G.TipTac_Config.tipColor = CopyTable(self.bColour)
	_G.TipTac_Config.tipBorderColor = CopyTable(self.bbColour)
	_G.TipTac_Config.barTexture = self.sbTexture

	-- N.B. The ItemRefTooltip border will be set to reflect the item's quality by TipTac

	-- check to see if settings have been applied yet
	if not _G.TipTac.VARIABLES_LOADED then
		_G.TipTac:ApplySettings()
	end

	-- Anchor frame
	self:skinButton{obj=_G.TipTac.close, cb=true, x1=2, y1=-2, x2=-2, y2=2}
	self:addSkinFrame{obj=_G.TipTac, y1=1, y2=-1, nb=true}

end

function aObj:TipTacOptions()

	local function skinCatPg()

		-- skin DropDowns & EditBoxes
		for _, child in ipairs{_G.TipTacOptions:GetChildren()} do
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
						aObj:addSkinFrame{obj=child, aso={ng=true}, nb=true, x1=-4, y1=2, x2=1, y2=-1}
					end
					-- add a button border around the dd button
					aObj:addButtonBorder{obj=child.button, es=12, ofs=-2, x1=1}
				elseif child.option.type == "Slider" then
					aObj:skinEditBox{obj=child.edit, noWidth=true, y=-2}
				elseif child.option.type == "Text" then
					aObj:skinEditBox{obj=child, regs={child.text and 12 or nil}, noWidth=true}
				end
			end
		end

	end

	-- hook this to skin new objects
	self:SecureHook(_G.TipTacOptions, "BuildCategoryPage", function()
		skinCatPg()
	end)

	-- hook this to skin the dropdown menu (also used by Examiner skin)
	if not self:IsHooked(_G.AzDropDown, "ToggleMenu") then
		self:SecureHook(_G.AzDropDown, "ToggleMenu", function(this, ...)
			local menu = _G["AzDropDownScroll" .. _G.AzDropDown.vers]:GetParent()
			self:skinSlider{obj=menu.scroll.ScrollBar}
			self:addSkinFrame{obj=menu}
			-- raise frame level so DD button borders are below menu
			_G.RaiseFrameLevel(menu)
			self:RawHook(menu, "SetFrameLevel", function(this, lvl)
				self.hooks[this].SetFrameLevel(this, lvl + 1)
			end, true)
			self:Unhook(this, "ToggleMenu")
			menu = nil
		end)
	end

	-- skin already created objects
	skinCatPg()
	self:addSkinFrame{obj=_G.TipTacOptions.outline}
	self:addSkinFrame{obj=_G.TipTacOptions}

end
