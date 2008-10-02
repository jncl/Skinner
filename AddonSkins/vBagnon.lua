
function Skinner:vBagnon()
	if not self.db.profile.ContainerFrames then return end

	self:Hook(BagnonFrame, "Create", function(name, bags, cats)
--		self:Debug("BagnonFrame.Create: [%s, %s, %s]", name, bags, cats)
		local frame = self.hooks[BagnonFrame].Create(name, bags, cats)
--		self:Debug("BF.C: [%s]", frame:GetName())
		self:applySkin(frame)
		return frame
	end)

	self:Hook(BagnonFrame, "CreateSaved", function(name, sets, defaultBags, isBank)
--		self:Debug("BagnonFrame.CreateSaved: [%s,%s, %s, %s]", name, sets, defaultBags, isBank)
		local frame = self.hooks[BagnonFrame].CreateSaved(name, sets, defaultBags, isBank)
--		self:Debug("BF.CS: [%s]", frame:GetName())
		self:applySkin(frame)
		-- hook this to stop the Backdrop colours from being changed
		self:Hook(frame, "SetBackdropColor", function() end, true)
		return frame
	end)

end
