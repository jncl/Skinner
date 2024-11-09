local _, aObj = ...
if not aObj:isAddonEnabled("EasyMail") then return end
local _G = _G

aObj.addonsToSkin.EasyMail = function(self) -- v 4.4.6.b

	self:getRegion(_G.EASYMAIL_L_Sowframe_HistoryFrame, 10):SetTextColor(self.HT:GetRGB())
	self:skinObject("slider", {obj=self:getChild(_G.EASYMAIL_L_Sowframe_HistoryFrame, 2).ScrollBar})
	self:skinObject("frame", {obj=_G.EASYMAIL_L_Sowframe_HistoryFrame, kfs=true, ofs=-8})
	if self.modBtns then
		self:skinCloseButton{obj=self:getChild(_G.EASYMAIL_L_Sowframe_HistoryFrame, 1)}
		self:skinStdButton{obj=_G.EasyMail_ForwardButton}
		self:skinStdButton{obj=_G.EasyMail_AttButton}
		self:SecureHook(_G.EasyMail_AttButton, "Disable", function(bObj, _)
			self:clrBtnBdr(bObj)
		end)
		self:SecureHook(_G.EasyMail_AttButton, "Enable", function(bObj, _)
			self:clrBtnBdr(bObj)
		end)
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.EasyMail_CheckAllButton}
		self:addButtonBorder{obj=_G.EasyMail_ClearAllButton}
		self:addButtonBorder{obj=_G.EasyMail_CheckPageButton}
		self:addButtonBorder{obj=_G.EasyMail_ClearPageButton}
		self:addButtonBorder{obj=_G.EasyMail_GetAllButton}
		self:SecureHook(_G.EasyMail, "InboxUpdate", function(_)
			self:clrBtnBdr(_G.EasyMail_CheckAllButton)
			self:clrBtnBdr(_G.EasyMail_ClearAllButton)
			self:clrBtnBdr(_G.EasyMail_CheckPageButton)
			self:clrBtnBdr(_G.EasyMail_ClearPageButton)
		end)
		-- N.B. using hooksecurefunc as already hooked so hook this to colour buttons on update
		_G.hooksecurefunc("InboxFrame_Update", function()
			_G.EasyMail.InboxUpdate()
		end)
		self:SecureHook(_G.EasyMail, "EnableGetButton", function(_)
			self:clrBtnBdr(_G.EasyMail_GetAllButton)
		end)
	end
	if self.modChkBtns then
		for i = 1, _G.INBOXITEMS_TO_DISPLAY do
			self:skinCheckButton{obj=_G["EasyMail_CheckButton" .. i]}
		end
	end

end
