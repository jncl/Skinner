
function Skinner:InventoryOnPar()

-->>--	Button on Character Frame
	self:moveObject(IOP_CPframe, "+", 35, "-", 70)

-->>--	UI Frame
	self:keepFontStrings(InventoryOnParUIFrameTableScrollFrame)
	self:skinScrollBar(InventoryOnParUIFrameTableScrollFrame)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerInfo)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderScore)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerName)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerLevel)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerClass)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderPlayerGuild)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderLastSeen)
	self:keepFontStrings(InventoryOnParUIFrameTableHeaderIOPScore)
	self:keepFontStrings(InventoryOnParUIFrameTable)
	self:applySkin(InventoryOnParUIFrameTable)
	self:keepFontStrings(InventoryOnParUIFrame)
	self:applySkin(InventoryOnParUIFrame)

-->>--	PaperDoll Frame
	IOP_PaperDollFrame:SetWidth(IOP_PaperDollFrame:GetWidth() * self.FxMult)
	IOP_PaperDollFrame:SetHeight(IOP_PaperDollFrame:GetHeight() * self.FyMult)
	self:moveObject(IOP_PaperDoll_ScoreText, nil, nil, "-", 20)
	self:moveObject(IOP_PaperDollFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(IOP_PaperDoll_ItemButtonHeadSlot, "+", 10, "-", 10)
	self:moveObject(IOP_PaperDoll_ItemScoreHeadSlot, "+", 10, "-", 10)
	self:moveObject(IOP_PaperDoll_ItemButtonHandsSlot, "+", 10, "-", 10)
	self:moveObject(IOP_PaperDoll_ItemScoreHandsSlot, "+", 10, "-", 10)
	self:moveObject(IOP_PaperDoll_ItemButtonMainHandSlot, "+", 10, "-", 10)
	self:moveObject(IOP_PaperDoll_ItemScoreMainHandSlot, "+", 10, "-", 10)
	self:keepFontStrings(IOP_PaperDollFrame)
	self:applySkin(IOP_PaperDollFrame)

-->>--	Option Frame
	self:moveObject(InventoryOnParOptionFrameTitleText, nil, nil, "-", 6)
	self:keepFontStrings(InventoryOnParOptionDropDownUpdateMinutes)
	self:skinEditBox(InventoryOnParOptionMinLevel, {9})
	self:skinEditBox(InventoryOnParOptionMaxLevel, {9})
	self:skinEditBox(InventoryOnParOptionDateFormat, {9})
	self:moveObject(InventoryOnParOptionFrameButtonClose, nil, nil, "-", 6)
	self:keepFontStrings(InventoryOnParOptionFrame)
	self:applySkin(InventoryOnParOptionFrame)

end
