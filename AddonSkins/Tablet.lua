local nop = function() end

function Skinner:Tablet()
	if not self.db.profile.Tooltips.skin then return end

	local qftinfo, tt, frame
	
	local function skinTablet()

		if not Skinner.db.profile.TrackerFrame.skin then
			-- Check for the QuestsFu_Tracker
			qftinfo = LibStub("Tablet-2.0", true).registry['QuestsFu_Tracker']
			if qftinfo and qftinfo.tooltip then
				tt = qftinfo.tooltip
				tt:SetBackdrop(nil)
				Skinner.skinned[tt] = true
			end
		end

		if Tablet20Frame then
			frame = Tablet20Frame
			if not Skinner.skinned[frame] then
				Skinner:applySkin(frame)
				-- change these to stop the Backdrop colours from being changed
				frame.SetBackdropColor = nop
				frame.SetBackdropBorderColor = nop
			end
		end

		local i = 1
		while _G["Tablet20DetachedFrame"..i] do
			frame = _G["Tablet20DetachedFrame"..i]
			if not Skinner.skinned[frame] then
				Skinner:applySkin(frame)
				-- change these to stop the Backdrop colours from being changed
				frame.SetBackdropColor = nop
				frame.SetBackdropBorderColor = nop
			end
			i = i + 1
		end

	end

	self:SecureHook(LibStub("Tablet-2.0", true), "Open", function(tablet, parent)
		skinTablet()
	end)
	self:SecureHook(LibStub("Tablet-2.0", true), "Detach", function(tablet, parent)
		skinTablet()
	end)

	skinTablet()

end
