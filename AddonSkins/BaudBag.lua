
function Skinner:BaudBag()
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook("BaudBagUpdateContainer", function(Container)
--		self:Debug("BBUC: [%s, %s]", Container, Container:GetName() or "nil")
		_G[Container:GetName().."BackdropTextures"]:Hide()
		self:applySkin(_G[Container:GetName().."Backdrop"])
	end)
	self:applySkin(BBCont1_1BagsFrame)
	self:applySkin(BBCont2_1BagsFrame)
	self:skinDropDown(BaudBagContainerDropDown)

-->>-- Options Frame
	self:keepFontStrings(BaudBagOptionsFrame)
	self:skinDropDown(BaudBagOptionsSetDropDown)
	self:skinEditBox(BaudBagNameEditBox, {9})
	self:skinDropDown(BaudBagOptionsBackgroundDropDown)
	self:applySkin(BaudBagOptionsFrame, true)

end
