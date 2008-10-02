
function Skinner:WoWEquip()

	-- Main Frame
	WoWEquip_Frame:SetHeight(WoWEquip_Frame:GetHeight() + 10)
	self:keepFontStrings(WoWEquip_BonusScrollFrame)
	self:skinScrollBar(WoWEquip_BonusScrollFrame)
	local WE_BF  = WoWEquip_BonusScrollFrame:GetParent() -- Bonus Frame
	local WE_LIB = self:getChild(WE_BF, 2) -- LevelInputBox
	self:skinEditBox(WE_LIB, {9}, nil)
	WE_LIB:SetHeight(20)
	WE_LIB:SetWidth(30)
	self:applySkin(WE_BF)

	-- Equip Frame
	self:keepFontStrings(WoWEquip_EquipFrame)
	local WE_IB = self:getChild(WoWEquip_EquipFrame, 3) -- InputBox
	self:skinEditBox(WE_IB, {9})
	self:keepFontStrings(WoWEquip_ListScrollFrame)
	self:skinScrollBar(WoWEquip_ListScrollFrame)
	self:applySkin(WoWEquip_ListScrollFrame:GetParent())
	self:applySkin(WoWEquip_EquipFrame)

	-- Options Frame
	self:keepFontStrings(WoWEquip_OptionsFrame)
	self:applySkin(WoWEquip_OptionsFrame)

	-- Load/Save/Send Frame
	self:keepFontStrings(WoWEquip_SaveFrame)
	local WE_SF_NIF = self:getChild(WoWEquip_SaveFrame, 3) -- NameInputFrame
	local WE_SF_TIF = self:getChild(WoWEquip_SaveFrame, 4) -- TargetInputFrame
	self:applySkin(WE_SF_NIF)
	self:applySkin(WE_SF_TIF)
	self:keepFontStrings(WoWEquip_DescEditScrollFrame)
	self:skinScrollBar(WoWEquip_DescEditScrollFrame)
	self:applySkin(WoWEquip_DescEditScrollFrame:GetParent())
	self:keepFontStrings(WoWEquip_ProfilesScrollFrame)
	self:skinScrollBar(WoWEquip_ProfilesScrollFrame)
	self:applySkin(WoWEquip_ProfilesScrollFrame:GetParent())
	self:applySkin(WoWEquip_SaveFrame)

	-- Hook this to position the DressUp frame and skin the WoWEquip frame
	self:SecureHook(WoWEquip_Frame, "Show", function(this)
		DressUpFrame:ClearAllPoints()
		DressUpFrame:SetPoint("TOPRIGHT", WoWEquip_Frame, "TOPLEFT", 3, 0)
		self:keepFontStrings(WoWEquip_Frame)
		self:applySkin(WoWEquip_Frame)
	end)

end

function Skinner:WoWEquip_CITB()

	-- Button on Inspect Frame
	self:moveObject(WoWEquip_CopyInspectTargetButton, "+", 30, "-", 74)

end
