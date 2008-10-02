
function Skinner:Baggins()
	if not self.db.profile.ContainerFrames then return end

	-- setup default colours
	if not self.db.profile.BagginsBBC then
		self.db.profile.BagginsBBC = {r = 0, g = 0, b = 0, a = 0.9}
	end

	-- setup option to change the Bank Bags colour
	bbckey = {}
	bbckey.name = "Baggins Bank Bags Colour"
	bbckey.desc = "Set Baggins Bank Bags Colour"
	bbckey.type = "color"
	bbckey.get = function()
		return self.db.profile.BagginsBBC.r, self.db.profile.BagginsBBC.g, self.db.profile.BagginsBBC.b, self.db.profile.BagginsBBC.a
	end
	bbckey.set = function(r, g, b, a)
		self.db.profile.BagginsBBC.r, self.db.profile.BagginsBBC.g, self.db.profile.BagginsBBC.b, self.db.profile.BagginsBBC.a = r, g, b, a
	end
	bbckey.hasAlpha = true
	-- add to the colour submenu
	self.options.args.cp.args["bagginsbankcolour"] = bbckey

	-- Hook this to skin the Bags after they are created
	self:SecureHook(Baggins, "CreateBagFrame", function(this, bagid)
		local bagname = _G["BagginsBag"..bagid]
		self:applySkin(bagname)
		if Baggins.db.profile.bags[bagid].isBank then
			bagname:SetBackdropColor(self.db.profile.BagginsBBC.r, self.db.profile.BagginsBBC.g, self.db.profile.BagginsBBC.b, self.db.profile.BagginsBBC.a)
		end
		if not self:IsHooked(bagname, "SetBackdropColor") then
			self:Hook(bagname, "SetBackdropColor", function() end, true)
		end
	end)

	for k, frame in ipairs(Baggins.bagframes) do
		self:applySkin(frame)
		if Baggins.db.profile.bags[k].isBank then
			frame:SetBackdropColor(self.db.profile.BagginsBBC.r, self.db.profile.BagginsBBC.g, self.db.profile.BagginsBBC.b, self.db.profile.BagginsBBC.a)
		end
		self:Hook(frame, "SetBackdropColor", function() end, true)
	end

end

function Skinner:Baggins_Search()

	self:applySkin(BagginsSearch_EditBox)

end
