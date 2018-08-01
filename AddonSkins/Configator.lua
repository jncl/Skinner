local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin.Configator = function(self) -- v 7.5.5724
	if self.initialized.Configator then return end
	self.initialized.Configator = true

	-- hook this to skin Slide bars
	local sblib = _G.LibStub("SlideBar", true)
	if sblib
	and sblib.frame
	then
		self:applySkin(sblib.frame)
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, sblib.tooltip)
		end)
	end

	local clib = _G.LibStub:GetLibrary("Configator", true)
	local function skinHelp(obj)

		aObj:moveObject{obj=obj.help.close, y=-2}
		aObj:skinCloseButton{obj=obj.help.close}
		aObj:skinUsingBD{obj=obj.help.scroll.hScroll}
		aObj:skinUsingBD{obj=obj.help.scroll.vScroll}
		aObj:addSkinFrame{obj=obj.help, ft="a", nb=true}

	end
	-- hook this to skin Configator frames
	if clib then
		self:RawHook(clib, "Create", function(this, ...)
			local frame = self.hooks[this].Create(this, ...)
--			self:Debug("Configator_Create: [%s]", frame:GetName())
			if not frame.Backdrop.sf then
				self:skinStdButton{obj=frame.Done}
				self:addSkinFrame{obj=frame.Backdrop, ft="a", nb=true}
			end

			-- TODO change to rawget
			if not _G.rawget(self.ttList, this.tooltip) then
				-- tooltip
				_G.C_Timer.After(0.1, function()
					self:add2Table(self.ttList, this.tooltip)
				end)
			end

			if not this.help.sf then
				skinHelp(this)
			end

			-- hook this to skin various controls
			self:RawHook(frame, "AddControl", function(this, id, cType, column, ...)
				local control = self.hooks[frame].AddControl(this, id, cType, column, ...)
	 			-- self:Debug("Configator_Create_AddControl: [%s, %s, %s, %s, %s]", control, id, cType, column, ...)
				-- skin the sub-frame if required
				if not this.tabs[id].frame.sf then
					self:addSkinFrame{obj=this.tabs[id].frame, ft="a", nb=true}
				end
				-- skin the scroll bars
				if this.tabs[id].scroll and not this.tabs[id].scroll.sknd then
					this.tabs[id].scroll.sknd = true
					self:skinUsingBD{obj=this.tabs[id].scroll.hScroll}
					self:skinUsingBD{obj=this.tabs[id].scroll.vScroll}
				end
				-- skin the DropDown
				if cType == "Selectbox" then
					self:skinDropDown{obj=control, rp=true, y2=-4}
					if not _G.SelectBoxMenu.back.sf then
						self:addSkinFrame{obj=_G.SelectBoxMenu.back, ft="a", nb=true}
					end
				elseif cType == "Text" or cType == "TinyNumber" or cType == "NumberBox" then
					self:skinEditBox{obj=control, regs={6}}
				elseif cType == "NumeriSlider" or cType == "NumeriWide" or cType == "NumeriTiny" then
					self:skinEditBox{obj=control.slave, regs={6}}
				elseif cType == "MoneyFrame" or cType == "MoneyFramePinned" then
					self:skinMoneyFrame{obj=control, noWidth=true, moveSEB=true}
				elseif cType == "Button" then
					self:skinStdButton{obj=control}
				elseif cType == "Checkbox" then
					self:skinCheckButton{obj=control}
				end
				if control
				and control.stype == "Slider" then
					self:skinSlider{obj=control, hgt=-4}
				end
				return control
			end, true)
			return frame
		end, true)
	end

	-- skin frames already created
	if clib
	and clib.frames
	then
		for i = 1, #clib.frames do
			local frame = clib.frames[i]
			if frame then
				self:addSkinFrame{obj=frame, ft="a", nb=true}
			end
			if frame.tabs then
				for j = 1, #frame.tabs do
					local tab = frame.tabs[j]
					self:addSkinFrame{obj=tab.frame, ft="a", nb=true}
					if tab.frame.ctrls then
						for k = 1, #tab.frame.ctrls do
							local tfc = tab.frame.ctrls[k]
							if tfc.kids then
								for l = 1, #tfc.kids do
									local tfck = tfc.kids[l]
									if tfck.stype then
										if tfck.stype == "SelectBox" then
											self:skinDropDown{obj=tfck, rp=true, y2=-4}
											if not _G.SelectBoxMenu.back.sf then
												self:addSkinFrame{obj=_G.SelectBoxMenu.back, ft="a", nb=true}
											end
										elseif tfck.stype == "EditBox" then
											self:skinEditBox{obj=tfck, regs={6}}
										elseif tfck.stype == "Slider" then
											self:skinSlider{obj=tfck, hgt=-4}
											if tfck.slave then
												self:skinEditBox{obj=tfck.slave, regs={6}}
											end
										-- elseif tfck.stype == "SelectBox" then
										-- 	self:keepFontStrings(tfck)
										elseif tfck.isMoneyFrame then
											self:skinMoneyFrame{obj=tfck, noWidth=true, moveSEB=true}
										elseif tfck.stype == "Button" then
											self:skinStdButton{obj=tfck}
										elseif tfck.stype == "CheckButton" then
											self:skinCheckButton{obj=tfck}
										end
									end
								end
							end
						end
					end
					if tab.scroll then
						tab.scroll.sknd = true
						self:skinUsingBD{obj=tab.scroll.hScroll}
						self:skinUsingBD{obj=tab.scroll.vScroll}
					end
				end
			end
		end
	end

	-- tooltip
	if clib
	and clib.tooltip
	then
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, clib.tooltip)
		end)
	end

	-- skin the Help frame
	if clib
	and clib.help
	then
		skinHelp(clib)
	end
	-- skin DropDown menu
	if _G.SelectBoxMenu then
		self:addSkinFrame{obj=_G.SelectBoxMenu.back, ft="a", nb=true}
	end

	-- skin ScrollSheets
	local sslib = _G.LibStub:GetLibrary("ScrollSheet", true)
	if sslib then
		self:RawHook(sslib, "Create", function(this, parent, ...)
			local sheet = self.hooks[this].Create(this, parent, ...)
			self:skinUsingBD{obj=sheet.panel.hScroll}
			self:skinUsingBD{obj=sheet.panel.vScroll}
			self:applySkin{obj=parent} -- just skin it otherwise text is hidden
			return sheet
		end, true)
	end

end
