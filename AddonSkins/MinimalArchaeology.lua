local aName, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end

function aObj:MinimalArchaeology()

	-- Buttons
	self:skinButton{obj=MinArchMain.buttonOpenHist, ob2="h"}
	self:moveObject{obj=MinArchMain.buttonOpenHist, x=self.modBtns and 2 or 8}
	self:skinButton{obj=MinArchMain.buttonOpenArch, ob2="a"}
	self:moveObject{obj=MinArchMain.buttonOpenArch, x=self.modBtns and 2 or 8}
	self:skinButton{obj=MinArchMain.openADIButton, ob2="d"}
	self:moveObject{obj=MinArchMain.openADIButton, x=self.modBtns and 2 or 8}
	self:skinButton{obj=MinArchMain.buttonClose, ob2="x"}
	self:moveObject{obj=MinArchMain.buttonClose, x=self.modBtns and 2 or 8}
	-- Skill Bar
	MinArchMainSkillBarBorder:Hide()
	MinArchMainSkillBarBackground:SetAllPoints(MinArchMain.skillBar)
	self:glazeStatusBar(MinArchMain.skillBar, 0,  MinArchMainSkillBarBackground)
	-- Artifact Bars
	for i = 1, 10 do
		local objName = "MinArchMainArtifactBar"..i
		local obj = _G[objName]
		_G[objName.."BarBG"]:Hide()
		obj:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
		self:glazeStatusBar(obj, 0,  nil)
		self:skinButton{obj=obj.buttonSolve}
	end
	-- Frame
	self:addSkinFrame{obj=MinArchMain, nb=true, y1=4}

-->>-- option panels
	self:addSkinFrame{obj=MinArchOptionPanel.hideArtifact}
	self:addSkinFrame{obj=MinArchOptionPanel.capArtifact}
	self:addSkinFrame{obj=MinArchOptionPanel.useKeystones}
	self:addSkinFrame{obj=MinArchOptionPanel.miscOptions}
	self:addSkinFrame{obj=MinArchOptionPanel.frameScale}

-->>-- History Frame
	MinArchHistGrad.bg:Hide()
	self:skinButton{obj=MinArchHist.buttonClose, ob2="x"}
	self:moveObject{obj=MinArchHist.buttonClose, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=MinArchHist, nb=true, y1=4}
	-- hook this to remove background textures
	self:SecureHook(MinArch, "CreateHistoryList", function(this, raceID)
		MinArchScrollFrame.bg:Hide()
		MinArchScrollBar.bg:Hide()
		self:skinSlider{obj=MinArchScrollBar}
		self:Unhook(MinArch, "CreateHistoryList")
	end)

-->>-- Digsites Frame
	MinArchDigsitesGrad.bg:Hide()
	self:addButtonBorder{obj=MinArchDigsites.kalimdorButton}
	self:addButtonBorder{obj=MinArchDigsites.easternButton}
	self:addButtonBorder{obj=MinArchDigsites.outlandsButton}
	self:addButtonBorder{obj=MinArchDigsites.northrendButton}
	self:skinButton{obj=MinArchDigsites.buttonClose, ob2="x"}
	self:moveObject{obj=MinArchDigsites.buttonClose, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=MinArchDigsites, nb=true, y1=4}
	self:SecureHook(MinArch, "CreateDigSitesList", function(this, contID)
		MinArchDSScrollFrame.bg:Hide()
		MinArchScrollDSBar.bg:Hide()
		-- self:skinSlider{obj=MinArchScrollDSBar}
		self:Unhook(MinArch, "CreateDigSitesList")
	end)
-->>-- Tooltip
	self:addButtonBorder{obj=MinArchTooltipIcon, relTo=MinArchTooltipIcon.icon, ofs=1}

end
