local aName, aObj = ...
if not aObj:isAddonEnabled("ZPerl") then return end
local _G = _G

local function skinFrame(frame, ...)

	-- frame is scaleable, backdrop is used rto position other objects by ZPerl
	aObj:applySkin{obj=frame, kfs=true}

end

aObj.addonsToSkin.ZPerl = function(self) -- v 5.7.0

	-- Frame and Border colours
	_G.XPerlDB.colour.frame = _G.CopyTable(self.bClr)
	_G.XPerlDB.colour.border = _G.CopyTable(self.bbClr)
	-- Gradient colours
	_G.XPerlDB.colour.gradient.e = _G.CopyTable(self.gminClr)
	_G.XPerlDB.colour.gradient.s = _G.CopyTable(self.gmaxClr)
	_G.XPerlDB.colour.gradient.horizontal = self.db.profile.Gradient.rotate
	-- statusBar texture
	_G.XPerlDB.bar.texture[2] = self.sbTexture
	_G.XPerl_SetBarTextures()

	-- minimap button
	self.mmButs["ZPerl"] = _G.XPerl_MinimapButton_Frame

end

local function skinClassIcon(frame)

	aObj:adjWidth{obj=frame, adj=-1}
	aObj:adjHeight{obj=frame, adj=-2}
	aObj:moveObject{obj=frame, y=2}
	if aObj.modBtns then
		aObj:addSkinButton(frame, frame)
	end

end
aObj.addonsToSkin.ZPerl_Player = function(self)

	-- Put a border around the class icon
	skinClassIcon(_G.XPerl_PlayerclassFrame)

end

aObj.addonsToSkin.ZPerl_Target = function(self)

	-- Put a border around the class icon
	skinClassIcon(_G.XPerl_TargettypeFramePlayer)
	_G.RaiseFrameLevel(_G.XPerl_TargetnameFrame)

	--	Focus
	-- Put a border around the class icon
	skinClassIcon(_G.XPerl_FocustypeFramePlayer)

end

aObj.addonsToSkin.ZPerl_Party = function(self)

	-- Put a border around the class icon
	for i = 1, 4 do
		skinClassIcon(_G["XPerl_party" .. i .. "classFrame"])
	end

end

aObj.addonsToSkin.ZPerl_RaidMonitor = function(self)

	skinFrame(_G.XPerl_RaidMonitor_Frame)

end

aObj.addonsToSkin.ZPerl_RaidAdmin = function(self)

	-- hook this to skin frames
	self:rawHook("XPerl_SetupFrameSimple", skinFrame)

	self:skinEditBox(_G.XPerl_AdminFrame_Controls_Edit)
	self:moveObject{obj=_G.XPerl_AdminFrame_Controls_Edit, x=-5}
	_G.XPerl_SetupFrameSimple(_G.XPerl_AdminFrame)
	-- skinFrame(_G.XPerl_AdminFrame)

	-- Item Checker Frame
	self:skinDropDown(_G.XPerl_CheckButtonChannel)
	_G.XPerl_SetupFrameSimple(_G.XPerl_Check)

	-- Roster Text Frame
	self:skinSlider{obj=_G.XPerl_RosterTexttextFramescroll.ScrollBar}
	skinFrame(_G.XPerl_RosterTexttextFrame)
	skinFrame(_G.XPerl_RosterText)

end

aObj.addonsToSkin.ZPerl_RaidHelper = function(self)

	-- hook this to skin frames
	self:rawHook("XPerl_SetupFrameSimple", skinFrame)

	_G.XPerl_SetupFrameSimple(_G.XPerl_Frame)

	_G.XPerl_SetupFrameSimple(_G.XPerl_Assists_Frame)
	if self.modBtns then
		self:skinCloseButton{obj=_G.XPerlAssistsCloseButton, font=self.fontSB, noSkin=true}
	end

	_G.XPerl_SetupFrameSimple(_G.XPerl_Target_AssistFrame)
	self:moveObject{obj=_G.XPerl_Target_AssistFrame, y=1}

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "XPerl_BottomTip")
	end

end

local function skinSelectedObject(frame)

	for _, child in ipairs{frame:GetChildren()} do
		if aObj:isDropDown(child) then
			aObj:skinDropDown{obj=child}
		elseif child:IsObjectType("EditBox") then
			aObj:skinEditBox{obj=child, regs={6}} -- 6 is text
		elseif child:IsObjectType("Slider") then
			aObj:skinSlider{obj=child}
		elseif child:IsObjectType("CheckButton")
		and aObj.modChkBtns
		then
			aObj:skinCheckButton{obj=child}
		end
	end

end
aObj.lodAddons.ZPerl_Options = function(self)

	-- hook these to manage backdrops
	for _, frame in _G.pairs{"Options", "ColourPicker", "Options_TooltipConfig", "Options_TextureSelect", "OptionsQuestionDialog", "Custom_Config"} do
		_G["XPerl_" .. frame].Setup = _G.nop
	end

	-- Colour Picker Frame
	self:addSkinFrame{obj=_G.XPerl_ColourPicker, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_ColourPicker_OK}
		self:skinStdButton{obj=_G.XPerl_ColourPicker_Cancel}
	end

	--	Texture Select Frame
	self:skinSlider{obj=_G.XPerl_Options_TextureSelectscrollBar.ScrollBar}
	self:addSkinFrame{obj=_G.XPerl_Options_TextureSelect, ft="a", kfs=true, nb=true}

	-- Options Frame
	skinFrame(_G.XPerl_Options)
	self:addSkinFrame{obj=_G.XPerl_Options_Area_Align, ft="a", kfs=true, nb=true, x1=-2, y1=4, x2=2, y2=-2}
	self:addSkinFrame{obj=_G.XPerl_Options_Area_Global, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2, y2=-2}
	self:addSkinFrame{obj=_G.XPerl_Options_Area_Tabs, ft="a", kfs=true, nb=true, x1=-2, y1=1, x2=2, y2=-2}

	-- player alignment
	self:adjWidth{obj=_G.XPerl_Options_Player_Gap, adj=-10}
	self:moveObject{obj=_G.XPerl_Options_Player_Gap, x=-10}
	self:moveObject{obj=_G.XPerl_Options_Player_BiggerGap, x=4}
	skinSelectedObject(_G.XPerl_Options_Player)
	-- party alignment
	self:moveObject{obj=_G.XPerl_Options_Party_Gap, x=-6}
	self:moveObject{obj=_G.XPerl_Options_Party_BiggerGap, x=6}
	skinSelectedObject(_G.XPerl_Options_Party)
	-- raid alignment
	self:adjWidth{obj=_G.XPerl_Options_Raid_Gap, adj=-10}
	self:moveObject{obj=_G.XPerl_Options_Raid_Gap, x=-10}
	self:moveObject{obj=_G.XPerl_Options_Raid_BiggerGap, x=4}
	skinSelectedObject(_G.XPerl_Options_Raid)
	if self.modBtns then
		self:skinCloseButton{obj=_G.XPerl_Options_CloseButton}
		self:skinStdButton{obj=_G.XPerl_Options_Layout_Save}
		self:skinStdButton{obj=_G.XPerl_Options_Layout_Load}
	end
	-- Layout
	self:skinEditBox{obj=_G.XPerl_Options_Layout_Name, regs={6}}
	self:addSkinFrame{obj=_G.XPerl_Options_Layout_List, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2, y2=-2}
	self:skinSlider{obj=_G.XPerl_Options_Layout_ListScrollBar.ScrollBar}

	-- Global Options subpanel
	skinSelectedObject(_G.XPerl_Options_Global_Options)
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Global_Options_Reset}
	end
	_G.XPerl_Options_Global_Options_RangeFinderSeparator:Hide()	-- separator line
	skinSelectedObject(_G.XPerl_Options_Global_Options_RangeFinder)
	if self.modBtnBs then
		 self:addButtonBorder{obj=_G.XPerl_Options_Global_Options_RangeFinder_CustomSpell, relTo=_G.XPerl_Options_Global_Options_RangeFinder_CustomSpellIcon}
	end

	-- Player Options subpanel
	skinSelectedObject(_G.XPerl_Options_Player_Options)
	skinSelectedObject(_G.XPerl_Options_Player_Options_Healer)
	skinSelectedObject(_G.XPerl_Options_Player_Options_Buffs)
	self:addSkinFrame{obj=_G.XPerl_Options_Player_Options_Buffs, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	skinSelectedObject(_G.XPerl_Options_Player_Options_Totems)
	self:addSkinFrame{obj=_G.XPerl_Options_Player_Options_Totems, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Player_AlignTop}
	end

	-- Pet Options subpanel
	skinSelectedObject(_G.XPerl_Options_Pet_Options)
	skinSelectedObject(_G.XPerl_Options_Pet_Options_PetTarget)
	skinSelectedObject(_G.XPerl_Options_Pet_Options_PetTarget_Healer)
	self:addSkinFrame{obj=_G.XPerl_Options_Pet_Options_PetTarget, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}

	-- Target Options subpanel
	skinSelectedObject(_G.XPerl_Options_Target_Options)
	skinSelectedObject(_G.XPerl_Options_Target_Options_Healer)
	skinSelectedObject(_G.XPerl_Options_Target_Options_TargetTarget)
	skinSelectedObject(_G.XPerl_Options_Target_Options_TargetTarget_Healer)
	self:addSkinFrame{obj=_G.XPerl_Options_Target_Options_TargetTarget, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2, y2=-6}

	-- Focus Options subpanel
	skinSelectedObject(_G.XPerl_Options_Focus_Options)
	skinSelectedObject(_G.XPerl_Options_Focus_Options_Healer)
	skinSelectedObject(_G.XPerl_Options_Focus_Options_FocusTarget)
	skinSelectedObject(_G.XPerl_Options_Focus_Options_FocusTarget_Healer)
	self:addSkinFrame{obj=_G.XPerl_Options_Focus_Options_FocusTarget, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}

	-- Party Options subpanel
	skinSelectedObject(_G.XPerl_Options_Party_Options)
	skinSelectedObject(_G.XPerl_Options_Party_Options_Healer)
	skinSelectedObject(_G.XPerl_Options_Party_Options_PartyPets)
	self:addSkinFrame{obj=_G.XPerl_Options_Party_Options_PartyPets, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	if _G.XPerl_Party_AnchorVirtual then
		self:addSkinFrame{obj=_G.XPerl_Party_AnchorVirtual, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	end

	-- Raid Options subpanel
	skinSelectedObject(_G.XPerl_Options_Raid_Options)
	skinSelectedObject(_G.XPerl_Options_Raid_Options_Groups)
	for i = 1, 12 do
		skinSelectedObject(_G["XPerl_Options_Raid_Options_Groups_ClassSel" .. i])
	end
	self:addSkinFrame{obj=_G.XPerl_Options_Raid_Options_Groups, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	skinSelectedObject(_G.XPerl_Options_Raid_Options_Pets)
	self:addSkinFrame{obj=_G.XPerl_Options_Raid_Options_Pets, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	skinSelectedObject(_G.XPerl_Options_Raid_Options_Custom)
	self:addSkinFrame{obj=_G.XPerl_Options_Raid_Options_Custom, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Raid_AlignTop}
		self:skinStdButton{obj=_G.XPerl_Options_Raid_AlignLeft}
		self:skinStdButton{obj=_G.XPerl_Options_Raid_Options_Groups_All}
		self:skinStdButton{obj=_G.XPerl_Options_Raid_Options_Groups_None}
		self:skinStdButton{obj=_G.XPerl_Options_Raid_Options_Custom_Config}
	end
	-- Raid Group frames
	if _G.XPerl_Raid_Title1 then
		for i = 1, 12 do
			self:addSkinFrame{obj=_G["XPerl_Raid_Title"..i.."Virtual"], ft="a", kfs=true, nb=true, ofs=0}
		end
	end

	-- All Options subpanel
	skinSelectedObject(_G.XPerl_Options_All_Options)
	skinSelectedObject(_G.XPerl_Options_All_Options_Healer)
	skinSelectedObject(_G.XPerl_Options_All_Options_AddOns)
	self:addSkinFrame{obj=_G.XPerl_Options_All_Options_AddOns, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_All_Options_AddOns_Reload}
	end

	-- Colours Options subpanel
	skinSelectedObject(_G.XPerl_Options_Colour_Options_BarColours)
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_BarColours, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	skinSelectedObject(_G.XPerl_Options_Colour_Options_UnitReactions)
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_UnitReactions, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	skinSelectedObject(_G.XPerl_Options_Colour_Options_Appearance)
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_Appearance, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	skinSelectedObject(_G.XPerl_Options_Colour_Options_FrameColours)
	self:addSkinFrame{obj=_G.XPerl_Options_Colour_Options_FrameColours, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_Appearance_Reset}
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_FrameColours_Reset}
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_BarColours_Reset}
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_UnitReactions_Reset}
	end

	-- Helper Options subpanel
	skinSelectedObject(_G.XPerl_Options_Helper_Options)
	skinSelectedObject(_G.XPerl_Options_Helper_Options_Healer)
	skinSelectedObject(_G.XPerl_Options_Helper_Options_Assists)
	self:addSkinFrame{obj=_G.XPerl_Options_Helper_Options_Assists, ft="a", kfs=true, nb=true, x1=-2, y1=2, x2=2}

	-- Monitor Options subpanel
	skinSelectedObject(_G.XPerl_Options_Monitor_Options)

	-- Admin Options subpanel
	skinSelectedObject(_G.XPerl_Options_Admin_Options)

	-- Custom Raid Highlights Config (appears when Configure button, on Raid Custon subpanel, is pressed)
	skinSelectedObject(_G.XPerl_Custom_Config)
	self:addSkinFrame{obj=_G.XPerl_Custom_Config, ft="a", kfs=true, nb=true, ofs=0}
	self:skinSlider{obj=_G.XPerl_Custom_ConfigzoneListscrollBar.ScrollBar}
	self:addSkinFrame{obj=_G.XPerl_Custom_ConfigzoneList, ft="a", kfs=true, nb=true, y1=2, y2=-3}
	self:skinSlider{obj=_G.XPerl_Custom_ConfigdebuffsscrollBar.ScrollBar}
	self:addSkinFrame{obj=_G.XPerl_Custom_Configdebuffs, ft="a", kfs=true, nb=true, y1=2, y2=-3}
	skinSelectedObject(_G.XPerl_Custom_ConfigNew)
	if self.modBtns then
		self:skinCloseButton{obj=_G.XPerl_Custom_Config_CloseButton}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigEdit_Defaults}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigEdit_New}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigEdit_Delete}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigNew_Cancel}
	end

	--	Options Question Dialog
	self:addSkinFrame{obj=_G.XPerl_OptionsQuestionDialog, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_OptionsQuestionDialogYes}
		self:skinStdButton{obj=_G.XPerl_OptionsQuestionDialogNo}
	end

	-- Tooltip Config
	self:addSkinFrame{obj=_G.XPerl_Options_TooltipConfig, ft="a", kfs=true, nb=true}

end
