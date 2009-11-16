
local x1, y1 = -2, -4
function Skinner:PhoenixStyle()

	-- shield monitor
	self:addSkinFrame{obj=PScolishieldmini}
	-- Main Panel buttons
	self:skinButton{obj=PSFmain1_Button1}
	self:skinButton{obj=PSFmain1_Button2}
	-- Menu (on LHS)
	self:skinButton{obj=PSFmain2_Button3}
	self:skinButton{obj=PSFmain2_Button4}
	self:skinButton{obj=PSFmain2_Button5}
	self:skinButton{obj=PSFmain2_Button6}
	self:skinButton{obj=PSFmain2_Button7}
	self:skinButton{obj=PSFmain2_Button8}
	self:skinButton{obj=PSFmain2_ButtonRA}
	self:addSkinFrame{obj=PSFmain2, y1=-4}
	-- Addon
	self:addSkinFrame{obj=PSFmain3, x1=x1, y1=y1}
	-- Autoupdate marks
	self:skinEditBox{obj=PSFmain4_secrefmark2}
	self:skinEditBox{obj=PSFmain4_setmark10}
	self:skinEditBox{obj=PSFmain4_setmark20}
	self:skinEditBox{obj=PSFmain4_setmark30}
	self:skinEditBox{obj=PSFmain4_setmark40}
	self:skinEditBox{obj=PSFmain4_setmark50}
	self:skinEditBox{obj=PSFmain4_setmark60}
	self:skinEditBox{obj=PSFmain4_setmark70}
	self:skinEditBox{obj=PSFmain4_setmark80}
	self:skinButton{obj=PSFmain4_Button20}
	self:skinButton{obj=PSFmain4_Button21}
	self:skinButton{obj=PSFmain4_Button22}
	self:addSkinFrame{obj=PSFmain4, x1=x1, y1=y1}
	-- Timers
	self:skinEditBox{obj=PSFmain5_timertopull1, x=-5}
	self:skinEditBox{obj=PSFmain5_timerpereriv1, x=-5}
	self:skinEditBox{obj=PSFmain5_timersvoi1, x=-5}
	self:skinEditBox{obj=PSFmain5_timersvoi2, x=-5}
	self:skinButton{obj=PSFmain5_Button51}
	self:skinButton{obj=PSFmain5_Button52}
	self:skinButton{obj=PSFmain5_Button53}
	self:addSkinFrame{obj=PSFmain5, kfs=true, x1=x1, y1=y1}
	-- Error frame
	self:addSkinFrame{obj=PSFmain12, x1=x1, y1=y1}
	-- Raid Achievements
	self:addSkinFrame{obj=PSFmainrano, x1=x1, y1=y1}

	-- skin minimap button
	if self.db.profile.MinimapButtons then
		self:addSkinButton{obj=PS_MinimapButton, parent=PS_MinimapButton, sap=true}
	end

end

function Skinner:PhoenixStyleMod_Coliseum()

	self:skinDropDown{obj=DropDownMenuTwins}
	self:skinDropDown{obj=DropDownMenujarax}
	self:skinDropDown{obj=DropDownMenuzveri}
	self:skinButton{obj=PSFmain7_Button3} -- shields info
	self:skinButton{obj=self:getChild(PSFmain7, 8)} -- shield options
	self:addSkinFrame{obj=PSFmain7, kfs=true, x1=x1, y1=y1}

	-- hook this to skin the dropdown
	self:SecureHook("PSF_colshieldinfoopen", function()
		self:skinDropDown{obj=DropDownMenureportinfoshield}
		self:Unhook("PSF_colshieldinfoopen")
	end)
	self:skinButton{obj=PSFmainshieldinfo_Button3}
	self:skinButton{obj=PSFmainshieldinfo_Buttonsend1}
	self:skinButton{obj=PSFmainshieldinfo_Buttonsend2}
	self:skinButton{obj=PSFmainshieldinfo_Buttonsend3}
	self:skinButton{obj=PSFmainshieldinfo_Buttonsend4}
	self:addSkinFrame{obj=PSFmainshieldinfo, x1=x1, y1=y1}
	-- TwinValkyrs frame
	self:skinButton{obj=PSTwinValmenu_Button1, x1=-1}
	self:skinButton{obj=PSTwinValmenu_Button2}
	self:skinButton{obj=PSTwinValmenu_Button3}
	self:skinEditBox{obj=PSTwinValmenu_width1}
	PSTwinValmenu_width1:SetWidth(PSTwinValmenu_width1:GetWidth() + 3)
	self:skinEditBox{obj=PSTwinValmenu_heigh1}
	self:addSkinFrame{obj=PSTwinValmenu, y1=-4, y2=2}

end

function Skinner:PhoenixStyleMod_Ulduar()

	self:skinButton{obj=PSFmain8_Button441}
	self:skinButton{obj=PSFmain8_Button442}
	self:skinButton{obj=PSFmain8_Button443}
	self:skinButton{obj=PSFmain8_Button444}
	self:skinButton{obj=PSFmain8_Button445}
	self:skinButton{obj=PSFmain8_Button446}
	self:addSkinFrame{obj=PSFmain8, x1=x1, y1=y1}

	self:skinDropDown{obj=DropDownMenuGeneral}
	self:skinDropDown{obj=DropDownMenuMimiron}
	self:skinDropDown{obj=DropDownMenuStal}
	self:skinDropDown{obj=DropDownMenuHodir}
	self:skinDropDown{obj=DropDownMenuAlg}
	self:skinDropDown{obj=DropDownMenuxt}
	self:skinDropDown{obj=DropDownMenutorim}
	self:skinButton{obj=PSFmain6_Button41}
	self:skinButton{obj=PSFmain6_Button42}
	self:addSkinFrame{obj=PSFmain6, kfs=true, x1=x1, y1=y1}

	self:skinButton{obj=PSFmain11_Button1}
	self:skinButton{obj=PSFmain11_Button2}
	self:skinButton{obj=PSFmain11_Button3}
	self:skinButton{obj=PSFmain11_Button4}
	self:skinButton{obj=PSFmain11_Button5}
	self:skinButton{obj=PSFmain11_Button6}
	self:skinButton{obj=PSFmain11_Button7}
	self:skinEditBox{obj=PSFmain11_primyogg}
	self:addSkinFrame{obj=PSFmain11, x1=x1, y1=y1}

end
