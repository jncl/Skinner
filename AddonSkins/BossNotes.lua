local aName, aObj = ...
if not aObj:isAddonEnabled("BossNotes") then return end

function aObj:BossNotes()

	self:moveObject{obj=BossNotesInstanceDropDown, x=-5}
	self:skinDropDown{obj=BossNotesInstanceDropDown}
	self:skinDropDown{obj=BossNotesEncounterDropDown}
	self:skinScrollBar{obj=BossNotesSourceListScrollFrame}
	self:skinScrollBar{obj=BossNotesNoteScrollFrame}
	self:moveObject{obj=BossNotesChatDropDown, x=5}
	self:skinDropDown{obj=BossNotesChatDropDown}
	self:addSkinFrame{obj=BossNotesFrame, kfs=true, x1=10, y1=-12, x2=-32, y2=71}


end

function aObj:BossNotes_PersonalNotes()

	self:addSkinFrame{obj=BossNotesPersonalNotesEditorScrollFrameBackground}
	self:skinScrollBar{obj=BossNotesPersonalNotesEditorScrollFrame}
	self:addSkinFrame{obj=BossNotesPersonalNotesEditor}

	-- Personal Notes Context Menu
	self:addSkinFrame{obj=BossNotesPersonalNotesContextMenu}

end
