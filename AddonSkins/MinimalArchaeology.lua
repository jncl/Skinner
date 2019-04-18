local aName, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end
local _G = _G

aObj.addonsToSkin.MinimalArchaeology = function(self) -- v 8.0.12.2

	-- Buttons
	if self.modBtns then
		self:skinOtherButton{obj=_G.MinArchMain.buttonOpenHist, text="h"}
		self:moveObject{obj=_G.MinArchMain.buttonOpenHist, x=2}
		self:skinOtherButton{obj=_G.MinArchMain.buttonOpenArch, text="a"}
		self:moveObject{obj=_G.MinArchMain.buttonOpenArch, x=2}
		self:skinOtherButton{obj=_G.MinArchMain.openADIButton, text="d"}
		self:moveObject{obj=_G.MinArchMain.openADIButton, x=2}
		self:skinOtherButton{obj=_G.MinArchMain.buttonClose, text="x"}
		self:moveObject{obj=_G.MinArchMain.buttonClose, x=2}
		self:skinOtherButton{obj=_G.MinArchMainAutoWayButton, text="w"}
		_G.MinArchMainAutoWayButton:SetSize(25, 25)
		self:moveObject{obj=_G.MinArchMainAutoWayButton, x=-4, y=1}
		self:skinOtherButton{obj=_G.MinArchMainCrateButton, text="c", aso={sab=true}}
		self:moveObject{obj=_G.MinArchMainCrateButton, x=-2, y=3}
		self:skinOtherButton{obj=_G.MinArchMainRelevancyButton, text="r"}
		_G.MinArchMainRelevancyButton:SetSize(25, 25)
	end
	-- Skill Bar
	_G.MinArchMainSkillBarBorder:Hide()
	_G.MinArchMainSkillBarBackground:SetAllPoints(_G.MinArchMain.skillBar)
	self:skinStatusBar{obj=_G.MinArchMain.skillBar, fi=0, bgTex=_G.MinArchMainSkillBarBackground}
	-- Artifact Bars
	for i = 1, _G.ARCHAEOLOGY_NUM_RACES do
		local obj = _G["MinArchArtifactBar" .. i]
		_G["MinArchArtifactBar" .. i .. "BarBG"]:Hide()
		obj:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
		self:skinStatusBar{obj=obj, fi=0}
		if self.modBtns then
			self:skinStdButton{obj=obj.buttonSolve}
		end
	end
	-- Frame
	self:addSkinFrame{obj=_G.MinArchMain, ft="a", kfs=true, nb=true, y1=4}

	-- History Frame
	_G.MinArchHistGrad.bg:Hide()
	if self.modBtns then
		self:skinOtherButton{obj=_G.MinArchHist.buttonClose, text="x"}
		self:moveObject{obj=_G.MinArchHist.buttonClose, x=2}
	end
	self:addSkinFrame{obj=_G.MinArchHist, ft="a", kfs=true, nb=true, y1=4}
	_G.RaiseFrameLevelByTwo(_G.MinArchHist)
	-- hook this to remove background textures
	self:SecureHook(_G.MinArch, "CreateHistoryList", function(this, raceID, caller)
		if _G.MinArchScrollFrame then
			_G.MinArchScrollFrame.bg:Hide()
			_G.MinArchScrollBar.bg:Hide()
			self:skinSlider{obj=_G.MinArchScrollBar}
			self:Unhook(_G.MinArch, "CreateHistoryList")
		end
	end)

	-- Digsites Frame
	_G.MinArchDigsitesGrad.bg:Hide()
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MinArchDigsites.kalimdorButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.easternButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.outlandsButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.northrendButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.pandariaButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.draenorButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.brokenIslesButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.kulTirasButton}
		self:addButtonBorder{obj=_G.MinArchDigsites.zandalarButton}
	end
	if self.modBtns then
		self:skinOtherButton{obj=_G.MinArchDigsites.buttonClose, text="x"}
	end
	self:moveObject{obj=_G.MinArchDigsites.buttonClose, x=7, y=4}
	self:addSkinFrame{obj=_G.MinArchDigsites, ft="a", kfs=true, nb=true, y1=4}
	_G.RaiseFrameLevelByTwo(_G.MinArchDigsites)
	self:SecureHook(_G.MinArch, "CreateDigSitesList", function(this, contID)
		_G.MinArchDSScrollFrame.bg:Hide()
		_G.MinArchScrollDSBar.bg:Hide()
		self:Unhook(_G.MinArch, "CreateDigSitesList")
	end)

	-- Tooltip
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MinArchTooltipIcon, relTo=_G.MinArchTooltipIcon.icon, ofs=1}
	end

	self.mmButs["MinimalArchaeology"] = _G.MinArchMinimapButton

end
