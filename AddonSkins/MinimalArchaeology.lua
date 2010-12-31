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

	self:addSkinFrame{obj=MinimalArchaeologyFrame, nb=true, x1=8, y1=4, x2=-8}

	-- option panels
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.hideArtifact}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.useKeystones}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.miscOptions}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.frameScale}

end
