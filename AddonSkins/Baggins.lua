local aName, aObj = ...
if not aObj:isAddonEnabled("Baggins") then return end
local _G = _G

function aObj:Baggins()
	if not self.db.profile.ContainerFrames then return end

	-- check for Ace3 version
	local Baggins = _G.LibStub("AceAddon-3.0"):GetAddon("Baggins", true)

	-- setup default colours
	if not self.db.profile.BagginsBBC then
		self.db.profile.BagginsBBC = {r = 0, g = 0, b = 0, a = 0.9}
	end

	local function skinBag(id, frame)
		aObj:addSkinFrame{obj=frame, y1=-3, x2=-3}
		if Baggins.db.profile.bags[id].isBank then
			frame.sf:SetBackdropColor(aObj.db.profile.BagginsBBC.r, aObj.db.profile.BagginsBBC.g, aObj.db.profile.BagginsBBC.b, aObj.db.profile.BagginsBBC.a)
		end
		frame.SetBackdrop = function() end
		frame.SetBackdropColor = function() end
		frame.SetBackdropBorderColor = function() end
		if Baggins.db.profile.skin == "blizzard" then
			frame.icon:SetTexture(nil)
			frame.portrait:SetTexture(nil)
		elseif Baggins.db.profile.skin == "oSkin" then
			frame.tfade:SetTexture(nil)
		end
	end

	-- Hook this to skin the Bags after they are created
	self:SecureHook(Baggins, "CreateBagFrame", function(this, bagid)
		skinBag(bagid, _G["BagginsBag"..bagid])
	end)

	-- skin existing bags
	for k, v in _G.pairs(Baggins.bagframes) do
		skinBag(k, v)
	end

end
