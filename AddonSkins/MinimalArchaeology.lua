local _, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end
local _G = _G

aObj.addonsToSkin.MinimalArchaeology = function(self) -- v 10.2.11.1

	self:SecureHookScript(_G.MinArchMain, "OnShow", function(this)
		_G.MinArchMainSkillBarBorder:Hide()
		_G.MinArchMainSkillBarBackground:SetAllPoints(_G.MinArchMain.skillBar)
		self:skinObject("statusbar", {obj=this.skillBar, fi=0, bg=_G.MinArchMainSkillBarBackground})
		for i = 1, _G.ARCHAEOLOGY_NUM_RACES do
			local obj = _G["MinArchArtifactBar" .. i]
			_G["MinArchArtifactBar" .. i .. "BarBG"]:Hide()
			obj:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
			self:skinObject("statusbar", {obj=obj, fi=0})
			if self.modBtns then
				self:skinStdButton{obj=obj.buttonSolve, schk=true}
			end
		end
		self:skinObject("frame", {obj=this, kfs=true, rb=true, y1=4})
		if self.modBtns then
			self:skinOtherButton{obj=this.buttonClose, text="x"}
			self:moveObject{obj=this.buttonClose, x=2, y=3}
			self:skinOtherButton{obj=this.buttonOpenHist, text="h"}
			self:moveObject{obj=this.buttonOpenHist, x=2, y=3}
			self:skinOtherButton{obj=this.openADIButton, text="d"}
			self:moveObject{obj=this.openADIButton, x=2, y=3}
			self:skinOtherButton{obj=_G.MinArchMainAutoWayButton, text="w"}
			_G.MinArchMainAutoWayButton:SetSize(25, 25)
			self:moveObject{obj=_G.MinArchMainAutoWayButton, x=-4, y=1}
			self:skinOtherButton{obj=_G.MinArchMainCrateButton, text="c"}
			self:moveObject{obj=_G.MinArchMainCrateButton, x=-2, y=3}
			self:skinOtherButton{obj=_G.MinArchMainRelevancyButton, text="r"}
			_G.MinArchMainRelevancyButton:SetSize(25, 25)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.MinArchMain)

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MinArchTooltipIcon, relTo=_G.MinArchTooltipIcon.icon, clr="grey"}
	end

	self:SecureHookScript(_G.MinArchHist, "OnShow", function(this)
		_G.MinArchHistGrad.bg:Hide()
		self:skinObject("frame", {obj=_G.MinArchHistStats, kfs=true, ofs=-4})
		self:skinObject("frame", {obj=this, kfs=true, rb=true, y1=5})
		self:RaiseFrameLevelByFour(this)
		if self.modBtns then
			self:skinOtherButton{obj=this.buttonClose, text="x"}
			self:moveObject{obj=this.buttonClose, x=2}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MinArchHistToggleButton, ofs=0, y1=-1, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.MinArchHist)

    local continentButtons = {
		"Kalimdor",
		"Eastern",
		"Outland",
		"Northrend",
		"Maelstrom",
		"Pandaria",
		"Draenor",
		"BrokenIsles",
		"Kultiras",
		"Zandalar"
	}

	self:SecureHookScript(_G.MinArchDigsites, "OnShow", function(this)
		_G.MinArchDigsitesGrad.bg:Hide()
		self:moveObject{obj=this.buttonClose, x=7, y=4}
		self:skinObject("frame", {obj=this, kfs=true, rb=true, y1=4})
		self:RaiseFrameLevelByFour(this)
		if self.modBtns then
			self:skinOtherButton{obj=this.buttonClose, text="x"}
		end
		if self.modBtnBs then
			self:skinOtherButton{obj=_G.MinArchDigsitesAutoWayButton, text="w"}
			_G.MinArchDigsitesAutoWayButton:SetSize(25, 25)
			for i = 1, _G.ARCHAEOLOGY_NUM_CONTINENTS do
				self:addButtonBorder{obj=_G["MinArchDigsites" .. continentButtons[i] .. "Button"]}
			end
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.MinArchDigsites)

	self:SecureHookScript(_G.MinArchCompanion, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=this.solveButton}
			self:skinOtherButton{obj=this.crateButton, text="c"}
		end
		if self.modBtnBs then
			self:skinOtherButton{obj=_G.MinArchCompanionAutoWayButton, text="w"}
			_G.MinArchCompanionAutoWayButton:SetSize(25, 25)
			self:addButtonBorder{obj=this.surveyButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.MinArchCompanion)

	self.mmButs["MinimalArchaeology"] = _G.MinArchMinimapButton

end
