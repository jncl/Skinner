local _, aObj = ...
if not aObj:isAddonEnabled("BulkMail2Inbox") then return end
local _G = _G

aObj.addonsToSkin.BulkMail2Inbox = function(self) -- v 9.0.5

	local BMI = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("BulkMailInbox", true)
	if BMI then
		self:SecureHook(BMI, "ShowInboxGUI", function(this)
			self:skinObject("editbox", {obj=this._toolbarEditBox, y1=-4, y2=4})
			self:skinObject("frame", {obj=this._toolbar, ofs=0, y2=-1})
			if self.modBtns then
				self:skinCloseButton{obj=_G.BulkMailInboxToolbarCloseButton} -- N.B. should be BMI.buttons.close but incorrectly named in code
				self:skinCloseButton{obj=BMI.buttons.Cancel}
				self:skinStdButton{obj=BMI.buttons.CS}
				self:skinStdButton{obj=BMI.buttons.TS}
				self:skinStdButton{obj=BMI.buttons.TC}
				self:skinStdButton{obj=BMI.buttons.TA}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=BMI.buttons.prev, ofs=0, y1=-1, x2=-1, clr="gold"}
				self:addButtonBorder{obj=BMI.buttons.next, ofs=0, y1=-1, x2=-1, clr="gold"}
				self:SecureHook(BMI.buttons.prev, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(BMI.buttons.prev, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(BMI.buttons.next, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(BMI.buttons.next, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end

			self:Unhook(BMI, "ShowInboxGUI")
		end)
	end

end
