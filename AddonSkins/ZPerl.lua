local _, aObj = ...
if not aObj:isAddonEnabled("ZPerl") then return end
local _G = _G

local function skinFrame(frame, ...)
	-- frame is scaleable, backdrop is used to position other objects by ZPerl
	if frame then
		aObj:skinObject("frame", {obj=frame, kfs=true})
	end
end

aObj.addonsToSkin.ZPerl = function(self) -- v 6.1.3

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

	-- hook this to replace frame object
	self:RawHook("XPerl_RegisterScalableFrame", function(frame, ...)
		aObj:Debug("XPerl_RegisterScalableFrame: [%s, %s]", frame, frame.sf)
		self.hooks.XPerl_RegisterScalableFrame(frame.sf, ...)
	end, true)

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

	self:skinObject("editbox", {obj=_G.XPerl_AdminFrame_Controls_Edit})
	self:moveObject{obj=_G.XPerl_AdminFrame_Controls_Edit, x=-5}
	_G.XPerl_SetupFrameSimple(_G.XPerl_AdminFrame)

	-- Item Checker Frame
	_G.XPerl_SetupFrameSimple(_G.XPerl_Check)

	-- Roster Text Frame
	self:skinObject("slider", {obj=_G.XPerl_RosterTexttextFramescroll.ScrollBar})
	skinFrame(_G.XPerl_RosterTexttextFrame)
	skinFrame(_G.XPerl_RosterText)

end

aObj.addonsToSkin.ZPerl_RaidHelper = function(self)

	-- hook this to skin frames
	self:rawHook("XPerl_SetupFrameSimple", skinFrame)

	_G.XPerl_SetupFrameSimple(_G.XPerl_Assists_Frame)
	if self.modBtns then
		self:skinCloseButton{obj=_G.XPerlAssistsCloseButton, font=self.fontSB, noSkin=true}
		self:skinOtherButton{obj=_G.XPerlAssistPin, text="•", noSkin=true} -- U+2022 Bullet
		self:moveObject{obj=_G.XPerlAssistPin, x=8}
		_G.XPerlAssistPin:SetSize(26, 26)
	end

	_G.XPerl_SetupFrameSimple(_G.XPerl_Target_AssistFrame)
	self:moveObject{obj=_G.XPerl_Target_AssistFrame, y=1}

	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "XPerl_BottomTip")
	end

end

local function skinKids(frame)
	for _, child in _G.ipairs{frame:GetChildren()} do
		if aObj:isDropDown(child) then
			aObj:skinObject("dropdown", {obj=child})
		elseif child:IsObjectType("EditBox") then
			aObj:skinObject("editbox", {obj=child})
		elseif child:IsObjectType("Slider") then
			aObj:skinObject("slider", {obj=child})
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
	self:skinObject("frame", {obj=_G.XPerl_ColourPicker, kfs=true})
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_ColourPicker_OK}
		self:skinStdButton{obj=_G.XPerl_ColourPicker_Cancel}
	end

	--	Texture Select Frame
	self:skinObject("slider", {obj=_G.XPerl_Options_TextureSelectscrollBar.ScrollBar})
	self:skinObject("frame", {obj=_G.XPerl_Options_TextureSelect, kfs=true})
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_TextureSelect_OK}
		self:skinStdButton{obj=_G.XPerl_Options_TextureSelect_Cancel}
	end

	-- Options Frame
	self:skinObject("frame", {obj=_G.XPerl_Options_Area_Align, kfs=true, fb=true, ofs=2, y1=4})
	self:skinObject("frame", {obj=_G.XPerl_Options_Area_Global, kfs=true, fb=true, ofs=2, y1=4})
	self:skinObject("frame", {obj=_G.XPerl_Options_Area_Tabs, kfs=true, fb=true, ofs=2, y1=1})

	-- player alignment
	self:adjWidth{obj=_G.XPerl_Options_Player_Gap, adj=-10}
	self:moveObject{obj=_G.XPerl_Options_Player_Gap, x=-10}
	self:moveObject{obj=_G.XPerl_Options_Player_BiggerGap, x=4}
	skinKids(_G.XPerl_Options_Player)
	-- party alignment
	self:moveObject{obj=_G.XPerl_Options_Party_Gap, x=-6}
	self:moveObject{obj=_G.XPerl_Options_Party_BiggerGap, x=6}
	skinKids(_G.XPerl_Options_Party)
	self:skinObject("dropdown", {obj=_G.XPerl_Options_Party_Anchor_DropDown, x1=16, x2=34, y2=-1})
	-- raid alignment
	self:adjWidth{obj=_G.XPerl_Options_Raid_Gap, adj=-10}
	self:moveObject{obj=_G.XPerl_Options_Raid_Gap, x=-10}
	self:moveObject{obj=_G.XPerl_Options_Raid_BiggerGap, x=4}
	skinKids(_G.XPerl_Options_Raid)
	self:skinObject("dropdown", {obj=_G.XPerl_Options_Raid_Anchor_DropDown, x1=16, x2=34, y2=-1})
	if self.modBtns then
		self:skinCloseButton{obj=_G.XPerl_Options_CloseButton}
		self:skinStdButton{obj=_G.XPerl_Options_Layout_Save}
		self:SecureHook(_G.XPerl_Options_Layout_Save, "Disable", function(this, _)
			self:clrBtnBdr(this)
		end)
		self:SecureHook(_G.XPerl_Options_Layout_Save, "Enable", function(this, _)
			self:clrBtnBdr(this)
		end)
		self:skinStdButton{obj=_G.XPerl_Options_Layout_Load}
		self:SecureHook(_G.XPerl_Options_Layout_Load, "Disable", function(this, _)
			self:clrBtnBdr(this)
		end)
		self:SecureHook(_G.XPerl_Options_Layout_Load, "Enable", function(this, _)
			self:clrBtnBdr(this)
		end)
	end
	-- Layout
	self:skinObject("editbox", {obj=_G.XPerl_Options_Layout_Name})
	self:skinObject("slider", {obj=_G.XPerl_Options_Layout_ListScrollBar.ScrollBar})
	self:skinObject("frame", {obj=_G.XPerl_Options_Layout_List, kfs=true, fb=true, ofs=2})

	local numTabs = 12
	self:skinObject("tabs", {obj=_G.XPerl_Options, prefix="XPerl_Options_", numTabs=numTabs, ignoreSize=true, lod=true, offsets={x1=0, y1=4, x2=0, y2=-4}, track=false, func=function(tab) tab:DisableDrawLayer("BACKGROUND") end})
	if self.isTT then
		self:SecureHook(_G._G.XPerl_Options_Tab, "SelectTab", function(this, id)
			local tab
			for i = 1, numTabs do
				tab = _G["XPerl_Options_Tab" .. i]
				if i == id then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
			tab = nil
		end)
	end
	self:skinObject("frame", {obj=_G.XPerl_Options, kfs=true, cb=true, ofs=0, y1=-1})

	-- Global Options subpanel
	skinKids(_G.XPerl_Options_Global_Options)
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Global_Options_Reset}
	end
	_G.XPerl_Options_Global_Options_RangeFinderSeparator:Hide()	-- separator line
	skinKids(_G.XPerl_Options_Global_Options_RangeFinder)
	if self.modBtnBs then
		 self:addButtonBorder{obj=_G.XPerl_Options_Global_Options_RangeFinder_CustomSpell, relTo=_G.XPerl_Options_Global_Options_RangeFinder_CustomSpellIcon}
	end

	-- Player Options subpanel
	skinKids(_G.XPerl_Options_Player_Options)
	skinKids(_G.XPerl_Options_Player_Options_Healer)
	skinKids(_G.XPerl_Options_Player_Options_Buffs)
	self:skinObject("frame", {obj=_G.XPerl_Options_Player_Options_Buffs, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Options_Player_Options_Totems)
	self:skinObject("frame", {obj=_G.XPerl_Options_Player_Options_Totems, kfs=true, fb=true, ofs=2})
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Player_AlignTop}
	end

	-- Pet Options subpanel
	skinKids(_G.XPerl_Options_Pet_Options)
	skinKids(_G.XPerl_Options_Pet_Options_PetTarget)
	skinKids(_G.XPerl_Options_Pet_Options_PetTarget_Healer)
	self:skinObject("frame", {obj=_G.XPerl_Options_Pet_Options_PetTarget, kfs=true, fb=true, ofs=2})

	-- Target Options subpanel
	skinKids(_G.XPerl_Options_Target_Options)
	skinKids(_G.XPerl_Options_Target_Options_Healer)
	skinKids(_G.XPerl_Options_Target_Options_TargetTarget)
	skinKids(_G.XPerl_Options_Target_Options_TargetTarget_Healer)
	self:skinObject("frame", {obj=_G.XPerl_Options_Target_Options_TargetTarget, kfs=true, fb=true, ofs=2, y2=-6})

	-- Focus Options subpanel
	skinKids(_G.XPerl_Options_Focus_Options)
	skinKids(_G.XPerl_Options_Focus_Options_Healer)
	skinKids(_G.XPerl_Options_Focus_Options_FocusTarget)
	skinKids(_G.XPerl_Options_Focus_Options_FocusTarget_Healer)
	self:skinObject("frame", {obj=_G.XPerl_Options_Focus_Options_FocusTarget, kfs=true, fb=true, ofs=2})

	-- Party Options subpanel
	skinKids(_G.XPerl_Options_Party_Options)
	skinKids(_G.XPerl_Options_Party_Options_Healer)
	skinKids(_G.XPerl_Options_Party_Options_PartyPets)
	self:skinObject("frame", {obj=_G.XPerl_Options_Party_Options_PartyPets, kfs=true, fb=true, ofs=2})
	if _G.XPerl_Party_AnchorVirtual then
		self:skinObject("frame", {obj=_G.XPerl_Party_AnchorVirtual, kfs=true, ofs=2})
	end

	-- Raid Options subpanel
	skinKids(_G.XPerl_Options_Raid_Options)
	skinKids(_G.XPerl_Options_Raid_Options_Groups)
	for i = 1, 12 do
		skinKids(_G["XPerl_Options_Raid_Options_Groups_ClassSel" .. i])
	end
	self:skinObject("frame", {obj=_G.XPerl_Options_Raid_Options_Groups, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Options_Raid_Options_Pets)
	self:skinObject("frame", {obj=_G.XPerl_Options_Raid_Options_Pets, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Options_Raid_Options_Custom)
	self:skinObject("frame", {obj=_G.XPerl_Options_Raid_Options_Custom, kfs=true, fb=true, ofs=2})
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
			self:skinObject("frame", {obj=_G["XPerl_Raid_Title" .. i .. "Virtual"], kfs=true, ofs=0})
		end
	end

	-- All Options subpanel
	skinKids(_G.XPerl_Options_All_Options)
	skinKids(_G.XPerl_Options_All_Options_Healer)
	skinKids(_G.XPerl_Options_All_Options_AddOns)
	self:skinObject("frame", {obj=_G.XPerl_Options_All_Options_AddOns, kfs=true, fb=true, ofs=2})
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_All_Options_AddOns_Reload}
		self:SecureHook(_G.XPerl_Options_All_Options_AddOns_Reload, "Disable", function(this, _)
			self:clrBtnBdr(this)
		end)
		self:SecureHook(_G.XPerl_Options_All_Options_AddOns_Reload, "Enable", function(this, _)
			self:clrBtnBdr(this)
		end)
	end

	-- Colours Options subpanel
	skinKids(_G.XPerl_Options_Colour_Options_BarColours)
	self:skinObject("frame", {obj=_G.XPerl_Options_Colour_Options_BarColours, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Options_Colour_Options_UnitReactions)
	self:skinObject("frame", {obj=_G.XPerl_Options_Colour_Options_UnitReactions, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Options_Colour_Options_Appearance)
	self:skinObject("frame", {obj=_G.XPerl_Options_Colour_Options_Appearance, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Options_Colour_Options_FrameColours)
	self:skinObject("frame", {obj=_G.XPerl_Options_Colour_Options_FrameColours, kfs=true, fb=true, ofs=2})
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_Appearance_Reset}
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_FrameColours_Reset}
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_BarColours_Reset}
		self:skinStdButton{obj=_G.XPerl_Options_Colour_Options_UnitReactions_Reset}
	end

	-- Helper Options subpanel
	skinKids(_G.XPerl_Options_Helper_Options)
	skinKids(_G.XPerl_Options_Helper_Options_Healer)
	skinKids(_G.XPerl_Options_Helper_Options_Assists)
	self:skinObject("frame", {obj=_G.XPerl_Options_Helper_Options_Assists, kfs=true, fb=true, ofs=2})

	-- Monitor Options subpanel
	skinKids(_G.XPerl_Options_Monitor_Options)

	-- Admin Options subpanel
	skinKids(_G.XPerl_Options_Admin_Options)

	-- Custom Raid Highlights Config (appears when Configure button, on Raid Custon subpanel, is pressed)
	-- skinKids(_G.XPerl_Custom_Config)
	self:skinObject("slider", {obj=_G.XPerl_Custom_ConfigzoneListscrollBar.ScrollBar})
	self:skinObject("frame", {obj=_G.XPerl_Custom_ConfigzoneList, kfs=true, fb=true, ofs=2})
	self:skinObject("slider", {obj=_G.XPerl_Custom_ConfigdebuffsscrollBar.ScrollBar})
	self:skinObject("frame", {obj=_G.XPerl_Custom_Configdebuffs, kfs=true, fb=true, ofs=2})
	skinKids(_G.XPerl_Custom_ConfigNew)
	self:skinObject("frame", {obj=_G.XPerl_Custom_Config, kfs=true, cb=true, ofs=0, y1=-1})
	if self.modBtns then
		self:skinCloseButton{obj=_G.XPerl_Custom_Config_CloseButton}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigEdit_Defaults}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigEdit_New}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigEdit_Delete}
		self:skinStdButton{obj=_G.XPerl_Custom_ConfigNew_Cancel}
	end

	--	Options Question Dialog
	self:skinObject("frame", {obj=_G.XPerl_OptionsQuestionDialog, kfs=true, ofs=2})
	if self.modBtns then
		self:skinStdButton{obj=_G.XPerl_OptionsQuestionDialogYes}
		self:skinStdButton{obj=_G.XPerl_OptionsQuestionDialogNo}
	end

	-- Tooltip Config
	self:skinObject("frame", {obj=_G.XPerl_Options_TooltipConfig, kfs=true, ofs=2})

end
