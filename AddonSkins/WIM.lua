
function Skinner:WIM() -- WIM3

	local function skinWindow(msgFrame)

		Skinner:keepFontStrings(msgFrame.widgets.Backdrop)
		msgFrame.widgets.class_icon:SetAlpha(1)

		local eBox = msgFrame.widgets.msg_box
		eBox:SetWidth(msgFrame:GetWidth() - 20)
		local xOfs = select(4, msgFrame.widgets.close:GetPoint())
		xOfs = math.floor(xOfs)
		if xOfs == 4 then
			eBox:SetHeight(eBox:GetHeight() - 5)
			Skinner:skinEditBox(eBox, {9})
			Skinner:moveObject(eBox, "-", 16, "-", 0)
			Skinner:moveObject{obj=msgFrame.widgets.close, x=-2}
			Skinner:moveObject{obj=msgFrame.widgets.class_icon, y=-2}
		end

		Skinner:addSkinFrame{obj=msgFrame, kfs=true}

	end

	local function checkKids(obj)
	
		if Skinner.skinned[obj] then return end
		Skinner:skinAllButtons{obj=obj}
		
		local kids = {obj:GetChildren()}
		for _, child in ipairs(kids) do
			if Skinner:isDropDown(child) then
				Skinner:skinDropDown(child)
			elseif child.backdrop then
				Skinner:addSkinFrame{obj=child, kfs=true, x1=-3, y1=3, x2=3, y2=-3}
				checkKids(child)
			elseif child:IsObjectType("ScrollFrame") then
				Skinner:skinScrollBar{obj=child}
			else checkKids(child)
			end
		end
		kids = nil
		
	end
	
	-- hook this to skin the options frame
	self:SecureHook(WIM.options, "OnShow", function(this)
		local optFrame = WIM.options.frame
		optFrame.title:SetPoint("TOPLEFT", 50 , -7)
		optFrame.close:SetPoint("TOPRIGHT", -4, -4)
		optFrame.nav.bg:Hide()
		self:skinAllButtons{obj=optFrame}
		self:applySkin(optFrame)
		-- if frame is a function then hook it, otherwise check it
		for i = 1, #WIM.options.frame.nav.category do
			local cat = WIM.options.frame.nav.category[i]
			for j = 1, #cat.info.subCategories do
				local subCat = cat.info.subCategories[j]
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
	if WIM.modules["Filters"] and WIM.modules["Filters"].enabled then
		self:SecureHook(WIM, "ShowFilterFrame", function(this, ...)
			local fFrame = self:findFrame3("WIM3_FilterFrame", "nameText")
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
			self:skinAllButtons{obj=fFrame}
			self:applySkin(fFrame)
			self:Unhook(WIM, "ShowFilterFrame")
		end)
	end
	-- skin the history viewer
	if WIM.modules["History"] and WIM.modules["History"].enabled then
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
	if WIM.modules["Menu"] and WIM.modules["Menu"].enabled then
		self:SecureHook(WIM.Menu, "Show", function(this, ...)
			for i = 1, #WIM.Menu.groups do
				local group = WIM.Menu.groups[i]
				group:SetBackdrop(nil)
				group.title:SetPoint("TOPLEFT", 10, -8)
				group.title:SetPoint("TOPRIGHT", -10, -8);
			end
			self:SecureHook(WIM.Menu, "Refresh", function(this)
				this:SetWidth(this:GetWidth() - 30)
				this:SetHeight(this:GetHeight() - 20)
			end)
			self:adjWidth{obj=WIM.Menu, adj=-30}
			self:adjHeight{obj=WIM.Menu, adj=-20}
			self:applySkin(WIM.Menu)
			self:Unhook(WIM.Menu, "Show")
		end)
	end

end
