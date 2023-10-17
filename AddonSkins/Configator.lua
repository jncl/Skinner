local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin.Configator = function(self) -- v 3.4.6987
	if self.initialized.Configator then return end
	self.initialized.Configator = true

	-- hook this to skin Slide bars
	local sblib = _G.LibStub:GetLibrary("SlideBar", true)
	if sblib
	and sblib.frame
	then
		-- self:applySkin(sblib.frame)
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, sblib.tooltip)
		end)
	end

	local function skinHelp(obj)
		aObj:moveObject{obj=obj.help.close, y=-1}
		aObj:skinObject("slider", {obj=obj.help.scroll.hScroll})
		aObj:skinObject("slider", {obj=obj.help.scroll.vScroll})
		aObj:skinObject("frame", {obj=obj.help, ofs=0})
		if aObj.modBtns then
			aObj:skinCloseButton{obj=obj.help.close}
		end
	end
	local clib = _G.LibStub:GetLibrary("Configator", true)
	-- hook this to skin Configator frames
	if clib then
		self:RawHook(clib, "Create", function(this, ...)
			local frame = self.hooks[this].Create(this, ...)
			self:skinObject("frame", {obj=frame.Backdrop, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=frame.Done}
			end

			if not _G.rawget(self.ttList, this.tooltip) then
				_G.C_Timer.After(0.1, function()
					self:add2Table(self.ttList, this.tooltip)
				end)
			end

			skinHelp(this)

			-- hook this to skin various controls
			self:RawHook(frame, "AddControl", function(fObj, id, cType, column, ...)
				local control = self.hooks[frame].AddControl(fObj, id, cType, column, ...)
				-- self:Debug("Configator_Create_AddControl: [%s, %s, %s, %s, %s, %s]", control, id, cType, column, ...)
				self:skinObject("frame", {obj=fObj.tabs[id].frame, y1=0})
				if fObj.tabs[id].scroll then
					self:skinObject("slider", {obj=this.tabs[id].scroll.hScroll})
					self:skinObject("slider", {obj=this.tabs[id].scroll.vScroll})
				end
				-- skin the DropDown
				if cType == "Selectbox" then
					self:skinObject("dropdown", {obj=control, rpc=true, y2=-4})
					-- self:skinObject("frame", {obj=_G.SelectBoxMenu.back})
				elseif cType == "Text" or cType == "TinyNumber" or cType == "NumberBox" then
					self:skinObject("editbox", {obj=control, y1=-4, y2=4})
				elseif cType == "NumeriSlider" or cType == "NumeriWide" or cType == "NumeriTiny" then
					self:skinObject("editbox", {obj=control.subcontrol, y1=-4, y2=4})
				elseif cType == "MoneyFrame" or cType == "MoneyFramePinned" then
					self:skinObject("moneyframe", {obj=control, moveSEB=true})
				elseif cType == "Button" then
					if self.modBtns then
						self:skinStdButton{obj=control}
					end
				elseif cType == "Checkbox" then
					if self.modChkBtns then
						self:skinCheckButton{obj=control}
					end
				end
				if control
				and control.stype == "Slider" then
					self:skinObject("slider", {obj=control})
				end
				return control
			end, true)
			return frame
		end, true)
		-- skin frames already created
		if clib.frames then
			for _, frame in _G.pairs(clib.frames) do
				if frame then
					self:skinObject("frame", {obj=frame.Backdrop, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=frame.Done}
					end
				end
				if frame.tabs then
					for _, tab in _G.ipairs(frame.tabs) do
						self:skinObject("frame", {obj=tab.frame})
						if tab.frame.ctrls then
							for _, tfc in _G.ipairs(tab.frame.ctrls) do
								if tfc.kids then
									for _, tfck in _G.ipairs(tfc.kids) do
										if tfck.stype then
											if tfck.stype == "SelectBox" then
												self:skinObject("dropdown", {obj=tfck, rpc=true, y2=-4})
												self:skinObject("frame", {obj=_G.SelectBoxMenu.back})
											elseif tfck.stype == "EditBox" then
												self:skinObject("editbox", {obj=tfck, y1=-4, y2=4})
											elseif tfck.stype == "Slider" then
												self:skinObject("slider", {obj=tfck})
												if tfck.slave then
													self:skinObject("editbox", {obj=tfck.slave, y1=-4, y2=4})
												end
											elseif tfck.isMoneyFrame then
												self:skinMoneyFrame{obj=tfck, noWidth=true, moveSEB=true}
											elseif tfck.stype == "Button" then
												if self.modBtns then
													self:skinStdButton{obj=tfck}
												end
											elseif tfck.stype == "CheckButton" then
												if self.modChkBtns then
													self:skinCheckButton{obj=tfck}
												end
											end
										end
									end
								end
							end
						end
						if tab.scroll then
							self:skinObject("slider", {obj=tab.scroll.hScroll})
							self:skinObject("slider", {obj=tab.scroll.vScroll})
						end
					end
				end
			end
		end
		if clib.tooltip then
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, clib.tooltip)
			end)
		end
		if clib.help then
			skinHelp(clib)
		end
	end
	-- skin DropDown menu
	if _G.SelectBoxMenu then
		self:skinObject("frame", {obj=_G.SelectBoxMenu.back})
	end

	-- skin ScrollSheets
	local sslib = _G.LibStub:GetLibrary("ScrollSheet", true)
	if sslib then
		self:RawHook(sslib, "Create", function(this, parent, ...)
			local sheet = self.hooks[this].Create(this, parent, ...)
			self:skinObject("slider", {obj=sheet.panel.hScroll})
			self:skinObject("slider", {obj=sheet.panel.vScroll})
			self:skinObject("frame", {obj=parent, ofs=0})
			return sheet
		end, true)
	end

end
