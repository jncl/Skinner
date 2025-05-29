local _, aObj = ...
if not aObj:isAddonEnabled("WoWPro") then return end
local _G = _G

aObj.addonsToSkin.WoWPro = function(self) -- v 2025.04.24.A

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

	local function skinRows(parent)
		for _, row in _G.pairs(parent.rows) do
			aObj:add2Table(aObj.ttList, row.action.tooltip)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=row.itembutton}
				aObj:addButtonBorder{obj=row.itembuttonSecured, sabt=true, hide=true}
				aObj:addButtonBorder{obj=row.targetbutton}
				aObj:addButtonBorder{obj=row.targetbuttonSecured, sabt=true}
				aObj:addButtonBorder{obj=row.eabutton}
				aObj:addButtonBorder{obj=row.eabuttonSecured, sabt=true}
				aObj:addButtonBorder{obj=row.lootsbutton}
				aObj:addButtonBorder{obj=row.jumpbutton}
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=row.check, ignNT=true}
				row.check:SetSize(22, 22)
			end
		end
	end
	_G.C_Timer.After(0.5, function()
		skinRows(_G.WoWPro)
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
		skinRows(this)
		-- TODO: skin row tooltip

		self:Unhook(this, "OnShow")
	end)

end
