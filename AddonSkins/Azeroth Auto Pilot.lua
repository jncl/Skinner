local _, aObj = ...
if not aObj:isAddonEnabled("AAP-Core")
and not aObj:isAddonEnabled("AAP-TBC-Classic")
then
	return
end
local _G = _G

if aObj.isRtl then
	aObj.addonsToSkin["AAP-Core"] = function(self) -- v 9.054

		-- Core frames
		self:addSkinFrame{obj=_G.AAP.AfkFrame, ft="a", kfs=true, nb=true, ofs=-6, x1=3}
		if self.modBtns then
			self:skinStdButton{obj=_G.AAP.ArrowFrame.Button}
		end

		self:SecureHook(_G.AAP, "RoutePlanLoadIn", function()
			self:addSkinFrame{obj=_G.AAP.LoadInOptionFrame, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.AAP.LoadInOptionFrame.B1}
				self:skinStdButton{obj=_G.AAP.LoadInOptionFrame.B2}
				self:skinStdButton{obj=_G.AAP.LoadInOptionFrame.B3}
			end
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.F22, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.xg2, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.F24, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.xg3, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.F23, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.Fx1, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.Fx2, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.F26, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.Fx3, ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.RoutePlan.FG1.Fx0, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.AAP.RoutePlan.FG1.CloseButton}
			end

			self:Unhook(_G.AAP, "RoutePlanLoadIn")
		end)

		-- OptionsPanel Frame
		self:SecureHook(_G.AAP, "LoadOptionsFrame", function()
			-- make frame appear above ZoneQuestOrder frame
			self:RaiseFrameLevelByFour(_G.AAP.OptionsFrame.MainFrame)
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame, ft="a", kfs=true, nb=true, ofs=4}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.Options, ft="a", kfs=true, nb=true, ofs=2, x2=4}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsB1, ft="a", kfs=true, nb=true, ofs=0}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsQuests, ft="a", kfs=true, nb=true, ofs=2, x1=-4}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsB2, ft="a", kfs=true, nb=true, ofs=0}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsArrow, ft="a", kfs=true, nb=true, ofs=2, x1=-4}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsB3, ft="a", kfs=true, nb=true, ofs=0}
			self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsGeneral, ft="a", kfs=true, nb=true, ofs=2, x1=-4}

			self:skinSlider{obj=_G.AAP.OptionsFrame.QuestListScaleSlider}
			self:skinSlider{obj=_G.AAP.OptionsFrame.QuestOrderListScaleSlider}
			self:skinSlider{obj=_G.AAP.OptionsFrame.ArrowScaleSlider}
			self:skinSlider{obj=_G.AAP.OptionsFrame.ArrowFpsSlider}
			self:skinSlider{obj=_G.AAP.OptionsFrame.MiniMapBlobAlphaSlider}
			self:skinSlider{obj=_G.AAP.OptionsFrame.QuestButtonsSlider}
			if self.modBtns then
				self:skinStdButton{obj=_G.AAP.OptionsFrame.ShowStuffs}
				self:skinStdButton{obj=_G.AAP.OptionsFrame.ShowStuffs2}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.AAP.OptionsFrame.ResetQorderL, seca=true}
				self:addButtonBorder{obj=_G.AAP.OptionsFrame.ResetARrow, seca=true}
				self:addButtonBorder{obj=_G.AAP.OptionsFrame.Button1, seca=true}
				self:addButtonBorder{obj=_G.AAP.OptionsFrame.Button2, seca=true}
				self:addButtonBorder{obj=_G.AAP.OptionsFrame.Button3, seca=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoAcceptCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoHandInCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoHandInChoiceCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowQListCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.LockQuestListCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.QorderListzCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.LockArrowCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowArrowCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.CutSceneCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoVendorCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoRepairCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowGroupCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoGossipCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoFlightCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.BlobsShowCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.MapBlobsShowCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowMap10sCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.DisableHeirloomWarningCheckButton}
				self:skinCheckButton{obj=_G.AAP.OptionsFrame.QuestButtonsCheckButton}
			end

			self:Unhook(_G.AAP, "LoadOptionsFrame")
		end)

		-- QuestList frames
		for i = 1, 5 do
			self:addSkinFrame{obj=_G.AAP.PartyList.PartyFrames[i], ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G.AAP.PartyList.PartyFrames2[i], ft="a", kfs=true, nb=true}
		end
		self:addSkinFrame{obj=_G.AAP.QuestList.SugQuestFrame, ft="a", kfs=true, nb=true}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AAP.QuestList.SugQuestFrame["Button1"], seca=true}
			self:addButtonBorder{obj=_G.AAP.QuestList.SugQuestFrame["Button2"], seca=true}
		end
		self:skinEditBox{obj=_G.AAP.QuestList.Greetings2EB1, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.AAP.QuestList.Greetings2EB2, regs={6}} -- 6 is text
		self:addSkinFrame{obj=_G.AAP.QuestList.Greetings, ft="a", kfs=true, nb=true, y2=-2}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AAP.QuestList.GreetingsHideB, seca=true}
		end
		self:addSkinFrame{obj=_G.AAP.QuestList.QuestFrames["MyProgress"], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		for i = 1, 20 do
			self:addSkinFrame{obj=_G.AAP.QuestList.QuestFrames[i], ft="a", kfs=true, nb=true, x1=-2, x2=2}
			if self.modBtns then
				self:skinStdButton{obj=_G.AAP.QuestList.QuestFrames["FS" .. i]["Button"]}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.AAP.QuestList2["BF" .. i]["AAP_Button"], seca=true}
			end
		end

		-- QuestTest frames
		self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder, ft="a", kfs=true, nb=true, x1=-2, x2=2}
		self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder.ZoneName, ft="a", kfs=true, nb=true, x1=-2, x2=2}
		if self.modBtns then
			_G.AAP.ZoneQuestOrder["AAP_Button"]:SetSize(26, 26)
			self:removeRegions(_G.AAP.ZoneQuestOrder["AAP_Button"], {2, 3, 5})
			self:moveObject{obj=_G.AAP.ZoneQuestOrder["AAP_Button"], x=-2, y=-2}
			self:skinCloseButton{obj=_G.AAP.ZoneQuestOrder["AAP_Button"]}
			_G.AAP.ZoneQuestOrder["AAP_Button"]:SetFrameStrata("MEDIUM")
		end
		self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder["Current"], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		self:SecureHook(_G.AAP, "AddQuestOrderFrame", function(CLi)
			self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder[CLi], ft="a", kfs=true, nb=true, x1=-2, x2=2}
			self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder["Order1"][CLi], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		end)
		self:SecureHook(_G.AAP, "AddQuestIdFrame", function(CLi)
			self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder["Order1iD"][CLi], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		end)
		self:SecureHook(_G.AAP, "AddQuestNameFrame", function(CLi)
			self:addSkinFrame{obj=_G.AAP.ZoneQuestOrder["OrderName"][CLi], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		end)

	end
else
	aObj.addonsToSkin["AAP-TBC-Classic"] = function(self) -- v 0.13

		-- _G.Spew("", _G.AAPClassic)

		self:SecureHookScript(_G.AAPClassic.GroupQuestFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Button1, sabt=true}
				self:skinStdButton{obj=this.Button2, sabt=true}
			end

			self:Unhook(this, "OnShow")
		end)

		-- AAPClassic.QL.MainFrame

		self:SecureHookScript(_G.AAPClassic.QL.QButtonFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, kfs=true})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Button, sabt=true}
			end

			self:Unhook(this, "OnShow")
		end)

		-- AAPClassic.QL.ListFrame

		for _, tObj in _G.pairs(_G.AAPClassic.QL.QuestFrames) do
			if tObj:IsObjectType("FRAME") then
				self:skinObject("frame", {obj=tObj, kfs=true})
			end
		end

		self:SecureHookScript(_G.AAPClassic.ArrowFrame.Button, "OnShow", function(this)
			self:skinObject("frame", {obj=this, kfs=true})

			self:Unhook(this, "OnShow")
		end)
	end
end
