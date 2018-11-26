local aName, aObj = ...
if not aObj:isAddonEnabled("Azeroth Auto Pilot") then return end
local _G = _G

aObj.addonsToSkin["Azeroth Auto Pilot"] = function(self) -- v 1.001

	-- Core frames
	self:addSkinFrame{obj=_G.AAP.AfkFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AAP.ArrowFrame.Button}
	end

	self:addSkinFrame{obj=_G.AAP.QuestList.SugQuestFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AAP.QuestList.SugQuestFrame["Button1"], seca=true}
		self:skinStdButton{obj=_G.AAP.QuestList.SugQuestFrame["Button2"], seca=true}
	end

	self:skinEditBox{obj=AAP.QuestList.Greetings2EB1, regs={6}, x=-5, y=-8} -- 6 is text
	self:addSkinFrame{obj=_G.AAP.QuestList.Greetings, ft="a", kfs=true, nb=true, y2=-2}
	if self.modBtns then
		self:skinStdButton{obj=AAP.QuestList.GreetingsHideB, seca=true}
	end

	-- AAP.QuestList.MainFrame
	-- AAP.QuestList.ListFrame
	-- AAP.QuestList20
	-- AAP.QuestList21
	-- AAP.QuestList.ButtonParent

	for i = 1, 10 do
		self:addSkinFrame{obj=_G.AAP.QuestList.QuestFrames[i], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		if self.modBtns then
			self:skinStdButton{obj=_G.AAP.QuestList.QuestFrames["FS" .. i]["Button"]}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AAP.QuestList2["BF" .. i]["AAP_Button"], seca=true}
		end
	end

	-- Options Frame
	self:SecureHook(_G.AAP, "LoadOptionsFrame", function(this)
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.Options, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsB1, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsQuests, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsB2, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsArrow, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsB3, ft="a", kfs=true, nb=true, ofs=4}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame.OptionsGeneral, ft="a", kfs=true, nb=true, ofs=4}

		self:skinSlider{obj=_G.AAP.OptionsFrame.QuestListScaleSlider}
		self:skinSlider{obj=_G.AAP.OptionsFrame.ArrowScaleSlider}
		self:skinSlider{obj=_G.AAP.OptionsFrame.BannerScaleSlider}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoAcceptCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoHandInCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoHandInChoiceCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowQListCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.LockQuestListCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.LockArrowCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowArrowCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CutSceneCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoVendorCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoRepairCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.ShowGroupCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.AutoGossipCheckButton}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.BannerShowCheckButton}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button1"], seca=true}
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button2"], seca=true}
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button3"], seca=true}
		end

		self:Unhook(this, "LoadOptionsFrame")
	end)

	-- Banners Frames
	self:addSkinFrame{obj=_G.AAP.Banners.BannersFrame.Frame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AAP.Banners.BannersFrame.B1, seca=true}
		self:skinStdButton{obj=_G.AAP.Banners.BannersFrame.B2, seca=true}
		self:skinStdButton{obj=_G.AAP.Banners.BannersFrame.B3, seca=true}
	end
	for i = 1, 4 do
		self:addSkinFrame{obj=_G.AAP.Banners.BannersFrame["Frame" .. i], ft="a", kfs=true, nb=true}
	end

	-- BrutalStatic Frames
	self:SecureHook("AAP_BrutallPaintFunc", function()
		self:addSkinFrame{obj=_G.AAP.BrutallCC.BrutallFrame.Frame, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.AAP.BrutallCC.BrutallFrame.FrameName, ft="a", kfs=true, nb=true}
		self:Unhook(this, "AAP_BrutallPaintFunc")
	end)

end
