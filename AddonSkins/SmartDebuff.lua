
function Skinner:SmartDebuff()

	self:applySkin(SmartDebuffSF)
	self:applySkin(SmartDebuffIF)
-->>--	Options Frame
	self:applySkin(SmartDebuffOF)
	self:applySkin(SmartDebuffAOFOrder)
	self:keepFontStrings(SmartDebuffAOFOrder_ScrollFrame)
	self:skinScrollBar(SmartDebuffAOFOrder_ScrollFrame)
	self:applySkin(SmartDebuffAOFKeys)

	self:Hook(SmartDebuffSF, "SetBackdrop", function() end, true)

end
