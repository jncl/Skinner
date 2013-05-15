local aName, aObj = ...
if not aObj:isAddonEnabled("HabeebIt") then return end
local _G = _G

function aObj:HabeebIt()

	-- Handle
	_G.HabeebItHandle:DisableDrawLayer("BACKGROUND")
	_G.HabeebItHandle:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=_G.HabeebItHandle, bg=true, x1=-9, y1=4, x2=2, y2=-4}
	-- need to adjust normal texture as per CompactRaidFrameManager
	_G.HabeebItHandle:SetSize(14, 56)
	_G.HabeebItHandle.nt = _G.HabeebItHandle:GetNormalTexture()
	_G.HabeebItHandle.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
	_G.HabeebItHandle:SetPoint("BOTTOMRIGHT", _G.BonusRollFrame, 12, 8)
	self:RawHook(_G.HabeebItHandle, "SetPoint", function(this, posn, obj, x, y)
		self.hooks[this].SetPoint(this, posn, obj, x - 4, y + 4)
	end, true)
	self:RawHook(_G.HabeebItHandle.nt, "SetTexCoord", function(this, x1, x2, y1, y2)
		self.hooks[this].SetTexCoord(this, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
	end, true)
	
	-- Frame
	self:addSkinFrame{obj=_G.HabeebItFrame}
	-- Items in list
	-- Specialization Tabs

end
