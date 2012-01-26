local aName, aObj = ...
if not aObj:isAddonEnabled("PhoenixStyle") then return end

local x1, y1 = -2, -4
function aObj:PhoenixStyle()

	-- Main Panel buttons
	self:skinAllButtons{obj=PSFmain1}
	-- Menu (on LHS)
	self:addSkinFrame{obj=PSFmain2, y1=-4}
	-- Addon
	self:addSkinFrame{obj=PSFmain3, x1=x1, y1=y1}
	-- Autoupdate marks
	self:SecureHook("psfautomarldraw", function()
		self:skinEditBox{obj=pseb1}
		self:skinEditBox{obj=pseb2}
		self:skinEditBox{obj=pseb3}
		self:skinEditBox{obj=pseb4}
		self:skinEditBox{obj=pseb5}
		self:skinEditBox{obj=pseb6}
		self:skinEditBox{obj=pseb7}
		self:skinEditBox{obj=pseb8}
		self:Unhook("psfautomarldraw")
	end)
	self:addSkinFrame{obj=PSFmain4, x1=x1, y1=y1}
	-- Timers
	self:skinEditBox{obj=PSFmain5_timertopull1, x=-5}
	self:skinEditBox{obj=PSFmain5_timerpereriv1, x=-5}
	self:skinEditBox{obj=PSFmain5_timersvoi1, x=-5}
	self:skinEditBox{obj=PSFmain5_timersvoi2, x=-5}
	-- remove divider lines
	self:SecureHook("psftimecrepol", function()
		self:keepFontStrings(PSFmain5)
		self:Unhook("psftimecrepol")
	end)
	self:addSkinFrame{obj=PSFmain5, kfs=true, x1=x1, y1=y1}
	-- Error frame
	self:addSkinFrame{obj=PSFerrorframeuniq, x1=x1, y1=y1}
	-- Potions check
	self:addSkinFrame{obj=PSFpotioncheckframe, x1=x1, y1=y1}
	-- Flask check
	self:addSkinFrame{obj=PSFrscflask, x1=x1, y1=y1}
	-- Rebirth - Rebuff
	self:addSkinFrame{obj=PSFrscbuff, x1=x1, y1=y1}
	-- Raid Achievements
	self:addSkinFrame{obj=PSFmainrano, x1=x1, y1=y1}
	-- Chat options
	self:SecureHook("openaddchat", function()
		self:skinDropDown{obj=DropDownaddchat}
		self:Unhook("openaddchat")
	end)
	self:SecureHook("openremovechat", function()
		self:skinDropDown{obj=DropDownremovechat}
		self:Unhook("openremovechat")
	end)
	self:addSkinFrame{obj=PSFmainchated, x1=x1, y1=y1}
	-- Font change
	self:addSkinFrame{obj=PSFmainfontchange, x1=x1, y1=y1}
	-- Credits
	self:addSkinFrame{obj=PSFthanks, x1=x1, y1=y1}
	-- Support development
	self:addSkinFrame{obj=PSFthanks2, x1=x1, y1=y1}
	self:SecureHook("PSFdonatef", function()
		self:skinScrollBar{obj=psdonatefr2}
		self:Unhook("PSFdonatef")
	end)
	-- Raids
	self:addSkinFrame{obj=PSFmainic1, x1=x1, y1=y1}
	self:SecureHook("openbossic", function()
		self:skinDropDown{obj=DropDownMenubossic}
		self:Unhook("openbossic")
	end)
	self:SecureHook("openbossic2", function()
		self:skinDropDown{obj=DropDownMenubossic2}
		self:Unhook("openbossic2")
	end)
	self:SecureHook("openchatic", function()
		self:skinDropDown{obj=DropDownchatic}
		self:Unhook("openchatic")
	end)
	self:SecureHook("openchatic2", function()
		self:skinDropDown{obj=DropDownchatic2}
		self:Unhook("openchatic2")
	end)
	self:SecureHook("openchatic3", function()
		self:skinDropDown{obj=DropDownchatic3}
		self:Unhook("openchatic3")
	end)

	-- Saved Info Module
	self:skinEditBox{obj=PSFmainfrainsavedinfo_edbox2}
	self:addSkinFrame{obj=PSFmainfrainsavedinfo, x1=x1, y1=y1}
	self:SecureHook("opensiplayers", function()
		self:skinDropDown{obj=DropDownsiplayerchoose}
		self:Unhook("opensiplayers")
	end)
	self:SecureHook("opensicombarchoose", function()
		self:skinDropDown{obj=DropDownsicombarchoose}
		self:Unhook("opensicombarchoose")
	end)
	self:SecureHook("opensitypereport", function()
		self:skinDropDown{obj=DropDownsityperepchoose}
		self:Unhook("opensitypereport")
	end)
	self:SecureHook("opensieventchoose", function()
		self:skinDropDown{obj=DropDownsieventchoose}
		self:Unhook("opensieventchoose")
	end)
	self:SecureHook("opensilogchat", function()
		self:skinDropDown{obj=DropDownsilogchat}
		self:Unhook("opensilogchat")
	end)
	self:SecureHook("pscreatesavedinfoframes", function()
		self:skinScrollBar{obj=pssavedinfscrollfr}
		self:Unhook("pscreatesavedinfoframes")
	end)

	-- Boss Mods check module
	self:addSkinFrame{obj=PSFbossmodframe, x1=x1, y1=y1}
	self:SecureHook("openchoosebssort", function()
		self:skinDropDown{obj=DropDownchoosebssort}
		self:Unhook("openchoosebssort")
	end)

	-- Get Spell Link module
	self:skinEditBox{obj=PSFmainspellidframe_edbox1, regs={9}}
	self:skinEditBox{obj=PSFmainspellidframe_edbox2, regs={9}}
	self:skinEditBox{obj=PSFmainspellidframe_edbox3, regs={9}}
	self:skinEditBox{obj=PSFmainspellidframe_edbox4, regs={9}}
	self:addSkinFrame{obj=PSFmainspellidframe, x1=x1, y1=y1}
	self:SecureHook("PSF_buttonspellidcreate", function()
		self:skinScrollBar{obj=psscrolllinkid}
		self:Unhook("PSF_buttonspellidcreate")
	end)

	-- Say announcer module
	self:addSkinFrame{obj=PSF_saframe, x1=x1, y1=y1}
	self:SecureHook("opensadrop", function()
		self:skinDropDown{obj=DropDownMenusadropaddon}
		self:Unhook("opensadrop")
	end)
	self:SecureHook("opensaybossad", function()
		self:skinDropDown{obj=DropDownMenusaybossad}
		self:Unhook("opensaybossad")
	end)

	-- Auto invite module
	self:skinEditBox{obj=PSFautoinvframe_edbox10, regs={9}}
	self:skinEditBox{obj=PSFautoinvframe_edbox20, regs={9}}
	self:skinEditBox{obj=PSFautoinvframe_edbox30, regs={9}}
	self:skinEditBox{obj=PSFautoinvframe_edbox40, regs={9}}
	self:addSkinFrame{obj=PSFautoinvframe, x1=x1, y1=y1}
	self:SecureHook("openguildranktoprom", function()
		self:skinDropDown{obj=DropDownguildranktoprom}
		self:Unhook("openguildranktoprom")
	end)
	self:SecureHook("openraiddiff", function()
		self:skinDropDown{obj=DropDowndiffrai1}
		self:Unhook("openraiddiff")
	end)
	self:SecureHook("openraiddiff2", function()
		self:skinDropDown{obj=DropDownraiddiff2}
		self:Unhook("openraiddiff2")
	end)
	self:SecureHook("openthreshold", function()
		self:skinDropDown{obj=DropDownthreshold}
		self:Unhook("openthreshold")
	end)

	-- Death Report module ?
	self:addSkinFrame{obj=PSFdeathreport, x1=x1, y1=y1}
	self:SecureHook("opendeathrc1", function()
		self:skinDropDown{obj=DropDowndeathrc1}
		self:Unhook("opendeathrc1")
	end)
	self:SecureHook("opendeathrc2", function()
		self:skinDropDown{obj=DropDowndeathrc2}
		self:Unhook("opendeathrc2")
	end)

	-- Raid options module
	self:addSkinFrame{obj=PSFraidopt, x1=x1, y1=y1}

end
