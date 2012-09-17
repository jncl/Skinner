local aName, aObj = ...
if not aObj:isAddonEnabled("Notes") then return end

function aObj:Notes()

	self:addSkinFrame{obj=Notes.Notes}
	self:skinSlider{obj=Notes.Notes.Scroll.ScrollBar}
	self:addButtonBorder{obj=Notes.InsertMailNote}
	self:addSkinFrame{obj=Notes.Frame}
	self:skinDropDown{obj=Notes.DropDownMenu}
	self:addSkinFrame{obj=Notes.ConfirmBox}
	self:addSkinButton{obj=NotesMapIcon, parent=NotesMapIcon, sap=true}

	-- Search Frame
	self:skinEditBox{obj=Notes.Notes.SearchFrame.Box, regs={9}}
	self:skinSlider{obj=Notes.Notes.SearchFrame.Scroll.ScrollBar}
	self:addSkinFrame{obj=Notes.Notes.SearchFrame, nb=true}
	self:skinButton{obj=Notes.Notes.SearchFrame.PhraseDD}
	self:skinButton{obj=Notes.Notes.SearchFrame.PhraseHelp}
	self:skinButton{obj=Notes.Notes.SearchFrame.CloseButton}

	-- CommOut Frame
	self:skinEditBox{obj=Notes.Notes.CommOutFrame.Box, regs={9}}
	self:skinSlider{obj=Notes.Notes.CommOutFrame.Scroll.ScrollBar}
	self:addSkinFrame{obj=Notes.Notes.CommOutFrame}
	self:skinButton{obj=Notes.Notes.CommOutFrame.FriendsDD}
	self:skinButton{obj=Notes.Notes.CommOutFrame.SendButton}
	self:skinButton{obj=Notes.Notes.CommOutFrame.CloseButton}
	self:skinButton{obj=Notes.Notes.CommOutFrame.IgnoreButton}

end