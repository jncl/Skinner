if not Skinner:isAddonEnabled("Chinchilla") then return end

function Skinner:Chinchilla()

	local function skinChinchilla()

		if Chinchilla.db:GetNamespace("Appearance", true).profile.shape == "SQUARE" then
			if GetCVar("rotateMinimap") == "1" then
				Chinchilla_Appearance_MinimapFullTexture:SetAlpha(0)
			else
				Chinchilla_Appearance_MinimapCorner1:Hide()
				Chinchilla_Appearance_MinimapCorner2:Hide()
				Chinchilla_Appearance_MinimapCorner3:Hide()
				Chinchilla_Appearance_MinimapCorner4:Hide()
			end
			Skinner:moveObject{obj=MinimapNorthTag, y=4}
			Skinner.minimapskin = Skinner:addSkinButton(Minimap, Minimap)
			if not Skinner.db.profile.Minimap.gloss then LowerFrameLevel(Skinner.minimapskin) end
		end

	end

	-- skin the coordinates frame if it exists
	if Chinchilla:GetModule("Coordinates", true) then
		if Chinchilla_Coordinates_Frame then
			self:addSkinFrame{obj=Chinchilla_Coordinates_Frame}
		else
			-- hook the OnEnable method
			self:SecureHook(Chinchilla:GetModule("Coordinates"), "OnEnable", function(this)
				self:addSkinFrame{obj=Chinchilla_Coordinates_Frame}
				self:Unhook(Chinchilla:GetModule("Coordinates"), "OnEnable")
			end)
		end
	end

	-- skin the location frame if it exists
	if Chinchilla:GetModule("Location", true) then
		if Chinchilla_Location_Frame then
			self:addSkinFrame{obj=Chinchilla_Location_Frame}
			Chinchilla_Location_Frame.SetBackdropColor = function() end
			Chinchilla_Location_Frame.SetBackdropBorderColor = function() end
		else
			-- hook the OnEnable method
			self:SecureHook(Chinchilla:GetModule("Location"), "OnEnable", function(this)
				self:addSkinFrame{obj=Chinchilla_Location_Frame}
				Chinchilla_Location_Frame.SetBackdropColor = function() end
				Chinchilla_Location_Frame.SetBackdropBorderColor = function() end
				self:Unhook(Chinchilla:GetModule("Location"), "OnEnable")
			end)
		end
	end

	-- skin the Minimap if it's square
	if Chinchilla:GetModule("Appearance", true) then
		skinChinchilla()
		-- hook the OnEnable method
		self:SecureHook(Chinchilla:GetModule("Appearance"), "OnEnable", function()
			skinChinchilla()
			self:Unhook(Chinchilla:GetModule("Appearance"), "OnEnable")
		end)
	end

end
