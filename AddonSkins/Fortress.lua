local aName, aObj = ...
if not aObj:isAddonEnabled("Fortress") then return end

function aObj:Fortress()

	local LB  = LibStub("LegoBlock-Beta1")
	local Fortress = LibStub("AceAddon-3.0"):GetAddon("Fortress")
	local db = Fortress.db.profile
	-- change the master settings
	db.masterSettings.background = self.bdTex
	db.masterSettings.bgTiled = self.backdrop.tile
	db.masterSettings.bgTileSize = self.backdrop.tileSize
	db.masterSettings.border = self.bdbTex
	db.masterSettings.edgeSize = self.backdrop.edgeSize
	db.masterSettings.insets = self.db.profile.BdInset
	db.masterSettings.frameColor = self.db.profile.Backdrop
	db.masterSettings.borderColor = self.db.profile.BackdropBorder
	-- hook this to apply gradient
	self:SecureHook(Fortress, "UpdateBackdrop", function(this, name)
		for btn, _ in pairs(LB.legos) do
			if btn
			and btn.name == name
			and not self.skinned[btn]
			then
				self:applySkin{obj=btn}
			end
		end
	end)
	-- force all objects to be updated
	Fortress:UpdateAllObjects()

end
