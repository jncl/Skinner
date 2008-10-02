
function Skinner:Tablet()
	if not self.db.profile.Tooltips.skin then return end

	local function skinTablet()

		if not Skinner.db.profile.TrackerFrame then
			-- Check for the QuestsFu_Tracker
			local qftinfo = AceLibrary("Tablet-2.0").registry['QuestsFu_Tracker']
			if qftinfo and qftinfo.tooltip then
				local tt = qftinfo.tooltip
--				Skinner:Debug("ST: [%s, %s]", tt, tt:GetName())
				tt:SetBackdrop(nil)
				tt.skinned = true
				tt.noFH = true
			end
		end

		if Tablet20Frame then
			local frame = Tablet20Frame
			if not frame.skinned then
--				Skinner:Debug("Tablet20Frame")
				Skinner:applySkin(frame)
				frame.skinned = true
				-- hook these to stop the Backdrop colours from being changed
				Skinner:Hook(frame, "SetBackdropColor", function() end, true)
				Skinner:Hook(frame, "SetBackdropBorderColor", function() end, true)
			end
		end

		local i = 1
		while _G["Tablet20DetachedFrame"..i] do
			local frame = _G["Tablet20DetachedFrame"..i]
			if not frame.skinned then
--				Skinner:Debug("DetachedFrame: [%s, %s]", frame:GetName(), frame:GetParent():GetName() )
				Skinner:applySkin(frame)
				frame.skinned = true
				-- hook these to stop the Backdrop colours from being changed
				Skinner:Hook(frame, "SetBackdropColor", function() end, true)
				Skinner:Hook(frame, "SetBackdropBorderColor", function() end, true)
			end
			if not frame.noFH then
			end
			i = i + 1
		end

	end

	self:SecureHook(AceLibrary("Tablet-2.0"), "Open", function(tablet, parent)
--		self:Debug("TabletOpen: [%s, %s]", tablet, parent)
		skinTablet()
	end)
	self:SecureHook(AceLibrary("Tablet-2.0"), "Detach", function(tablet, parent)
--		self:Debug("TabletDetach: [%s, %s]", tablet, parent)
		skinTablet()
	end)

	skinTablet()

end
