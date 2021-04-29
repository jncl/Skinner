local aName, aObj = ...
if not aObj:isAddonEnabled("Baggins") then return end
local _G = _G

aObj.addonsToSkin.Baggins = function(self) -- v 3.7.5
	if not self.db.profile.ContainerFrames then return end

	local function skinBag(id, frame)
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0})
		if _G.Baggins.db.profile.bags[id].isBank then
			frame.sf:SetBackdropColor(aObj.db.profile.BagginsBBC:GetRGBA())
		end
		frame.SetBackdrop = _G.nop
		frame.SetBackdropColor = _G.nop
		frame.SetBackdropBorderColor = _G.nop
		if _G.Baggins.db.profile.skin == "blizzard" then
			frame.icon:SetTexture(nil)
			frame.portrait:SetTexture(nil)
		elseif _G.Baggins.db.profile.skin == "oSkin" then
			frame.tfade:SetTexture(nil)
		end
	end
	self:SecureHook(_G.Baggins, "CreateBagFrame", function(this, bagid)
		skinBag(bagid, _G["BagginsBag" .. bagid])
	end)
	for id, frame in _G.pairs(_G.Baggins.bagframes) do
		skinBag(id, frame)
	end
	-- BagginsBankControlFrame
	if self.modBtns then
		for _, btn in _G.pairs{"slotbuy", "rabuy", "radeposit"} do
			self:skinStdButton{obj=_G.BagginsBankControlFrame[btn]}
			self:adjHeight{obj=_G.BagginsBankControlFrame[btn], adj=2}
		end
	end
	self:moveObject{obj=_G.BagginsBankControlFrame, x=-2}
	self:RawHook(_G.BagginsBankControlFrame, "SetPoint", function(this, point, frame, relTo, x, y)
		self.hooks[this].SetPoint(this, point, frame, relTo, 10, y)
	end, true)

end
