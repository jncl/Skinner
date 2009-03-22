
function Skinner:TipTac()
	if not self.db.profile.Tooltips.skin then return end

	-- set the TipTac backdrop settings to ours
	TipTac_Config.tipBackdropBG = self.backdrop.bgFile
	TipTac_Config.tipBackdropEdge = self.backdrop.edgeFile
	TipTac_Config.backdropEdgeSize = self.backdrop.edgeSize
	TipTac_Config.backdropInsets = self.backdrop.insets.left
	TipTac_Config.tipColor = CopyTable(self.bColour)
	TipTac_Config.tipBorderColor = CopyTable(self.bbColour)

	TipTac:ApplySettings()

	self:applySkin(TipTac.anchor)

end

function Skinner:TipTacOptions()

	local function skinCatPg()

		-- skin DropDowns
		for i = 1, TipTacOptions:GetNumChildren() do
			local child = select(i, TipTacOptions:GetChildren())
			if child.InitSelectedItem and not Skinner.skinned[child] then
				child:SetBackdrop(nil)
			end
		end
		
		-- skin EditBoxes
		for i = 1, 7 do
			local eb = _G["AzOptionsFactoryEditBox"..i]
			if eb and not Skinner.skinned[eb] then
				Skinner:skinEditBox(eb, {9})
			end
		end

	end

	-- hook this to skin new objects
	self:SecureHook(TipTacOptions, "BuildCategoryPage", function()
		self:Debug("TTO_BCP")
		skinCatPg()
	end)

	local ddMenu
	-- hook this to skin the DropDown menu
	self:SecureHook(AzDropDown, "ToggleMenu", function(...)
		self:Debug("ADD_TM")
		if not ddMenu then
			local obj = EnumerateFrames()
			while obj do
				if obj.text and obj.items and obj.list then
					ddMenu = obj
					break
				end
				obj = EnumerateFrames(obj)
			end
		end
		self:applySkin(ddMenu)	
	end)

	-- skin already created objects
	skinCatPg()
	self:applySkin(TipTacOptions.outline)
	self:applySkin(TipTacOptions)

end
