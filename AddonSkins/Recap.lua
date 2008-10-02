
function Skinner:Recap()

-->>-- Recap Frame
	self:keepRegions(RecapCombatEvents, {})
	self:applySkin(RecapCombatEvents, nil)
	self:keepRegions(RecapScrollBar, {})
	self:skinScrollBar(RecapScrollBar)
	self:keepRegions(RecapDropSubFrame, {})
	self:applySkin(RecapDropSubFrame, nil)
	self:keepRegions(RecapMenu, {})
	self:applySkin(RecapMenu, nil)
	self:keepRegions(Recap_xml_359, {})
	self:applySkin(Recap_xml_359, nil)
	self:keepRegions(RecapFrame, {})
	self:applySkin(RecapFrame, nil)

	self:Hook(RecapFrame, "SetBackdropColor", function() end, true)
	self:Hook(RecapFrame, "SetBackdropBorderColor", function() end, true)

-->>-- Recap Panel
	self:keepRegions(RecapPanel_xml_359, {})
	self:applySkin(RecapPanel_xml_359, nil)
	self:keepRegions(RecapPanelIncomingDetailsScrollBar, {})
	self:skinScrollBar(RecapPanelIncomingDetailsScrollBar)
	self:keepRegions(RecapPanelOutgoingDetailsScrollBar, {})
	self:skinScrollBar(RecapPanelOutgoingDetailsScrollBar)
	self:keepRegions(RecapPanel, {11,13})
	self:applySkin(RecapPanel, nil)

-->>-- Recap Options Frame
	self:keepRegions(Recap_DropMenu, {})
	self:applySkin(Recap_DropMenu, nil)
	self:keepRegions(RecapOptAnchorFrame, {10})
	self:applySkin(RecapOptAnchorFrame, nil)
	self:keepRegions(RecapOptions_xml_359, {})
	self:applySkin(RecapOptions_xml_359, nil)
	self:keepRegions(RecapFightSetsScrollBar, {})
	self:skinScrollBar(RecapFightSetsScrollBar)
	self:keepRegions(RecapOpt_StatDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(RecapOpt_ChannelDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(RecapClipScrollFrame, {})
	self:skinScrollBar(RecapClipScrollFrame)
	self:keepRegions(RecapOptClipFrame, {1})
	self:applySkin(RecapOptClipFrame, nil)
	self:skinEditBox(RecapSetEditBox, {9})
	self:skinEditBox(RecapClipEditBox, {9})
	self:keepRegions(RecapOptFrame, {10})
	self:applySkin(RecapOptFrame, nil)

	self:keepRegions(RecapOptTab1, {1})
	self:moveObject(RecapOptTab1, nil, nil, "+", 19)
	self:keepRegions(RecapOptTab2, {1})
	self:keepRegions(RecapOptTab3, {1})
	self:keepRegions(RecapOptTab4, {1})
	self:keepRegions(RecapOptTab5, {1})
	if self.db.profile.TexturedTab then self:applySkin(RecapOptTab1, nil, 0)
	else self:applySkin(RecapOptTab1) end
	if self.db.profile.TexturedTab then self:applySkin(RecapOptTab2, nil, 0)
	else self:applySkin(RecapOptTab2) end
	if self.db.profile.TexturedTab then self:applySkin(RecapOptTab3, nil, 0)
	else self:applySkin(RecapOptTab3) end
	if self.db.profile.TexturedTab then self:applySkin(RecapOptTab4, nil, 0)
	else self:applySkin(RecapOptTab4) end
	if self.db.profile.TexturedTab then self:applySkin(RecapOptTab5, nil, 0)
	else self:applySkin(RecapOptTab5) end
	self:setActiveTab(RecapOptTab1)
	self:setInactiveTab(RecapOptTab2)
	self:setInactiveTab(RecapOptTab3)
	self:setInactiveTab(RecapOptTab4)
	self:setInactiveTab(RecapOptTab5)

	self:SecureHook("RecapOptTab_OnClick", function()
		self:setInactiveTab(RecapOptTab1)
		self:setInactiveTab(RecapOptTab2)
		self:setInactiveTab(RecapOptTab3)
		self:setInactiveTab(RecapOptTab4)
		self:setInactiveTab(RecapOptTab5)
		self:setActiveTab(_G["RecapOptTab"..this:GetID()])
	end)

end
