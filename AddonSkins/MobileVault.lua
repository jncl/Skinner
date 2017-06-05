local aName, aObj = ...
if not aObj:isAddonEnabled("MobileVault") then return end
local _G = _G

function aObj:MobileVault()
	if not self.db.profile.GuildBankUI then return end

	local mVault = _G.LibStub("AceAddon-3.0"):GetAddon("MobileVault", true)
	if not mVault then return end

	mVault.db.profile.itemBorderColor = {self.bbColour[1], self.bbColour[2], self.bbColour[3]}
	mVault.db.profile.tabBorderColor = {self.bbColour[1], self.bbColour[2], self.bbColour[3]}

	local function skinBtn(btn)
		-- change backdrop
		btn:SetBackdrop(self.Backdrop[10]) -- no bgFile texture
		btn:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
	end

	-- hook this to skin frame & buttons
	self:RawHook(mVault, "CreateVaultFrame", function(this)
		local frame = self.hooks[this].CreateVaultFrame(this)
		self:addSkinFrame{obj=frame}
		skinBtn(frame.moneyButton)
		-- skin item buttons
		for i = 1, #frame.items do
			skinBtn(frame.items[i])
		end
		-- skin tab buttons
		for i = 1, _G.MAX_GUILDBANK_TABS do
			skinBtn(frame.tabButtons[i])
		end
		self:Unhook(this, "CreateVaultFrame")
		return frame
	end, true)

end
