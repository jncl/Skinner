local _, aObj = ...
if not aObj:isAddonEnabled("SoulshapeJournal") then return end
local _G = _G

aObj.addonsToSkin.SoulshapeJournal = function(self) -- v 1.2.3

	self:SecureHookScript(_G.SoulshapeCollectionPanel, "OnShow", function(this)
		_G.MountJournal:Hide()
		_G.PetJournal:Hide()
		_G.ToyBox:Hide()
		_G.HeirloomsJournal:Hide()
		_G.WardrobeCollectionFrame:Hide()
		if not this.sf then
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			self:skinObject("editbox", {obj=self:getChild(this, 11), si=true})
			self:removeInset(_G.SoulshapeCollectionPanelCount)
			self:skinObject("slider", {obj=this.ScrollFrame.scrollBar})
			for _, btn in _G.pairs(this.ScrollFrame.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
			end
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-1})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(this, 13), clr="grey"}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.SoulshapeDisplay.ModelScene.RotateLeftButton, ofs=-3, clr="grey"}
				self:addButtonBorder{obj=this.SoulshapeDisplay.ModelScene.RotateRightButton, ofs=-3, clr="grey"}
			end
		end
	end)

end
