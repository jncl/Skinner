
function Skinner:XRS()

	local function skinXRS()

		if not XRSFrame.skinned then
			Skinner:Hook(XRS, "SetColorGradient", function() end, true)
			XRS.framegradient:Hide()
			XRS.db.profile.Texture = Skinner.db.profile.StatusBar.texture
			Skinner:applySkin(XRSFrame)
			Skinner:Hook(XRSFrame, "SetBackdropColor", function() end, true)
			Skinner:Hook(XRSFrame, "SetBackdropBorderColor", function() end, true)
			if Skinner.db.profile.Tooltips.skin then
				Skinner:skinTooltip(XRSTooltip)
				if Skinner.db.profile.Tooltips.style == 3 then XRSTooltip:SetBackdrop(Skinner.backdrop) end
			end
			XRSFrame.skinned = true
		end

	end

	self:SecureHook(XRS, "SetupFrames", skinXRS)

	-- remember to reskin on reloadui
	if getglobal("XRSFrame") ~= nil then skinXRS() end

end
