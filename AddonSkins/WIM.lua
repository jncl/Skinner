local aName, aObj = ...
if not aObj:isAddonEnabled("WIM") then return end

function aObj:WIM() -- WIM3

	local function findFrame3(name, element)

		local frame

		for _, child in pairs{UIParent:GetChildren()} do
			if child:GetName() == name then
				if child[element] then
					frame = child
					break
				end
			end
		end

		return frame

	end
	local function skinWindow(msgFrame)

		if aObj.skinFrame[msgFrame] then return end

		aObj:keepFontStrings(msgFrame.widgets.Backdrop)
		msgFrame.widgets.class_icon:SetAlpha(1)

		local eBox = msgFrame.widgets.msg_box
		eBox:SetWidth(msgFrame:GetWidth() - 20)
		local xOfs = select(4, msgFrame.widgets.close:GetPoint())
		xOfs = floor(xOfs)
		if xOfs == 4 then
			eBox:SetHeight(eBox:GetHeight() - 5)
			aObj:skinEditBox(eBox, {9})
			aObj:moveObject(eBox, "-", 16, "-", 0)
			aObj:moveObject{obj=msgFrame.widgets.close, x=-2}
			aObj:moveObject{obj=msgFrame.widgets.class_icon, y=-2}
		end

		aObj:addSkinFrame{obj=msgFrame, kfs=true}

	end
	local function checkKids(obj)

		if aObj.skinned[obj] then return end
		aObj:skinAllButtons{obj=obj}

		for _, child in pairs{obj:GetChildren()} do
			if aObj:isDropDown(child) then
				aObj:skinDropDown{obj=child, x2= obj.mf and 110 or nil}
			elseif child.backdrop then
				-- aObj:addSkinFrame{obj=child, kfs=true, x1=-3, y1=3, x2=3, y2=-3}
				checkKids(child)
			elseif child:IsObjectType("ScrollFrame") then
				aObj:skinScrollBar{obj=child}
			else checkKids(child)
			end
		end

	end

	-- hook this to skin the options frame
	self:SecureHook(WIM.options, "OnShow", function(this)
		local optFrame = WIM.options.frame
		optFrame.title:SetPoint("TOPLEFT", 50 , -7)
		optFrame.close:SetPoint("TOPRIGHT", -4, -4)
		optFrame.nav.bg:Hide()
		self:addSkinFrame{obj=optFrame, y2=12}
		-- if frame is a function then hook it, otherwise check it
		for _, cat in pairs(WIM.options.frame.nav.category) do
			for _, subCat in pairs(cat.info.subCategories) do
				if type(subCat["frame"]) == "function" then -- if the frame hasn't been created yet
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
		self:Unhook(WIM.options, "OnShow")
	end)
	-- hook this to skin the dropdown frame
	self:SecureHook(WIM.options, "createDropDownFrame", function(this)
		self:addSkinFrame{obj=WIM_DropDownFrame}
		self:Unhook(WIM.options, "createDropDownFrame")
	end)
	-- hook these to skin the Message Frames
	self:RawHook(WIM, "CreateWhisperWindow", function(playerName)
		local msgFrame = self.hooks[WIM].CreateWhisperWindow(playerName)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	self:RawHook(WIM, "CreateChatWindow", function(chatName)
		local msgFrame = self.hooks[WIM].CreateChatWindow(chatName)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	self:RawHook(WIM, "CreateW2WWindow", function(w2wname)
		local msgFrame = self.hooks[WIM].CreateW2WWindow(w2wname)
		skinWindow(msgFrame)
		return msgFrame
	end, true)
	-- hook this to skin the filter frame
	if WIM.modules["Filters"]
	and WIM.modules["Filters"].enabled
	then
		self:SecureHook(WIM, "ShowFilterFrame", function(this, ...)
			local fFrame = findFrame3("WIM3_FilterFrame", "nameText")
			fFrame.title:SetPoint("TOPLEFT", 50 , -7);
			fFrame.close:SetPoint("TOPRIGHT", -4, -4);
			self:skinDropDown(fFrame.by)
			self:skinScrollBar{obj=fFrame.patternContainer, size=3}
			self:keepFontStrings(fFrame.user)
			self:applySkin(fFrame.user)
			self:keepFontStrings(fFrame.level)
			self:applySkin(fFrame.level)
			self:skinDropDown(fFrame.action)
			fFrame.border:Hide()
			self:addSkinFrame{obj=fFrame}
			self:Unhook(WIM, "ShowFilterFrame")
		end)
	end
	-- skin the history viewer
	if WIM.modules["History"]
	and WIM.modules["History"].enabled
	then
		self:SecureHook(WIM, "ShowHistoryViewer", function(this, ...)
			local hvFrame = WIM3_HistoryFrame
			hvFrame.title:SetPoint("TOPLEFT", 50 , -7)
			hvFrame.close:SetPoint("TOPRIGHT", -4, -4)
		    hvFrame.resize:SetPoint("BOTTOMRIGHT", 0, 0)
			self:applySkin(hvFrame)
			-- navigation panel
			hvFrame.nav.border:Hide()
			self:skinDropDown(hvFrame.nav.user)
			self:skinScrollBar{obj=hvFrame.nav.filters.scroll, size=3}
			hvFrame.nav.filters.border:Hide()
			self:applySkin(hvFrame.nav.filters)
			self:skinScrollBar{obj=hvFrame.nav.userList.scroll, size=3}
			hvFrame.nav.userList.border:Hide()
			self:applySkin(hvFrame.nav.userList)
			-- search
			hvFrame.search.bg:Hide()
			self:keepFontStrings(hvFrame.search.text)
			self:skinEditBox(hvFrame.search.text, {9})
			-- content panel
			hvFrame.content.border:Hide()
			self:skinScrollBar{obj=hvFrame.content.textFrame, size=3}
			self:applySkin(hvFrame.content)
			-- progress viewer
			self:keepFontStrings(hvFrame.progressBar)
			self:applySkin(hvFrame.progressBar)
			self:Unhook(WIM, "ShowHistoryViewer")
		end)
	end
	-- skin the Menu (Minimap/LDB)
	if WIM.modules["Menu"]
	and WIM.modules["Menu"].enabled
	then
		self:SecureHook(WIM.Menu, "Show", function(this, ...)
			for _, group in pairs(WIM.Menu.groups) do
				group:SetBackdrop(nil)
				group.title:SetPoint("TOPLEFT", 10, -8)
				group.title:SetPoint("TOPRIGHT", -10, -8);
			end
			self:SecureHook(WIM.Menu, "Refresh", function(this)
				self:adjWidth{obj=this, adj=-30}
				self:adjHeight{obj=this, adj=-20}
			end)
			self:adjWidth{obj=WIM.Menu, adj=-30}
			self:adjHeight{obj=WIM.Menu, adj=-20}
			self:applySkin(WIM.Menu)
			self:Unhook(WIM.Menu, "Show")
		end)
	end

	-- skin any existing chat windows
	for i = 1, 10 do
		local mFrame = _G["WIM3_msgFrame"..i]
		if mFrame then skinWindow(mFrame) end
	end

end
