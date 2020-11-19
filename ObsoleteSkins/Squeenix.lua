local aName, aObj = ...
if not aObj:isAddonEnabled("Squeenix") then return end
local _G = _G

function aObj:Squeenix()

	-- Find & Skin the Squeenix border & direction indicators
	local kids = {_G.Minimap:GetChildren()}
	for _, child in _G.ipairs(kids) do
		if child:IsObjectType("Button")
		and child:GetName() == nil
		then
			child:Hide()
			self:addSkinButton{obj=_G.Minimap, parent=_G.Minimap}
			if not self.db.profile.Minimap.gloss then _G.LowerFrameLevel(_G.Minimap.sb) end
		end
		-- Move the compass points text
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and child:GetFrameStrata() == "BACKGROUND"
		and _G.ceil(child:GetWidth()) == 140
		and _G.ceil(child:GetHeight()) == 140
		then
--			self:Debug("Squeenix, found Compass Frame")
			local regs = {child:GetRegions()}
			for _, reg in _G.ipairs(regs) do
				if reg:IsObjectType("FontString") then
--					self:Debug("Squeenix found direction text")
					if reg:GetText() == "E" then self:moveObject{obj=reg, x=1}
					elseif reg:GetText() == "W" then self:moveObject{obj=reg, x=-1}
					end
				end
			end
			regs = nil
		end
	end
	kids = nil

	self:moveObject{obj=_G.MinimapNorthTag, y=4}

end
