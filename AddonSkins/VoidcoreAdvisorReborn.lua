local _, aObj = ...
if not aObj:isAddonEnabled("VoidcoreAdvisorReborn") then return end
local _G = _G

aObj.addonsToSkin.VoidcoreAdvisorReborn = function(self) -- v 2.8.2

	local cnt, DungeonOverview, Panel, picker, pickerPopup, RaidOverview = 0
	self.RegisterCallback("VoidCoreAdvisorReborn", "UIParent_GetChildren", function(_, child, _)
		if child:GetSourceLocation():find("VoidcoreAdvisorReborn/UI/DungeonOverview")
		and child:GetWidth() == 480
		then
			DungeonOverview = child
			cnt = cnt + 1
		end
		if child:GetSourceLocation():find("VoidcoreAdvisorReborn/UI/DungeonOverview")
		and child:GetWidth() == 300
		then
			pickerPopup = child
			cnt = cnt + 1
		end
		if child:GetSourceLocation():find("VoidcoreAdvisorReborn/UI/Panel") then
			Panel = child
			cnt = cnt + 1
		end
		if child:GetSourceLocation():find("VoidcoreAdvisorReborn/UI/RaidOverview") then
			RaidOverview = child
			cnt = cnt + 1
		end
		if child:GetSourceLocation():find("VoidcoreAdvisorReborn/UI/RaidSlots")
		and child.GetBackdrop
		then
			picker = child
			cnt = cnt + 1
		end
		if cnt == 5 then
			self.UnregisterCallback("VoidCoreAdvisorReborn", "UIParent_GetChildren")
		end
	end)

	_G.RunNextFrame(function()

		-- TODO: skin buttons on EncounterJournal Dungeons tab which toggles the VoidcoreAdvisor panel & DungeonOverview
			-- toggleBtn
			-- overviewToggleBtn
		self:SecureHookScript(DungeonOverview, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("frame", {obj=this, kfs=true, cb=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1)} -- closeBtn
				self:skinStdButton{obj=self:getChild(this, 2)} -- scanBtn
			end

			self:Unhook(DungeonOverview, "OnShow")
		end)
		self:checkShown(DungeonOverview)

		self:SecureHookScript(Panel, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			-- contentArea
				-- keyLevelButton
					-- keyLevelMenu
			self:skinObject("frame", {obj=this, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1)} -- closeBtn
			end

			self:Unhook(Panel, "OnShow")
		end)
		self:checkShown(Panel)

		-- RaidSlots
		self:SecureHookScript(picker, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("slider", {obj=self:getChild(this, 2).ScrollBar})
			self:skinObject("frame", {obj=this, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1)} -- closeBtn
			end

			self:Unhook(picker, "OnShow")
		end)
		self:checkShown(picker)

		-- DungeonOverview
		self:SecureHookScript(pickerPopup, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			-- contentArea
			self:skinObject("slider", {obj=self:getChild(this, 2).ScrollBar})
			self:skinObject("frame", {obj=this, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1)} -- pickerCloseBtn
			end

			self:Unhook(pickerPopup, "OnShow")
		end)
		self:checkShown(pickerPopup)

		self:SecureHookScript(RaidOverview, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("frame", {obj=this, kfs=true, cb=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1)} -- closeBtn
				self:skinStdButton{obj=self:getChild(this, 2)} -- raidScanBtn
				-- self:skinStdButton{obj=self:getChild(this, 4)} -- charsBtn (DON'T skin this button)
			end

			self:Unhook(RaidOverview, "OnShow")
		end)
		self:checkShown(RaidOverview)

	end)

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("slider", {obj=_G.VCAReportScroll.ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true, cb=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(fObj, 1)} -- closeBtn
				self:skinStdButton{obj=self:getChild(fObj, 3)} -- actionBtn
			end
		end)
	end}, "VCAReportFrame")

	-- TODO: skin settings ??
	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(fObj, 1)} -- closeBtn
			end
		end)
	end}, "VCASettingsFrame")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=self:getChild(fObj, 1), kfs=true, fb=true}) -- innerBorder
			self:skinObject("statusbar", {obj=self:getChild(fObj, 12), fi=0})
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(fObj, 2)} -- closeBtn
				self:skinOtherButton{obj=self:getChild(fObj, 3), size=26, text="<"} -- prevBtn
				self:skinOtherButton{obj=self:getChild(fObj, 4), size=26, text=">"} -- nextBtn
			end

		end)
	end}, "VCAThemePreviewFrame")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("slider", {obj=self:getChild(fObj, 2).ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(fObj, 1)} -- closeBtn
			end
		end)
	end}, "VCAMissingFrame")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("slider", {obj=self:getChild(fObj, 2).ScrollBar})
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(fObj, 1)} -- closeBtn
				self:skinStdButton{obj=self:getChild(fObj, 3)} -- importBtn
			end
		end)
	end}, "VCATransferFrame")

	self:SecureHookScript(_G.VCABanner, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		self:skinObject("frame", {obj=this, kfs=true, cb=true})

		self:Unhook(_G.VCABanner, "OnShow")
	end)
	self:checkShown(_G.VCABanner)

	self:SecureHookScript(_G.VCARollWindow, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		self:skinObject("frame", {obj=self:getChild(this, 1), kfs=true, fb=true}) -- winInnerEdge
		self:skinObject("statusbar", {obj=self:getChild(this, 3), fi=0})
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(_G.VCARollWindow, "OnShow")
	end)
	self:checkShown(_G.VCARollWindow)

	self:SecureHookScript(_G.VoidcoreAdvisorReminder, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 1)} -- yesBtn
			self:skinStdButton{obj=self:getChild(this, 2)} -- noBtn
		end

		self:Unhook(_G.VoidcoreAdvisorReminder, "OnShow")
	end)
	self:checkShown(_G.VoidcoreAdvisorReminder)

	self:SecureHookScript(_G.VoidcoreAdvisorWarning, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 1)} -- wf_closeBtn
		end

		self:Unhook(_G.VoidcoreAdvisorWarning, "OnShow")
	end)
	self:checkShown(_G.VoidcoreAdvisorWarning)

end
