
function Skinner:AtlasQuest()

	self:keepFontStrings(AtlasQuestFrame)
	self:applySkin(AtlasQuestFrame)
	
	--	button on Atlas frame
	self:moveObject(CLOSEbutton3, "+", 0, "+", 10)
	
-->>--	Options Frame
	self:keepFontStrings(AtlasQuestOptionFrame)
	self:applySkin(AtlasQuestOptionFrame)


-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasQuestTooltip:SetBackdrop(backdrop) end
		self:skinTooltip(AtlasQuestTooltip)
		self:Hook(AtlasQuestTooltip, "SetBackdropBorderColor", function() end, true)
	end
	
end
