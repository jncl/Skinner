local aName, aObj = ...
if not aObj:isAddonEnabled("BulkMail2") then return end

function aObj:BulkMail2()

	-- uses QTIP for frames

end

function aObj:BulkMail2Inbox()

	local BMI = LibStub("AceAddon-3.0"):GetAddon("BulkMailInbox", true)

	self:SecureHook(BMI, "ShowInboxGUI", function(this)
		self:skinEditBox{obj=BulkMailInboxSearchFilterEditBox, regs={9}}
		self:addSkinFrame{obj=this._toolbar}
		self:Unhook(BMI, "ShowInboxGUI")
	end)

	-- uses QTIP for frames

end
