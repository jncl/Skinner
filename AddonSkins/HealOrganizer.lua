
function Skinner:HealOrganizer()

	self:keepFontStrings(HealOrganizerDialog)
	self:applySkin(HealOrganizerDialog, true)
	self:applySkin(HealOrganizerDialogEinteilung)
	self:applySkin(HealOrganizerDialogEinteilungOptionen)
	self:applySkin(HealOrganizerDialogEinteilungStats)
	self:skinEditBox(HealOrganizerDialogEinteilungRestAction, {9})
	self:applySkin(HealOrganizerDialogEinteilungSets)
	self:keepFontStrings(HealOrganizerDialogEinteilungSetsDropDown)
	self:applySkin(HealOrganizerDialogBroadcast)
	self:skinEditBox(HealOrganizerDialogBroadcastChannelEditbox, {9})
	self:moveObject(HealOrganizerDialogClose, nil, nil, "-", 5)

end
