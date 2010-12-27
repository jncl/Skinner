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
	-- Saved Reports module
	self:SecureHook("openiccbosschsv", function()
		self:skinDropDown{obj=DropDowniccbosschsv}
		self:Unhook("openiccbosschsv")
	end)
	self:SecureHook("openiccbosschsv2", function()
		self:skinDropDown{obj=DropDowniccbosschsv2}
		self:Unhook("openiccbosschsv2")
	end)
	self:SecureHook("psiccaftcombop", function()
		self:skinScrollBar{obj=psiccinfscroll}
		self:Unhook("psiccaftcombop")
	end)
	self:SecureHook("openicclogfailchat", function()
		self:skinDropDown{obj=DropDownicclogfailchat}
		self:Unhook("openicclogfailchat")
	end)
	self:skinEditBox{obj=PSFiccaftercombinfoframe_edbox2}
	self:addSkinFrame{obj=PSFiccaftercombinfoframe, x1=x1, y1=y1}
	-- Damage/Switch info module
	self:SecureHook("openicccombarchoose", function()
		self:skinDropDown{obj=DropDownicccombarchoose}
		self:Unhook("openicccombarchoose")
	end)
	self:SecureHook("openicceventchoose", function()
		self:skinDropDown{obj=DropDownicceventchoose}
		self:Unhook("openicceventchoose")
	end)
	self:SecureHook("openiccquantname", function()
		self:skinDropDown{obj=DropDowniccquantname}
		self:Unhook("openiccquantname")
	end)
	self:SecureHook("openicclogchat", function()
		self:skinDropDown{obj=DropDownicclogchat}
		self:Unhook("openicclogchat")
	end)
	self:skinEditBox{obj=PSFiccdamageinfo_edbox2}
	self:addSkinFrame{obj=PSFiccdamageinfo, x1=x1, y1=y1}
	-- Raid options module
	self:addSkinFrame{obj=PSFraidopt, x1=x1, y1=y1}

end
