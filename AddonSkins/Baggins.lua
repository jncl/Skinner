local aName, aObj = ...
if not aObj:isAddonEnabled("Baggins") then return end
local _G = _G

aObj.addonsToSkin.Baggins = function(self) -- r485-alpha
	if not self.db.profile.ContainerFrames then return end

	local Baggins = _G.LibStub("AceAddon-3.0"):GetAddon("Baggins", true)
	local c = self.db.profile.ClassClrBd and _G.RAID_CLASS_COLORS[self.uCls] or self.db.profile.BagginsBBC

	local function skinBag(id, frame)
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, y1=-4, x2=-3}
		if Baggins.db.profile.bags[id].isBank then
			frame.sf:SetBackdropColor(c.r, c.g, c.b, aObj.db.profile.BagginsBBC.a)
		end
		frame.SetBackdrop = _G.nop
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		if Baggins.db.profile.skin == "blizzard" then
			frame.icon:SetTexture(nil)
			frame.portrait:SetTexture(nil)
		elseif Baggins.db.profile.skin == "oSkin" then
			frame.tfade:SetTexture(nil)
		end
	end

	-- Hook this to skin the Bags after they are created
	self:SecureHook(Baggins, "CreateBagFrame", function(this, bagid)
		skinBag(bagid, _G["BagginsBag" .. bagid])
	end)

	-- skin existing bags
	for k, v in _G.pairs(Baggins.bagframes) do
		skinBag(k, v)
	end

end
