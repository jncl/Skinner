
function Skinner:Chatr()

	Chatr_BGColor = CopyTable(self.bColour)
	Chatr_BorderColor = CopyTable(self.bbColour)

	for i = 1, 20 do
		self:applySkin(_G["Chatr"..i])
		self:applySkin(_G["Chatr"..i.."EditBox"])
	end

	self:moveObject(ChatrOptionsTitle, nil, nil, "-", 8)
	self:moveObject(ChatrOptionsClose, "-", 8, "-", 8)
	self:skinEditBox(ChatrOptionsFmt, {9})
	self:skinEditBox(ChatrOptionsFmt2, {9})
	ChatrOptions:SetHeight(ChatrOptions:GetHeight() + 40)
	self:moveObject(ChatrOptionsSavePer, nil, nil, "+", 40)
	self:moveObject(ChatrOptionsSavePerT, nil, nil, "+", 40)
	self:moveObject(ChatrOptionsQuote, nil, nil, "+", 35)
	self:applySkin(ChatrOptions)

	if IsAddOnLoaded("ChatrAlterEgo") then self:applySkin(ChatrAlterEgoOptions) end
	if IsAddOnLoaded("ChatrBacklog") then self:applySkin(ChatrBacklogOptions) end
	if IsAddOnLoaded("ChatrBuddies") then
		self:applySkin(ChatrBuddiesOptions)
		self:applySkin(ChatrBuddiesCustom)
	end
	if IsAddOnLoaded("ChatrChanneler") then self:applySkin(ChatrChannelerOptions) end
	if IsAddOnLoaded("ChatrCrayons") then self:applySkin(ChatrCrayonsOptions) end
	if IsAddOnLoaded("ChatrFilter") then self:applySkin(ChatrFilterOptions) end
	if IsAddOnLoaded("ChatrShoo") then self:applySkin(ChatrShooOptions) end

end
