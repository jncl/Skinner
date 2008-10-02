
function Skinner:TipTac()
	if not self.db.profile.Tooltips.skin then return end

	-- set the TipTac backdrop settings to ours
	local bd = self.backdrop
	TipTac_Config.tipBackdropBG = bd.bgFile
	TipTac_Config.tipBackdropEdge = bd.edgeFile
	TipTac_Config.backdropEdgeSize = bd.edgeSize
	TipTac_Config.backdropInsets = bd.insets.left
	TipTac_Config.tipTacColor = CopyTable(self.bColour)
	TipTac_Config.tipTacBorderColor = CopyTable(self.bbColour)
	TipTac_Config.tipColor = CopyTable(self.bColour)
	TipTac_Config.tipBorderColor = CopyTable(self.bbColour)

	TipTac:ApplySettings()

	self:keepFontStrings(TipTacAnchorDropDown)
	self:applySkin(TipTacAnchor)

end

function Skinner:TipTacOptions()

	local function skinEBDD()

		local ddmenu = TipTacOptionsDropDownScroll:GetParent()
		Skinner:applySkin(ddmenu)

		for i = 1, 5 do
			local eb = _G["TipTacOptionsText"..i]
			if eb and not eb.skinned then
				Skinner:skinEditBox(eb, {9})
				eb.skinned = true
			end
		end
		for i = 1, 4 do
			local eb = _G["TipTacOptionsEdit"..i]
			if eb and not eb.skinned then
				Skinner:skinEditBox(eb, {9})
				eb.skinned = true
			end
		end

	end

	self:SecureHook(TipTacOptions, "BuildCategoryPage", function()
--		self:Debug("TTO_BCP")
		skinEBDD()
	end)

	-- hook this to skin the drop downs (N.B. dropdown var is aka this)
	self:SecureHook(TTOFactory, "DropDown_InitSelected", function(dropDown, selectedValue)
--		self:Debug("TTOF.DD_IS: [%s, %s]", dropDown, selectedValue)
		if dropDown and not dropDown.skinned then
			dropDown:SetBackdrop(nil)
			dropDown.skinned = true
		end
	end, true)

	skinEBDD()
	self:applySkin(TipTacOptions.outline)
	self:applySkin(TipTacOptions)

	-- catch the elements on the first displayed page
	TipTacOptions:BuildCategoryPage()

end
