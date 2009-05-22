
function Skinner:TipTac()
	if not self.db.profile.Tooltips.skin then return end

	-- set the TipTac backdrop settings to ours
	TipTac_Config.tipBackdropBG = self.backdrop.bgFile
	TipTac_Config.tipBackdropEdge = self.backdrop.edgeFile
	TipTac_Config.backdropEdgeSize = self.backdrop.edgeSize
	TipTac_Config.backdropInsets = self.backdrop.insets.left
	TipTac_Config.tipColor = CopyTable(self.bColour)
	TipTac_Config.tipBorderColor = CopyTable(self.bbColour)
	
	-- N.B. The ItemRefTooltip border will be set to reflect the item's quality by TipTac

	TipTac:ApplySettings()

	-- Anchor frame
	self:addSkinFrame{obj=TipTac, x1=1, y1=-1, x2=-1, y2=1}
	
end

function Skinner:TipTacOptions()

	local function skinCatPg()

		-- skin DropDowns
		for i = 1, TipTacOptions:GetNumChildren() do
			local child = select(i, TipTacOptions:GetChildren())
			if child.InitSelectedItem and not Skinner.skinned[child] then
				child:SetBackdrop(nil)
				-- add a texture, if required
				if Skinner.db.profile.TexturedDD then
					child.ddTex = child:CreateTexture(nil, "BORDER")
					child.ddTex:SetTexture(Skinner.itTex)
					child.ddTex:ClearAllPoints()
					child.ddTex:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -2)
					child.ddTex:SetPoint("BOTTOMRIGHT", child, "BOTTOMRIGHT", -3, 3)
				end
			end
		end
		
		-- skin EditBoxes
		for i = 1, 7 do
			local eb = _G["AzOptionsFactoryEditBox"..i]
			if eb and not Skinner.skinned[eb] then
				Skinner:skinEditBox{obj=eb, regs={eb.text and 15 or nil}}
			end
		end

	end

	-- hook this to skin new objects
	self:SecureHook(TipTacOptions, "BuildCategoryPage", function()
--		self:Debug("TTO_BCP")
		skinCatPg()
	end)

	-- hook this to skin the dropdown menu (also used by Examiner skin)
	if not self:IsHooked(AzDropDown, "ToggleMenu") then
		self:SecureHook(AzDropDown, "ToggleMenu", function(...)
			self:skinScrollBar{obj=_G["AzDropDownScroll"..AzDropDown.vers]}
			self:addSkinFrame{obj=_G["AzDropDownScroll"..AzDropDown.vers]:GetParent()}
			self:Unhook(AzDropDown, "ToggleMenu")
		end)
	end

	-- skin already created objects
	skinCatPg()
	self:addSkinFrame{obj=TipTacOptions.outline}
	self:addSkinFrame{obj=TipTacOptions}

end
