
function Skinner:Talented()

	local function skinTalented_SpecTabs()
		
		if Talented.tabs then
			for _, tName in pairs{"spec1", "spec2", "petspec1"} do
				local tabName = Talented.tabs[tName]
				if tabName then
					self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
				end
			end
		end
		
	end
	
	self:SecureHook(Talented, "CreateBaseFrame", function()
		self:addSkinFrame{obj=Talented.base}
		skinTalented_SpecTabs()
		self:Unhook(Talented, "CreateBaseFrame")
	end)
	
-->>-- Glyphs frame
	self:SecureHook(Talented, "MakeGlyphFrame", function(this, parent)
		self:moveObject{obj=TalentedGlyphs.title, x=-14}
		self:addSkinFrame{obj=TalentedGlyphs, kfs=true, y1=-12, x2=-32, y2=78}
		self:Unhook(Talented, "MakeGlyphFrame")
	end)

end
