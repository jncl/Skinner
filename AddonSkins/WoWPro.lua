local _, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end
local _G = _G

aObj.addonsToSkin.WoWPro = function(self) -- v 2025.03.04.A

	self:SecureHookScript(_G.WoWPro.MainFrame, "OnShow", function(this)
		_G.WoWPro.BackgroundSet = _G.nop
		_G.WoWPro.Titlebar:SetBackdrop(nil)
		_G.WoWPro.Titlebar.SetBackdrop = _G.nop
		self:skinObject("slider", {obj=_G.WoWPro.Scrollbar})
		self:getChild(_G.WoWPro.Scrollbar, 3):SetBackdrop(nil)
		self:skinObject("frame", {obj=this, kfs=true, ng=true, ba=0.35})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WoWPro.MainFrame)

	_G.C_Timer.After(0.5, function()
		for _, row in _G.pairs(_G.WoWPro.rows) do
			self:add2Table(self.ttList, row.action.tooltip)
			-- .step
			-- .note
			-- .track
			if self.modBtnBs then
				self:addButtonBorder{obj=row.itembutton, iabt=true, ofs=3}
				-- .itembuttonSecured
				self:addButtonBorder{obj=row.targetbutton, iabt=true, ofs=3}
				-- .targetbuttonSecured
				self:addButtonBorder{obj=row.lootsbutton, ofs=3}
				-- .jumpbutton
				-- .eabutton
				-- .eabuttonSecured
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=row.check, ignNT=true}
				row.check:SetSize(22, 22)
			end
		end
		for _, row in _G.ipairs(_G.WoWPro.mousenotes) do
			self:skinObject("frame", {obj=row, kfs=true})
		end
	end)

	self:SecureHookScript(_G.WoWPro_SkipSteps, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.WoWPro_SkipOkay}
			self:skinStdButton{obj=_G.WoWPro_SkipCancel}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WoWPro_GuideCompleted, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.WoWPro_LoadNextGuide}
			self:skinStdButton{obj=_G.WoWPro_OpenLevelingGuidelist}
			self:skinStdButton{obj=_G.WoWPro_ResetGuide}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.WoWPro, "CreateErrorLog", function(this, _)
		self:skinObject("slider", {obj=_G.WoWProErrorLog.Scroll.ScrollBar})
		self:skinObject("frame", {obj=_G.WoWProErrorLog, kfs=true})

		self:Unhook(this, "CreateErrorLog")
	end)

	self:SecureHookScript(_G.WoWPro.GuideList, "OnShow", function(this)
		this.scrollBox.scrollBar.trackBG:SetTexture(nil)
		self:skinObject("slider", {obj=this.scrollBox.scrollBar})
		self:skinObject("tabs", {obj=this.scrollBox, tabs=this.scrollBox.Tabs, ignoreSize=true, lod=self.isTT and true, upwards=true, offsets={x1=6, y1=-5, x2=-6, y2=-5}})

		self:skinObject("frame", {obj=this.scrollBox.titleRow, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WoWPro.CurrentGuideFrame, "OnShow", function(this)
		self:removeBackdrop(self:getChild(this.scrollbar, 3))
		self:skinObject("slider", {obj=this.scrollbar})
		self:skinObject("frame", {obj=this.box, kfs=true, fb=true})
		if self.modChkBtns then
			for _, row in _G.pairs(this.rows) do
				self:skinCheckButton{obj=row.check, ignNT=true}
				row.check:SetSize(22, 22)
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
