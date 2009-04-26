
function Skinner:Talented()

	local function skinTalented_SpecTabs()
		
		if Talented.tabs then
			local t_st = {"spec1", "spec2", "petspec1"}
			for _, tName in pairs(t_st) do
				local tabName = Talented.tabs[tName]
				if tabName then
					self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
					tabName:SetWidth(tabName:GetWidth() * 1.25)
					tabName:SetHeight(tabName:GetHeight() * 1.25)
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
		TalentedGlyphs:SetWidth(TalentedGlyphs:GetWidth() * self.FxMult)
		TalentedGlyphs:SetHeight(TalentedGlyphs:GetHeight() * self.FyMult)
		self:keepFontStrings(TalentedGlyphs)
		self:moveObject(TalentedGlyphs.close, "+", 28, "+", 9)
		self:moveObject(TalentedGlyphs.title, nil, nil, "+", 8)
		self:applySkin(TalentedGlyphs)
		self:SecureHook(TalentedGlyphs, "Update", function()
			self:moveObject(TalentedGlyphs.glyphs[1], "+", 10, "-", 15)
			self:moveObject(TalentedGlyphs.glyphs[2], "+", 15, "-", 40)
			self:moveObject(TalentedGlyphs.glyphs[3], "+", 10, "-", 0)
			self:moveObject(TalentedGlyphs.glyphs[4], "+", 30, "-", 50)
			self:moveObject(TalentedGlyphs.glyphs[5], "+", 20, "-", 0)
			self:moveObject(TalentedGlyphs.glyphs[6], "-", 5, "-", 50)
			for i = 1, 6 do
				self:RawHook(TalentedGlyphs.glyphs[i], "SetPoint", function() end, true)
			end
			self:Unhook(TalentedGlyphs, "Update")
		end)
		self:Unhook(Talented, "MakeGlyphFrame")
	end)

end
