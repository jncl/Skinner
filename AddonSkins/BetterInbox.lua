local aName, aObj = ...
if not aObj:isAddonEnabled("BetterInbox") then return end
local btn

function aObj:BetterInbox(LoD)
	if not self.db.profile.MailFrame then return end

	local bib = LibStub('AceAddon-3.0'):GetAddon('BetterInbox', true)
	if not bib then return end
	
	local function skinBIb()

		bib.scrollframe.t1:SetAlpha(0)
		bib.scrollframe.t2:SetAlpha(0)
		aObj:skinScrollBar{obj=bib.scrollframe}
		for i = 1, #bib.scrollframe.entries do
			aObj:removeRegions(bib.scrollframe.entries[i], {1, 2, 3})
			self:moveObject{obj=bib.scrollframe.entries[i].bicheckbox, x=2, y=-1}
			if self.modBtnBs then
				btn = _G[bib.scrollframe.entries[i]:GetName().."Button"]
				btn:DisableDrawLayer("BACKGROUND")
				aObj:addButtonBorder{obj=btn}
			end
		end
		-- skin the buttons
		aObj:skinButton{obj=BetterInboxCancelButton}
		aObj:skinButton{obj=BetterInboxOpenButton}
		-- fix the dropdown, as the sizes had been changed
		self:moveObject{obj=bib.scrollframe.dropdown.button, x=0, y=-1}
		bib.scrollframe.dropdown.frame:SetHeight(26)
		bib.scrollframe.dropdown.frame:SetScale(.93)
		self:moveObject{obj=bib.scrollframe.dropdown.frame, x=8, y=4}

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
