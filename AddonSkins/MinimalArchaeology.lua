local aName, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end
local _G = _G

function aObj:MinimalArchaeology()

	-- Buttons
	self:skinButton{obj=_G.MinArchMain.buttonOpenHist, ob2="h"}
	self:moveObject{obj=_G.MinArchMain.buttonOpenHist, x=self.modBtns and 2 or 8}
	self:skinButton{obj=_G.MinArchMain.buttonOpenArch, ob2="a"}
	self:moveObject{obj=_G.MinArchMain.buttonOpenArch, x=self.modBtns and 2 or 8}
	self:skinButton{obj=_G.MinArchMain.openADIButton, ob2="d"}
	self:moveObject{obj=_G.MinArchMain.openADIButton, x=self.modBtns and 2 or 8}
	self:skinButton{obj=_G.MinArchMain.buttonClose, ob2="x"}
	self:moveObject{obj=_G.MinArchMain.buttonClose, x=self.modBtns and 2 or 8}
	-- Skill Bar
	_G.MinArchMainSkillBarBorder:Hide()
	_G.MinArchMainSkillBarBackground:SetAllPoints(_G.MinArchMain.skillBar)
	self:glazeStatusBar(_G.MinArchMain.skillBar, 0, _G.MinArchMainSkillBarBackground)
	-- Artifact Bars
	for i = 1, 15 do
		local objName = "MinArchMainArtifactBar"..i
		local obj = _G[objName]
		_G[objName.."BarBG"]:Hide()
		obj:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
		self:glazeStatusBar(obj, 0,  nil)
		self:skinButton{obj=obj.buttonSolve}
	end
	-- Frame
	self:addSkinFrame{obj=_G.MinArchMain, nb=true, y1=4}

-->>-- option panels
	self:addSkinFrame{obj=_G.MinArchOptionPanel.hideArtifact}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.capArtifact}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.useKeystones}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.miscOptions}
	self:addSkinFrame{obj=_G.MinArchOptionPanel.frameScale}

-->>-- History Frame
	_G.MinArchHistGrad.bg:Hide()
	self:skinButton{obj=_G.MinArchHist.buttonClose, ob2="x"}
	self:moveObject{obj=_G.MinArchHist.buttonClose, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=_G.MinArchHist, nb=true, y1=4}
	-- hook this to remove background textures
	self:SecureHook(_G.MinArch, "CreateHistoryList", function(this, raceID)
		_G.MinArchScrollFrame.bg:Hide()
		_G.MinArchScrollBar.bg:Hide()
		self:skinSlider{obj=_G.MinArchScrollBar}
		self:Unhook(_G.MinArch, "CreateHistoryList")
	end)

-->>-- Digsites Frame
	_G.MinArchDigsitesGrad.bg:Hide()
	self:addButtonBorder{obj=_G.MinArchDigsites.kalimdorButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.easternButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.outlandsButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.northrendButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.pandariaButton}
	self:addButtonBorder{obj=_G.MinArchDigsites.draenorButton}
	self:skinButton{obj=_G.MinArchDigsites.buttonClose, ob2="x"}
	self:moveObject{obj=_G.MinArchDigsites.buttonClose, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=_G.MinArchDigsites, nb=true, y1=4}
	self:SecureHook(_G.MinArch, "CreateDigSitesList", function(this, contID)
		_G.MinArchDSScrollFrame.bg:Hide()
		_G.MinArchScrollDSBar.bg:Hide()
		self:Unhook(_G.MinArch, "CreateDigSitesList")
	end)
-->>-- Tooltip
	self:addButtonBorder{obj=_G.MinArchTooltipIcon, relTo=_G.MinArchTooltipIcon.icon, ofs=1}

end
