
function Skinner:DBM_GUI()

-->>--	Boss Mods Frame
	-- Hook this to manage the tabs
	self:Hook("DBMGUI_SetTabPosition_Update", function(div, lax, lay, lbx, lby, tabcount, frame, forceUpdate)
--		self:Debug("DBMGUI_STP_U: [%s, %s, %s, %s, %s, %s, %s, %s]", div, lax, lay, lbx, lby, tabcount, frame, forceUpdate)
		-- is this the Boss Mod Load Addon Frame
		if lax == 11 then
			-- skin the tab if required
			frame = frame or this
			for i = 1, tabcount do
				local tabName = _G["DBMBossModFrameTab"..i]
				if not tabName.skinned then
					self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
					if self.db.profile.TexturedTab then
						self:applySkin(tabName, nil, 0, 1)
						if i == 1 then self:setActiveTab(tabName) else self:setInactiveTab(tabName) end
						self:HookScript(tabName, "OnClick", function(this)
							self.hooks[this].OnClick(this)
							for i = 1, DBMGUI_MAINFRAME_TABCOUNT do
								local tabName = _G["DBMBossModFrameTab"..i]
								if i == this:GetID() then self:setActiveTab(tabName) else self:setInactiveTab(tabName) end
							end
						end)
					else self:applySkin(tabName) end
					tabName.skinned = true
				end
				-- Resize the Tabs here
				if forceUpdate then tabName:SetWidth(tabName:GetWidth() - 20) end
			end
		end
		self.hooks.DBMGUI_SetTabPosition_Update(0, 8, -9, -6, 0, tabcount, frame, forceUpdate)
	end)


	DBMBossModFrame:SetWidth(DBMBossModFrame:GetWidth() * self.FxMult)
	DBMBossModFrame:SetHeight(DBMBossModFrame:GetHeight() * self.FyMult)
	self:moveObject(DBMBossModFrameTitleText, nil, nil, "+", 8)
	self:keepFontStrings(DBMBossModFrameDropDownLevel)
	self:moveObject(DBMBossModFrameCloseButton, "+", 30, "+", 8)
	self:moveObject(DBMBossModFrameOptionsButton, "+", 28, "+", 8)
	self:keepFontStrings(DBMBossModFrame)
	self:applySkin(DBMBossModFrame)
	-- List Frame
	self:moveObject(DBMBossModListFrameButton1, "-", 10, "-", 70)
	self:moveObject(DBMBossModListFrameLoadAddOns, nil, nil, "-", 40)
	self:moveObject(DBMBossModButton1, "-", 10, "+", 10)
	self:moveObject(DBMBossModFrameDBMBossModScrollFrame, "+", 30, "+", 10)
	self:keepFontStrings(DBMBossModFrameDBMBossModScrollFrame)
	self:skinScrollBar(DBMBossModFrameDBMBossModScrollFrame)

-->>--	Options Frame
	-- Hook this to manage tab widths
	self:HookScript(DBMOptionsFrame, "OnShow", function()
		self.hooks[DBMOptionsFrame].OnShow()
		for i = 1, DBMGUI_SIDEFRAME_TABCOUNT do
			local tabName = _G["DBMOptionsFrameTab"..i]
			tabName:SetWidth(tabName:GetWidth() - 10)
		end
	end)

	self:keepFontStrings(DBMOptionsFrame)
	self:moveObject(DBMOptionsFrame, "+", 25, nil, nil)
	self:moveObject(DBMOptionsFrameCloseButton, "-", 2, "-", 5)
	self:applySkin(DBMOptionsFrame)

	self:keepFontStrings(DBMOptionsFramePage2StatusBarDesignDropDown)
	self:moveObject(DBMOptionsFramePage2PizzaBoxName, "-", 20, nil, nil)
	self:skinEditBox(DBMOptionsFramePage2PizzaBoxName, {9})
	self:moveObject(DBMOptionsFramePage2PizzaBoxHourTitle, "+", 8, nil, nil)
	self:skinEditBox(DBMOptionsFramePage2PizzaBoxHour, {9})
	self:moveObject(DBMOptionsFramePage2PizzaBoxMinTitle, "+", 8, nil, nil)
	self:skinEditBox(DBMOptionsFramePage2PizzaBoxMin, {9})
	self:moveObject(DBMOptionsFramePage2PizzaBoxSecTitle, "+", 8, nil, nil)
	self:skinEditBox(DBMOptionsFramePage2PizzaBoxSec, {9})
	self:keepFontStrings(DBMOptionsFramePage3RaidWarningDropDown)
	self:skinEditBox(DBMOptionsFramePage5AutoRespondBusyMessage, {9})

	-- Options Frame Tabs
	for i = 1, DBMGUI_SIDEFRAME_TABCOUNT do
		local tabName = _G["DBMOptionsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName) else self:setInactiveTab(tabName) end
			self:HookScript(tabName, "OnClick", function(this)
--				self:Debug("DBMOptionsFrameTab_OnClick: [%s, %s]", this:GetName(), this:GetID())
				self.hooks[this].OnClick(this)
				for i = 1, DBMGUI_SIDEFRAME_TABCOUNT do
					local tabName = _G["DBMOptionsFrameTab"..i]
					if i == this:GetID() then self:setActiveTab(tabName) else self:setInactiveTab(tabName) end
				end
			end)
		else self:applySkin(tabName) end
	end

end

function Skinner:DBM_RaidTools()

	self:applySkin(DBM_DurabilityFrame)

end
