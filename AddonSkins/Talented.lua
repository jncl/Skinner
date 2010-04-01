if not Skinner:isAddonEnabled("Talented") then return end

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
	
end

function Skinner:Talented_GlyphFrame()

	self:moveObject{obj=TalentedGlyphs.title, x=-14}
	self:addSkinFrame{obj=TalentedGlyphs, kfs=true, y1=-12, x2=-31, y2=78}

end
