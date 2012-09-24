local aName, aObj = ...
if not aObj:isAddonEnabled("oQueue") then return end

function aObj:oQueue()

	-- TabContainer Frame
	self:moveObject{obj=OQFrameHeaderLogo, y=-6}
	self:skinButton{obj=OQTabContainerFrameClose1, cb=true}
	self:addSkinFrame{obj=OQTabContainerFrame, kfs=true, nb=true, y2=-2}
	-- TabPage1 (Premade)
	self:addButtonBorder{obj=OQ_Tab1BGDropDownButton1, ofs=-2}
	OQ_Tab1BGDropDownButton1:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=OQ_Tab1BGDropDownButton2, ofs=-2}
	OQ_Tab1BGDropDownButton2:DisableDrawLayer("BACKGROUND")
	local function unhookAllgrdr()
		for i = 1, 8 do
			for j = i * 5 - 4, i * 5 do
				self:Unhook(_G["OQTabPage1GroupRegion"..i.."DotRegion"..j], "OnEnter")
			end
		end
	end
	-- hook all OnEnter scripts to skin tooltip
	for i = 1, 8 do
		_G["OQTabPage1GroupRegion"..i].texture:SetTexture(nil)
		for j = i * 5 - 4, i * 5 do
			self:SecureHookScript(_G["OQTabPage1GroupRegion"..i.."DotRegion"..j], "OnEnter", function(this)
				if OQTooltip then
					self:addSkinFrame{obj=OQTooltip}
					unhookAllgrdr()
				end
			end)
		end
	end
	local function skinLeaveQ(btn)
		if (btn:GetText() == OQ_JOIN_QUEUE or button == "RightButton")
		and OQLeaveQ
		then
			self:addSkinFrame{obj=OQLeaveQ}
			self:Unhook(OQTabPage1Button1, "OnClick")
			self:Unhook(OQTabPage1Button2, "OnClick")
		end
	end
	self:skinButton{obj=OQTabPage1Button1}
	self:SecureHookScript(OQTabPage1Button1, "OnClick", function(this, button)
		skinLeaveQ(this)
	end)
	self:skinButton{obj=OQTabPage1Button2}
	self:SecureHookScript(OQTabPage1Button2, "OnClick", function(this, button)
		skinLeaveQ(this)
	end)
	self:skinButton{obj=OQTabPage1Button3}
	self:SecureHookScript(OQTabPage1Button3, "OnClick", function(this)
		self:addSkinFrame{obj=OQBRBDialog}
		self:Unhook(OQTabPage1Button3, "OnClick")
	end)
	self:skinButton{obj=OQTabPage1Button4}
	self:skinButton{obj=OQTabPage1Button5}
	self:skinButton{obj=OQTabPage1Button6}
	self:skinButton{obj=OQTabPage1Button7}
	-- TabPage2 (Find Premade)
	self:skinScrollBar{obj=OQTabPage2ListScrollBar}
	self:addSkinFrame{obj=OQTabPage2List}
	self:skinButton{obj=OQTabPage2ButtonClose}
	local function unhookAlllr()
		for i = 1, 99 do
			if _G["OQTabPage2ListListingRegion"..i] then
				self:Unhook(_G["OQTabPage2ListListingRegion"..i], "OnEnter")
			end
		end
	end
	for i = 1, 99 do
		if _G["OQTabPage2ListListingRegion"..i] then
			self:SecureHookScript(_G["OQTabPage2ListListingRegion"..i], "OnEnter", function(this)
				if OQPMTooltip then
					self:addSkinFrame{obj=OQPMTooltip}
					unhookAlllr()
				end
			end)
		end
	end
	-- TabPage3 (Create Premade)
	self:skinEditBox{obj=OQ_RaidName1, regs={9}}
	self:skinEditBox{obj=OQ_LeadName2, regs={9}}
	self:skinEditBox{obj=OQ_RealID3, regs={9}}
	self:skinEditBox{obj=OQ_RealID4, regs={9}}
	self:skinEditBox{obj=OQ_MinResil5, regs={9}}
	self:skinEditBox{obj=OQ_Battlegrounds6, regs={9}}
	self:addSkinFrame{obj=OQ_Notes7}
	self:skinEditBox{obj=OQ_password8, regs={9}}
	self:skinButton{obj=OQTabPage3Button8}
	-- TabPage4 (Wait List)
	self:skinScrollBar{obj=OQTabPage4ListScrollBar}
	self:addSkinFrame{obj=OQTabPage4List}
	for i = 1, 99 do
		if _G["OQTabPage4ListWaitRegion"..i] then
			self:skinButton{obj=_G["OQTabPage4ListWaitRegion"..i].invite_but}
			if _G["OQTabPage4ListWaitRegion"..i].ginvite_but then
				self:skinButton{obj=_G["OQTabPage4ListWaitRegion"..i].ginvite_but}
			end
		end
	end
	-- TabPage5 (The Score)
		-- N.B. can't do anything about the capture bars, removing main texture exposes count value too early
	-- TabPage6 (Setup)
	self:skinScrollBar{obj=OQTabPage6ListScrollBar}
	self:applySkin{obj=OQTabPage6List} -- applySkin so list items appear in the FG
	self:skinEditBox{obj=OQ_BnetAddress9, regs={9}}
	self:skinButton{obj=OQTabPage6Button9}
	self:skinButton{obj=OQTabPage6Button10}
	self:skinButton{obj=OQTabPage6Button11}
	self:skinButton{obj=OQTabPage6Button12}
	self:skinButton{obj=OQTabPage6Button13}
	self:skinButton{obj=OQTabPage6Button14}
	local function skinAlts()
		for i = 1, 99 do
			if _G["OQTabPage6ListAlt"..i] then
				_G["OQTabPage6ListAlt"..i].texture:SetTexture(nil)
				self:skinButton{obj=_G["OQTabPage6ListAlt"..i].remove_but, as=true} -- applySkin so text appears in the FG
			end
		end
	end
	-- hook this to skin new Alts
	self:SecureHook(StaticPopupDialogs["OQ_AddToonName"], "OnAccept", function(this, ...)
		skinAlts()
	end)
	self:SecureHook(StaticPopupDialogs["OQ_AddToonName"], "EditBoxOnEnterPressed", function(this)
		skinAlts()
	end)
	-- skin any existing Alts
	skinAlts()
	-- Tabs
	self:skinTabs{obj=OQTabContainerFrame}
	-- OQMarquee
	self:addSkinFrame{obj=UIParentOQMarquee}
	
end
