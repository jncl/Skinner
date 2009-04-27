
function Skinner:Talented()

	local function skinTalented_SpecTabs()
		
		if Talented.tabs then
			local t_st = {"spec1", "spec2", "petspec1"}
			for _, tName in pairs(t_st) do
				local tabName = Talented.tabs[tName]
				if tabName then
					self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
					if tName == "spec1" then self:moveObject(tabName, "+", 2, nil, nil) end
				end
			end
		end
		
	end
	
	self:SecureHook(Talented, "CreateBaseFrame", function()
		self:applySkin(Talented.base)
		skinTalented_SpecTabs()
	end)
	
-->>-- Glyphs frame
	self:SecureHook(Talented, "MakeGlyphFrame", function(this, parent)
		self:keepFontStrings(TalentedGlyphs)
		self:moveObject(TalentedGlyphs.title, "-", 14, nil, nil)
		self:addSkinFrame(TalentedGlyphs, 0, -12, -32, 78)
		self:Unhook(Talented, "MakeGlyphFrame")
	end)

end
