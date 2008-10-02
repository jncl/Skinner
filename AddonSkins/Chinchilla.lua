
function Skinner:Chinchilla()

	local function skinChinchilla()

		if Chinchilla:GetDatabaseNamespace("Appearance").profile.shape == "SQUARE" then
			if GetCVar("rotateMinimap") == "1" then
				Chinchilla_Appearance_MinimapFullTexture:SetAlpha(0)
			else
				Chinchilla_Appearance_MinimapCorner1:Hide()
				Chinchilla_Appearance_MinimapCorner2:Hide()
				Chinchilla_Appearance_MinimapCorner3:Hide()
				Chinchilla_Appearance_MinimapCorner4:Hide()
			end
			Skinner:addSkinButton(Minimap, Minimap)
			Skinner:moveObject(MinimapNorthTag, nil, nil, "+", 4)
			Skinner.minimapskin = Minimap.sBut
			if not Skinner.db.profile.MinimapGloss then LowerFrameLevel(Skinner.minimapskin) end
		end

	end

	-- skin the coordinates frame if it exists
	if Chinchilla:IsModuleActive("Coordinates") and Chinchilla_Coordinates_Frame then
		self:applySkin(Chinchilla_Coordinates_Frame)
	end
	-- hook the OnEnable method
	if Chinchilla:HasModule("Coordinates") then
		self:SecureHook(Chinchilla:GetModule("Coordinates"), "OnEnable", function()
			self:applySkin(Chinchilla_Coordinates_Frame)
		end)
	end

	-- skin the location frame if it exists
	if Chinchilla:IsModuleActive("Location") and Chinchilla_Location_Frame then
		self:applySkin(Chinchilla_Location_Frame)
		self:Hook(Chinchilla_Location_Frame, "SetBackdropColor", function() end, true)
		self:Hook(Chinchilla_Location_Frame, "SetBackdropBorderColor", function() end, true)
	end
	-- hook the OnEnable method
	if Chinchilla:HasModule("Location") then
		self:SecureHook(Chinchilla:GetModule("Location"), "OnEnable", function()
			self:applySkin(Chinchilla_Location_Frame)
			self:Hook(Chinchilla_Location_Frame, "SetBackdropColor", function() end, true)
			self:Hook(Chinchilla_Location_Frame, "SetBackdropBorderColor", function() end, true)
		end)
	end

	-- skin the Minimap if it's square
	if Chinchilla:IsModuleActive("Appearance") then
		skinChinchilla()
	end
	-- hook the OnEnable method
	if Chinchilla:HasModule("Appearance") then
		self:SecureHook(Chinchilla:GetModule("Appearance"), "OnEnable", function()
			skinChinchilla()
		end)
	end

end
