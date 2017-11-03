local aName, aObj = ...
if not aObj:isAddonEnabled("WIM") then return end
local _G = _G

aObj.addonsToSkin.WIM = function(self) -- v 3.7.14

	local function skinWindow(msgFrame)

		if msgFrame.sf then return end

		aObj:keepFontStrings(msgFrame.widgets.Backdrop)
		msgFrame.widgets.class_icon:SetAlpha(1)

		local eBox = msgFrame.widgets.msg_box
		eBox:SetWidth(msgFrame:GetWidth() - 20)
		local xOfs = _G.select(4, msgFrame.widgets.close:GetPoint())
		xOfs = _G.floor(xOfs)
		if xOfs == 4 then
			eBox:SetHeight(eBox:GetHeight() - 5)
			aObj:skinEditBox(eBox, {9})
			eBox:SetPoint("TOPLEFT", msgFrame, "BOTTOMLEFT", 10, 30)
			aObj:moveObject{obj=msgFrame.widgets.close, x=-2}
			aObj:moveObject{obj=msgFrame.widgets.class_icon, y=-2}
		end
		eBox, xOfs = nil, nil
		aObj:addSkinFrame{obj=msgFrame, ft="a", kfs=true}

	end

	-- hook these to skin the Message Frames
	self:RawHook(_G.WIM, "CreateWhisperWindow", function(playerName)
		local msgFrame = self.hooks[_G.WIM].CreateWhisperWindow(playerName)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	self:RawHook(_G.WIM, "CreateChatWindow", function(chatName)
		local msgFrame = self.hooks[_G.WIM].CreateChatWindow(chatName)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	self:RawHook(_G.WIM, "CreateW2WWindow", function(w2wname)
		local msgFrame = self.hooks[_G.WIM].CreateW2WWindow(w2wname)
		skinWindow(msgFrame)
		return msgFrame
	end, true)

	-- skin the history viewer
	if _G.WIM.modules["History"]
	and _G.WIM.modules["History"].enabled
	then
		self:SecureHook(_G.WIM, "ShowHistoryViewer", function(this, ...)
			local hvFrame = _G.WIM3_HistoryFrame
			hvFrame.title:SetPoint("TOPLEFT", 50 , -7)
			hvFrame.close:SetPoint("TOPRIGHT", -4, -4)
		    hvFrame.resize:SetPoint("BOTTOMRIGHT", 0, 0)
			self:applySkin(hvFrame)
			-- navigation panel
			hvFrame.nav.border:Hide()
			self:skinDropDown(hvFrame.nav.user)
			self:skinSlider{obj=hvFrame.nav.filters.scroll.ScrollBar, size=3}
			hvFrame.nav.filters.border:Hide()
			self:applySkin(hvFrame.nav.filters)
			self:skinSlider{obj=hvFrame.nav.userList.scroll.ScrollBar, size=3}
			hvFrame.nav.userList.border:Hide()
			self:applySkin(hvFrame.nav.userList)
			-- search
			hvFrame.search.bg:Hide()
			self:keepFontStrings(hvFrame.search.text)
			self:skinEditBox(hvFrame.search.text, {9})
			-- content panel
			hvFrame.content.border:Hide()
			self:skinSlider{obj=hvFrame.content.textFrame.ScrollBar, size=3}
			self:applySkin(hvFrame.content)
			-- progress viewer
			self:keepFontStrings(hvFrame.progressBar)
			self:applySkin(hvFrame.progressBar)
			self:Unhook(_G.WIM, "ShowHistoryViewer")
		end)
	end

	-- skin the Menu (Minimap/LDB)
	if _G.WIM.modules["Menu"]
	and _G.WIM.modules["Menu"].enabled
	then
		self:SecureHook(_G.WIM.Menu, "Show", function(this, ...)
			for _, group in _G.pairs(_G.WIM.Menu.groups) do
				group:SetBackdrop(nil)
				group.title:SetPoint("TOPLEFT", 10, -8)
				group.title:SetPoint("TOPRIGHT", -10, -8);
			end
			self:SecureHook(_G.WIM.Menu, "Refresh", function(this)
				self:adjWidth{obj=this, adj=-30}
				self:adjHeight{obj=this, adj=-20}
			end)
			self:adjWidth{obj=_G.WIM.Menu, adj=-30}
			self:adjHeight{obj=_G.WIM.Menu, adj=-20}
			self:applySkin(_G.WIM.Menu)
			self:Unhook(_G.WIM.Menu, "Show")
		end)
	end

	-- skin any existing chat windows
	for i = 1, 10 do
		local mFrame = _G["WIM3_msgFrame"..i]
		if mFrame then skinWindow(mFrame) end
	end

	-- minimap button
	self.mmButs["WIM"] = _G.WIM3MinimapButton

	-- skin WIM_Options
	self:checkAndRun("WIM_Options", "o")

end

aObj.otherAddons.WIM_Options = function(self)

	local r, g, b, a = self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4]
	local function checkKids(obj)

		if obj.sknd then return end
		obj.sknd = true

		for _, child in _G.ipairs{obj:GetChildren()} do
			if aObj:isDropDown(child) then
				aObj:skinDropDown{obj=child, x2= obj.mf and 110 or nil}
			elseif child.backdrop then
				child.backdrop.top:SetColorTexture(r, g, b, a)
				child.backdrop.bottom:SetColorTexture(r, g, b, a)
				child.backdrop.left:SetColorTexture(r, g, b, a)
				child.backdrop.right:SetColorTexture(r, g, b, a)
				child.backdrop.bg:SetTexture(nil)
				aObj:adjHeight{obj=child, adj=4}
			elseif child:IsObjectType("ScrollFrame") then
				aObj:skinSlider{obj=child.ScrollBar}
			elseif child:IsObjectType("Slider") then
				aObj:skinSlider{obj=child}
			elseif child:IsObjectType("CheckButton") then
				aObj:skinCheckButton{obj=child}
				checkKids(child)
			elseif child:IsObjectType("Button") then
				if child:GetName()
				and not child:GetNormalTexture()
				then
					aObj:skinStdButton{obj=child}
				else
					checkKids(child)
				end
			elseif child:GetParent().list then -- filter list
				local fl = child:GetParent().list
				-- move list above buttons, done by moving the associated checkbox up instead
				local relTo = select(2, fl:GetPoint(1))
				if relTo:GetNumPoints() == 1 then
					aObj:moveObject{obj=relTo, y=30}
				end
				aObj:skinSlider{obj=fl.scroll.ScrollBar}
				checkKids(fl)
				fl, relTo = nil, nil
				checkKids(child)
			else checkKids(child)
			end
		end

	end

	-- hook this to skin the options frame
	self:SecureHook(_G.WIM.options, "OnShow", function()
		local optFrame = _G.WIM.options.frame
		optFrame.title:SetPoint("TOPLEFT", 50 , -7)
		optFrame.close:SetPoint("TOPRIGHT", -4, -4)
		optFrame.nav.bg:Hide()
		self:addSkinFrame{obj=optFrame, ft="a", nb=true, y2=8}
		-- if frame is a function then hook it, otherwise check it
		for _, cat in _G.pairs(_G.WIM.options.frame.nav.category) do
			for _, subCat in _G.pairs(cat.info.subCategories) do
				if _G.type(subCat["frame"]) == "function" then -- if the frame hasn't been created yet
					self:RawHook(subCat, "frame", function()
						local catFrame = self.hooks[subCat].frame()
						checkKids(catFrame)
						self:Unhook(subCat, "frame")
						return catFrame
					end, true)
				elseif subCat.frame then checkKids(subCat.frame) -- it is a frame
				end
			end
		end
		self:Unhook(_G.WIM.options, "OnShow")
	end)

	-- hook this to skin the dropdown frame
	self:SecureHook(_G.WIM.options, "createDropDownFrame", function()
		self:addSkinFrame{obj=_G.WIM_DropDownFrame, ft="a"}
		-- hook this to ensure the frame is above button borders
		self:SecureHook(_G.WIM_DropDownFrame, "SetParent", function(this, parent)
			_G.RaiseFrameLevelByTwo(this)
		end)
		self:Unhook(_G.WIM.options, "createDropDownFrame")
	end)

	-- hook this to skin the filter frame
	if _G.WIM.modules["Filters"]
	and _G.WIM.modules["Filters"].enabled
	then
		self:SecureHook(_G.WIM, "ShowFilterFrame", function(this, ...)
			if _G.WIM3_FilterFrame then
				_G.WIM3_FilterFrame.title:SetPoint("TOPLEFT", 50 , -7)
				_G.WIM3_FilterFrame.close:SetPoint("TOPRIGHT", -4, -4)
				_G.WIM3_FilterFrame.name.backdrop.top:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.name.backdrop.bottom:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.name.backdrop.left:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.name.backdrop.right:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.name.backdrop.bg:SetTexture(nil)
				self:skinDropDown{obj=_G.WIM3_FilterFrame.by, x2=109}
				-- pattern box
				self:skinSlider{obj=_G.WIM3_FilterFrame.patternContainer.ScrollBar, size=3}
				_G.WIM3_FilterFrame.patternContainer.backdrop.top:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.patternContainer.backdrop.bottom:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.patternContainer.backdrop.left:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.patternContainer.backdrop.right:SetColorTexture(r, g, b, a)
				_G.WIM3_FilterFrame.patternContainer.backdrop.bg:SetTexture(nil)
				-- User options
				self:keepFontStrings(_G.WIM3_FilterFrame.user)
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.user.friend}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.user.guild}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.user.party}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.user.raid}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.user.xrealm}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.user.all}
				-- level options
				self:keepFontStrings(_G.WIM3_FilterFrame.level)
				self:skinSlider{obj=_G.WIM3_FilterFrame.level.slider}
				self:skinDropDown{obj=_G.WIM3_FilterFrame.level.class, x2=109}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.received}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.sent}
				self:skinDropDown{obj=_G.WIM3_FilterFrame.action, x2=109}
				self:skinCheckButton{obj=_G.WIM3_FilterFrame.actionNotify}
				_G.WIM3_FilterFrame.border:Hide()
				self:skinStdButton{obj=_G.WIM3_FilterFrame.cancel}
				self:skinStdButton{obj=_G.WIM3_FilterFrame.save}
				self:addSkinFrame{obj=_G.WIM3_FilterFrame, ft="a", nb=true}
				self:Unhook(this, "ShowFilterFrame")
			end
		end)
	end

end
