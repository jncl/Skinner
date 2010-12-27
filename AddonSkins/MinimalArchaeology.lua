local aName, aObj = ...
if not aObj:isAddonEnabled("MinimalArchaeology") then return end

function aObj:MinimalArchaeology()

	self:glazeStatusBar(MinimalArchaeologyFrame.skillBar, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar1, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar2, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar3, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar4, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar5, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar6, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar7, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar8, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar9, 0,  nil)
	self:glazeStatusBar(MinimalArchaeologyFrame.statusBar1, 0,  nil)
	self:addSkinFrame{obj=MinimalArchaeologyFrame}

	-- option panels
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.hideArtifact}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.useKeystones}
	self:addSkinFrame{obj=MinimalArchaeologyOptionPanel.miscOptions}
	
end
