
function Skinner:Configator()
	
	local function skinSearchUI(gui)
	
		Skinner:skinEditBox(gui.saves.name, {9})
		Skinner:skinMoneyFrame(gui.frame.bidbox, nil, true, true)
		Skinner:glazeStatusBar(gui.frame.progressbar, 0)
		
		-- scan the gui tabs for known MoneyFrames
		for i = 1, #gui.tabs do
			local frame = gui.tabs[i].content
			if frame.money and frame.money.isMoneyFrame then
				Skinner:skinMoneyFrame(frame.money, nil, true, true)
			end
		end
		
	end

	-- hook this to skin Slide bar
	local sblib = LibStub("SlideBar", true)
	if sblib and sblib.frame then
		self:applySkin(sblib.frame)
		if self.db.profile.Tooltips.skin then
			if self.db.profile.Tooltips.style == 3 then sblib.tooltip:SetBackdrop(self.backdrop) end
			self:SecureHook(sblib.tooltip, "Show", function(this)
				self:skinTooltip(sblib.tooltip)
			end)
		end
	end

	-- hook this to skin Configator frames
	local clib = LibStub("Configator", true)
	if clib then
		self:RawHook(clib, "Create", function(this, ...)
			local frame = self.hooks[clib].Create(this, ...)
			self:Debug("Configator_Create: [%s]", frame:GetName())
			if not frame.skinned then
				self:applySkin(frame.Backdrop)
				frame.skinned = true
				-- look for the SearchUI frame
				local w, h, gw, gh, to, lo = select(3, ...)
				if w == 900 and h == 500 and gw == 5 and gh == 350 and to == 20 and lo == 5 then
					self:ScheduleTimer(skinSearchUI, 0.1, frame) -- wait for frame to be populated
				end
			end

			-- skin the Tooltip
			if self.db.profile.Tooltips.skin then
				if not clib.tooltip.hooked then
					if self.db.profile.Tooltips.style == 3 then clib.tooltip:SetBackdrop(self.backdrop) end
					self:SecureHook(clib.tooltip, "Show", function(this)
						self:skinTooltip(clib.tooltip)
					end)
					clib.tooltip.hooked = true
				end
			end

			-- skin the Help frame
			if not clib.help.skinned then
				self:moveObject(clib.help.close, nil, nil, "-", 2)
				self:applySkin(clib.help)
				self:skinUsingBD2(clib.help.scroll.hScroll)
				self:skinUsingBD2(clib.help.scroll.vScroll)
				clib.help.skinned = true
			end

			-- hook this to skin various controls
			self:RawHook(frame, "AddControl", function(this, id, cType, column, ...)
	-- 		self:Debug("Configator_Create_AddControl: [%s, %s, %s, %s]", id, cType, column, ...)
				local control = self.hooks[frame].AddControl(this, id, cType, column, ...)
				-- skin the sub-frame if required
				if not this.tabs[id].frame.skinned then
					self:applySkin(this.tabs[id].frame)
					this.tabs[id].frame.skinned = true
				end
				-- skin the scroll bars
				if this.tabs[id].scroll and not this.tabs[id].scroll.skinned then
					self:skinUsingBD2(this.tabs[id].scroll.hScroll)
					self:skinUsingBD2(this.tabs[id].scroll.vScroll)
					this.tabs[id].scroll.skinned = true
				end
				-- skin the DropDown
				if cType == "Selectbox" then
					self:skinDropDown(control)
	--				self:keepFontStrings(control)
					if not SelectBoxMenu.skinned then
						self:applySkin(SelectBoxMenu.back)
						SelectBoxMenu.skinned= true
					end
				end
				if cType == "Text" or cType == "TinyNumber" or cType == "NumberBox" then
					self:skinEditBox(control, {9})
				end
				if cType == "MoneyFrame" or cType == "MoneyFramePinned" then
					self:skinMoneyFrame(control, nil, true, true)
				end
				return control
				end, true)
			return frame
		end, true)
	end

	-- skin frames already created
	if clib and clib.frames then
		for i = 1, #clib.frames do
			local frame = clib.frames[i]
			if frame then
				self:applySkin(frame)
				frame.skinned = true
			end
			if frame.tabs then
				for j = 1, #frame.tabs do
					local tab = frame.tabs[j]
					self:applySkin(tab.frame)
					tab.frame.skinned = true
					if tab.frame.ctrls then
						for k = 1, #tab.frame.ctrls do
							local tfc = tab.frame.ctrls[k]
							if tfc.kids then
								for l = 1, #tfc.kids do
									local tfck = tfc.kids[l]
									if tfck.stype then
										if tfck.stype == "EditBox" then
											self:skinEditBox(tfck, {9})
										end
										if tfck.stype == "SelectBox" then
											self:keepFontStrings(tfck)
										end
										if tfck.isMoneyFrame then
											self:skinMoneyFrame(tfck, nil, true, true)
										end
									end
								end
							end
						end
					end
					if tab.scroll then
						self:skinUsingBD2(tab.scroll.hScroll)
						self:skinUsingBD2(tab.scroll.vScroll)
						tab.scroll.skinned = true
					end
				end
			end
		end
	end

	-- skin the Tooltip
	if self.db.profile.Tooltips.skin then
		if clib and not clib.tooltip.hooked then
			if self.db.profile.Tooltips.style == 3 then clib.tooltip:SetBackdrop(self.backdrop) end
			self:SecureHook(clib.tooltip, "Show", function(this)
				self:skinTooltip(clib.tooltip)
			end)
			clib.tooltip.hooked = true
		end
	end

	-- skin the Help frame
	if clib and clib.help then
		self:moveObject(clib.help.close, nil, nil, "-", 2)
		self:applySkin(clib.help)
		self:skinUsingBD2(clib.help.scroll.hScroll)
		self:skinUsingBD2(clib.help.scroll.vScroll)
		clib.help.skinned = true
	end
	-- skin DropDown menu
	if SelectBoxMenu then
		self:applySkin(SelectBoxMenu.back)
		SelectBoxMenu.skinned= true
	end

	-- skin ScrollSheets
	local sslib = LibStub("ScrollSheet", true)
	if sslib then
		self:RawHook(sslib, "Create", function(this, parent, ...)
			local sheet = self.hooks[sslib].Create(this, parent, ...)
	--		self:Debug("ScrollSheet_Create: [%s]", sheet.name)
			self:applySkin(parent)
			self:skinUsingBD2(sheet.panel.hScroll)
			self:skinUsingBD2(sheet.panel.vScroll)
			return sheet
		end, true)
	end

end
