local _, aObj = ...
if not aObj:isAddonEnabled("Notes") then return end
local _G = _G

aObj.addonsToSkin.Notes = function(self) -- v 11.0.2


	self:SecureHookScript(_G.NotesFrame, "OnShow", function(this)
		self:skinObject("ddbutton", {obj=_G.NotesFrameSendNoteButton, noSF=true--[[, ofs=0]]})
		-- NotesFrameScrollFrame
		self:skinObject("frame", {obj=this, kfs=true, cb=true--[[, ofs=2, x1=0, y1=0, x2=0, y2=0]]})
		if self.modBtns then
			self:skinStdButton{obj=_G.NotesFrameCancelButton}
			self:skinStdButton{obj=_G.NotesFrameCreateNoteButton}
			self:skinStdButton{obj=_G.NotesFrameCopyNoteButton}
			self:skinStdButton{obj=_G.NotesFrameDeleteNoteButton}
			self:skinStdButton{obj=_G.NotesFrameRedoButton}
			self:skinStdButton{obj=_G.NotesFrameUndoButton}
		end

		self:SecureHookScript(_G.ConfigNotesFrame, "OnShow", function(fObj)
			self:skinObject("dropdown", {obj=_G.Notes_AddInfoDropDown, x1=-10, x2=-1})
			self:skinObject("dropdown", {obj=_G.Notes_TypeDropDown, x2=-51})
			if self.modBtns then
				self:skinStdButton{obj=_G.Notes_AddInfo, ofs=-2}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditNotesFrame, "OnShow", function(fObj)
			self:skinObject("scrollbar", {obj=_G.TextScrollFrame.ScrollBar})
			_G.TextBodyEditBox:SetTextColor(self.BT:GetRGB())

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

end
