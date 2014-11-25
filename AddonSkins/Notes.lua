local aName, aObj = ...
if not aObj:isAddonEnabled("Notes") then return end
local _G = _G

function aObj:Notes()

	self:addSkinFrame{obj=_G.NotesFrameSendToMenu}
	self:keepFontStrings(_G.EmptyNotesFrame)
	self:skinDropDown{obj=_G.Notes_AddInfoDropDown, x2=0}
	self:skinDropDown{obj=_G.Notes_TypeDropDown, x2=-50}
	self:skinScrollBar{obj=_G.TextScrollFrame} -- EditNotesFrame
	_G.TextBodyEditBox:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinSlider{obj=_G.NotesFrameScrollFrame.scrollBar, adj=-4}
	self:addSkinFrame{obj=_G.NotesFrame, kfs=true, bgen=1, ofs=-10, x2=0, y2=4}

end