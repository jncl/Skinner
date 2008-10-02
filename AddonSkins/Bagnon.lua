--This Skin is for the Original Bagnon/Banknon Addon found here: http://wowui.incgamers.com/ui.php?id=4060
-- and here http://wow.curse.com/downloads/details/2090/
-- and also for the Bagnon Addon formerly known as vBagnon, found here: http://wow-en.curse-gaming.com/files/details/2090/vbagnon/ or here http://wowui.incgamers.com/ui.php?id=3197

function Skinner:Bagnon(LoD)
	if not self.db.profile.ContainerFrames or self.initialized.Bagnon then return end
	self.initialized.Bagnon = true

--	if Addon is LoD then it's the original one
	if LoD then
		self:applySkin(Bagnon)
		-- hook these to stop the Backdrop colours from being changed
		self:Hook(Bagnon, "SetBackdropColor", function() end, true)
		self:Hook(Bagnon, "SetBackdropBorderColor", function() end, true)

--	otherwise it's the renamed vBagnon one
	else
		self:SecureHook(Bagnon, "CreateInventory", function()
			self:applySkin(Bagnon.bags)
			-- hook these to stop the Backdrop colours from being changed
			self:Hook(Bagnon.bags, "SetBackdropColor", function() end, true)
			self:Hook(Bagnon.bags, "SetBackdropBorderColor", function() end, true)
		end)

		self:SecureHook(Bagnon, "CreateBank", function()
			self:applySkin(Bagnon.bank)
			-- hook these to stop the Backdrop colours from being changed
			self:Hook(Bagnon.bank, "SetBackdropColor", function() end, true)
			self:Hook(Bagnon.bank, "SetBackdropBorderColor", function() end, true)
		end)
		-- skin the search edit box
		self:SecureHook(BagnonSpot, "Show", function(this, anchor)
			self:skinEditBox(this.frame, {9})
			self:Unhook(BagnonSpot, "Show")
		end)
	end

end

function Skinner:Banknon()
	if not self.db.profile.ContainerFrames then return end

	self:applySkin(Banknon)
	-- hook these to stop the Backdrop colours from being changed
	self:Hook(Banknon, "SetBackdropColor", function() end, true)
	self:Hook(Banknon, "SetBackdropBorderColor", function() end, true)

end

function Skinner:Bagnon_Forever()
	if not self.db.profile.ContainerFrames then return end

	self:SecureHook(BagnonDB, "ToggleDropdown", function(this)
		self:keepFontStrings(BagnonDBCharSelect)
		self:Unhook(BagnonDB, "ToggleDropdown")
	end)

end

function Skinner:Bagnon_Options()

	self:applySkin(BagnonRightClickMenu)
	self:skinDropDown(BagnonRightClickMenuPanelSelector)

end
