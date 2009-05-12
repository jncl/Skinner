
function Skinner:BetterInbox(LoD)
	if not self.db.profile.MailFrame then return end

	local bib = LibStub:GetLibrary('AceAddon-3.0', true):GetAddon('BetterInbox', true)

	if not bib then return end
	
--	self:Debug("BetterInbox:[%s, %s]", bib, LoD)

	local function skinBIb()

		bib.scrollframe.t1:SetAlpha(0)
		bib.scrollframe.t2:SetAlpha(0)
		Skinner:skinScrollBar{obj=bib.scrollframe}

	end

	if not LoD then
		self:SecureHook(bib, "SetupGUI", function()
			skinBIb()
			self:Unhook(bib, "SetupGUI")
		end)
	else
		skinBIb()
	end

end
