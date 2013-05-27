local aName, aObj = ...
if not aObj:isAddonEnabled("HabeebIt") then return end
local _G = _G

function aObj:HabeebIt()

	-- HabeebItContainer
	self:addSkinFrame{obj=_G.HabeebItContainer}

	-- HabeebItHandle
	_G.HabeebItHandle:DisableDrawLayer("BACKGROUND")
	_G.HabeebItHandle:DisableDrawLayer("BORDER")
	-- need to adjust normal texture as per CompactRaidFrameManager
	_G.HabeebItHandle.nt = _G.HabeebItHandle:GetNormalTexture()
	if _G.HabeebItDB.position == "BOTTOM" then
		_G.HabeebItHandle.nt:SetTexCoord(1, 0.3, 0.8, 0.3 ,1, 0.7, 0.8, 0.7) -- point down
	else
		_G.HabeebItHandle.nt:SetTexCoord(0.8, 0.7, 1, 0.7 ,0.8, 0.3, 1, 0.3) -- point up
	end
	self:RawHook(_G.HabeebItHandle.nt, "SetTexCoord", function(this, ULx,ULy,LLx,LLy,URx,URy,LRx,LRy)
		if (_G.HabeebItContainer:IsShown() -- currently shown, will be hidden
		and not _G.HabeebItDB.position == "BOTTOM")
		or (not _G.HabeebItContainer:IsShown() -- currently hidden, will be shown
		and _G.HabeebItDB.position == "BOTTOM")
		then
			self.hooks[this].SetTexCoord(this, 0.8, 0.7, 1, 0.7 ,0.8, 0.3, 1, 0.3) -- point up
		else
			self.hooks[this].SetTexCoord(this, 1, 0.3, 0.8, 0.3 ,1, 0.7, 0.8, 0.7) -- point down
		end
	end, true)

	-- Hotspot
	-- HabeebItSpecButtons
	self:SecureHookScript(_G.HabeebItSpecButtons, "OnShow", function(this)
		for _, child in pairs{_G.HabeebItSpecButtons:GetChildren()} do
			self:removeRegions(child, {2}) -- icon ring
		end
		self:Unhook(_G.HabeebItSpecButtons, "OnShow")
	end)

end
