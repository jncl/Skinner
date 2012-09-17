local aName, aObj = ...
if not aObj:isAddonEnabled("BlackList") then return end

function aObj:BlackList()
	if not self.db.profile.FriendsFrame then return end

-->>-- BlackList Frame
	self:skinScrollBar{obj=FriendsFrameBlackListScrollFrame}
	self:keepFontStrings(BlackListFrame)

-->>-- BlackList Details Frame
	self:skinScrollBar{obj=BlackListDetailsFrameScrollFrame}
	self:addSkinFrame{obj=BlackListDetailsFrameReasonTextBackground, kfs=true}
 	self:addSkinFrame{obj=BlackListDetailsFrame, kfs=true}
	BlackListEditDetailsFrameLevelBackground:SetBackdrop(nil)
	BlackListEditDetailsFrameLevel:SetWidth(30)
	self:moveObject{obj=BlackListEditDetailsFrameLevel, y=-5}
	self:skinEditBox{obj=BlackListEditDetailsFrameLevel, regs={9}, noWidth=true}
	BlackListEditDetailsFrameRealmBackground:SetBackdrop(nil)
	self:moveObject{obj=BlackListEditDetailsFrameRealm, y=-5}
	self:skinEditBox{obj=BlackListEditDetailsFrameRealm, regs={9}, noWidth=true}
	self:skinDropDown{obj=BlackListEditDetailsFrameClassDropDown}
	self:skinDropDown{obj=BlackListEditDetailsFrameRaceDropDown}

-->>-- Options Frame
	self:addSkinFrame{obj=BlackListOptionsFrame, kfs=true, y1=2}

end
