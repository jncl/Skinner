local aName, aObj = ...
if not aObj:isAddonEnabled("ZPerl") then return end
local _G = _G

local function colourBD(...)

	local frm = _G.select(1, ...)
	local alpha = _G.select(2, ...)
	local c = _G.XPerlDB.colour.frame
	frm:SetBackdropColor(c.r, c.g, c.b, alpha or c.a)
	local c = _G.XPerlDB.colour.border
	frm:SetBackdropBorderColor(c.r, c.g, c.b, alpha or c.a)

end

function aObj:ZPerl()

	-- Frame and Border colours
	_G.XPerlDB.colour.frame = {r = self.bColour[1], g = self.bColour[2], b = self.bColour[3], a = self.bColour[4]}
	_G.XPerlDB.colour.border = {r = self.bbColour[1], g = self.bbColour[2], b = self.bbColour[3], a = self.bbColour[4]}
	-- Gradient colours
	local c = self.db.profile.GradientMin
	_G.XPerlDB.colour.gradient.e = {r = c.r, g = c.g, b = c.b, a = c.a}
	local c = self.db.profile.GradientMax
	_G.XPerlDB.colour.gradient.s = {r = c.r, g = c.g, b = c.b, a = c.a}
	_G.XPerlDB.colour.gradient.horizontal = self.db.profile.Gradient.rotate
	-- statusBar texture
	_G.XPerlDB.bar.texture[2] = self.sbTexture
	_G.XPerl_SetBarTextures()

	self:checkAndRunAddOn("ZPerl_Player")
	self:checkAndRunAddOn("ZPerl_Target")
	self:checkAndRunAddOn("ZPerl_Party")
	self:checkAndRunAddOn("ZPerl_RaidMonitor")

end

local function skinClassIcon(frame)

	aObj:adjWidth{obj=frame, adj=-1}
	aObj:adjHeight{obj=frame, adj=-2}
	aObj:moveObject{obj=frame, y=2}
	aObj:addSkinButton(frame, frame)

end
function aObj:ZPerl_Player()

	-- Put a border around the class icon
	skinClassIcon(_G.XPerl_PlayerclassFrame)

end

function aObj:ZPerl_Target()

	-- Put a border around the class icon
	skinClassIcon(_G.XPerl_TargettypeFramePlayer)
	_G.RaiseFrameLevel(_G.XPerl_TargetnameFrame)

-->>--	Focus
	-- Put a border around the class icon
	skinClassIcon(_G.XPerl_FocustypeFramePlayer)

end

function aObj:ZPerl_Party()

	-- Put a border around the class icon
	for i = 1, 4 do
		skinClassIcon(_G["XPerl_party" .. i.. "classFrame"])
	end

end

function aObj:ZPerl_RaidMonitor()

	self:addSkinFrame{obj=_G.XPerl_RaidMonitor_Frame}

end

function aObj:ZPerl_RaidAdmin()

	-- hook this to change colours
	if not self:IsHooked("XPerl_SetupFrameSimple") then
		self:RawHook("XPerl_SetupFrameSimple", colourBD)
	end

	self:skinEditBox(_G.XPerl_AdminFrame_Controls_Edit)
	self:moveObject{obj=_G.XPerl_AdminFrame_Controls_Edit, x=-5}
	self:applySkin(_G.XPerl_AdminFrame_Controls_Roster)
	self:addSkinFrame{obj=_G.XPerl_AdminFrame}
-->>-- Item Checker Frame
	self:skinDropDown(_G.XPerl_CheckButtonChannel)
	self:addSkinFrame{obj=_G.XPerl_Check}
-->>-- Roster Text Frame
	self:skinSlider{obj=_G.XPerl_RosterTexttextFramescroll.ScrollBar}
	self:applySkin(_G.XPerl_RosterTexttextFrame)
	self:addSkinFrame{obj=_G.XPerl_RosterText}

end

function aObj:ZPerl_RaidHelper()

	-- hook this to change colours
	if not self:IsHooked("XPerl_SetupFrameSimple") then
		self:RawHook("XPerl_SetupFrameSimple", colourBD)
	end

	_G.XPerl_SetupFrameSimple(_G.XPerl_Frame)
	_G.XPerl_SetupFrameSimple(_G.XPerl_Assists_Frame)
	_G.XPerl_SetupFrameSimple(_G.XPerl_Target_AssistFrame)

	self:moveObject{obj=_G.XPerl_Target_AssistFrame, y=1}

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "XPerl_BottomTip")
	end

end

function aObj:ZPerl_Options()

	-- hook these to manage backdrops
	for _, frm in _G.pairs{"Options", "ColourPicker", "Options_TooltipConfig", "Options_TextureSelect", "OptionsQuestionDialog",  "Custom_Config"} do
		self:RawHook(_G["XPerl_"..frm], "Setup", function() end)
	end

-->>-- Options Frame
	colourBD(_G.XPerl_Options)

	self:skinDropDown{obj=_G.XPerl_Options_DropDown_LoadSettings}
	self:addSkinFrame{obj=_G.XPerl_Options_Area_Align, x1=-2, y1=4, x2=2, y2=-2}
	self:skinEditBox{obj=_G.XPerl_Options_Layout_Name, regs={6}}
	self:addSkinFrame{obj=_G.XPerl_Options_Area_Global, x1=-2, y1=2, x2=2, y2=-2}
	self:addSkinFrame{obj=_G.XPerl_Options_Layout_List, x1=-2, y1=2, x2=2, y2=-2}
	self:skinSlider{obj=_G.XPerl_Options_Layout_ListScrollBar.ScrollBar}
	self:addSkinFrame{obj=_G.XPerl_Options_Area_Tabs, x1=-2, y1=1, x2=2, y2=-2}
	-- player alignment
	self:adjWidth{obj=_G.XPerl_Options_Player_Gap, adj=-10}
	self:moveObject{obj=_G.XPerl_Options_Player_Gap, x=-10}
	self:moveObject{obj=_G.XPerl_Options_Player_BiggerGap, x=4}
	self:skinEditBox{obj=_G.XPerl_Options_Player_Gap, regs={6}}
	-- party alignment
	self:skinDropDown{obj=_G.XPerl_Options_Party_Anchor}
	self:moveObject{obj=_G.XPerl_Options_Party_Gap, x=-6}
	self:moveObject{obj=_G.XPerl_Options_Party_BiggerGap, x=6}
	self:skinEditBox{obj=_G.XPerl_Options_Party_Gap, regs={6}}
	-- raid alignment
	self:skinDropDown{obj=_G.XPerl_Options_Raid_Anchor}
	self:adjWidth{obj=_G.XPerl_Options_Raid_Gap, adj=-10}
	self:moveObject{obj=_G.XPerl_Options_Raid_Gap, x=-10}
	self:moveObject{obj=_G.XPerl_Options_Raid_BiggerGap, x=4}
	self:skinEditBox{obj=_G.XPerl_Options_Raid_Gap, regs={6}}
	-- separator line
	_G.XPerl_Options_Global_Options_RangeFinderSeparator:Hide()

-->>-- Player Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Player_Options_Buffs, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=_G.XPerl_Options_Player_Options_Totems, x1=-2, y1=2, x2=2}
-->>-- Pet Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Pet_Options_PetTarget, x1=-2, y1=2, x2=2}
-->>-- Target Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Target_Options_TargetTarget, x1=-2, y1=2, x2=2, y2=-6}
-->>-- Focus Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Focus_Options_FocusTarget, x1=-2, y1=2, x2=2}
-->-- Party Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Party_Options_PartyPets, x1=-2, y1=2, x2=2}
	if _G.XPerl_Party_AnchorVirtual then
		self:addSkinFrame{obj=_G.XPerl_Party_AnchorVirtual, x1=-2, y1=2, x2=2}
	end
-->>-- Raid Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Raid_Options_Groups, x1=-2, y1=2, x2=2}
	if _G.XPerl_Raid_Title1 then
		for i = 1, 10 do
			self:addSkinFrame{obj=_G["XPerl_Raid_Title"..i.."Virtual"]}
		end
	end
	self:addSkinFrame{obj=_G.XPerl_Options_Raid_Options_Pets, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=_G.XPerl_Options_Raid_Options_Custom, x1=-2, y1=2, x2=2}
-->>-- Custom Raid Highlights Config (appears when Configure button is pressed)
	self:skinEditBox{obj=_G.XPerl_Custom_ConfigNew_Zone, regs={6}}
	self:skinEditBox{obj=_G.XPerl_Custom_ConfigNew_Search, regs={6}}
	self:addSkinFrame{obj=_G.XPerl_Custom_ConfigzoneList, y1=2, y2=-3}
	self:skinSlider{obj=_G.XPerl_Custom_ConfigdebuffsscrollBar.ScrollBar}
	self:addSkinFrame{obj=_G.XPerl_Custom_Configdebuffs, y1=2, y2=-3}
	self:addSkinFrame{obj=_G.XPerl_Custom_Config, y1=-1}
-->>-- All Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_All_Options_AddOns, x1=-2, y1=2, x2=2}
-->>-- Colours Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_BarColours, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_UnitReactions, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_Appearance, x1=-2, y1=2, x2=2}
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_FrameColours, x1=-2, y1=2, x2=2}
-->>-- Helper Options subpanel
	self:addSkinFrame{obj=_G.XPerl_Options_Helper_Options_Assists, x1=-2, y1=2, x2=2}

-->>-- Colour Picker Frame
	self:addSkinFrame{obj=_G.XPerl_ColourPicker}
-->>--	Texture Select Frame
	self:skinSlider{obj=_G.XPerl_Options_TextureSelectscrollBar.ScrollBar}
	self:addSkinFrame{obj=_G.XPerl_Options_TextureSelect}
-->>--	Options Question Dialog
	self:addSkinFrame{obj=_G.XPerl_OptionsQuestionDialog}
-->>-- Tooltip Config
	self:addSkinFrame{obj=_G.XPerl_Options_TooltipConfig}

-->>-- skin buttons
	if self.modBtns then
		self:skinButton{obj=_G.XPerl_Options_CloseButton, cb=true}
		self:skinButton{obj=_G.XPerl_Options_Global_Options_Reset}
		self:skinButton{obj=_G.XPerl_Options_Layout_Save}
		self:skinButton{obj=_G.XPerl_Options_Layout_Load}
		self:skinButton{obj=_G.XPerl_Options_Player_AlignTop}
		self:skinButton{obj=_G.XPerl_Options_Raid_AlignTop}
		self:skinButton{obj=_G.XPerl_Options_Raid_AlignLeft}
	end

end
