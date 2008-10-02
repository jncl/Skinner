
function Skinner:BetterInbox(LoD)
	if not self.db.profile.MailFrame then return end

	local bib = LibStub:GetLibrary('AceAddon-3.0', true):GetAddon('BetterInbox', true)

	if not bib then return end

	local function skinBIb()

		-- move heading text
		bib.summary.numitems:ClearAllPoints()
		bib.summary.numitems:SetPoint( "TOPLEFT", InboxFrame, "TOPLEFT", 90, -23)
		bib.summary.numitemsText:ClearAllPoints()
		bib.summary.numitemsText:SetPoint( "LEFT", bib.summary.numitems, "RIGHT", 5, 0)
		bib.summary.moneyText:ClearAllPoints()
		bib.summary.moneyText:SetPoint( "TOPLEFT", InboxFrame, "TOPLEFT", 111, -36)
		bib.summary.money:ClearAllPoints()
		bib.summary.money:SetPoint( "LEFT", bib.summary.moneyText, "RIGHT", 5, 0)
		bib.summary.soonText:ClearAllPoints()
		bib.summary.soonText:SetPoint( "TOPLEFT", InboxFrame, "TOPLEFT", 115, -49)
		bib.summary.soon:ClearAllPoints()
		bib.summary.soon:SetPoint( "LEFT", bib.summary.soonText, "RIGHT", 5, 0)
		bib.summary.codText:ClearAllPoints()
		bib.summary.codText:SetPoint( "TOPLEFT", InboxFrame, "TOPLEFT", 130, -62)
		bib.summary.cod:ClearAllPoints()
		bib.summary.cod:SetPoint( "LEFT", bib.summary.codText, "RIGHT", 5, 0)

		Skinner:skinScrollBar(bib.scrollframe)
		bib.scrollframe.t1:SetAlpha(0)
		bib.scrollframe.t2:SetAlpha(0)
		Skinner:moveObject(bib.scrollframe, "-", 5, "+", 20)
		bib.scrollframe:SetHeight(bib.scrollframe:GetHeight() + 10)
		Skinner:moveObject(bib.scrollframe.entries[1], "-", 5, "+", 20)
		Skinner:moveObject(bib.scrollframe.dropdown.frame, "-", 10, "-", 5)
		Skinner:moveObject(BetterInboxCancelButton, "-", 7, "-", 5)

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
