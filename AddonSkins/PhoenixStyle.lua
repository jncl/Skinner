local aName, aObj = ...
if not aObj:isAddonEnabled("PhoenixStyle") then return end
local _G = _G

local x1, y1 = -2, -4
aObj.addonsToSkin.PhoenixStyle = function(self) -- v 8.002

	local function skinKids(frame)
		for _, child in ipairs{frame:GetChildren()} do
			if child:IsObjectType("CheckButton") then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("Button") then
				aObj:skinStdButton{obj=child}
			elseif child:IsObjectType("EditBox") then
				aObj:skinEditBox{obj=child, regs={6}, x=-10}
			end
		end
	end
	local function skinDD(dropdown)
		_G.UIDropDownMenu_SetButtonWidth(dropdown, 24)
		self:skinDropDown{obj=dropdown}
	end
	self.mmButs["PhoenixStyle"] = _G.PS_MinimapButton

	self:skinStdButton{obj=_G.PSFmain1_Button2}
	-- Menu (on LHS)
	skinKids(_G.PSFmain2)
	self:addSkinFrame{obj=_G.PSFmain2, ft="a", kfs=true, nb=true, y1=-4}
	-- Addon
	skinKids(_G.PSFmain3)
	self:addSkinFrame{obj=_G.PSFmain3, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Autoupdate marks
	self:SecureHook("psfautomarldraw", function()
		self:skinEditBox{obj=_G.pseb1}
		self:skinEditBox{obj=_G.pseb2}
		self:skinEditBox{obj=_G.pseb3}
		self:skinEditBox{obj=_G.pseb4}
		self:skinEditBox{obj=_G.pseb5}
		self:skinEditBox{obj=_G.pseb6}
		self:skinEditBox{obj=_G.pseb7}
		self:skinEditBox{obj=_G.pseb8}
		self:Unhook("psfautomarldraw")
	end)
	skinKids(_G.PSFmain4)
	self:skinSlider{obj=_G.PSFmain4_Timerref}
	self:addSkinFrame{obj=_G.PSFmain4, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Timers
	skinKids(_G.PSFmain5)
	self:addSkinFrame{obj=_G.PSFmain5, ft="a", kfs=true, nb=true, kfs=true, x1=x1, y1=y1}
	-- Error frame
	self:addSkinFrame{obj=_G.PSFerrorframeuniq, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Potions check
	skinKids(_G.PSFpotioncheckframe)
	self:addSkinFrame{obj=_G.PSFpotioncheckframe, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Flask check
	self:addSkinFrame{obj=_G.PSFrscflask, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Rebirth - Rebuff
	self:addSkinFrame{obj=_G.PSFrscbuff, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Raid Achievements
	self:addSkinFrame{obj=_G.PSFmainrano, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Chat options
	self:SecureHook("openaddchat", function()
		skinDD(_G.DropDownaddchat)
	end)
	self:SecureHook("openremovechat", function()
		skinDD(_G.DropDownremovechat)
	end)
	skinKids(_G.PSFmainchated)
	self:addSkinFrame{obj=_G.PSFmainchated, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Font change
	self:skinSlider{obj=_G.PSFmainfontchange_slid1}
	self:skinSlider{obj=_G.PSFmainfontchange_slid2}
	self:skinStdButton{obj=_G.PSFmainfontchange_Buttonrezet}
	self:addSkinFrame{obj=_G.PSFmainfontchange, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Credits
	self:addSkinFrame{obj=_G.PSFthanks, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	-- Support development
	self:addSkinFrame{obj=_G.PSFthanks2, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("PSFdonatef", function()
		self:skinScrollBar{obj=_G.psdonatefr2}
		self:Unhook("PSFdonatef")
	end)
	-- Raids
	skinKids(_G.PSFmainic1)
	self:addSkinFrame{obj=_G.PSFmainic1, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("psopenexpansion", function()
		skinDD(_G.DropDownMenuexpans)
	end)
	self:SecureHook("openbossic", function()
		skinDD(_G.DropDownMenubossic)
	end)
	self:SecureHook("openbossic2", function()
		skinDD(_G.DropDownMenubossic2)
	end)
	self:SecureHook("openchatic", function()
		skinDD(_G.DropDownchatic)
	end)
	self:SecureHook("openchatic2", function()
		skinDD(_G.DropDownchatic2)
	end)
	self:SecureHook("openchatic3", function()
		skinDD(_G.DropDownchatic3)
	end)

	-- Saved Info Module
	skinKids(_G.PSFmainfrainsavedinfo)
	self:skinSlider{obj=_G.PSFmainfrainsavedinfo_Combatsvd1}
	self:skinSlider{obj=_G.PSFmainfrainsavedinfo_Combatsvd2}
	self:skinSlider{obj=_G.PSFmainfrainsavedinfo_slid1}
	self:skinSlider{obj=_G.PSFmainfrainsavedinfo_slid2}
	self:addSkinFrame{obj=_G.PSFmainfrainsavedinfo, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("opensiplayers", function()
		skinDD(_G.DropDownsiplayerchoose)
	end)
	self:SecureHook("opensicombarchoose", function()
		skinDD(_G.DropDownsicombarchoose)
	end)
	self:SecureHook("opensitypereport", function()
		skinDD(_G.DropDownsityperepchoose)
	end)
	self:SecureHook("opensieventchoose", function()
		skinDD(_G.DropDownsieventchoose)
	end)
	self:SecureHook("opensilogchat", function()
		skinDD(_G.DropDownsilogchat)
	end)
	self:SecureHook("pscreatesavedinfoframes", function()
		self:skinScrollBar{obj=_G.pssavedinfscrollfr}
		self:Unhook("pscreatesavedinfoframes")
	end)

	-- Boss Mods check module
	skinKids(_G.PSFbossmodframe)
	self:addSkinFrame{obj=_G.PSFbossmodframe, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("openchoosebssort", function()
		skinDD(_G.DropDownchoosebssort)
	end)

	-- Get Spell Link module
	skinKids(_G.PSFmainspellidframe)
	self:addSkinFrame{obj=_G.PSFmainspellidframe, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("PSF_buttonspellidcreate", function()
		self:skinSlider{obj=_G.psscrolllinkid.ScrollBar}
		self:Unhook("PSF_buttonspellidcreate")
	end)

	-- Say announcer module
	self:skinStdButton{obj=_G.PSF_saframe_ButtonSA}
	self:addSkinFrame{obj=_G.PSF_saframe, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("opensadrop", function()
		skinDD(_G.DropDownMenusadropaddon)
	end)
	self:SecureHook("opensaybossad", function()
		skinDD(_G.DropDownMenusaybossad)
	end)
	self:SecureHook("opensaybossadexp", function()
		skinDD(_G.DropDownMenusaybossadexp)
	end)

	-- Auto invite module
	skinKids(_G.PSFautoinvframe)
	self:addSkinFrame{obj=_G.PSFautoinvframe, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("openguildranktoprom", function()
		skinDD(_G.DropDownguildranktoprom)
	end)
	self:SecureHook("openraiddiff", function()
		skinDD(_G.DropDowndiffrai1)
	end)
	self:SecureHook("openraiddiff2", function()
		skinDD(_G.DropDownraiddiff2)
	end)
	self:SecureHook("openthreshold", function()
		skinDD(_G.DropDownthreshold)
	end)

	-- Death Report module ?
	self:skinStdButton{obj=_G.PSFdeathreport_Button1}
	self:addSkinFrame{obj=_G.PSFdeathreport, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("opendeathrc1", function()
		skinDD(_G.DropDowndeathrc1)
	end)
	self:SecureHook("opendeathrc2", function()
		skinDD(_G.DropDowndeathrc2)
	end)
	self:SecureHook("opendeathrc3", function()
		skinDD(_G.DropDowndeathrc3)
	end)

	-- Raid options module
	self:skinStdButton{obj=_G.PSFraidopt_Buttonrez}
	self:skinSlider{obj=_G.PSFraidopt_Combatsvd1}
	self:addSkinFrame{obj=_G.PSFraidopt, ft="a", kfs=true, nb=true, x1=x1, y1=y1}

	-- Donations frame
	skinKids(_G.PSFemptyframe)
	self:addSkinFrame{obj=_G.PSFemptyframe, ft="a", kfs=true, nb=true, x1=x1, y1=y1}
	self:SecureHook("psshowdoateinf", function()
		self:skinSlider{obj=_G.adfdfdpsdonatefr2.ScrollBar}
		self:Unhook(this, "psshowdoateinf")
	end)


end
