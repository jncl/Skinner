
function Skinner:EngBags()
	if not self.db.profile.ContainerFrames then return end

--	self:Debug("EngBags")

	self:SecureHook("EngInventory_UpdateWindow", function()
--		self:Debug("EngInventory_UpdateWindow")
		for i = 1, EngBags_MAX_BARS do
			local frame = _G["EngInventory_frame_bar_"..i]
			self:applySkin(frame)
			-- hook these to stop the Backdrop/BackdropBorder colours from being changed
			if not self:IsHooked(frame, "SetBackdropColor") then
				self:Hook(frame, "SetBackdropColor", function() end, true)
				self:Hook(frame, "SetBackdropBorderColor", function() end, true)
			end
		end
		self:keepRegions(EngInventory_frame)
		self:applySkin(EngInventory_frame)
		-- hook these to stop the Backdrop/BackdropBorder colours from being changed
		if not self:IsHooked(EngInventory_frame, "SetBackdropColor") then
			self:Hook(EngInventory_frame, "SetBackdropColor", function() end, true)
			self:Hook(EngInventory_frame, "SetBackdropBorderColor", function() end, true)
		end
		self:Unhook("EngInventory_UpdateWindow")
	end)

	self:SecureHook("EngInventory_Options_InitWindow", function()
--		self:Debug("EngInventory_Options_InitWindow")
		self:keepRegions(EngInventory_OptsFrame)
		self:applySkin(EngInventory_OptsFrame)
		self:skinScrollBar(EngInventory_OptsFrame, "_")
		for i = 1, #ENGINVENTORY_OPTIONS_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngInventory_OptsFrame_Line_"..i.."_Edit_"..j]
				self:skinEditBox(eb)
			end
		end
		if not self:IsHooked(EngInventory_OptsFrame, "SetBackdropColor") then
			self:Hook(EngInventory_OptsFrame, "SetBackdropColor", function() end, true)
			self:Hook(EngInventory_OptsFrame, "SetBackdropBorderColor", function() end, true)
		end
		self:Unhook("EngInventory_Options_InitWindow")
	end)

	-- move the editboxes to the left
	self:SecureHook("EngInventory_Options_UpdateWindow", function()
--		self:Debug("EngInventory_Options_UpdateWindow")
		for i = 1, #ENGINVENTORY_OPTIONS_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngInventory_OptsFrame_Line_"..i.."_Edit_"..j]
				self:moveObject(eb, "-", 10, nil, nil)
			end
		end
	end)

	self:moveObject(EngInventory_OptsFrame_Button_Close, nil, nil, "+", 10)

	self:SecureHook("EngBank_UpdateWindow", function()
--		self:Debug("EngBank_UpdateWindow")
		for i = 1, EngBags_MAX_BARS do
			local frame = _G["EngBank_frame_bar_"..i]
			self:applySkin(frame)
			-- hook these to stop the Backdrop/BackdropBorder colours from being changed
			if not self:IsHooked(frame, "SetBackdropColor") then
				self:Hook(frame, "SetBackdropColor", function() end, true)
				self:Hook(frame, "SetBackdropBorderColor", function() end, true)
			end
		end
		self:applySkin(EngBank_frame)
		-- hook these to stop the Backdrop/BackdropBorder colours from being changed
		if not self:IsHooked(EngBank_frame, "SetBackdropColor") then
			self:Hook(EngBank_frame, "SetBackdropColor", function() end, true)
			self:Hook(EngBank_frame, "SetBackdropBorderColor", function() end, true)
		end
		self:Unhook("EngBank_UpdateWindow")
	end)

	self:SecureHook("EngBank_Options_InitWindow", function()
--		self:Debug("EngBank_Options_InitWindow")
		self:applySkin(EngBank_OptsFrame)
		self:skinScrollBar(EngBank_OptsFrame, "_")
		for i = 1, #EngBank_Options_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngBank_OptsFrame_Line_"..i.."_Edit_"..j]
				self:skinEditBox(eb)
			end
		end
		if not self:IsHooked(EngBank_OptsFrame, "SetBackdropColor") then
			self:Hook(EngBank_OptsFrame, "SetBackdropColor", function() end, true)
			self:Hook(EngBank_OptsFrame, "SetBackdropBorderColor", function() end, true)
		end
		self:Unhook("EngBank_Options_InitWindow")
	end)

	-- move the editboxes to the left
	self:SecureHook("EngBank_Options_UpdateWindow", function()
--		self:Debug("EngBank_Options_UpdateWindow")
		for i = 1, #EngBank_Options_LIST_FRAMES do
			for j = 1, 4 do
				local eb = _G["EngBank_OptsFrame_Line_"..i.."_Edit_"..j]
				self:moveObject(eb, "-", 10, nil, nil)
			end
		end
	end)

	self:moveObject(EngBank_OptsFrame_Button_Close, nil, nil, "+", 10)

end
