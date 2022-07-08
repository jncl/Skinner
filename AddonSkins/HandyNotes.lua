local _, aObj = ...
if not aObj:isAddonEnabled("HandyNotes") then return end
local _G = _G

aObj.addonsToSkin.HandyNotes = function(self) -- v 1.6.6

	-- thanks to Xinhuan for the pointer in the code :-)
	local HNEditFrame = _G.LibStub("AceAddon-3.0"):GetAddon("HandyNotes"):GetModule("HandyNotes").HNEditFrame

	HNEditFrame.titleinputframe:SetBackdrop(nil)
	self:moveObject{obj=HNEditFrame.title, y=-6}
	self:skinObject("editbox", {obj=HNEditFrame.titleinputbox})
	self:skinObject("frame", {obj=HNEditFrame.descframe, kfs=true, fb=true})
	self:skinObject("slider", {obj=HNEditFrame.descscrollframe.ScrollBar})
	self:skinObject("dropdown", {obj=HNEditFrame.icondropdown})
	self:skinObject("frame", {obj=HNEditFrame, kfs=true, ofs=-5, y1=-4, y2=30})
	if self.modBtns then
		self:skinStdButton{obj=HNEditFrame.okbutton}
		self:skinStdButton{obj=HNEditFrame.cancelbutton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=HNEditFrame.continentcheckbox}
	end

end

aObj.addonsToSkin.HandyNotes_BattleForAzeroth = function(self) -- v 10

	self:skinObject("slider", {obj=_G.HandyNotes_BattleForAzerothAlphaMenuSliderOption.Slider})
	self:skinObject("slider", {obj=_G.HandyNotes_BattleForAzerothScaleMenuSliderOption.Slider})

	for _, child in _G.ipairs{_G.WorldMapFrame:GetChildren()} do
		if child:IsObjectType("button")
		and child.Border
		and	child.relativeFrame
		then
			child.Border:SetTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=child, ofs=-1, clr="gold"}
			end
		end
	end

end

aObj.addonsToSkin.HandyNotes_Shadowlands = function(self) -- v 44

	self:skinObject("slider", {obj=_G.HandyNotes_ShadowlandsAlphaMenuSliderOption.Slider})
	self:skinObject("slider", {obj=_G.HandyNotes_ShadowlandsScaleMenuSliderOption.Slider})

	for _, child in _G.ipairs{_G.WorldMapFrame:GetChildren()} do
		if child:IsObjectType("button")
		and child.Border
		and	child.relativeFrame
		then
			child.Border:SetTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=child, ofs=-1, clr="gold"}
			end
		end
	end

end
