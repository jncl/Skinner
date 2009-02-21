
function Skinner:Tablet()
	if not self.db.profile.Tooltips.skin then return end

	local function skinTablet()

		if not Skinner.db.profile.TrackerFrame then
			-- Check for the QuestsFu_Tracker
			local qftinfo = LibStub("Tablet-2.0", true).registry['QuestsFu_Tracker']
			if qftinfo and qftinfo.tooltip then
				local tt = qftinfo.tooltip
--				Skinner:Debug("ST: [%s, %s]", tt, tt:GetName())
				tt:SetBackdrop(nil)
				Skinner.skinned[tt] = true
				tt.noFH = true
			end
		end

		if Tablet20Frame then
			local frame = Tablet20Frame
			if not Skinner.skinned[frame] then
--				Skinner:Debug("Tablet20Frame")
				Skinner:applySkin(frame)
				-- hook these to stop the Backdrop colours from being changed
				Skinner:RawHook(frame, "SetBackdropColor", function() end, true)
				Skinner:RawHook(frame, "SetBackdropBorderColor", function() end, true)
			end
		end

		local i = 1
		while _G["Tablet20DetachedFrame"..i] do
			local frame = _G["Tablet20DetachedFrame"..i]
			if not Skinner.skinned[frame] then
--				Skinner:Debug("DetachedFrame: [%s, %s]", frame:GetName(), frame:GetParent():GetName() )
				Skinner:applySkin(frame)
				-- hook these to stop the Backdrop colours from being changed
				Skinner:RawHook(frame, "SetBackdropColor", function() end, true)
				Skinner:RawHook(frame, "SetBackdropBorderColor", function() end, true)
			end
			if not frame.noFH then
			end
			i = i + 1
		end

	end

	self:SecureHook(LibStub("Tablet-2.0", true), "Open", function(tablet, parent)
--		self:Debug("TabletOpen: [%s, %s]", tablet, parent)
		skinTablet()
	end)
	self:SecureHook(LibStub("Tablet-2.0", true), "Detach", function(tablet, parent)
--		self:Debug("TabletDetach: [%s, %s]", tablet, parent)
		skinTablet()
	end)

	skinTablet()

end
