local aName, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end

function aObj:MinimalArchaeology()

	MinimalArchaeologyFrameSkillBarBorder:Hide()
	MinimalArchaeologyFrameSkillBarBackground:SetAllPoints(MinimalArchaeologyFrame.skillBar)
	self:glazeStatusBar(MinimalArchaeologyFrame.skillBar, 0,  MinimalArchaeologyFrameSkillBarBackground)

	for i = 1, 10 do
		local objName = "MinimalArchaeologyFrameArtifactBar"..i
		local obj = _G[objName]
		_G[objName.."BarBG"]:Hide()
		obj:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
		obj.progress:GetStatusBarTexture():SetTexCoord(0, 1, 0, 1)
		self:glazeStatusBar(obj, 0,  nil)
		self:glazeStatusBar(obj.progress, 0,  nil)
		self:skinButton{obj=obj.solveButton}
	end

	self:skinButton{obj=MinimalArchaeologyFrame.openHistButton, ob2="h"}
	self:moveObject{obj=MinimalArchaeologyFrame.openHistButton, x=self.modBtns and 2 or 8}
	self:skinButton{obj=MinimalArchaeologyFrame.openArchButton, ob2="a"}
	self:moveObject{obj=MinimalArchaeologyFrame.openArchButton, x=self.modBtns and 2 or 8}
	self:skinButton{obj=MinimalArchaeologyFrame.closeButton, ob2="x"}
	self:moveObject{obj=MinimalArchaeologyFrame.closeButton, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=MinimalArchaeologyFrame, nb=true, y1=4}

-->>-- option panels
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.hideArtifact}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.useKeystones}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.miscOptions}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.frameScale}

-->>-- History Frame
	MinimalArchaeologyHistoryFrameGrad.bg:Hide()
	self:skinButton{obj=MinimalArchaeologyHistoryFrame.closeButton, ob2="x"}
	self:moveObject{obj=MinimalArchaeologyHistoryFrame.closeButton, x=self.modBtns and 2 or 8}
	self:addSkinFrame{obj=MinimalArchaeologyHistoryFrame, nb=true, y1=4}
	-- hook this to remove background textures
	self:SecureHook(MinimalArchaeology, "CreateHistoryList", function(this, raceID)
		MinArchScrollFrame.bg:Hide()
		MinArchScrollBar.bg:Hide()
		self:Unhook(MinimalArchaeology, "CreateHistoryList")
	end)

end
