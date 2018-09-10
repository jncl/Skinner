local aName, aObj = ...
if not aObj:isAddonEnabled("Azeroth Auto Pilot") then return end
local _G = _G

aObj.addonsToSkin["Azeroth Auto Pilot"] = function(self) -- v 0.173

	-- Core frames
	self:addSkinFrame{obj=_G.AAP_AfkFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AAP_ArrowFrame.Button}
	end

	-- QuestList Frames
	for i = 1, 5 do
		self:addSkinFrame{obj=_G.AAP.PartyList.PartyFrames[i], ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.AAP.PartyList.PartyFrames2[i], ft="a", kfs=true, nb=true}
	end

	self:addSkinFrame{obj=_G.AAP.QuestList.SugQuestFrame, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.AAP.QuestList.SugQuestFrame2, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.AAP.QuestList.SugQuestFrame2.TextureAFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AAP.QuestList.SugQuestFrame["Button1"], seca=true}
		self:skinStdButton{obj=_G.AAP.QuestList.SugQuestFrame["Button2"], seca=true}
		self:skinStdButton{obj=_G.AAP.QuestList.SugQuestFrame2["Button1"], seca=true}
		self:skinStdButton{obj=_G.AAP.QuestList.SugQuestFrame2["Button2"], seca=true}
	end

	self:skinEditBox{obj=AAP.QuestList.Greetings2EB1, regs={6}, x=-5, y=-8} -- 6 is text
	self:skinStdButton{obj=AAP.QuestList.GreetingsHideB, seca=true}
	self:addSkinFrame{obj=_G.AAP.QuestList.Greetings, ft="a", kfs=true, nb=true, y2=-2}

	-- AAP.QuestList.MainFrame
	-- AAP.QuestList.ListFrame
	-- AAP.QuestList20
	-- AAP.QuestList21

	for i = 1, 10 do
		self:addSkinFrame{obj=_G.AAP.QuestList.QuestFrames[i], ft="a", kfs=true, nb=true, x1=-2, x2=2}
		if self.modBtns then
			self:skinStdButton{obj=_G.AAP.QuestList.QuestFrames["FS" .. i]["Button"]}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AAP.QuestList2["BF" .. i]["AAP_Button"], seca=true}
		end
	end

	self:addSkinFrame{obj=_G.AAP.QuestList.Warcamp, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.AAP.QuestList.Warcamp2, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AAP.QuestList.WarcampB1, seca=true}
		self:skinStdButton{obj=_G.AAP.QuestList.WarcampB2, seca=true}
	end

	-- Options Frame
	self:SecureHookScript(_G.AAP.OptionsFrame.MainFrame, "OnShow", function(this)
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton1}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton2}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton3}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton10}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton11}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton12}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton5}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton7}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton8}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton9}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton13}
			self:skinCheckButton{obj=_G.AAP.OptionsFrame.CheckButton14}
		end
		self:skinSlider{obj=_G.AAP.OptionsFrame.Slider1}--, rt="artwork", wdth=-4, size=3, hgt=-10}
		self:skinSlider{obj=_G.AAP.OptionsFrame.Slider2}--, rt="artwork", wdth=-4, size=3, hgt=-10}
		self:skinSlider{obj=_G.AAP.OptionsFrame.Slider3}--, rt="artwork", wdth=-4, size=3, hgt=-10}
		if self.modBtns then
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button1"], seca=true}
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button2"], seca=true}
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button3"], seca=true}
			self:skinStdButton{obj=_G.AAP.OptionsFrame["Button4"], seca=true}
		end
		self:skinDropDown{obj=_G.AAP_DropDownList}--, noSkin=true, x1=0, y1=0, x2=0, y2=0}
		self:skinDropDown{obj=_G.AAP_dropDown1}--, noSkin=true, x1=0, y1=0, x2=0, y2=0}
		self:addSkinFrame{obj=_G.AAP.OptionsFrame.MainFrame, ft="a", kfs=true, nb=true, ofs=4}

		self:Unhook(this, "OnShow")
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
	self:addSkinFrame{obj=_G.AAP.BrutallCC.BrutallFrame.Frame, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.AAP.BrutallCC.BrutallFrame.FrameName, ft="a", kfs=true, nb=true}

end
