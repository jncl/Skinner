local aName, aObj = ...
if not aObj:isAddonEnabled("Baggins") then return end

function aObj:Baggins()
	if not self.db.profile.ContainerFrames then return end

	-- check for Ace3 version
	local a3Ver = LibStub("AceAddon-3.0"):GetAddon("Baggins", true)

	-- setup default colours
	if not self.db.profile.BagginsBBC then
		self.db.profile.BagginsBBC = {r = 0, g = 0, b = 0, a = 0.9}
	end

	local function skinBag(id, frame)
		aObj:addSkinFrame{obj=frame, y1=-3, x2=-3}
		if Baggins.db.profile.bags[id].isBank then
			frame:SetBackdropColor(aObj.db.profile.BagginsBBC.r, aObj.db.profile.BagginsBBC.g, aObj.db.profile.BagginsBBC.b, aObj.db.profile.BagginsBBC.a)
		end
		frame.SetBackdropColor = function() end
		if a3Ver then
			if a3Ver.db.profile.skin == "blizzard" then
				frame.icon:SetTexture(nil)
				frame.portrait:SetTexture(nil)
			elseif a3Ver.db.profile.skin == "oSkin" then
				frame.tfade:SetTexture(nil)
			end
		end
	end

	-- Hook this to skin the Bags after they are created
	self:SecureHook(Baggins, "CreateBagFrame", function(this, bagid)
		skinBag(bagid, _G["BagginsBag"..bagid])
	end)

	-- skin existing bags
	for k, v in pairs(Baggins.bagframes) do
		skinBag(k, v)
	end

end
