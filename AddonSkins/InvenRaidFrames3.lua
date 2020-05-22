local _, aObj = ...
if not aObj:isAddonEnabled("InvenRaidFrames3") then return end
local _G = _G

aObj.addonsToSkin.InvenRaidFrames3 = function(self) -- v classic.2

	self:removeRegions(_G.InvenRaidFrames3Manager.content, {1, 2, 3})
	self:addSkinFrame{obj=_G.InvenRaidFrames3Manager, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.CompactRaidFrameManager.displayFrame.leaderOptions.readyCheckButton}
		self:skinStdButton{obj=_G.InvenRaidFrames3Manager.content.lockButton}
		self:skinStdButton{obj=_G.InvenRaidFrames3Manager.content.hideButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.InvenRaidFrames3Manager.content.everyoneIsAssistButton}
	end
	-- TODO: skin toggleButton

	-- Don't skin options automatically
	self.RegisterCallback("InvenRaidFrames3", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.addon ~= "InvenRaidFrames3" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("InvenRaidFrames3", "IOFPanel_Before_Skinning")
	end)

end

aObj.lodAddons.InvenRaidFrames3_Option = function(self) -- v classic.2

	local OF = _G.InvenRaidFrames3.optionFrame
	self:addSkinFrame{obj=OF.mainBorder, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=OF.detailBorder, ft="a", kfs=true, nb=true}

	self:skinTabs{obj=OF, ignore=true, up=true, lod=true, ignht=true, x1=6, y1=0, x2=-6, y2=-4}

	self:SecureHook(OF, "CreateClickCastingMenu", function(this, menu, parent)
		self:addSkinFrame{obj=menu.buttons, ft="a", kfs=true, nb=true, ofs=1}
		self:addSkinFrame{obj=menu.clickKeys, ft="a", kfs=true, nb=true, ofs=1}
	end)

	self:SecureHook(OF, "CreateGroupMenu", function(this, menu, parent)
		self:addSkinFrame{obj=menu.group, ft="a", kfs=true, nb=true, ofs=1}
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=OF.group[i]}
			end
		end
	end)

end
