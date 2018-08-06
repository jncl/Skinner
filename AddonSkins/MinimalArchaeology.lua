local aName, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end
local _G = _G

aObj.addonsToSkin.MinimalArchaeology = function(self) -- v 8.0.6.1

	-- Buttons
	self:skinOtherButton{obj=_G.MinArchMain.buttonOpenHist, text="h"}
	self:moveObject{obj=_G.MinArchMain.buttonOpenHist, x=self.modBtns and 2 or 8}
	self:skinOtherButton{obj=_G.MinArchMain.buttonOpenArch, text="a"}
	self:moveObject{obj=_G.MinArchMain.buttonOpenArch, x=self.modBtns and 2 or 8}
	self:skinOtherButton{obj=_G.MinArchMain.openADIButton, text="d"}
	self:moveObject{obj=_G.MinArchMain.openADIButton, x=self.modBtns and 2 or 8}
	self:skinOtherButton{obj=_G.MinArchMain.buttonClose, text="x"}
	self:moveObject{obj=_G.MinArchMain.buttonClose, x=self.modBtns and 2 or 8}
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
		self:skinStdButton{obj=obj.buttonSolve}
	end
	-- Frame
	self:addSkinFrame{obj=_G.MinArchMain, ft="a", kfs=true, nb=true, y1=4}

	-- option panels
	self:addSkinFrame{obj=_G.MinArchOptionPanel.hideArtifact, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.capArtifact, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.useKeystones, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.miscOptions, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.frameScale, ft="a", kfs=true, nb=true}
	self:skinSlider{obj=_G.MinArchOptionPanel.frameScale.slider}
	if self.modChkBtns then
		for i = 1, 20 do
			self:skinCheckButton{obj=_G.MinArchOptionPanel.hideArtifact["hide" .. i]}
		end
		for i = 1, 20 do
			self:skinCheckButton{obj=_G.MinArchOptionPanel.capArtifact["cap" .. i]}
		end
		for i = 1, 20 do
			-- NO keystone 18
			if i ~= 18 then
				self:skinCheckButton{obj=_G.MinArchOptionPanel.useKeystones["usekeystone" .. i]}
			end
		end
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.hideMinimap}
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.disableSound}
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.showStatusMessages}
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.showWorldMapOverlay}
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.startHidden}
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.hideAfter}
		self:skinCheckButton{obj=_G.MinArchOptionPanel.miscOptions.waitSolve}
	end

	-- History Frame
	_G.MinArchHistGrad.bg:Hide()
	self:skinOtherButton{obj=_G.MinArchHist.buttonClose, text="x"}
	self:moveObject{obj=_G.MinArchHist.buttonClose, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=_G.MinArchHist, ft="a", kfs=true, nb=true, y1=4}
	_G.RaiseFrameLevelByTwo(_G.MinArchHist)
	-- hook this to remove background textures
	self:SecureHook(_G.MinArch, "CreateHistoryList", function(this, raceID)
		_G.MinArchScrollFrame.bg:Hide()
		_G.MinArchScrollBar.bg:Hide()
		self:skinSlider{obj=_G.MinArchScrollBar}
		self:Unhook(_G.MinArch, "CreateHistoryList")
	end)

	-- Digsites Frame
	_G.MinArchDigsitesGrad.bg:Hide()
	self:addButtonBorder{obj=_G.MinArchDigsites.kalimdorButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.easternButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.outlandsButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.northrendButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.pandariaButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.draenorButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.brokenIslesButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.kulTirasButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.zandalarButton}
	self:skinOtherButton{obj=_G.MinArchDigsites.buttonClose, text="x"}
	self:moveObject{obj=_G.MinArchDigsites.buttonClose, x=7, y=4}
	self:addSkinFrame{obj=_G.MinArchDigsites, ft="a", kfs=true, nb=true, y1=4}
	_G.RaiseFrameLevelByTwo(_G.MinArchDigsites)
	self:SecureHook(_G.MinArch, "CreateDigSitesList", function(this, contID)
		_G.MinArchDSScrollFrame.bg:Hide()
		_G.MinArchScrollDSBar.bg:Hide()
		self:Unhook(_G.MinArch, "CreateDigSitesList")
	end)

	-- Tooltip
	self:addButtonBorder{obj=_G.MinArchTooltipIcon, relTo=_G.MinArchTooltipIcon.icon, ofs=1}

	self.mmButs["MinimalArchaeology"] = _G.MinArchMinimapButton

end
