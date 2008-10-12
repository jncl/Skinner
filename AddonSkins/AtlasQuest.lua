
function Skinner:AtlasQuest()

	self:keepFontStrings(AtlasQuestFrame)
	self:applySkin(AtlasQuestFrame)
	
	--	button on Atlas frame
	self:moveObject(CLOSEbutton3, nil, nil, "+", 10)
	
-->>--	Options Frame
	self:keepFontStrings(AtlasQuestOptionFrame)
	self:applySkin(AtlasQuestOptionFrame)


-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AtlasQuestTooltip:SetBackdrop(self.backdrop) end
		self:SecureHook(AtlasQuestTooltip, "Show", function(this, ...)
			self:skinTooltip(AtlasQuestTooltip)
		end)
	end
	
end
